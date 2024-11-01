package com.ssafy.padlock.meal.repository;

import com.ssafy.padlock.meal.domain.Meal;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface MealRepository extends JpaRepository<Meal, Long> {
    List<Meal> findBySchool_IdAndMaelDateContaining(Long schoolId, String yearMonth);
}
