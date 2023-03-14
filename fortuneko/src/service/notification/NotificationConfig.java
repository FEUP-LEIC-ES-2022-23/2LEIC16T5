package service.notification;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import utils.Pair;

public class NotificationConfig {
    private final Map<String, NotificationText> notificationMap;

    public NotificationConfig(Map<String, List<Pair<String, String>>> configs) {
        notificationMap = new HashMap<>();
        for (String config : configs.keySet()) {
            NotificationText notificationText = new NotificationText(Objects.requireNonNull(configs.get(config)));
        }
    }

    public String getNotificationText(String notificationType, String language) {
        NotificationText notificationText = notificationMap.get(notificationType);
        return notificationText.getNotificationText(language);
    }
}
