package com.example.fortuneko.service.notification;

import android.util.Pair;

import com.example.fortuneko.exception.LanguageNotSupportedException;
import com.example.fortuneko.exception.NotificationTypeNotFoundException;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

public class NotificationConfig {
    private Map<String, NotificationText> notificationMap;
    private final String language;

    private static final List<String> acceptedNotifications = Arrays.asList(NotificationConstants.EXAMPLE);

    public NotificationConfig(Map<String, List<Pair<String, String>>> configs, NotificationText.LanguageConstants language) {
        notificationMap = new HashMap<>();
        this.language = language.toString();
        for(String config : configs.keySet()){
            if(acceptedNotifications.contains(config)){
                try {
                    NotificationText notificationText = new NotificationText(Objects.requireNonNull(configs.get(config)));
                    notificationMap.put(config, notificationText);
                }catch(LanguageNotSupportedException e){
                    System.out.println(e.getMessage());
                }
            }
        }
    }

    public String getNotificationText(NotificationConstants notificationType) throws NotificationTypeNotFoundException {
        if(notificationMap.containsKey(notificationType.toString())){
            NotificationText notificationText = notificationMap.get(notificationType.toString());
            if(notificationText != null) {
                try {
                    return notificationText.getNotificationText(language);
                } catch (LanguageNotSupportedException e) {
                    System.out.println(e.getMessage());
                }
            }
        }
        throw new NotificationTypeNotFoundException(notificationType.toString());
    }

    public static final class NotificationConstants{
        public static final String EXAMPLE = "example";
    }

}
