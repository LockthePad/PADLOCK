package com.ssafy.padlock.meal.service;

import com.ssafy.padlock.meal.controller.response.MonthMeal;
import com.ssafy.padlock.meal.controller.response.TodayMeal;
import com.ssafy.padlock.meal.domain.Allergy;
import com.ssafy.padlock.meal.domain.Meal;
import com.ssafy.padlock.meal.repository.AllergyRepository;
import com.ssafy.padlock.meal.repository.MealRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class MealService {
    private final MealRepository mealRepository;
    private final AllergyRepository allergyRepository;

    public List<MonthMeal> getMonthMeals(String yearMonth, Long schoolId) {
        List<Meal> meals = mealRepository.findBySchool_IdAndMaelDateContaining(schoolId, yearMonth);
        return meals.stream()
                .map(meal -> new MonthMeal(meal.getMaelDate(), meal.getMenu()))
                .collect(Collectors.toList());
    }

    public TodayMeal getTodayMeal(String date, Long schoolId) {
        Meal meal = mealRepository.findFirstBySchool_IdAndMaelDate(schoolId, date);

        // 알러지 코드 파싱
        List<Integer> allergyIds = Arrays.stream(meal.getAllergyCode().split(","))
                .map(String::trim)
                .map(Integer::parseInt)
                .collect(Collectors.toList());

        // 알러지 음식 조회
        List<Allergy> allergies = allergyRepository.findByAllergyIdIn(allergyIds);
        String allergyFoodNames = allergies.stream()
                .map(Allergy::getFoodName)
                .collect(Collectors.joining(", "));

        return new TodayMeal(
                meal.getMaelDate(),
                meal.getMenu(),
                allergyFoodNames,
                meal.getCalorie()
        );
    }
}

