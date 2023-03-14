package com.example.fortuneko.service.notification;

import android.util.Pair;

import com.example.fortuneko.exception.LanguageNotSupportedException;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class NotificationText {
    private final Map<String, String> notificationText;

    public static final List<String> acceptedLanguages = Arrays.asList(LanguageConstants.PORTUGUESE, LanguageConstants.ENGLISH);

    NotificationText(List<Pair<String, String>> texts) throws LanguageNotSupportedException {
        this.notificationText = new HashMap<>();
        for(Pair<String, String> text : texts){
            if(acceptedLanguages.contains(text.first)){
                notificationText.put(text.first, text.second);
            }
            else throw new LanguageNotSupportedException(text.first);
        }
    }

    public String getNotificationText(String language) throws LanguageNotSupportedException {
        if(acceptedLanguages.contains(language)){
            return notificationText.get(language);
        }
        else throw new LanguageNotSupportedException(language);
    }

    public static final class LanguageConstants {
        public static final String PORTUGUESE = "pt";
        public static final String ENGLISH = "en";
    }

}
