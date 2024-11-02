package com.ssafy.padlock.meal.controller.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class TodayMeal {
    private String date;
    private String menu;
    private String allergyFood;
    private String calorie;
}
