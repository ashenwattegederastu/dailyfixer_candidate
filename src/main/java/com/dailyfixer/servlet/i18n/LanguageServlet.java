package com.dailyfixer.servlet.i18n;

import com.dailyfixer.util.I18nUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URI;
public class LanguageServlet extends HttpServlet {
    private static final String DEFAULT_REDIRECT_PATH = "/index.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String lang = I18nUtil.normalizeLanguage(request.getParameter("lang"));
        request.getSession().setAttribute(I18nUtil.SESSION_LANG_KEY, lang);

        String contextPath = request.getContextPath();
        String safeDefault = contextPath + DEFAULT_REDIRECT_PATH;
        String safeReturnUrl = validateReturnUrl(request.getParameter("returnUrl"), contextPath);
        response.sendRedirect(safeReturnUrl != null ? safeReturnUrl : safeDefault);
    }

    private String validateReturnUrl(String returnUrl, String contextPath) {
        if (returnUrl == null || returnUrl.isBlank()) {
            return null;
        }

        try {
            URI uri = URI.create(returnUrl);
            if (uri.isAbsolute() || uri.getHost() != null || uri.getScheme() != null) {
                return null;
            }

            String path = uri.getPath();
            if (path == null || path.isBlank()) {
                return null;
            }

            String normalizedPath = path.replace('\\', '/');
            if (normalizedPath.startsWith("//") || normalizedPath.contains("://")) {
                return null;
            }

            boolean validForRootContext = contextPath == null || contextPath.isEmpty();
            boolean validForContextPath = normalizedPath.equals(contextPath) || normalizedPath.startsWith(contextPath + "/");
            if (!(validForRootContext ? normalizedPath.startsWith("/") : validForContextPath)) {
                return null;
            }

            StringBuilder target = new StringBuilder(normalizedPath);
            String query = uri.getQuery();
            if (query != null && !query.isBlank()) {
                target.append('?').append(query);
            }
            return target.toString();
        } catch (IllegalArgumentException ex) {
            return null;
        }
    }
}
