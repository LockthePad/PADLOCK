package com.ssafy.padlock.member.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Getter
@Table(name = "attendance")
@NoArgsConstructor
public class Attendance {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "member_id", nullable = false)
    private Long memberId;

    @Column(name = "attendance_date", nullable = false)
    private LocalDate attendanceDate;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    private Status status;

    @Column(name = "last_communication")
    private LocalDateTime lastCommunication;

    @Column(name = "is_away")
    private boolean isAway;

    public Attendance(Long memberId) {
        this.memberId = memberId;
        this.attendanceDate = LocalDate.now();
        this.status = Status.UNREPORTED;
        this.isAway = false;
    }

    public void updateStatus(Status status) {
        this.status = status;
    }

    public void updateLastCommunication(LocalDateTime lastCommunication) {
        this.lastCommunication = lastCommunication;
        this.isAway = false;
    }
}