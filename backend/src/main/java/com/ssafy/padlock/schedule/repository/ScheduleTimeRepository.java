package com.ssafy.padlock.schedule.repository;

import com.ssafy.padlock.schedule.domain.ScheduleTime;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface ScheduleTimeRepository extends JpaRepository<ScheduleTime, Long> {
    Optional<ScheduleTime> findBySchoolIdAndPeriod(Long schoolId, int period);
}
