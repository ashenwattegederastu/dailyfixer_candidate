<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ page session="true" %>
<%@ page import="java.util.Map, com.dailyfixer.model.CartItem" %>
<%@ page import="java.util.ResourceBundle, com.dailyfixer.util.I18nUtil" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // Compute cart item count for nav cart icon
    @SuppressWarnings("unchecked")
    Map<String, CartItem> _navCart = (Map<String, CartItem>) session.getAttribute("cart");
    int _navCartCount = 0;
    if (_navCart != null) {
        for (CartItem _ci : _navCart.values()) _navCartCount += _ci.getQuantity();
    }
    String _lang = (String) session.getAttribute(I18nUtil.SESSION_LANG_KEY);
    ResourceBundle bundle = I18nUtil.getBundle(_lang);
%>

        <head>
            <title></title>
        <meta charset="UTF-8">
        <link
            href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&family=Inter:wght@400;500;600;700&family=Lora:wght@400;500;600;700&family=IBM+Plex+Mono:wght@400;500;600&family=Noto+Sans+Sinhala:wght@400;500;600;700&display=swap"
            rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/framework.css">
        <link rel="stylesheet" type="text/css"
            href="${pageContext.request.contextPath}/assets/icons/regular/style.css" />
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/icons/fill/style.css" />
        </head>

        <!-- Navigation -->
        <nav id="navbar" class="public-nav">
            <div class="nav-container">
                <div class="hamburger" id="hamburger-btn">
                    <span></span>
                    <span></span>
                    <span></span>
                </div>
                <a href="${pageContext.request.contextPath}/index.jsp" class="logo">
                    <img src="${pageContext.request.contextPath}/assets/images/logo/logo_main.svg" alt="Logo" class="logo-icon">
                    <%= bundle.getString("brand.name") %>
                </a>
                <ul class="nav-links" id="nav-links">
                    <li><a href="${pageContext.request.contextPath}/pages/diagnostic/diagnostic-browse.jsp"><%= bundle.getString("nav.diagnostic") %></a></li>
                    <li><a href="${pageContext.request.contextPath}/guides"><%= bundle.getString("nav.guides") %></a></li>
                    <li><a href="${pageContext.request.contextPath}/services"><%= bundle.getString("nav.bookTechnician") %></a></li>
                    <li><a href="${pageContext.request.contextPath}/pages/stores/store_main.jsp"><%= bundle.getString("nav.marketplace") %></a></li>
                </ul>

                <!-- Dynamic Login/Logout -->
                <div class="nav-buttons">
                    <a href="${pageContext.request.contextPath}/change-language?lang=en" class="btn-login" aria-label="<%= bundle.getString("nav.switchToEnglish") %>"><%= bundle.getString("nav.english") %></a>
                    <a href="${pageContext.request.contextPath}/change-language?lang=si" class="btn-login" aria-label="<%= bundle.getString("nav.switchToSinhala") %>"><%= bundle.getString("nav.sinhala") %></a>
                    <c:choose>
                        <c:when test="${not empty sessionScope.currentUser}">
                            <!-- User is logged in -->
                            <a href="${pageContext.request.contextPath}/pages/stores/Cart.jsp" class="nav-cart-link" title="Cart">
                                <i class="ph ph-shopping-cart"></i>
                                <span class="cart-count"><%= _navCartCount %></span>
                            </a>
                            <a href="${pageContext.request.contextPath}/pages/dashboards/${sessionScope.currentUser.role}dash/${sessionScope.currentUser.role}dashmain.jsp"
                                class="btn-login">
                                <i class="ph ph-user"></i>
                            </a>
                            <a href="${pageContext.request.contextPath}/logout" class="btn-logout"><%= bundle.getString("logout") %></a>
                        </c:when>
                        <c:otherwise>
                            <!-- Guest -->
                            <a href="${pageContext.request.contextPath}/pages/authentication/login.jsp" class="btn-login"><%= bundle.getString("login") %></a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </nav>

        <script>
            // Navbar scroll effect
            const navbar = document.getElementById('navbar');
            window.addEventListener('scroll', () => {
                if (window.scrollY > 50) {
                    navbar.classList.add('scrolled');
                } else {
                    navbar.classList.remove('scrolled');
                }
            });

            // Mobile Menu Toggle
            const hamburger = document.getElementById('hamburger-btn');
            const navLinks = document.getElementById('nav-links');

            hamburger.addEventListener('click', () => {
                navLinks.classList.toggle('active');
                hamburger.classList.toggle('active');
            });
        </script>
