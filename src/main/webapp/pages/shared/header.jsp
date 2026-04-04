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
    String _returnUrl = request.getRequestURI();
    if (request.getQueryString() != null && !request.getQueryString().isBlank()) {
        _returnUrl += "?" + request.getQueryString();
    }
    String _encodedReturnUrl = java.net.URLEncoder.encode(_returnUrl, "UTF-8");
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
                    <div class="language-switcher" style="position: relative; display: inline-block;">
                        <button type="button"
                                class="btn-login"
                                id="lang-menu-btn"
                                aria-haspopup="true"
                                aria-expanded="false"
                                aria-label="<%= bundle.getString("nav.languageMenu") %>"
                                title="<%= bundle.getString("nav.languageMenu") %>">
                            <i class="ph ph-translate"></i>
                        </button>
                        <div id="lang-menu"
                             style="display:none; position:absolute; right:0; top:110%; min-width:140px; background:var(--card); border:1px solid var(--border); border-radius:var(--radius-md); box-shadow:var(--shadow-md); z-index:1000;">
                            <a href="${pageContext.request.contextPath}/change-language?lang=en&returnUrl=<%= _encodedReturnUrl %>"
                               style="display:block; padding:10px 12px; text-decoration:none; color:var(--foreground);"
                               aria-label="<%= bundle.getString("nav.switchToEnglish") %>"><%= bundle.getString("nav.english") %></a>
                            <a href="${pageContext.request.contextPath}/change-language?lang=si&returnUrl=<%= _encodedReturnUrl %>"
                               style="display:block; padding:10px 12px; text-decoration:none; color:var(--foreground); border-top:1px solid var(--border);"
                               aria-label="<%= bundle.getString("nav.switchToSinhala") %>"><%= bundle.getString("nav.sinhala") %></a>
                        </div>
                    </div>
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

            const langMenuBtn = document.getElementById('lang-menu-btn');
            const langMenu = document.getElementById('lang-menu');
            if (langMenuBtn && langMenu) {
                langMenuBtn.addEventListener('click', () => {
                    const open = langMenu.style.display === 'block';
                    langMenu.style.display = open ? 'none' : 'block';
                    langMenuBtn.setAttribute('aria-expanded', open ? 'false' : 'true');
                });
                document.addEventListener('click', (e) => {
                    if (!langMenu.contains(e.target) && !langMenuBtn.contains(e.target)) {
                        langMenu.style.display = 'none';
                        langMenuBtn.setAttribute('aria-expanded', 'false');
                    }
                });
            }
        </script>
