<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title><%= bundle.getString("home.pageTitle") %></title>
                <link
                        href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&family=Inter:wght@400;500;600;700&family=Lora:wght@400;500;600;700&family=IBM+Plex+Mono:wght@400;500;600&family=Noto+Sans+Sinhala:wght@400;500;600;700&display=swap"
                        rel="stylesheet">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/framework.css">
                <!-- Importing Phosphor Icon Library Locally from assets-->
                <link
                        rel="stylesheet"
                        type="text/css"
                        href="${pageContext.request.contextPath}/assets/icons/regular/style.css"
                />
                <link
                        rel="stylesheet"
                        type="text/css"
                        href="${pageContext.request.contextPath}/assets/icons/fill/style.css"
                />
            </head>

            <body>
                <!-- Shared Header/Navigation -->
                <jsp:include page="/pages/shared/header.jsp" />

                <!-- Hero Section 1: Community -->
                <section class="hero-section active" id="hero1">
                    <div class="hero-content">
                        <h1><%= bundle.getString("home.hero1.title") %></h1>
                        <p><%= bundle.getString("home.hero1.subtitle") %></p>
                        <c:choose>
                            <c:when test="${not empty sessionScope.currentUser}">
                                <a href="${pageContext.request.contextPath}/pages/diagnostic/diagnostic-browse.jsp"
                                    class="hero-cta"><%= bundle.getString("home.hero1.cta.startDiagnosing") %></a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/pages/authentication/register/preliminarySignup.jsp" class="hero-cta"><%= bundle.getString("home.hero1.cta.getStarted") %></a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="scroll-indicator">
                        <div class="chevron"></div>
                    </div>
                </section>

                <!-- Hero Section 2: View Guides -->
                <section class="hero-section" id="hero2">
                    <div class="hero-content">
                        <h1><%= bundle.getString("home.hero2.title") %></h1>
                        <p><%= bundle.getString("home.hero2.subtitle") %></p>
                        <a href="${pageContext.request.contextPath}/guides" class="hero-cta"><%= bundle.getString("home.hero2.cta") %></a>
                    </div>
                    <div class="scroll-indicator">
                        <div class="chevron"></div>
                    </div>
                </section>

                <!-- Features Section: View Guides -->
                <section class="features-section" id="guides">
                    <div class="features-container">
                        <h2 class="section-title"><%= bundle.getString("home.guides.sectionTitle") %></h2>
                        <div class="features-grid">
                            <div class="feature-card">
                                <div class="feature-icon"><i class="ph ph-books"></i></div>
                                <h3><%= bundle.getString("home.guides.feature1.title") %></h3>
                                <p><%= bundle.getString("home.guides.feature1.desc") %></p>
                            </div>
                            <div class="feature-card">
                                <div class="feature-icon"><i class="ph ph-users-three"></i></div>
                                <h3><%= bundle.getString("home.guides.feature2.title") %></h3>
                                <p><%= bundle.getString("home.guides.feature2.desc") %></p>
                            </div>
                            <div class="feature-card">
                                <div class="feature-icon"><i class="ph ph-pencil-ruler"></i></div>
                                <h3><%= bundle.getString("home.guides.feature3.title") %></h3>
                                <p><%= bundle.getString("home.guides.feature3.desc") %></p>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- Hero Section 3: Technician Booking -->
                <section class="hero-section" id="hero3">
                    <div class="hero-content">
                        <h1><%= bundle.getString("home.hero3.title") %></h1>
                        <p><%= bundle.getString("home.hero3.subtitle") %></p>
                        <a href="${pageContext.request.contextPath}/findtech.jsp" class="hero-cta"><%= bundle.getString("home.hero3.cta") %></a>
                    </div>
                    <div class="scroll-indicator">
                        <div class="chevron"></div>
                    </div>
                </section>

                <!-- Features Section: Technician Booking -->
                <section class="features-section" id="technician">
                    <div class="features-container">
                        <h2 class="section-title"><%= bundle.getString("home.technician.sectionTitle") %></h2>
                        <div class="features-grid">
                            <div class="feature-card">
                                <div class="feature-icon">✓</div>
                                <h3><%= bundle.getString("home.technician.feature1.title") %></h3>
                                <p><%= bundle.getString("home.technician.feature1.desc") %></p>
                            </div>
                            <div class="feature-card">
                                <div class="feature-icon">⏱️</div>
                                <h3><%= bundle.getString("home.technician.feature2.title") %></h3>
                                <p><%= bundle.getString("home.technician.feature2.desc") %></p>
                            </div>
                            <div class="feature-card">
                                <div class="feature-icon">💰</div>
                                <h3><%= bundle.getString("home.technician.feature3.title") %></h3>
                                <p><%= bundle.getString("home.technician.feature3.desc") %></p>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- Page-specific Scripts -->
                <script>
                    // Hero section visibility on scroll
                    const heroSections = document.querySelectorAll('.hero-section');
                    const observerOptions = {
                        threshold: 0.5
                    };

                    const observer = new IntersectionObserver((entries) => {
                        entries.forEach(entry => {
                            if (entry.isIntersecting) {
                                entry.target.classList.add('active');
                            } else {
                                entry.target.classList.remove('active');
                            }
                        });
                    }, observerOptions);

                    heroSections.forEach(section => {
                        observer.observe(section);
                    });

                    // Smooth scroll for internal links
                    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
                        anchor.addEventListener('click', function (e) {
                            e.preventDefault();
                            const target = document.querySelector(this.getAttribute('href'));
                            if (target) {
                                target.scrollIntoView({
                                    behavior: 'smooth',
                                    block: 'start'
                                });
                            }
                        });
                    });
                </script>
            </body>

            </html>
