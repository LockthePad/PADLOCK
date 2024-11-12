package com.ssafy.padlock.notification.controller;

import com.ssafy.padlock.auth.supports.LoginMember;
import com.ssafy.padlock.notification.controller.response.NotificationResponse;
import com.ssafy.padlock.notification.service.NotificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.util.List;

@RestController
@RequiredArgsConstructor
public class NotificationController {
    private final NotificationService notificationService;

    @GetMapping(value = "/subscribe", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public SseEmitter subscribe(@LoginMember Long memberId) {
        return notificationService.subscribe(memberId);
    }

    @GetMapping("/notifications")
    public List<NotificationResponse> findNotifications(@LoginMember Long memberId) {
        return notificationService.findNotifications(memberId);
    }

    @PostMapping("/notifications/{notificationId}")
    public void updateReadStatus(@LoginMember Long memberId, @PathVariable Long notificationId) {
        notificationService.updateReadStatus(memberId, notificationId);
    }
}
