package com.ssafy.padlock.notification.service;

import com.ssafy.padlock.member.domain.Member;
import com.ssafy.padlock.member.domain.Role;
import com.ssafy.padlock.member.repository.MemberRepository;
import com.ssafy.padlock.notification.controller.response.NotificationResponse;
import com.ssafy.padlock.notification.domain.Notification;
import com.ssafy.padlock.notification.domain.NotificationReadStatus;
import com.ssafy.padlock.notification.domain.NotificationType;
import com.ssafy.padlock.notification.repository.NotificationReadStatusRepository;
import com.ssafy.padlock.notification.repository.NotificationRepository;
import com.ssafy.padlock.notification.repository.SseEmitterRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.io.IOException;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class NotificationService {
    private final SseEmitterRepository sseEmitterRepository;
    private final NotificationRepository notificationRepository;
    private final NotificationReadStatusRepository notificationReadStatusRepository;
    private final MemberRepository memberRepository;

    public SseEmitter subscribe(Long memberId) {
        SseEmitter sseEmitter = new SseEmitter(30_000L);
        sseEmitter.onCompletion(() -> sseEmitterRepository.deleteById(memberId));
        sseEmitter.onTimeout(() -> sseEmitterRepository.deleteById(memberId));
        sendMessage(sseEmitter);
        return sseEmitterRepository.save(memberId, sseEmitter);
    }

    private void sendMessage(SseEmitter sseEmitter) {
        try {
            sseEmitter.send(SseEmitter.event()
                    .name("CONNECT")
                    .data("연결!"));
        } catch (IOException e) {
            log.warn("알림 연결 실패!!", e);
        }
    }

    public void sendMessageToMember(NotificationType type, Long receiverId) {
        sseEmitterRepository.findById(receiverId)
                .ifPresent(sseEmitter -> sendMessage(sseEmitter, type));
    }

    private void sendMessage(SseEmitter sseEmitter, NotificationType type) {
        try {
            sseEmitter.send(SseEmitter.event()
                    .name(type.toString())
                    .data("알림 전송!"));
        } catch (IOException e) {
            log.warn("알림 보내기 실패!!", e);
        }
    }

    @Transactional
    public void updateReadStatus(Long memberId, Long notificationId) {
        notificationRepository.findById(notificationId)
                .orElseThrow(() -> new EntityNotFoundException("알림(notificationId: " + notificationId + ")이 존재하지 않습니다."));

        if (!notificationReadStatusRepository.existsByNotificationIdAndMemberId(notificationId, memberId)) {
            notificationReadStatusRepository.save(new NotificationReadStatus(notificationId, memberId));
        }
    }

    public List<NotificationResponse> findNotifications(Long memberId) {
        List<Notification> notifications = getNotificationsByRole(memberId);

        return notifications.stream()
                .map(notification -> {
                    boolean isRead = notificationReadStatusRepository.existsByNotificationIdAndMemberId(notification.getId(), memberId);
                    return NotificationResponse.from(notification, isRead);
                })
                .toList();
    }

    private List<Notification> getNotificationsByRole(Long memberId) {
        Role role = memberRepository.findById(memberId)
                .map(Member::getRole)
                .orElseThrow(() -> new IllegalArgumentException("Member 없음"));

        if (role == Role.TEACHER) {
            return notificationRepository.findAllByReceiverIdOrderByTimestampDesc(memberId);
        }

        return notificationRepository.findAllByReceiverIdOrReceiverIdIsNullOrderByTimestampDesc(memberId);
    }
}
