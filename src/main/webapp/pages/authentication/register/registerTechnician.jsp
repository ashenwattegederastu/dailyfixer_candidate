<%@ page contentType="text/html; charset=UTF-8" %>
    <%@ page import="java.util.*" %>
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
            <title><%= bundle.getString("auth.registerTechnician.pageTitle") %></title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/framework.css">
            <style>
                body {
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    min-height: 100vh;
                    background-color: var(--background);
                    padding: 40px 20px;
                }

                .register-container {
                    width: 100%;
                    max-width: 650px;
                }

                .form-container {
                    margin: 0 auto;
                }

                .page-header {
                    text-align: center;
                    margin-bottom: 30px;
                }

                .page-header h2 {
                    font-size: 2rem;
                    color: var(--primary);
                    margin-bottom: 10px;
                }

                .page-header p {
                    color: var(--muted-foreground);
                }

                .error-text {
                    color: var(--destructive);
                    font-size: 0.85rem;
                    font-weight: 500;
                }

                .server-error {
                    background-color: var(--destructive);
                    color: white;
                    padding: 15px;
                    border-radius: var(--radius-md);
                    margin-bottom: 20px;
                    font-weight: 500;
                    line-height: 1.6;
                }

                .section-title {
                    font-size: 0.85rem;
                    font-weight: 700;
                    color: var(--primary);
                    text-transform: uppercase;
                    letter-spacing: 0.5px;
                    margin-top: 24px;
                    margin-bottom: 16px;
                }

                .section-title:first-of-type {
                    margin-top: 0;
                }

                .form-cols {
                    display: grid;
                    grid-template-columns: 1fr 1fr;
                    gap: 16px;
                }

                .login-link {
                    text-align: center;
                    margin-top: 20px;
                    color: var(--muted-foreground);
                }

                .login-link a {
                    color: var(--primary);
                    font-weight: 600;
                    text-decoration: none;
                }

                .login-link a:hover {
                    text-decoration: underline;
                }

                @media (max-width: 600px) {
                    .form-cols {
                        grid-template-columns: 1fr;
                        gap: 0;
                    }
                }
            </style>
        </head>

        <body>

            <div class="register-container">
                <div class="form-container">
                    <div class="page-header">
                        <h2><%= bundle.getString("auth.registerTechnician.title") %></h2>
                        <p><%= bundle.getString("auth.registerTechnician.subtitle") %></p>
                    </div>

                    <div id="errorMsg" class="server-error" style="display: none;"></div>

                    <form method="post" action="${pageContext.request.contextPath}/registerTechnician" id="registerForm">
                        <div class="section-title"><%= bundle.getString("auth.registerTechnician.personalDetails") %></div>

                        <div class="form-cols">
                            <div class="form-group">
                                <label for="firstName"><%= bundle.getString("auth.registerUser.firstName") %></label>
                                <input type="text" name="firstName" id="firstName" placeholder="<%= bundle.getString("auth.registerUser.firstName") %>" required>
                            </div>
                            <div class="form-group">
                                <label for="lastName"><%= bundle.getString("auth.registerUser.lastName") %></label>
                                <input type="text" name="lastName" id="lastName" placeholder="<%= bundle.getString("auth.registerUser.lastName") %>" required>
                            </div>
                        </div>

                        <div class="form-cols">
                            <div class="form-group">
                                <label for="username"><%= bundle.getString("auth.registerUser.username") %></label>
                                <input type="text" name="username" id="username" placeholder="<%= bundle.getString("auth.registerUser.username") %>" required>
                            </div>
                            <div class="form-group">
                                <label for="email"><%= bundle.getString("auth.registerUser.emailAddress") %></label>
                                <input type="email" name="email" id="email" placeholder="<%= bundle.getString("auth.registerUser.emailAddress") %>" required>
                            </div>
                        </div>

                        <div class="form-cols">
                            <div class="form-group">
                                <label for="password"><%= bundle.getString("auth.registerUser.password") %></label>
                                <input type="password" name="password" id="password"
                                    placeholder="<%= bundle.getString("auth.registerTechnician.passwordPlaceholder") %>" required>
                            </div>
                            <div class="form-group">
                                <label for="confirmPassword"><%= bundle.getString("auth.registerUser.confirmPassword") %></label>
                                <input type="password" name="confirmPassword" id="confirmPassword"
                                    placeholder="<%= bundle.getString("auth.registerUser.confirmPassword") %>" required>
                            </div>
                        </div>

                        <div class="section-title"><%= bundle.getString("auth.registerTechnician.contactInfo") %></div>

                        <div class="form-cols">
                            <div class="form-group">
                                <label for="phone"><%= bundle.getString("auth.registerUser.phoneNumber") %></label>
                                <input type="text" name="phone" id="phone" placeholder="<%= bundle.getString("auth.registerUser.phoneNumber") %>">
                            </div>
                            <div class="form-group">
                                <label for="city"><%= bundle.getString("auth.registerUser.city") %></label>
                                <select name="city" id="city" class="filter-select" style="width: 100%;" required>
                                    <option value=""><%= bundle.getString("auth.registerTechnician.selectCity") %></option>
                                    <% String[]
                                        cities={"Colombo","Kandy","Galle","Jaffna","Kurunegala","Matara","Trincomalee","Batticaloa","Negombo","Anuradhapura","Polonnaruwa","Badulla","Ratnapura","Puttalam","Kilinochchi","Mannar","Hambantota"};
                                        for (String c : cities) { %>
                                        <option value="<%=c%>">
                                            <%=c%>
                                        </option>
                                        <% } %>
                                </select>
                            </div>
                        </div>

                        <button type="submit" class="btn-primary" style="width: 100%; margin-top: 24px;">Register
                            <%= bundle.getString("auth.registerTechnician.registerButton") %></button>
                    </form>
                    <p class="login-link"><%= bundle.getString("auth.registerUser.alreadyHaveAccount") %> <a href="${pageContext.request.contextPath}/pages/authentication/login.jsp"><%= bundle.getString("auth.registerUser.loginHere") %></a></p>
                </div>
            </div>

            <script>
                document.getElementById('registerForm').addEventListener('submit', function (e) {
                    var errorMsg = [];
                    var firstName = document.getElementById('firstName').value.trim();
                    var lastName = document.getElementById('lastName').value.trim();
                    var username = document.getElementById('username').value.trim();
                    var email = document.getElementById('email').value.trim();
                    var password = document.getElementById('password').value;
                    var confirmPassword = document.getElementById('confirmPassword').value;
                    var city = document.getElementById('city').value;

                    if (!firstName) errorMsg.push("<%= bundle.getString("auth.validation.firstNameRequiredWithPeriod") %>");
                    if (!lastName) errorMsg.push("<%= bundle.getString("auth.validation.lastNameRequiredWithPeriod") %>");
                    if (!username) errorMsg.push("<%= bundle.getString("auth.validation.usernameRequiredWithPeriod") %>");
                    if (!email) errorMsg.push("<%= bundle.getString("auth.validation.emailRequiredWithPeriod") %>");
                    if (!password) errorMsg.push("<%= bundle.getString("auth.validation.passwordRequiredWithPeriod") %>");
                    if (password && password.length < 6) errorMsg.push("<%= bundle.getString("auth.validation.passwordMin6WithPeriod") %>");
                    if (password !== confirmPassword) errorMsg.push("<%= bundle.getString("auth.validation.passwordsDoNotMatchWithPeriod") %>");
                    if (!city) errorMsg.push("<%= bundle.getString("auth.validation.cityRequiredWithPeriod") %>");

                    var errorDiv = document.getElementById('errorMsg');
                    if (errorMsg.length > 0) {
                        errorDiv.innerHTML = errorMsg.join("<br>");
                        errorDiv.style.display = 'block';
                        e.preventDefault();
                    } else {
                        errorDiv.style.display = 'none';
                    }
                });
            </script>
            <script src="${pageContext.request.contextPath}/assets/js/password-toggle.js"></script>

        </body>

        </html>
