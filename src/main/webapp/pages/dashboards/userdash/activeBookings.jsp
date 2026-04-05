<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ page import="com.dailyfixer.model.User" %>

<% User user=(User) session.getAttribute("currentUser"); if (user==null || user.getRole()==null ||
        !"user".equalsIgnoreCase(user.getRole().trim())) {
            response.sendRedirect(request.getContextPath() + "/pages/authentication/login.jsp" ); return; } %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Active Bookings | Daily Fixer</title>
    <link
            href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&family=Inter:wght@400;500;600;700&display=swap"
            rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/framework.css">
    <style>
        .alert-banner { padding: 0.9rem 1.2rem; border-radius: 0.5rem; margin-bottom: 1rem; font-weight: 500; }
        .alert-banner.success { background: #10b981; color: white; }
        .alert-banner.warning { background: #f59e0b; color: white; }
        .reschedule-info { background: #fef3c7; border: 1px solid #fcd34d; border-radius: 0.4rem; padding: 0.55rem 0.85rem; font-size: 0.82rem; margin-top: 0.4rem; color: #92400e; }
        .reschedule-info strong { color: #78350f; }
    </style>
</head>

<body class="dashboard-layout">
<jsp:include page="sidebar.jsp"/>

<main class="dashboard-container">
    <header class="dashboard-header">
        <h1>Active Bookings</h1>
        <p>Manage and track your ongoing service requests</p>
    </header>

    <!-- Alert banners -->
    <c:if test="${param.rescheduleRequested}">
        <div class="alert-banner success">Reschedule request submitted. Your technician will be notified.</div>
    </c:if>
    <c:if test="${param.rescheduleAccepted}">
        <div class="alert-banner success">Reschedule accepted. Your booking date has been updated.</div>
    </c:if>
    <c:if test="${param.rescheduleRejected}">
        <div class="alert-banner warning">Reschedule request rejected. Your booking continues at the original time.</div>
    </c:if>

    <div class="section">
        <div class="table-container">
            <c:choose>
                <c:when test="${empty activeBookings}">
                    <div class="empty-state">
                        <h3>No Active Bookings</h3>
                        <p>You don't have any requested or accepted bookings at the moment.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <table>
                        <thead>
                        <tr>
                            <th>Service</th>
                            <th>Technician</th>
                            <th>Date & Time</th>
                            <th>Address</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="b" items="${activeBookings}">
                            <tr>
                                <td>
                                    <strong>${b.serviceName}</strong>
                                    <c:if test="${not empty b.recurringContractId}">
                                        <br><span style="display:inline-block; background:#dbeafe; color:#1e40af; border-radius:4px; padding:1px 6px; font-size:0.75rem; font-weight:700; margin-top:2px;">&#8635; Recurring &mdash; Month ${b.recurringSequence}/12</span>
                                        <br><a href="${pageContext.request.contextPath}/pages/dashboards/userdash/recurringContracts.jsp" style="font-size:0.78rem; color:var(--muted-foreground); text-decoration:underline;">View full contract</a>
                                    </c:if>
                                    <br><small>${b.problemDescription}</small>
                                </td>
                                <td>${b.technicianName}</td>
                                <td>
                                    <fmt:formatDate value="${b.bookingDate}" pattern="MMM dd, yyyy"/><br>
                                    <fmt:formatDate value="${b.bookingTime}" pattern="hh:mm a" type="time"/>
                                </td>
                                <td>${b.locationAddress}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${b.status eq 'ACCEPTED'}">
                                            <span class="status-badge" style="background:#d1fae5;color:#065f46;">Accepted</span>
                                        </c:when>
                                        <c:when test="${b.status eq 'IN_PROGRESS'}">
                                            <span class="status-badge" style="background:#dbeafe;color:#1e40af;">In Progress</span>
                                        </c:when>
                                        <c:when test="${b.status eq 'RESCHEDULE_PENDING'}">
                                            <span class="status-badge" style="background:#fef3c7;color:#92400e;">Reschedule Pending</span>
                                            <c:set var="pr" value="${pendingReschedules[b.bookingId]}"/>
                                            <c:if test="${not empty pr}">
                                                <div class="reschedule-info">
                                                    New time: <strong><fmt:formatDate value="${pr.newDate}" pattern="MMM dd, yyyy"/> at <fmt:formatDate value="${pr.newTime}" pattern="hh:mm a" type="time"/></strong>
                                                    <c:if test="${not empty pr.reason}"> &mdash; &ldquo;${pr.reason}&rdquo;</c:if>
                                                </div>
                                            </c:if>
                                        </c:when>
                                        <c:when test="${b.status eq 'NO_SHOW'}">
                                            <span class="status-badge" style="background:#fee2e2;color:#991b1b;">No Show</span>
                                        </c:when>
                                        <c:when test="${b.status eq 'TECHNICIAN_COMPLETED'}">
                                            <span class="status-badge" style="background:#e0e7ff;color:#3730a3;">Awaiting Confirmation</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge priority-low" style="background:#fef3c7;color:#92400e;">Pending</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <a href="${pageContext.request.contextPath}/chats?userId=${fn:replace(b.technicianName, ' ', '')}"
                                           class="btn-primary"
                                           style="padding: 4px 10px; font-size: 0.8em; margin-right: 5px;">Message</a>

                                        <%-- Confirm completion (TECHNICIAN_COMPLETED) --%>
                                        <c:if test="${b.status eq 'TECHNICIAN_COMPLETED'}">
                                            <form method="post" action="${pageContext.request.contextPath}/bookings/complete" style="display:inline;">
                                                <input type="hidden" name="bookingId" value="${b.bookingId}">
                                                <input type="hidden" name="completionType" value="user">
                                                <button type="submit" class="btn-secondary"
                                                        style="padding:4px 10px;font-size:0.8em;background:#4f46e5;color:white;border:none;cursor:pointer;">Confirm Completion</button>
                                            </form>
                                        </c:if>

                                        <%-- Request reschedule (ACCEPTED only) --%>
                                        <c:if test="${b.status eq 'ACCEPTED'}">
                                            <button onclick="openRescheduleModal(${b.bookingId})"
                                                    style="padding:4px 10px;font-size:0.8em;background:#6b7280;color:white;border:none;border-radius:4px;cursor:pointer;font-family:inherit;">Reschedule</button>
                                        </c:if>

                                        <%-- Respond to technician's reschedule request --%>
                                        <c:if test="${b.status eq 'RESCHEDULE_PENDING'}">
                                            <c:set var="pr" value="${pendingReschedules[b.bookingId]}"/>
                                            <c:choose>
                                                <c:when test="${not empty pr and pr.requestedBy eq sessionScope.currentUser.userId}">
                                                    <span style="font-size:0.78rem;color:#92400e;font-weight:600;">Awaiting technician response</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:if test="${not empty pr}">
                                                        <form method="post" action="${pageContext.request.contextPath}/bookings/reschedule/respond" style="display:inline;">
                                                            <input type="hidden" name="bookingId" value="${b.bookingId}">
                                                            <input type="hidden" name="rescheduleId" value="${pr.rescheduleId}">
                                                            <input type="hidden" name="action" value="accept">
                                                            <input type="hidden" name="keepBooking" value="true">
                                                            <button type="submit" style="padding:4px 10px;font-size:0.8em;background:#10b981;color:white;border:none;border-radius:4px;cursor:pointer;font-family:inherit;">Accept</button>
                                                        </form>
                                                        <form method="post" action="${pageContext.request.contextPath}/bookings/reschedule/respond" style="display:inline;">
                                                            <input type="hidden" name="bookingId" value="${b.bookingId}">
                                                            <input type="hidden" name="rescheduleId" value="${pr.rescheduleId}">
                                                            <input type="hidden" name="action" value="reject">
                                                            <input type="hidden" name="keepBooking" value="true">
                                                            <button type="submit" style="padding:4px 10px;font-size:0.8em;background:#f59e0b;color:white;border:none;border-radius:4px;cursor:pointer;font-family:inherit;">Reject</button>
                                                        </form>
                                                        <form method="post" action="${pageContext.request.contextPath}/bookings/reschedule/respond" style="display:inline;">
                                                            <input type="hidden" name="bookingId" value="${b.bookingId}">
                                                            <input type="hidden" name="rescheduleId" value="${pr.rescheduleId}">
                                                            <input type="hidden" name="action" value="reject">
                                                            <input type="hidden" name="keepBooking" value="false">
                                                            <button type="submit" style="padding:4px 10px;font-size:0.8em;background:#ef4444;color:white;border:none;border-radius:4px;cursor:pointer;font-family:inherit;">Reject &amp; Cancel</button>
                                                        </form>
                                                    </c:if>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:if>

                                        <%-- NO_SHOW note --%>
                                        <c:if test="${b.status eq 'NO_SHOW'}">
                                            <span style="font-size:0.78rem;color:#991b1b;font-weight:600;">Technician did not show up.</span>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</main>

<!-- Reschedule Request Modal -->
<div id="rescheduleModal" style="display:none;position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.5);z-index:1000;align-items:center;justify-content:center;">
    <div style="background:var(--card);padding:2rem;border-radius:0.75rem;max-width:480px;width:90%;border:1px solid var(--border);">
        <h3 style="font-size:1.3rem;font-weight:700;margin-bottom:1rem;">Request Reschedule</h3>
        <form id="rescheduleForm" method="post" action="${pageContext.request.contextPath}/bookings/reschedule/request">
            <input type="hidden" name="bookingId" id="rescheduleBookingId">
            <div style="margin-bottom:0.9rem;">
                <label style="display:block;margin-bottom:0.4rem;font-weight:600;">New Date *</label>
                <input type="date" name="newDate" required style="width:100%;padding:0.65rem;border:1px solid var(--border);border-radius:0.4rem;background:var(--input);color:var(--foreground);font-family:inherit;">
            </div>
            <div style="margin-bottom:0.9rem;">
                <label style="display:block;margin-bottom:0.4rem;font-weight:600;">New Time *</label>
                <input type="time" name="newTime" required style="width:100%;padding:0.65rem;border:1px solid var(--border);border-radius:0.4rem;background:var(--input);color:var(--foreground);font-family:inherit;">
            </div>
            <div style="margin-bottom:0.9rem;">
                <label style="display:block;margin-bottom:0.4rem;font-weight:600;">Reason (optional)</label>
                <textarea name="reason" rows="3" placeholder="Reason for rescheduling..."
                    style="width:100%;padding:0.65rem;border:1px solid var(--border);border-radius:0.4rem;background:var(--input);color:var(--foreground);resize:vertical;font-family:inherit;"></textarea>
            </div>
            <div style="display:flex;gap:0.75rem;">
                <button type="submit" style="flex:1;padding:0.7rem;background:#10b981;color:white;border:none;border-radius:0.4rem;font-weight:600;cursor:pointer;font-family:inherit;">Submit Request</button>
                <button type="button" onclick="closeRescheduleModal()" style="flex:1;padding:0.7rem;background:var(--secondary);color:var(--secondary-foreground);border:1px solid var(--border);border-radius:0.4rem;font-weight:600;cursor:pointer;font-family:inherit;">Cancel</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openRescheduleModal(bookingId) {
        document.getElementById('rescheduleBookingId').value = bookingId;
        document.getElementById('rescheduleModal').style.display = 'flex';
    }
    function closeRescheduleModal() {
        document.getElementById('rescheduleModal').style.display = 'none';
    }
    document.getElementById('rescheduleModal').addEventListener('click', function(e) {
        if (e.target === this) closeRescheduleModal();
    });
</script>
</body>
</html>