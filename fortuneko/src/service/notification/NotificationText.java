package service.notification;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import utils.Pair;

public class NotificationText {
    private final Map<String, String> notificationText;

    public NotificationText(List<Pair<String, String>> texts){
        this.notificationText = new HashMap<>();
        for(Pair<String, String> text : texts){
                notificationText.put(text.first, text.second);
        }
    }

    public String getNotificationText(String language){
        return notificationText.get(language);
    }

}
