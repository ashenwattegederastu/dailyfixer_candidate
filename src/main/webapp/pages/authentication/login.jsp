<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.dailyfixer.model.User" %>
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
    <title><%= bundle.getString("auth.login.pageTitle") %></title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&family=Inter:wght@400;500;600;700&family=Lora:wght@400;500;600;700&family=IBM+Plex+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/framework.css">
</head>
<body>

<div class="login-container">
    <div class="login-card">
        <!-- Added logo/branding section -->
        <div class="login-header">
            <h1 class="login-title"><%= bundle.getString("brand.name") %></h1>
            <p class="login-subtitle"><%= bundle.getString("auth.login.subtitle") %></p>
        </div>

        <!-- Improved message styling with better visual hierarchy -->
        <% String success = (String) session.getAttribute("successMsg");
            if (success != null) { %>
        <div class="alert alert-success"><%= success %></div>
        <% session.removeAttribute("successMsg"); } %>

        <% String loginError = (String) request.getAttribute("loginError");
            if (loginError != null) { %>
        <div class="alert alert-error"><%= loginError %></div>
        <% } %>

        <form method="post" action="${pageContext.request.contextPath}/login" class="login-form">
            <div class="form-group">
                <label for="username" class="form-label"><%= bundle.getString("auth.login.username") %></label>
                <input
                        type="text"
                        id="username"
                        name="username"
                        class="form-input"
                        placeholder="<%= bundle.getString("auth.login.usernamePlaceholder") %>"
                        required>
            </div>

            <div class="form-group">
                <label for="password" class="form-label"><%= bundle.getString("auth.login.password") %></label>
                <input
                        type="password"
                        id="password"
                        name="password"
                        class="form-input"
                        placeholder="<%= bundle.getString("auth.login.passwordPlaceholder") %>"
                        required>
            </div>

            <!-- Improved button styling -->
            <button type="submit" class="login-btn"><%= bundle.getString("auth.login.signIn") %></button>
        </form>

        <!-- Better organized footer links with improved styling -->
        <div class="login-footer">
            <p class="footer-text">
                <%= bundle.getString("auth.login.noAccount") %>
                <a href="${pageContext.request.contextPath}/pages/authentication/register/preliminarySignup.jsp" class="footer-link"><%= bundle.getString("auth.login.createOne") %></a>
            </p>
            <p class="footer-text">
                <a href="${pageContext.request.contextPath}/pages/authentication/forgot_password/forgot_password.jsp" class="footer-link"><%= bundle.getString("auth.login.forgotPassword") %></a>
            </p>
            <p class="footer-text">
                <a href="${pageContext.request.contextPath}/index.jsp" class="footer-link-secondary"><%= bundle.getString("auth.backToHome") %></a>
            </p>
        </div>
    </div>
</div>
<script src="${pageContext.request.contextPath}/assets/js/password-toggle.js"></script>
</body>
</html>
