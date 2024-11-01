package com.ssafy.padlock.meal.controller;

import com.ssafy.padlock.meal.controller.response.MonthMeal;
import com.ssafy.padlock.meal.service.MealService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequiredArgsConstructor
public class MealController {
    private final MealService mealService;

    @GetMapping("/meal/month/{yearMonth}/{school_id}")
    public List<MonthMeal> getMonthMeals(@PathVariable String yearMonth, @PathVariable("school_id") Long schoolId) {
        return mealService.getMonthMeals(yearMonth, schoolId);
    }
}
