package com.ssafy.padlock.classroom.domain;

import com.ssafy.padlock.member.domain.Member;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;

import static lombok.AccessLevel.PROTECTED;

@Entity
@Getter
@Table(name = "classroom")
@NoArgsConstructor(access = PROTECTED)
public class Classroom {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "school_id", nullable = false)
    private School school;

    @OneToOne
    @JoinColumn(name = "teacher_id")
    private Member teacher;

    @Column(name = "grade", nullable = false)
    private int grade;

    @Column(name = "class_number", nullable = false)
    private int classNumber;

    @Column(name = "student_count")
    private int studentCount;
}
