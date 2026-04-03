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
        String referrer = request.getHeader("referer");
        String safeTarget = getSafeRedirectTarget(referrer, contextPath);
        if (safeTarget != null && !safeTarget.contains("/change-language")) {
            response.sendRedirect(safeTarget);
            return;
        }

        response.sendRedirect(safeDefault);
    }

    private String getSafeRedirectTarget(String referrer, String contextPath) {
        if (referrer == null || referrer.isBlank()) {
            return null;
        }

        try {
            URI uri = URI.create(referrer);
            String path = uri.getPath();
            if (path == null || path.isBlank() || !path.startsWith(contextPath)) {
                return null;
            }

            String normalizedPath = path.replace('\\', '/');
            if (normalizedPath.contains("://")) {
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
