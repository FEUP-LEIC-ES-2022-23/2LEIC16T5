package com.example.fortuneko.exception;

public class NotificationTypeNotFoundException extends Exception{
    public NotificationTypeNotFoundException(String notificationType){
        super(String.format("Notification type [%s] not found\n", notificationType));
    }
}
