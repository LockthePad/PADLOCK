package com.ssafy.padlock.schedule.service;

import com.ssafy.padlock.classroom.domain.Classroom;
import com.ssafy.padlock.classroom.repository.ClassroomRepository;
import com.ssafy.padlock.member.domain.Member;
import com.ssafy.padlock.member.repository.MemberRepository;
import com.ssafy.padlock.schedule.controller.request.UpdateScheduleRequest;
import com.ssafy.padlock.schedule.controller.response.ClassScheduleResponse;
import com.ssafy.padlock.schedule.controller.response.CurrentPeriodResponse;
import com.ssafy.padlock.schedule.domain.ClassSchedule;
import com.ssafy.padlock.schedule.domain.GradeSchedule;
import com.ssafy.padlock.schedule.domain.ScheduleTime;
import com.ssafy.padlock.schedule.exception.InvalidPeriodException;
import com.ssafy.padlock.schedule.exception.ScheduleNotRegisteredException;
import com.ssafy.padlock.schedule.repository.ClassScheduleRepository;
import com.ssafy.padlock.schedule.repository.GradeScheduleRepository;
import com.ssafy.padlock.schedule.repository.ScheduleTimeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.TextStyle;
import java.util.List;
import java.util.Locale;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ScheduleService {
    private final ClassScheduleRepository classScheduleRepository;
    private final MemberRepository memberRepository;
    private final ClassroomRepository classroomRepository;
    private final ScheduleTimeRepository scheduleTimeRepository;
    private final GradeScheduleRepository gradeScheduleRepository;

    public List<ClassScheduleResponse> getClassSchedules(Long classroomId) {
        return classScheduleRepository.findByClassroomId(classroomId)
                .stream()
                .map(ClassScheduleResponse::from)
                .toList();
    }

    @Transactional
    public void updateClassSchedule(Long teacherId, Long classroomId, UpdateScheduleRequest request) {
        validateTeacherOfClassroom(teacherId, classroomId);

        Classroom classroom = getClassroom(classroomId);
        GradeSchedule gradeSchedule = getGradeSchedule(classroom.getSchool().getId(), classroom.getGrade(), request.getDay());

        if (request.getPeriod() > gradeSchedule.getEndPeriod()) {
            throw new InvalidPeriodException("마지막 교시를 넘는 시간표는 추가할 수 없습니다.");
        }

        String day = request.getDay();
        int period = request.getPeriod();
        String subject = request.getSubject();

        classScheduleRepository.findByClassroomIdAndDayAndPeriod(classroomId, day, period)
                .ifPresentOrElse(
                        existingSchedule -> existingSchedule.updateSubject(subject),
                        () -> classScheduleRepository.save(new ClassSchedule(classroomId, day, period, subject))
                );
    }

    @Transactional
    public void deleteClassSchedule(Long teacherId, Long classroomId, String day, int period) {
        validateTeacherOfClassroom(teacherId, classroomId);
        classScheduleRepository.deleteByClassroomIdAndDayAndPeriod(classroomId, day, period);
    }

    public CurrentPeriodResponse getCurrentPeriodStatus(Long classroomId) {
        Classroom classroom = getClassroom(classroomId);
        Long schoolId = classroom.getSchool().getId();

        return scheduleTimeRepository.findPeriodBySchoolIdAndCurrentTime(schoolId, LocalTime.now())
                .map(period -> getPeriodAndSubject(classroomId, schoolId, classroom.getGrade(), period.getPeriod()))
                .orElseGet(() -> getNonClassTimeStatus(schoolId, LocalTime.now()));
    }

    private CurrentPeriodResponse getPeriodAndSubject(Long classroomId, Long schoolId, int grade, int period) {
        String day = LocalDate.now().getDayOfWeek()
                .getDisplayName(TextStyle.SHORT, Locale.ENGLISH)
                .toUpperCase();

        GradeSchedule gradeSchedule = getGradeSchedule(schoolId, grade, day);
        if (period > gradeSchedule.getEndPeriod()) {
            return new CurrentPeriodResponse("OUT_OF_CLASS_TIME");
        }

        return classScheduleRepository.findByClassroomIdAndDayAndPeriod(classroomId, day, period)
                .map(classSchedule -> new CurrentPeriodResponse("IN_CLASS", period, classSchedule.getSubject()))
                .orElseThrow(() -> new ScheduleNotRegisteredException("해당 시간에 아직 시간표가 등록되지 않았습니다."));
    }

    private CurrentPeriodResponse getNonClassTimeStatus(Long schoolId, LocalTime currentTime) {
        Optional<ScheduleTime> previousPeriod = scheduleTimeRepository.findTop1BySchoolIdAndEndTimeBeforeOrderByEndTimeDesc(schoolId, currentTime);
        Optional<ScheduleTime> nextPeriod = scheduleTimeRepository.findTop1BySchoolIdAndStartTimeAfterOrderByStartTimeAsc(schoolId, currentTime);

        if (previousPeriod.isPresent() && nextPeriod.isPresent() &&
                currentTime.isAfter(previousPeriod.get().getEndTime()) &&
                currentTime.isBefore(nextPeriod.get().getStartTime())) {
            return new CurrentPeriodResponse("BREAK_TIME");
        }

        return new CurrentPeriodResponse("OUT_OF_CLASS_TIME");
    }

    public void validateTeacherOfClassroom(Long teacherId, Long classroomId) {
        Member teacher = memberRepository.findById(teacherId)
                .orElseThrow(() -> new IllegalArgumentException("teacherId (" + teacherId + ") 존재하지 않음"));

        if (!teacher.getClassRoom().getId().equals(classroomId)) {
            throw new IllegalArgumentException("해당 반의 담임 교사만 가능합니다.");
        }
    }

    private Classroom getClassroom(Long classroomId) {
        return classroomRepository.findById(classroomId)
                .orElseThrow(() -> new IllegalArgumentException("해당 교실을 찾을 수 없습니다."));
    }

    private GradeSchedule getGradeSchedule(Long schoolId, int grade, String day) {
        return gradeScheduleRepository.findBySchoolIdAndGradeAndDay(schoolId, grade, day)
                .orElseThrow(() -> new ScheduleNotRegisteredException("해당 학년의 시간표가 등록되지 않았습니다."));
    }
}
