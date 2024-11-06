package com.ssafy.padlock.schedule.repository;

import com.ssafy.padlock.schedule.domain.GradeSchedule;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface GradeScheduleRepository extends JpaRepository<GradeSchedule, Long> {
    Optional<GradeSchedule> findBySchoolIdAndGradeAndDay(Long schoolId, int grade, String day);
}
