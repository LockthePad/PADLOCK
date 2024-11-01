package com.ssafy.padlock.meal.domain;

import com.ssafy.padlock.classroom.domain.School;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;

import static lombok.AccessLevel.PROTECTED;

@Entity
@Getter
@Table(name = "meal")
@NoArgsConstructor(access = PROTECTED)
public class Meal {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "meal_id")
    private Long mealId;

    @Column(name = "calorie", nullable = false)
    private String calorie;

    @Column(name = "meal_date", nullable = false)
    private String maelDate;

    @Column(name = "menu", nullable = false)
    private String menu;

    @Column(name = "allergy_code", nullable = false)
    private String allergyCode;

    @ManyToOne
    @JoinColumn(name = "school_id", nullable = false)
    private School school;
}
