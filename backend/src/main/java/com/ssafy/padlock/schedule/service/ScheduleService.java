package com.ssafy.padlock.schedule.service;

import com.ssafy.padlock.member.domain.Member;
import com.ssafy.padlock.member.repository.MemberRepository;
import com.ssafy.padlock.schedule.controller.request.UpdateScheduleRequest;
import com.ssafy.padlock.schedule.controller.response.ClassScheduleResponse;
import com.ssafy.padlock.schedule.domain.ClassSchedule;
import com.ssafy.padlock.schedule.repository.ClassScheduleRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ScheduleService {
    private final ClassScheduleRepository classScheduleRepository;
    private final MemberRepository memberRepository;

    public List<ClassScheduleResponse> getClassSchedules(Long classroomId) {
        return classScheduleRepository.findByClassroomId(classroomId)
                .stream()
                .map(ClassScheduleResponse::from)
                .toList();
    }

    @Transactional
    public void updateClassSchedule(Long teacherId, Long classroomId, UpdateScheduleRequest updateScheduleRequest) {
        validateTeacherOfClassroom(teacherId, classroomId);

        String day = updateScheduleRequest.getDay();
        int period = updateScheduleRequest.getPeriod();
        String subject = updateScheduleRequest.getSubject();

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

    public void validateTeacherOfClassroom(Long teacherId, Long classroomId) {
        Member teacher = memberRepository.findById(teacherId)
                .orElseThrow(() -> new IllegalArgumentException("teacherId (" + teacherId + ") 존재하지 않음"));

        if (!teacher.getClassRoom().getId().equals(classroomId)) {
            throw new IllegalArgumentException("해당 반의 담임 교사만 가능합니다.");
        }
    }
}
