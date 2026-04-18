<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.ResourceBundle, com.dailyfixer.util.I18nUtil" %>
<%@ page session="true" %>
<%
    String lang = (String) session.getAttribute(I18nUtil.SESSION_LANG_KEY);
    ResourceBundle bundle = I18nUtil.getBundle(lang);
    String htmlLang = I18nUtil.normalizeLanguage(lang);
%>
<!DOCTYPE html>
<html lang="<%= htmlLang %>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= bundle.getString("auth.forgot.pageTitle") %></title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&family=Inter:wght@400;500;600;700&family=Lora:wght@400;500;600;700&family=IBM+Plex+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/framework.css">
</head>
<body>

<div class="login-container">
    <div style="position: fixed; top: 20px; right: 20px; z-index: 1000;">
        <button id="theme-toggle-btn" class="theme-toggle" onclick="toggleTheme()" aria-label="<%= bundle.getString("auth.toggleDarkMode") %>">🌙 <%= bundle.getString("auth.dark") %></button>
    </div>
    <div class="login-card">
        <div class="login-header">
            <h1 class="login-title"><%= bundle.getString("auth.forgot.title") %></h1>
            <p class="login-subtitle"><%= bundle.getString("auth.forgot.subtitle") %></p>
        </div>

        <% String message = (String) request.getAttribute("message");
            if (message != null) { %>
        <div class="alert alert-success"><%= message %></div>
        <% } %>

        <% String error = (String) request.getAttribute("error");
            if (error != null) { %>
        <div class="alert alert-error"><%= error %></div>
        <% } %>

        <form method="post" action="${pageContext.request.contextPath}/ForgotPasswordServlet" class="login-form">
            <div class="form-group">
                <label for="email" class="form-label"><%= bundle.getString("auth.forgot.email") %></label>
                <input
                        type="email"
                        id="email"
                        name="email"
                        class="form-input"
                        placeholder="<%= bundle.getString("auth.forgot.emailPlaceholder") %>"
                        required>
            </div>

            <button type="submit" class="login-btn"><%= bundle.getString("auth.forgot.sendResetLink") %></button>
        </form>

        <div class="login-footer">
            <p class="footer-text">
                <%= bundle.getString("auth.forgot.rememberPassword") %>
                <a href="${pageContext.request.contextPath}/pages/authentication/login.jsp" class="footer-link"><%= bundle.getString("auth.login.signIn") %></a>
            </p>
            <p class="footer-text">
                <a href="${pageContext.request.contextPath}/index.jsp" class="footer-link-secondary"><%= bundle.getString("auth.backToHome") %></a>
            </p>
        </div>
    </div>
</div>
</body>
</html>
