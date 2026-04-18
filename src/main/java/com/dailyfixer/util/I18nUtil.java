package com.dailyfixer.util;

import java.util.Locale;
import java.util.ResourceBundle;

public final class I18nUtil {
    public static final String DEFAULT_LANG = "en";
    public static final String SINHALA_LANG = "si";
    public static final String SESSION_LANG_KEY = "lang";

    private I18nUtil() {
    }

    public static String normalizeLanguage(String lang) {
        if (SINHALA_LANG.equals(lang)) {
            return SINHALA_LANG;
        }
        return DEFAULT_LANG;
    }

    public static ResourceBundle getBundle(String lang) {
        String safeLang = normalizeLanguage(lang);
        Locale locale = Locale.forLanguageTag(safeLang);
        return ResourceBundle.getBundle("messages", locale);
    }
}
