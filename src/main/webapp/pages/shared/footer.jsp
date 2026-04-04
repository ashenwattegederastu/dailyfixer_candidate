<%@ page session="true" %>
<%@ page import="java.util.ResourceBundle, com.dailyfixer.util.I18nUtil" %>
<%
  String _lang = (String) session.getAttribute(I18nUtil.SESSION_LANG_KEY);
  ResourceBundle bundle = I18nUtil.getBundle(_lang);
%>
<footer class="footer">
  <div class="footer-container">
    <div class="footer-logo">
      <h2><%= bundle.getString("brand.name") %></h2>
      <p><%= bundle.getString("footer.tagline") %></p>
    </div>
    <div class="footer-links">
      <h3><%= bundle.getString("footer.quickLinks") %></h3>
      <ul>
        <li><a href="${pageContext.request.contextPath}/index.jsp"><%= bundle.getString("footer.home") %></a></li>
        <li><a href="#about"><%= bundle.getString("footer.about") %></a></li>
        <li><a href="#services"><%= bundle.getString("footer.services") %></a></li>
        <li><a href="${pageContext.request.contextPath}/pages/authentication/login.jsp"><%= bundle.getString("footer.login") %></a></li>
      </ul>
    </div>
    <div class="footer-contact">
      <h3><%= bundle.getString("footer.contact") %></h3>
      <p><%= bundle.getString("footer.email") %>: support@dailyfixer.com</p>
      <p><%= bundle.getString("footer.phone") %>: +94 77 123 4567</p>
      <div class="socials">
        <a href="#"><img src="${pageContext.request.contextPath}/assets/images/icons/youtube.png" alt="YouTube"></a>
        <a href="#"><img src="${pageContext.request.contextPath}/assets/images/icons/facebook.png" alt="Facebook"></a>
        <a href="#"><img src="${pageContext.request.contextPath}/assets/images/icons/instagram.png" alt="Instagram"></a>
      </div>
    </div>
  </div>
  <div class="footer-bottom">
    <p><%= bundle.getString("footer.copyright") %></p>
  </div>
</footer>
