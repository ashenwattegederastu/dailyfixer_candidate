<%@ page contentType="text/html; charset=UTF-8" %>
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
            <title><%= bundle.getString("auth.registerUser.pageTitle") %></title>
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
                    max-width: 600px;
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

                .error-text {
                    color: var(--destructive);
                    font-size: 0.85rem;
                    margin-top: 5px;
                    font-weight: 500;
                }

                .server-error {
                    background-color: var(--destructive);
                    /* Using destructive color */
                    color: white;
                    /* Force white text on red background */
                    padding: 15px;
                    border-radius: var(--radius-md);
                    margin-bottom: 20px;
                    font-weight: 500;
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

                .form-cols {
                    display: grid;
                    grid-template-columns: 1fr 1fr;
                    gap: 20px;
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
                        <h2><%= bundle.getString("auth.registerUser.title") %></h2>
                        <p style="color: var(--muted-foreground)"><%= bundle.getString("auth.registerUser.subtitle") %></p>
                    </div>

                    <% String serverError=(String) request.getAttribute("errorMsg"); %>
                        <% if (serverError !=null) { %>
                            <div class="server-error">
                                <%= serverError %>
                            </div>
                            <% } %>

                                <form id="registerForm" method="post" action="${pageContext.request.contextPath}/registerUser">
                                    <div class="form-cols">
                                        <div class="form-group">
                                            <label for="firstName"><%= bundle.getString("auth.registerUser.firstName") %></label>
                                            <input type="text" name="firstName" id="firstName" placeholder="<%= bundle.getString("auth.registerUser.firstName") %>">
                                            <div id="firstNameError" class="error-text"></div>
                                        </div>

                                        <div class="form-group">
                                            <label for="lastName"><%= bundle.getString("auth.registerUser.lastName") %></label>
                                            <input type="text" name="lastName" id="lastName" placeholder="<%= bundle.getString("auth.registerUser.lastName") %>">
                                            <div id="lastNameError" class="error-text"></div>
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label for="username"><%= bundle.getString("auth.registerUser.username") %></label>
                                        <input type="text" name="username" id="username"
                                            placeholder="<%= bundle.getString("auth.registerUser.usernamePlaceholder") %>">
                                        <div id="usernameError" class="error-text"></div>
                                    </div>

                                    <div class="form-group">
                                        <label for="email"><%= bundle.getString("auth.registerUser.emailAddress") %></label>
                                        <input type="email" name="email" id="email" placeholder="<%= bundle.getString("auth.registerUser.emailPlaceholder") %>">
                                        <!-- input[type=email] acts like text in framework css generally, or we use class -->
                                        <div id="emailError" class="error-text"></div>
                                    </div>

                                    <div class="form-cols">
                                        <div class="form-group">
                                            <label for="password"><%= bundle.getString("auth.registerUser.password") %></label>
                                            <input type="password" name="password" id="password"
                                                placeholder="<%= bundle.getString("auth.registerUser.passwordPlaceholder") %>">
                                            <div id="passwordError" class="error-text"></div>
                                        </div>

                                        <div class="form-group">
                                            <label for="confirmPassword"><%= bundle.getString("auth.registerUser.confirmPassword") %></label>
                                            <input type="password" name="confirmPassword" id="confirmPassword"
                                                placeholder="<%= bundle.getString("auth.registerUser.confirmPasswordPlaceholder") %>">
                                            <div id="confirmPasswordError" class="error-text"></div>
                                        </div>
                                    </div>

                                    <div class="form-cols">
                                        <div class="form-group">
                                            <label for="phone"><%= bundle.getString("auth.registerUser.phoneNumber") %></label>
                                            <input type="text" name="phone" id="phone" placeholder="<%= bundle.getString("auth.registerUser.phonePlaceholder") %>">
                                            <div id="phoneError" class="error-text"></div>
                                        </div>

                                        <div class="form-group">
                                            <label for="city"><%= bundle.getString("auth.registerUser.city") %></label>
                                            <select name="city" id="city" class="filter-select" style="width: 100%">
                                                <option value=""><%= bundle.getString("auth.registerUser.selectCity") %></option>
                                                <option>Colombo</option>
                                                <option>Kandy</option>
                                                <option>Galle</option>
                                                <option>Jaffna</option>
                                                <option>Negombo</option>
                                                <option>Matara</option>
                                                <option>Trincomalee</option>
                                                <option>Anuradhapura</option>
                                                <option>Kurunegala</option>
                                                <option>Ratnapura</option>
                                                <option>Badulla</option>
                                                <option>Hambantota</option>
                                                <option>Puttalam</option>
                                                <option>Polonnaruwa</option>
                                                <option>Nuwara Eliya</option>
                                                <option>Vavuniya</option>
                                                <option>Mannar</option>
                                                <option>Mullaitivu</option>
                                                <option>Kalutara</option>
                                                <option>Batticaloa</option>
                                                <option>Ampara</option>
                                                <option>Monaragala</option>
                                                <option>Kegalle</option>
                                                <option>Matalawa</option>
                                            </select>
                                            <div id="cityError" class="error-text"></div>
                                        </div>
                                    </div>

                                    <button type="submit" class="btn-primary"
                                        style="width: 100%; margin-top: 20px;"><%= bundle.getString("auth.registerUser.register") %></button>
                                </form>

                                <p class="login-link"><%= bundle.getString("auth.registerUser.alreadyHaveAccount") %> <a href="${pageContext.request.contextPath}/pages/authentication/login.jsp"><%= bundle.getString("auth.registerUser.loginHere") %></a></p>
                </div>
            </div>

            <script>
                const form = document.getElementById('registerForm');
                form.addEventListener('submit', e => {
                    document.querySelectorAll('.error-text').forEach(el => el.textContent = '');
                    let hasError = false;
                    const f = id => document.getElementById(id).value.trim();

                    if (!f('firstName')) { document.getElementById('firstNameError').textContent = '<%= bundle.getString("auth.validation.firstNameRequired") %>'; hasError = true; }
                    if (!f('lastName')) { document.getElementById('lastNameError').textContent = '<%= bundle.getString("auth.validation.lastNameRequired") %>'; hasError = true; }
                    if (!f('username')) { document.getElementById('usernameError').textContent = '<%= bundle.getString("auth.validation.usernameRequired") %>'; hasError = true; }
                    if (!f('email')) { document.getElementById('emailError').textContent = '<%= bundle.getString("auth.validation.emailRequired") %>'; hasError = true; }
                    if (f('password').length < 6) { document.getElementById('passwordError').textContent = '<%= bundle.getString("auth.validation.passwordMin6") %>'; hasError = true; }
                    if (f('password') !== f('confirmPassword')) { document.getElementById('confirmPasswordError').textContent = '<%= bundle.getString("auth.validation.passwordsDoNotMatch") %>'; hasError = true; }
                    if (!f('city')) { document.getElementById('cityError').textContent = '<%= bundle.getString("auth.validation.cityRequired") %>'; hasError = true; }

                    // Phone number validation: exactly 10 digits
                    const phoneVal = f('phone').replace(/\D/g, ''); // remove non-digit characters
                    if (!phoneVal) {
                        document.getElementById('phoneError').textContent = '<%= bundle.getString("auth.validation.phoneRequired") %>';
                        hasError = true;
                    } else if (phoneVal.length !== 10) {
                        document.getElementById('phoneError').textContent = '<%= bundle.getString("auth.validation.phoneMustBe10") %>';
                        hasError = true;
                    }

                    // Email validation: required + valid format
                    const emailVal = f('email');
                    if (!emailVal) {
                        document.getElementById('emailError').textContent = '<%= bundle.getString("auth.validation.emailRequired") %>';
                        hasError = true;
                    } else {
                        // Simple regex for basic email format check
                        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                        if (!emailRegex.test(emailVal)) {
                                document.getElementById('emailError').textContent = '<%= bundle.getString("auth.validation.invalidEmailFormat") %>';
                            hasError = true;
                        }
                    }

                    if (hasError) e.preventDefault();
                });
            </script>
            <script src="${pageContext.request.contextPath}/assets/js/password-toggle.js"></script>
        </body>

        </html>
