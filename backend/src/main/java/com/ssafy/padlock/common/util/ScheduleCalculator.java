package com.ssafy.padlock.common.util;

import com.ssafy.padlock.classroom.domain.Classroom;
import com.ssafy.padlock.classroom.repository.ClassroomRepository;
import com.ssafy.padlock.schedule.domain.GradeSchedule;
import com.ssafy.padlock.schedule.domain.ScheduleTime;
import com.ssafy.padlock.schedule.repository.GradeScheduleRepository;
import com.ssafy.padlock.schedule.repository.ScheduleTimeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.TextStyle;
import java.util.Locale;
import java.util.Map;

@Component
@RequiredArgsConstructor
public class ScheduleCalculator {
    private final ClassroomRepository classroomRepository;
    private final GradeScheduleRepository gradeScheduleRepository;
    private final ScheduleTimeRepository scheduleTimeRepository;

    public Map<String, LocalTime> calculateScheduleTime(Long classroomId) {
        Classroom classroom = classroomRepository.findById(classroomId)
                .orElseThrow(() -> new IllegalArgumentException("해당 학급 ID 존재x"));

        Long schoolId = classroom.getSchool().getId();
        String day = LocalDate.now().getDayOfWeek()
                .getDisplayName(TextStyle.SHORT, Locale.ENGLISH)
                .toUpperCase();

        LocalTime startTime = getFirstPeriodStartTime(schoolId);
        LocalTime endTime = getLastPeriodEndTime(schoolId, getEndPeriod(schoolId, classroom.getGrade(), day));

        return Map.of("startTime", startTime, "endTime", endTime);
    }

    public int getEndPeriod(Long schoolId, int grade, String day) {
        return gradeScheduleRepository.findBySchoolIdAndGradeAndDay(schoolId, grade, day)
                .map(GradeSchedule::getEndPeriod)
                .orElseThrow(() -> new IllegalArgumentException("해당 학년의 종료 교시 존재x"));
    }

    public LocalTime getFirstPeriodStartTime(Long schoolId) {
        return scheduleTimeRepository.findBySchoolIdAndPeriod(schoolId, 1)
                .map(ScheduleTime::getStartTime)
                .orElseThrow(() -> new IllegalArgumentException("시작 교시 존재x"));
    }

    public LocalTime getLastPeriodEndTime(Long schoolId, int endPeriod) {
        return scheduleTimeRepository.findBySchoolIdAndPeriod(schoolId, endPeriod)
                .map(ScheduleTime::getEndTime)
                .orElseThrow(() -> new IllegalArgumentException("종료 교시 존재x"));
    }
}
