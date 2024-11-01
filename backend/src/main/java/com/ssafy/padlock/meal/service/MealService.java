package com.ssafy.padlock.meal.service;

import com.ssafy.padlock.meal.controller.response.MonthMeal;
import com.ssafy.padlock.meal.domain.Meal;
import com.ssafy.padlock.meal.repository.MealRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class MealService {
    private final MealRepository mealRepository;

    public List<MonthMeal> getMonthMeals(String yearMonth, Long schoolId) {
        List<Meal> meals = mealRepository.findBySchool_IdAndMaelDateContaining(schoolId, yearMonth);
        return meals.stream()
                .map(meal -> new MonthMeal(meal.getMaelDate(), meal.getMenu()))
                .collect(Collectors.toList());
    }
}
