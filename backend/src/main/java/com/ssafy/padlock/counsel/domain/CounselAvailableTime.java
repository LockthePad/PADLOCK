package com.ssafy.padlock.counsel.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalTime;

@Entity
@Getter
@Table(name = "counsel_available_time")
@NoArgsConstructor
public class CounselAvailableTime {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "counsel_available_time_id")
    private Long id;

    @Column(name = "teacher_id", nullable = false)
    private Long teacherId;

    @Column(name = "counsel_available_date", nullable = false)
    private LocalDate counselAvailableDate;

    @Column(name = "counsel_available_time", nullable = false)
    private LocalTime counselAvailableTime;

    @Column(name = "closed", nullable = false)
    private Integer closed;

    public CounselAvailableTime(Long teacherId, LocalDate counselAvailableDate, LocalTime counselAvailableTime, Integer closed) {
        this.teacherId = teacherId;
        this.counselAvailableDate = counselAvailableDate;
        this.counselAvailableTime = counselAvailableTime;
        this.closed = closed;
    }

    public void changeClosed(Integer closed) {
        this.closed = closed;
    }
}