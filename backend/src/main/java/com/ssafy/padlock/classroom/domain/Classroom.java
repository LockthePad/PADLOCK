package com.ssafy.padlock.classroom.domain;

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

    @Column(name = "grade", nullable = false)
    private int grade;

    @Column(name = "class_number", nullable = false)
    private int classNumber;

    @Column(name = "student_count")
    private int studentCount;
}
