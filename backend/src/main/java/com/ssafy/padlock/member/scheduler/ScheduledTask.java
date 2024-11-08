package com.ssafy.padlock.member.scheduler;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Getter
@Table(name = "scheduled_task")
@NoArgsConstructor
@Entity
public class ScheduledTask {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "member_id")
    private Long memberId;

    @Column(name = "scheduled_time")
    private LocalDateTime scheduledTime;

    @Column(name = "executed")
    private boolean executed;

    public ScheduledTask(Long memberId, LocalDateTime scheduledTime) {
        this.memberId = memberId;
        this.scheduledTime = scheduledTime;
        this.executed = false;
    }

    public void updateExecuted() {
        this.executed = true;
    }
}
