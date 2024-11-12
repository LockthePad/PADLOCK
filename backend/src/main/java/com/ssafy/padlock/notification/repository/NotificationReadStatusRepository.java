package com.ssafy.padlock.notification.repository;

import com.ssafy.padlock.notification.domain.NotificationReadStatus;
import org.springframework.data.jpa.repository.JpaRepository;

public interface NotificationReadStatusRepository extends JpaRepository<NotificationReadStatus, Long> {
    boolean existsByNotificationIdAndMemberId(Long notificationId, Long memberId);
}
