package com.ssafy.padlock.schedule.controller;

import com.ssafy.padlock.auth.supports.LoginMember;
import com.ssafy.padlock.schedule.controller.request.UpdateScheduleRequest;
import com.ssafy.padlock.schedule.controller.response.ClassScheduleResponse;
import com.ssafy.padlock.schedule.service.ScheduleService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
public class ScheduleController {
    private final ScheduleService scheduleService;

    @GetMapping("/classrooms/{classroomId}/schedules")
    public List<ClassScheduleResponse> getClassSchedules(@PathVariable Long classroomId) {
        return scheduleService.getClassSchedules(classroomId);
    }

    @PreAuthorize("hasRole('TEACHER')")
    @PostMapping("/classrooms/{classroomId}/schedules")
    public ResponseEntity<String> updateClassSchedule(@LoginMember Long teacherId, @PathVariable Long classroomId,
                                    @RequestBody UpdateScheduleRequest request) {
        scheduleService.updateClassSchedule(teacherId, classroomId, request);
        return ResponseEntity.ok(String.format("시간표 수정 : 요일=%s, 교시=%d, 과목=%s",
                request.getDay(), request.getPeriod(), request.getSubject()));
    }

    @PreAuthorize("hasRole('TEACHER')")
    @DeleteMapping("/classrooms/{classroomId}/schedules")
    public ResponseEntity<String> deleteClassSchedule(@LoginMember Long teacherId, @PathVariable Long classroomId,
                                              @RequestParam String day, @RequestParam int period) {
        scheduleService.deleteClassSchedule(teacherId, classroomId, day, period);
        return ResponseEntity.ok(String.format("시간표 삭제 : 요일=%s, 교시=%d", day, period));
    }
}
