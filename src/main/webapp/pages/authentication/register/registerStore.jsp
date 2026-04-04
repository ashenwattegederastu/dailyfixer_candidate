<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
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
    <title><%= bundle.getString("auth.registerStore.pageTitle") %></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/framework.css">
    <style>
        body {
            display: flex;
            align-items: flex-start;
            justify-content: center;
            min-height: 100vh;
            background-color: var(--background);
            padding: 40px 20px;
        }

        .register-wrapper {
            width: 100%;
            max-width: 1200px;
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

        .register-card {
            display: flex;
            gap: 24px;
            align-items: flex-start;
        }

        /* Override form-container centering for side-by-side layout */
        .register-card .form-container {
            max-width: none;
            margin: 0;
        }

        .register-left {
            flex: 1;
        }

        .register-right {
            width: 420px;
            flex-shrink: 0;
        }

        .form-cols {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }

        /* Extend framework form-group to cover additional input types */
        .form-group input[type="email"],
        .form-group input[type="password"],
        .form-group select {
            width: 100%;
            padding: 10px 15px;
            border: 2px solid var(--border);
            border-radius: var(--radius-md);
            font-size: 0.9rem;
            background-color: var(--input);
            color: var(--foreground);
            transition: border-color 0.2s, background-color 0.3s ease, color 0.3s ease;
            font-family: var(--font-sans), serif;
        }

        .form-group input[type="email"]:focus,
        .form-group input[type="password"]:focus,
        .form-group select:focus {
            outline: none;
            border-color: var(--ring);
        }

        .section-label {
            font-size: 1.05rem;
            font-weight: 700;
            color: var(--foreground);
            margin: 20px 0 14px;
            padding-bottom: 6px;
            border-bottom: 2px solid var(--border);
        }

        .section-label:first-of-type {
            margin-top: 4px;
        }

        /* Map panel */
        #store-map {
            width: 100%;
            height: 280px;
            border-radius: var(--radius-md);
            margin-top: 12px;
            border: 2px solid var(--border);
        }

        .location-info {
            background: var(--muted);
            color: var(--muted-foreground);
            padding: 10px 14px;
            border-radius: var(--radius-md);
            margin-top: 10px;
            font-size: 0.85rem;
        }

        .location-info.success {
            background: oklch(0.92 0.05 156);
            color: oklch(0.35 0.12 156);
        }

        .location-info.error {
            background: oklch(0.96 0.03 23);
            color: var(--destructive);
        }

        .location-coords {
            font-weight: 600;
        }

        .map-instructions {
            font-size: 0.8rem;
            color: var(--muted-foreground);
            margin-top: 8px;
            padding: 10px 12px;
            background: var(--muted);
            border-radius: var(--radius-md);
        }

        .login-link {
            text-align: center;
            margin-top: 20px;
            color: var(--muted-foreground);
            font-size: 0.85rem;
        }

        .login-link a {
            color: var(--primary);
            font-weight: 600;
            text-decoration: none;
        }

        .login-link a:hover {
            text-decoration: underline;
        }

        @media (max-width: 900px) {
            .register-card {
                flex-direction: column;
            }

            .register-right {
                width: 100%;
            }

            .form-cols {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>

<body>

    <div class="register-wrapper">
        <div class="page-header">
            <h2><%= bundle.getString("auth.registerStore.title") %></h2>
            <p><%= bundle.getString("auth.registerStore.subtitle") %></p>
        </div>

        <div class="register-card">
            <!-- Left: Form -->
            <div class="register-left form-container">

                <c:if test="${not empty errorMsg}">
                    <div class="server-error">${errorMsg}</div>
                </c:if>

                <form id="registerForm" method="post" action="${pageContext.request.contextPath}/registerStore"
                    onsubmit="return submitForm(event);">
                    <input type="hidden" name="latitude" id="latitude">
                    <input type="hidden" name="longitude" id="longitude">
                    <input type="hidden" name="storeAddress" id="storeAddress">

                    <div class="section-label"><%= bundle.getString("auth.registerStore.ownerDetails") %></div>

                    <div class="form-cols">
                        <div class="form-group">
                            <label><%= bundle.getString("auth.registerStore.firstName") %></label>
                            <input type="text" name="firstName" id="firstName" required>
                        </div>
                        <div class="form-group">
                            <label><%= bundle.getString("auth.registerStore.lastName") %></label>
                            <input type="text" name="lastName" id="lastName" required>
                        </div>
                    </div>

                    <div class="form-cols">
                        <div class="form-group">
                            <label><%= bundle.getString("auth.registerStore.username") %></label>
                            <input type="text" name="username" id="username" required>
                        </div>
                        <div class="form-group">
                            <label><%= bundle.getString("auth.registerStore.password") %></label>
                            <input type="password" name="password" id="password" required>
                        </div>
                    </div>

                    <div class="form-cols">
                        <div class="form-group">
                            <label><%= bundle.getString("auth.registerStore.email") %></label>
                            <input type="email" name="email" id="email" required>
                        </div>
                        <div class="form-group">
                            <label><%= bundle.getString("auth.registerStore.phoneNumber") %></label>
                            <input type="text" name="phone" id="phone">
                        </div>
                    </div>

                    <div class="form-group">
                        <label><%= bundle.getString("auth.registerStore.yourCityOptional") %></label>
                        <select name="city">
                            <option value=""><%= bundle.getString("auth.registerStore.selectCity") %></option>
                            <% String[] cities={"Colombo","Kandy","Galle","Jaffna","Kurunegala","Matara","Trincomalee","Batticaloa","Negombo","Anuradhapura","Polonnaruwa","Badulla","Ratnapura","Puttalam","Kilinochchi","Mannar","Hambantota"};
                               for (String c : cities) { %>
                                <option value="<%=c%>"><%=c%></option>
                            <% } %>
                        </select>
                    </div>

                    <div class="section-label"><%= bundle.getString("auth.registerStore.storeDetails") %></div>

                    <div class="form-group">
                        <label><%= bundle.getString("auth.registerStore.storeName") %></label>
                        <input type="text" name="storeName" id="storeName" required>
                    </div>

                    <div class="form-cols">
                        <div class="form-group">
                            <label><%= bundle.getString("auth.registerStore.storeCity") %></label>
                            <select name="storeCity" id="storeCity" required>
                                <option value=""><%= bundle.getString("auth.registerStore.selectCity") %></option>
                                <% for (String c : cities) { %>
                                    <option value="<%=c%>"><%=c%></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label><%= bundle.getString("auth.registerStore.storeType") %></label>
                            <select name="storeType" id="storeType" required>
                                <option value=""><%= bundle.getString("auth.registerStore.selectType") %></option>
                                <option value="electronics"><%= bundle.getString("auth.registerStore.type.electronics") %></option>
                                <option value="hardware"><%= bundle.getString("auth.registerStore.type.hardware") %></option>
                                <option value="vehicle repair"><%= bundle.getString("auth.registerStore.type.vehicleRepair") %></option>
                                <option value="other"><%= bundle.getString("auth.registerStore.type.other") %></option>
                            </select>
                        </div>
                    </div>

                    <button type="submit" class="login-btn" id="submitBtn" style="width:100%;margin-top:8px;"><%= bundle.getString("auth.registerStore.registerButton") %></button>
                </form>
            </div>

            <!-- Right: Map -->
            <div class="register-right form-container">
                <h3 style="color:var(--primary);margin-bottom:6px;"><%= bundle.getString("auth.registerStore.storeLocationTitle") %></h3>
                <p style="font-size:0.85rem;color:var(--muted-foreground);"><%= bundle.getString("auth.registerStore.storeLocationSubtitle") %></p>

                <div class="form-group" style="margin-top:12px;margin-bottom:0;">
                    <label><%= bundle.getString("auth.registerStore.searchForLocation") %></label>
                    <input type="text" id="map-search-input" placeholder="<%= bundle.getString("auth.registerStore.searchPlaceholder") %>">
                </div>

                <div id="store-map"></div>

                <div class="map-instructions">
                    <strong><%= bundle.getString("auth.registerStore.tipsTitle") %></strong><br>
                    <%= bundle.getString("auth.registerStore.tip1") %><br>
                    <%= bundle.getString("auth.registerStore.tip2") %>
                </div>

                <div id="locationInfo" class="location-info">
                    <%= bundle.getString("auth.registerStore.locationNotSet") %>
                </div>

                <hr style="margin-top:20px;border-color:var(--border);">

                <div class="login-link">
                    <p><%= bundle.getString("auth.registerStore.alreadyHaveAccount") %> <a href="${pageContext.request.contextPath}/pages/authentication/login.jsp"><%= bundle.getString("auth.registerStore.logIn") %></a></p>
                    <p style="margin-top:6px;"><%= bundle.getString("auth.registerStore.orGoBack") %> <a href="${pageContext.request.contextPath}/index.jsp"><%= bundle.getString("auth.registerStore.home") %></a></p>
                    <p style="font-size:0.75rem;color:var(--muted-foreground);margin-top:10px;"><%= bundle.getString("auth.registerStore.termsNote") %></p>
                </div>
            </div>
        </div>
    </div>

            <!-- Google Maps API with Places library -->
            <script
                src="https://maps.googleapis.com/maps/api/js?key=AIzaSyA8zSes6UGbYKIHNzCp3tny5RgccFruILI&libraries=places&callback=initMap"
                async defer></script>

            <script>
                var map;
                var marker;
                var geocoder;
                var autocomplete;
                var selectedLat = null;
                var selectedLng = null;

                // Initialize the map
                function initMap() {
                    // Default center: Sri Lanka
                    var sriLanka = { lat: 7.8731, lng: 80.7718 };

                    map = new google.maps.Map(document.getElementById('store-map'), {
                        center: sriLanka,
                        zoom: 8,
                        mapTypeControl: false,
                        streetViewControl: false,
                        fullscreenControl: true
                    });

                    geocoder = new google.maps.Geocoder();

                    // Create a draggable marker
                    marker = new google.maps.Marker({
                        map: map,
                        draggable: true,
                        visible: false,
                        animation: google.maps.Animation.DROP
                    });

                    // Click on map to set location
                    map.addListener('click', function (e) {
                        setLocation(e.latLng.lat(), e.latLng.lng());
                        reverseGeocode(e.latLng);
                    });

                    // Drag marker to set location
                    marker.addListener('dragend', function (e) {
                        setLocation(e.latLng.lat(), e.latLng.lng());
                        reverseGeocode(e.latLng);
                    });

                    // Initialize Places Autocomplete
                    var searchInput = document.getElementById('map-search-input');
                    autocomplete = new google.maps.places.Autocomplete(searchInput, {
                        componentRestrictions: { country: 'lk' }, // Restrict to Sri Lanka
                        fields: ['geometry', 'formatted_address', 'name']
                    });

                    autocomplete.addListener('place_changed', function () {
                        var place = autocomplete.getPlace();

                        if (place.geometry && place.geometry.location) {
                            var lat = place.geometry.location.lat();
                            var lng = place.geometry.location.lng();

                            setLocation(lat, lng);
                            map.setCenter(place.geometry.location);
                            map.setZoom(15);

                            updateLocationInfo(place.formatted_address || place.name, lat, lng);
                        } else {
                            showLocationError('<%= bundle.getString("auth.registerStore.couldNotFindLocation") %>');
                        }
                    });
                }

                // Set the location coordinates
                function setLocation(lat, lng) {
                    selectedLat = lat;
                    selectedLng = lng;

                    // Update hidden form fields
                    document.getElementById('latitude').value = lat;
                    document.getElementById('longitude').value = lng;

                    // Update marker position
                    var position = new google.maps.LatLng(lat, lng);
                    marker.setPosition(position);
                    marker.setVisible(true);
                }

                // Reverse geocode to get address from coordinates
                function reverseGeocode(latLng) {
                    geocoder.geocode({ location: latLng }, function (results, status) {
                        if (status === 'OK' && results[0]) {
                            updateLocationInfo(results[0].formatted_address, latLng.lat(), latLng.lng());
                        } else {
                            updateLocationInfo('<%= bundle.getString("auth.registerStore.locationSelected") %>', latLng.lat(), latLng.lng());
                        }
                    });
                }

                // Update the location info display
                function updateLocationInfo(address, lat, lng) {
                    var infoDiv = document.getElementById('locationInfo');
                    infoDiv.className = 'location-info success';
                    infoDiv.innerHTML = '<strong><%= bundle.getString("auth.registerStore.locationSet") %></strong><br>' +
                        '<span style="font-size:12px;">' + address + '</span><br>' +
                        '<span class="location-coords"><%= bundle.getString("auth.registerStore.lat") %>: ' + lat.toFixed(6) + ', <%= bundle.getString("auth.registerStore.lng") %>: ' + lng.toFixed(6) + '</span>';

                    // Auto-fill the hidden store address field
                    document.getElementById('storeAddress').value = address;
                }

                // Show location error
                function showLocationError(message) {
                    var infoDiv = document.getElementById('locationInfo');
                    infoDiv.className = 'location-info error';
                    infoDiv.innerHTML = '<strong><%= bundle.getString("auth.registerStore.error") %></strong> ' + message;
                }

                // Client-side validation
                function validateForm() {
                    var u = document.getElementById('username').value.trim();
                    var em = document.getElementById('email').value.trim();
                    var pw = document.getElementById('password').value;
                    var sn = document.getElementById('storeName').value.trim();
                    var lat = document.getElementById('latitude').value;
                    var lng = document.getElementById('longitude').value;
                    var sc = document.getElementById('storeCity').value;

                    var err = [];
                    if (!u) err.push("<%= bundle.getString("auth.validation.usernameRequired") %>");
                    if (!em) err.push("<%= bundle.getString("auth.validation.emailRequired") %>");
                    if (!pw || pw.length < 6) err.push("<%= bundle.getString("auth.registerStore.passwordRequiredMin6") %>");
                    if (!sn) err.push("<%= bundle.getString("auth.registerStore.storeNameRequired") %>");
                    if (!lat || !lng || lat === '' || lng === '') err.push("<%= bundle.getString("auth.registerStore.selectStoreLocation") %>");
                    if (!sc) err.push("<%= bundle.getString("auth.registerStore.storeCityRequired") %>");

                    if (err.length) {
                        alert(err.join("\n"));
                        return false;
                    }
                    return true;
                }

                // Submit form - geocode if no map selection, else use selected coords
                function submitForm(event) {
                    event.preventDefault();

                    if (!validateForm()) {
                        return false;
                    }

                    var submitBtn = document.getElementById('submitBtn');
                    submitBtn.disabled = true;
                    submitBtn.textContent = '<%= bundle.getString("auth.registerStore.registering") %>';

                    // Submit the form - validation already checked that location is set
                    document.getElementById('registerForm').submit();
                    return false;
                }
            </script>

        </body>

        </html>
