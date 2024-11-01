package com.ssafy.padlock.classroom.domain;

import com.ssafy.padlock.member.domain.Member;
import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Getter
@Table(name = "suggestion")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Suggestion {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "content", nullable = false)
    private String content;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "student_id", nullable = false)
    private Member student;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "classroom_id", nullable = false)
    private Classroom classroom;

    @Column(name = "time", nullable = false)
    private LocalDateTime time;

    @Column(name = "is_read", nullable = false)
    private boolean isRead;

    public Suggestion(String content, Classroom classroom, Member student) {
        this.content = content;
        this.classroom = classroom;
        this.student = student;
        this.time = LocalDateTime.now();
        this.isRead = false;
    }

    public void changeStatus() {
        this.isRead = true;
    }
}
