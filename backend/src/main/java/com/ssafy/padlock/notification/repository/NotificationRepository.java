package com.ssafy.padlock.notification.repository;

import com.ssafy.padlock.notification.domain.Notification;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface NotificationRepository extends JpaRepository<Notification, Long> {
    List<Notification> findAllByReceiverIdOrderByTimestampDesc(Long receiverId);
    List<Notification> findAllByReceiverIdOrReceiverIdIsNullOrderByTimestampDesc(Long receiverId);
}
