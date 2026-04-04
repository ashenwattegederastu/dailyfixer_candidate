<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
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
            <title><%= bundle.getString("leaderboard.pageTitle") %></title>
            <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap"
                rel="stylesheet">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/framework.css">
            <style>
                .leaderboard-container {
                    max-width: 800px;
                    margin: 100px auto 50px;
                    padding: 30px;
                    background: var(--card);
                    border-radius: var(--radius-lg);
                    box-shadow: var(--shadow-lg);
                    border: 1px solid var(--border);
                }

                .leaderboard-header {
                    text-align: center;
                    margin-bottom: 30px;
                }

                .leaderboard-header h2 {
                    font-size: 2em;
                    color: var(--primary);
                    margin-bottom: 10px;
                }

                .leaderboard-table {
                    width: 100%;
                    border-collapse: collapse;
                }

                .leaderboard-table th,
                .leaderboard-table td {
                    padding: 15px;
                    text-align: left;
                    border-bottom: 1px solid var(--border);
                }

                .leaderboard-table th {
                    color: var(--muted-foreground);
                    font-weight: 600;
                    text-transform: uppercase;
                    font-size: 0.85em;
                }

                .rank-1 {
                    color: #FFD700;
                    font-weight: bold;
                    font-size: 1.2em;
                }

                .rank-2 {
                    color: #C0C0C0;
                    font-weight: bold;
                    font-size: 1.1em;
                }

                .rank-3 {
                    color: #CD7F32;
                    font-weight: bold;
                    font-size: 1.1em;
                }

                .badge-pill {
                    background: var(--secondary);
                    color: var(--secondary-foreground);
                    padding: 4px 10px;
                    border-radius: 12px;
                    font-size: 0.8em;
                    font-weight: 500;
                }
            </style>
        </head>

        <body>

            <!-- Simple Navbar -->
            <header class="topbar">
                <div class="logo"><%= bundle.getString("brand.name") %></div>
                <div>
                    <a href="${pageContext.request.contextPath}/"
                        style="color: var(--foreground); text-decoration: none; margin-right: 20px;"><%= bundle.getString("leaderboard.home") %></a>
                    <c:if test="${sessionScope.currentUser != null}">
                        <a href="${pageContext.request.contextPath}/pages/dashboards/volunteerdash/volunteerdashmain.jsp" class="btn-primary"><%= bundle.getString("leaderboard.returnToDashboard") %></a>
                    </c:if>
                    <c:if test="${sessionScope.currentUser == null}">
                        <a href="${pageContext.request.contextPath}/pages/authentication/login.jsp"
                            class="btn-primary"><%= bundle.getString("leaderboard.login") %></a>
                    </c:if>
                </div>
            </header>

            <main class="leaderboard-container">
                <div class="leaderboard-header">
                    <h2><%= bundle.getString("leaderboard.title") %></h2>
                    <p style="color: var(--muted-foreground);"><%= bundle.getString("leaderboard.subtitle") %></p>
                </div>

                <table class="leaderboard-table">
                    <thead>
                        <tr>
                            <th width="10%"><%= bundle.getString("leaderboard.col.rank") %></th>
                            <th width="40%"><%= bundle.getString("leaderboard.col.volunteer") %></th>
                            <th width="30%"><%= bundle.getString("leaderboard.col.topBadge") %></th>
                            <th width="20%" style="text-align: right;"><%= bundle.getString("leaderboard.col.reputation") %></th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="entry" items="${leaderboard}">
                            <tr>
                                <td class="rank-${entry.rank}">#${entry.rank}</td>
                                <td style="font-weight: 600; color: var(--foreground);">${entry.name}</td>
                                <td>
                                    <c:if test="${not empty entry.badge}">
                                        <span class="badge-pill">${entry.badge}</span>
                                    </c:if>
                                    <c:if test="${empty entry.badge}">
                                        <span style="color: var(--muted-foreground); font-size: 0.8em;">-</span>
                                    </c:if>
                                </td>
                                <td style="text-align: right; font-family: monospace; font-size: 1.1em;">${entry.score}
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty leaderboard}">
                            <tr>
                                <td colspan="4"
                                    style="text-align: center; padding: 40px; color: var(--muted-foreground);">
                                    <%= bundle.getString("leaderboard.empty") %>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </main>
        </body>
        </html>
