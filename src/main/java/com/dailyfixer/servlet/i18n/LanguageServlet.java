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

        response.sendRedirect(request.getContextPath() + DEFAULT_REDIRECT_PATH);
    }
}
