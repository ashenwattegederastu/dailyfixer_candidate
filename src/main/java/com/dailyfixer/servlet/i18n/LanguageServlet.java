package com.dailyfixer.servlet.i18n;

import com.dailyfixer.util.I18nUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class LanguageServlet extends HttpServlet {
    private static final String DEFAULT_REDIRECT_PATH = "/index.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String lang = I18nUtil.normalizeLanguage(request.getParameter("lang"));
        request.getSession().setAttribute(I18nUtil.SESSION_LANG_KEY, lang);

        String contextPath = request.getContextPath();
        String safeDefault = contextPath + DEFAULT_REDIRECT_PATH;
        String referer = request.getHeader("referer");
        if (referer != null && !referer.isBlank()) {
            int pathStart = referer.indexOf(contextPath);
            if (pathStart >= 0) {
                String target = referer.substring(pathStart);
                if (!target.contains("/change-language")) {
                    response.sendRedirect(target);
                    return;
                }
            }
        }

        response.sendRedirect(safeDefault);
    }
}
