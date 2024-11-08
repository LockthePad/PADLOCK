package com.ssafy.padlock.schedule.repository;

import com.ssafy.padlock.schedule.domain.ScheduleTime;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalTime;
import java.util.Optional;

public interface ScheduleTimeRepository extends JpaRepository<ScheduleTime, Long> {
    Optional<ScheduleTime> findBySchoolIdAndPeriod(Long schoolId, int period);

    @Query("SELECT st FROM ScheduleTime st " +
            "WHERE st.schoolId = :schoolId " +
            "AND :currentTime BETWEEN st.startTime AND st.endTime")
    Optional<ScheduleTime> findPeriodBySchoolIdAndCurrentTime(@Param("schoolId") Long schoolId, @Param("currentTime") LocalTime currentTime);

    Optional<ScheduleTime> findTop1BySchoolIdAndEndTimeBeforeOrderByEndTimeDesc(Long schoolId, LocalTime currentTime);

    Optional<ScheduleTime> findTop1BySchoolIdAndStartTimeAfterOrderByStartTimeAsc(Long schoolId, LocalTime currentTime);
}
