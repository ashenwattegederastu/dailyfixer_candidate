<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="true" %>
<%@ page import="java.util.ResourceBundle, com.dailyfixer.util.I18nUtil" %>
<%
  String lang = (String) session.getAttribute(I18nUtil.SESSION_LANG_KEY);
  ResourceBundle bundle = I18nUtil.getBundle(lang);
  String htmlLang = I18nUtil.normalizeLanguage(lang);
%>

<!DOCTYPE html>
<html lang="<%= htmlLang %>">
<head>
  <meta charset="UTF-8">
  <title><%= bundle.getString("auth.reset.pageTitle") %></title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/resetPassword.css">
</head>
<body>

<header>
  <!-- Main Navbar -->
  <nav class="navbar">
    <div class="logo"><%= bundle.getString("brand.name") %></div>
    <ul class="nav-links">
      <li><a href="${pageContext.request.contextPath}"><%= bundle.getString("auth.reset.home") %></a></li>
      <li><a href="${pageContext.request.contextPath}/LogoutServlet"><%= bundle.getString("auth.reset.logOut") %></a></li>
    </ul>
  </nav>

  <!-- Subnav -->
  <nav class="subnav">
    <div class="store-name"><%= bundle.getString("auth.reset.userProfile") %></div>
    <ul>
      <li><a href="${pageContext.request.contextPath}/pages/dashboards/userdash/userdashmain.jsp"><%= bundle.getString("auth.reset.dashboard") %></a></li>
      <li><a href="${pageContext.request.contextPath}/pages/dashboards/userdash/myProfile.jsp"><%= bundle.getString("auth.reset.myProfile") %></a></li>
    </ul>
  </nav>
</header>

<div class="container">
  <h2><%= bundle.getString("auth.reset.title") %></h2>

  <c:if test="${not empty errorMsg}">
    <div class="message error">${errorMsg}</div>
  </c:if>

  <c:if test="${not empty successMsg}">
    <div class="message success">${successMsg}</div>
  </c:if>

  <form action="${pageContext.request.contextPath}/ResetPasswordServlet" method="post">
    <div class="form-group">
      <label for="currentPassword"><%= bundle.getString("auth.reset.currentPassword") %></label>
      <input type="password" id="currentPassword" name="currentPassword" required>
    </div>

    <div class="form-group">
      <label for="newPassword"><%= bundle.getString("auth.reset.newPassword") %></label>
      <input type="password" id="newPassword" name="newPassword" minlength="6" required>
    </div>

    <div class="form-group">
      <label for="confirmPassword"><%= bundle.getString("auth.reset.confirmPassword") %></label>
      <input type="password" id="confirmPassword" name="confirmPassword" minlength="6" required>
    </div>

    <div class="btn-container">
      <button type="submit"><%= bundle.getString("auth.reset.resetPassword") %></button>
      <button type="button" class="cancel" onclick="history.back()"><%= bundle.getString("auth.reset.cancel") %></button>
    </div>
  </form>
</div>

<script src="${pageContext.request.contextPath}/assets/js/password-toggle.js"></script>

</body>
</html>
