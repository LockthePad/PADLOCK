package com.ssafy.padlock.meal.repository;

import com.ssafy.padlock.meal.domain.Allergy;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface AllergyRepository extends JpaRepository<Allergy, Integer> {
    List<Allergy> findByAllergyIdIn(List<Integer> allergyIds);
}
