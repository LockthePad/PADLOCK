package com.ssafy.padlock.meal.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.NoArgsConstructor;

import static lombok.AccessLevel.PROTECTED;

@Entity
@Getter
@Table(name = "allergy")
@NoArgsConstructor(access = PROTECTED)
public class Allergy {
    @Id
    @Column(name = "allergy_id")
    private int allergyId;

    @Column(name = "food_name")
    private String foodName;
}