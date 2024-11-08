package com.ssafy.padlock.member.repository;

import com.ssafy.padlock.member.scheduler.ScheduledTask;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDateTime;
import java.util.List;

public interface ScheduledTaskRepository extends JpaRepository<ScheduledTask, Long> {
    List<ScheduledTask> findByExecutedFalseAndScheduledTimeAfter(LocalDateTime now);
}