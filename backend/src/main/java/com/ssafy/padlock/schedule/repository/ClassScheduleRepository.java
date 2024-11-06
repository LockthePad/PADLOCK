package com.ssafy.padlock.schedule.repository;

import com.ssafy.padlock.schedule.domain.ClassSchedule;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;

import java.util.List;
import java.util.Optional;

public interface ClassScheduleRepository extends JpaRepository<ClassSchedule, Long> {
    List<ClassSchedule> findByClassroomId(Long classroomId);
    Optional<ClassSchedule> findByClassroomIdAndDayAndPeriod(Long classroomId, String day, int period);

    @Modifying
    void deleteByClassroomIdAndDayAndPeriod(Long classroomId, String day, int period);
}
