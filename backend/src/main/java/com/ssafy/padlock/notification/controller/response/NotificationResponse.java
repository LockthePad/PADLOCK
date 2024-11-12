package com.ssafy.padlock.notification.controller.response;

import com.ssafy.padlock.notification.domain.Notification;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.format.DateTimeFormatter;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class NotificationResponse {
    private Long notificationId;
    private String type;
    private String time;
    private boolean isRead;

    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("y.M.d HH:mm");

    public static NotificationResponse from(Notification notification, boolean isRead) {
        return new NotificationResponse(
                notification.getId(),
                notification.getType().name(),
                notification.getTimestamp().format(FORMATTER),
                isRead
        );
    }
}
