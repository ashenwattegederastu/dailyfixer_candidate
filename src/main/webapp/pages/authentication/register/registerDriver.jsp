<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
    <title><%= bundle.getString("auth.registerDriver.pageTitle") %></title>
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
            max-width: 700px;
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
            margin-top: 5px;
            font-weight: 500;
        }

        .server-error {
            background-color: var(--destructive);
            color: white;
            padding: 15px;
            border-radius: var(--radius-md);
            margin-bottom: 20px;
            font-weight: 500;
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

        .section-title {
            font-size: 1rem;
            font-weight: 700;
            color: var(--foreground);
            margin-top: 28px;
            margin-bottom: 14px;
            padding-bottom: 8px;
            border-bottom: 2px solid var(--border);
        }

        .file-upload-group {
            margin-bottom: 16px;
        }

        .file-upload-group label {
            display: block;
            font-weight: 600;
            margin-bottom: 6px;
            color: var(--foreground);
            font-size: 0.9rem;
        }

        .file-upload-group .file-hint {
            font-size: 0.8rem;
            color: var(--muted-foreground);
            margin-bottom: 6px;
        }

        .file-upload-group input[type="file"] {
            width: 100%;
            padding: 10px;
            border: 2px dashed var(--border);
            border-radius: var(--radius-md);
            background: var(--muted);
            cursor: pointer;
            font-size: 0.9rem;
        }

        .file-upload-group input[type="file"]:hover {
            border-color: var(--primary);
        }

        .file-preview {
            margin-top: 8px;
            max-width: 200px;
            max-height: 120px;
            border-radius: var(--radius-md);
            border: 1px solid var(--border);
            display: none;
            object-fit: cover;
        }

        .policy-group {
            margin-top: 24px;
            display: flex;
            align-items: flex-start;
            gap: 10px;
        }

        .policy-group input[type="checkbox"] {
            margin-top: 3px;
            width: 18px;
            height: 18px;
            accent-color: var(--primary);
        }

        .policy-group label {
            font-size: 0.9rem;
            color: var(--foreground);
        }

        .policy-group label a {
            color: var(--primary);
            font-weight: 600;
            text-decoration: none;
        }

        .policy-group label a:hover {
            text-decoration: underline;
        }

        .required-star {
            color: var(--destructive);
        }
    </style>
</head>

<body>

    <div class="register-container">
        <div class="form-container">
            <div class="page-header">
                <h2><%= bundle.getString("auth.registerDriver.title") %></h2>
                <p><%= bundle.getString("auth.registerDriver.subtitle") %></p>
            </div>

            <%
                String error = request.getParameter("error");
                if (error != null && !error.isEmpty()) {
            %>
            <div class="server-error"><%= error %></div>
            <% } %>

            <div id="error" class="error-text" style="margin-bottom: 15px; text-align: center;"></div>

            <form action="${pageContext.request.contextPath}/RegisterDriverServlet" method="post" enctype="multipart/form-data" id="registerForm">

                <!-- Personal Information -->
                <div class="section-title"><%= bundle.getString("auth.registerDriver.personalInfo") %></div>

                <div class="form-cols">
                    <div class="form-group">
                        <label for="first_name"><%= bundle.getString("auth.registerUser.firstName") %> <span class="required-star">*</span></label>
                        <input type="text" name="first_name" id="first_name" placeholder="<%= bundle.getString("auth.registerUser.firstName") %>" required>
                    </div>

                    <div class="form-group">
                        <label for="last_name"><%= bundle.getString("auth.registerUser.lastName") %> <span class="required-star">*</span></label>
                        <input type="text" name="last_name" id="last_name" placeholder="<%= bundle.getString("auth.registerUser.lastName") %>" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="username"><%= bundle.getString("auth.registerUser.username") %> <span class="required-star">*</span></label>
                    <input type="text" name="username" id="username" placeholder="<%= bundle.getString("auth.registerUser.username") %>" required>
                </div>

                <div class="form-cols">
                    <div class="form-group">
                        <label for="email"><%= bundle.getString("auth.registerUser.emailAddress") %> <span class="required-star">*</span></label>
                        <input type="email" name="email" id="email" placeholder="<%= bundle.getString("auth.registerUser.emailAddress") %>" required>
                    </div>

                    <div class="form-group">
                        <label for="phone_number"><%= bundle.getString("auth.registerUser.phoneNumber") %> <span class="required-star">*</span></label>
                        <input type="tel" name="phone_number" id="phone_number" placeholder="<%= bundle.getString("auth.registerUser.phoneNumber") %>" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="city"><%= bundle.getString("auth.registerUser.city") %> <span class="required-star">*</span></label>
                    <input type="text" name="city" id="city" placeholder="<%= bundle.getString("auth.registerUser.city") %>" required>
                </div>

                <!-- Identification Documents -->
                <div class="section-title"><%= bundle.getString("auth.registerDriver.identificationDocs") %></div>

                <div class="form-group">
                    <label for="nic_number"><%= bundle.getString("auth.registerDriver.nicNumber") %> <span class="required-star">*</span></label>
                    <input type="text" name="nic_number" id="nic_number"
                           placeholder="<%= bundle.getString("auth.registerDriver.nicPlaceholder") %>" required>
                    <div id="nicError" class="error-text"></div>
                </div>

                <div class="form-cols">
                    <div class="file-upload-group">
                        <label><%= bundle.getString("auth.registerDriver.nicFrontPhoto") %> <span class="required-star">*</span></label>
                        <div class="file-hint"><%= bundle.getString("auth.registerDriver.nicFrontHint") %></div>
                        <input type="file" name="nic_front" id="nic_front" accept="image/*" required
                               onchange="previewFile(this, 'nicFrontPreview')">
                        <img id="nicFrontPreview" class="file-preview" alt="<%= bundle.getString("auth.registerDriver.nicFrontPreview") %>">
                    </div>

                    <div class="file-upload-group">
                        <label><%= bundle.getString("auth.registerDriver.nicBackPhoto") %> <span class="required-star">*</span></label>
                        <div class="file-hint"><%= bundle.getString("auth.registerDriver.nicBackHint") %></div>
                        <input type="file" name="nic_back" id="nic_back" accept="image/*" required
                               onchange="previewFile(this, 'nicBackPreview')">
                        <img id="nicBackPreview" class="file-preview" alt="<%= bundle.getString("auth.registerDriver.nicBackPreview") %>">
                    </div>
                </div>

                <!-- Profile Picture -->
                <div class="section-title"><%= bundle.getString("auth.registerDriver.profilePicture") %></div>

                <div class="file-upload-group">
                    <label><%= bundle.getString("auth.registerDriver.driverPhoto") %> <span class="required-star">*</span></label>
                    <div class="file-hint"><%= bundle.getString("auth.registerDriver.driverPhotoHint") %></div>
                    <input type="file" name="profile_picture" id="profile_picture" accept="image/*" required
                           onchange="previewFile(this, 'profilePreview')">
                    <img id="profilePreview" class="file-preview" alt="<%= bundle.getString("auth.registerDriver.profilePreview") %>">
                </div>

                <!-- Driving License -->
                <div class="section-title"><%= bundle.getString("auth.registerDriver.drivingLicense") %></div>

                <div class="form-cols">
                    <div class="file-upload-group">
                        <label><%= bundle.getString("auth.registerDriver.licenseFrontPhoto") %> <span class="required-star">*</span></label>
                        <div class="file-hint"><%= bundle.getString("auth.registerDriver.licenseFrontHint") %></div>
                        <input type="file" name="license_front" id="license_front" accept="image/*" required
                               onchange="previewFile(this, 'licenseFrontPreview')">
                        <img id="licenseFrontPreview" class="file-preview" alt="<%= bundle.getString("auth.registerDriver.licenseFrontPreview") %>">
                    </div>

                    <div class="file-upload-group">
                        <label><%= bundle.getString("auth.registerDriver.licenseBackPhoto") %></label>
                        <div class="file-hint"><%= bundle.getString("auth.registerDriver.licenseBackHint") %></div>
                        <input type="file" name="license_back" id="license_back" accept="image/*"
                               onchange="previewFile(this, 'licenseBackPreview')">
                        <img id="licenseBackPreview" class="file-preview" alt="<%= bundle.getString("auth.registerDriver.licenseBackPreview") %>">
                    </div>
                </div>

                <!-- Password -->
                <div class="section-title"><%= bundle.getString("auth.registerDriver.accountSecurity") %></div>

                <div class="form-cols">
                    <div class="form-group">
                        <label for="password"><%= bundle.getString("auth.registerUser.password") %> <span class="required-star">*</span></label>
                        <input type="password" name="password" id="password" placeholder="<%= bundle.getString("auth.registerDriver.passwordPlaceholder") %>" required>
                    </div>

                    <div class="form-group">
                        <label for="confirmPassword"><%= bundle.getString("auth.registerUser.confirmPassword") %> <span class="required-star">*</span></label>
                        <input type="password" name="confirmPassword" id="confirmPassword"
                               placeholder="<%= bundle.getString("auth.registerUser.confirmPassword") %>" required>
                    </div>
                </div>

                <!-- Policy Acceptance -->
                <div class="policy-group">
                    <input type="checkbox" name="policy_accepted" id="policy_accepted" required>
                    <label for="policy_accepted">
                        <%= bundle.getString("auth.registerDriver.policyAgreementPrefix") %>
                        <a href="${pageContext.request.contextPath}/pages/policies/driver-policies.jsp" target="_blank"><%= bundle.getString("auth.registerDriver.driverPolicies") %></a>
                        <span class="required-star">*</span>
                    </label>
                </div>

                <button type="submit" class="btn-primary" style="width: 100%; margin-top: 24px;">
                    <%= bundle.getString("auth.registerDriver.submitApplication") %>
                </button>
            </form>
            <p class="login-link"><%= bundle.getString("auth.registerUser.alreadyHaveAccount") %> <a href="${pageContext.request.contextPath}/pages/authentication/login.jsp"><%= bundle.getString("auth.registerUser.loginHere") %></a></p>
        </div>
    </div>

    <script>
        function previewFile(input, previewId) {
            var preview = document.getElementById(previewId);
            if (input.files && input.files[0]) {
                var file = input.files[0];

                // Validate file type
                if (!file.type.startsWith('image/')) {
                    alert('<%= bundle.getString("auth.registerDriver.alert.selectImageFile") %>');
                    input.value = '';
                    preview.style.display = 'none';
                    return;
                }

                // Validate file size (5MB)
                if (file.size > 5 * 1024 * 1024) {
                    alert('<%= bundle.getString("auth.registerDriver.alert.fileSize") %>');
                    input.value = '';
                    preview.style.display = 'none';
                    return;
                }

                var reader = new FileReader();
                reader.onload = function(e) {
                    preview.src = e.target.result;
                    preview.style.display = 'block';
                };
                reader.readAsDataURL(file);
            } else {
                preview.style.display = 'none';
            }
        }

        document.getElementById('registerForm').addEventListener('submit', function(e) {
            var pw   = document.getElementById("password").value;
            var cpw  = document.getElementById("confirmPassword").value;
            var email = document.getElementById("email").value;
            var phone = document.getElementById("phone_number").value;
            var nic   = document.getElementById("nic_number").value.trim();
            var policy = document.getElementById("policy_accepted").checked;

            var errorMsg = "";

            if (!email.includes("@")) errorMsg += "<%= bundle.getString("auth.validation.invalidEmailFormatWithBr") %>";
            if (pw.length < 6) errorMsg += "<%= bundle.getString("auth.validation.passwordMin6WithBr") %>";
            if (pw !== cpw) errorMsg += "<%= bundle.getString("auth.validation.passwordsDoNotMatchWithBr") %>";
            if (phone.length < 10) errorMsg += "<%= bundle.getString("auth.validation.enterValidPhoneWithBr") %>";

            // NIC validation: 9 digits + V/X or 12 digits
            var nicRegex = /^\d{9}[VvXx]$|^\d{12}$/;
            if (!nicRegex.test(nic)) {
                errorMsg += "<%= bundle.getString("auth.registerDriver.invalidNicFormatWithBr") %>";
                document.getElementById("nicError").textContent = "<%= bundle.getString("auth.registerDriver.invalidNicFormat") %>";
            } else {
                document.getElementById("nicError").textContent = "";
            }

            // Validate required files
            var nicFront = document.getElementById("nic_front").files.length;
            var nicBack  = document.getElementById("nic_back").files.length;
            var profile  = document.getElementById("profile_picture").files.length;
            var licFront = document.getElementById("license_front").files.length;

            if (nicFront === 0) errorMsg += "<%= bundle.getString("auth.registerDriver.nicFrontRequiredWithBr") %>";
            if (nicBack === 0) errorMsg += "<%= bundle.getString("auth.registerDriver.nicBackRequiredWithBr") %>";
            if (profile === 0) errorMsg += "<%= bundle.getString("auth.registerDriver.profileRequiredWithBr") %>";
            if (licFront === 0) errorMsg += "<%= bundle.getString("auth.registerDriver.licenseFrontRequiredWithBr") %>";

            if (!policy) errorMsg += "<%= bundle.getString("auth.registerDriver.mustAcceptPoliciesWithBr") %>";

            var errorDiv = document.getElementById("error");
            errorDiv.innerHTML = errorMsg;

            if (errorMsg !== "") {
                e.preventDefault();
                window.scrollTo({top: 0, behavior: 'smooth'});
            }
        });
    </script>
    <script src="${pageContext.request.contextPath}/assets/js/password-toggle.js"></script>
</body>

</html>
