package com.ssafy.padlock.schedule.domain;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Getter
@Table(name = "grade_schedule")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class GradeSchedule {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "school_id", nullable = false)
    private Long schoolId;

    @Column(name = "grade", nullable = false)
    private int grade;

    @Column(name = "day", nullable = false)
    private String day;

    @Column(name = "end_period", nullable = false)
    private int endPeriod;
}
