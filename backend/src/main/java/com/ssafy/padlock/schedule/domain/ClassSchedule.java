package com.ssafy.padlock.schedule.domain;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Getter
@Table(name = "class_schedule")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class ClassSchedule {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "classroom_id", nullable = false)
    private Long classroomId;

    @Column(name = "day", nullable = false)
    private String day;

    @Column(name = "period", nullable = false)
    private int period;

    @Column(name = "subject", nullable = false)
    private String subject;

    public ClassSchedule(Long classroomId, String day, int period, String subject) {
        this.classroomId = classroomId;
        this.day = day;
        this.period = period;
        this.subject = subject;
    }

    public void updateSubject(String subject) {
        this.subject = subject;
    }
}
