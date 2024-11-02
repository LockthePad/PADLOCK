package com.ssafy.padlock.meal.controller;

import com.ssafy.padlock.meal.controller.response.MonthMeal;
import com.ssafy.padlock.meal.controller.response.TodayMeal;
import com.ssafy.padlock.meal.service.MealService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequiredArgsConstructor
public class MealController {
    private final MealService mealService;

    @GetMapping("/meal/month")
    public List<MonthMeal> getMonthMeals(@RequestParam String yearMonth, @RequestParam Long schoolId) {
        return mealService.getMonthMeals(yearMonth, schoolId);
    }

    @GetMapping("/meal/today")
    public TodayMeal getTodayMeal(@RequestParam String date, @RequestParam Long schoolId) {
        return mealService.getTodayMeal(date, schoolId);
    }
}
