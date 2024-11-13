package com.ssafy.padlock.member.controller;

import com.ssafy.padlock.auth.supports.LoginMember;
import com.ssafy.padlock.member.controller.request.AddStudentRequest;
import com.ssafy.padlock.member.controller.response.AttendanceResponse;
import com.ssafy.padlock.member.controller.response.ChildResponse;
import com.ssafy.padlock.member.controller.response.MonthlyAttendanceResponse;
import com.ssafy.padlock.member.service.AttendanceService;
import com.ssafy.padlock.member.service.MemberService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequiredArgsConstructor
public class MemberController {
    private final MemberService memberService;
    private final AttendanceService attendanceService;

    @PostMapping("/admin/members")
    public void saveMember(@RequestBody String memberData) {
        memberService.saveMembers(memberData);
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/members")
    public ResponseEntity<Void> addStudentToClassroom(@RequestBody AddStudentRequest addStudentRequest) {
        memberService.addStudent(addStudentRequest.getClassroomId(), addStudentRequest.getStudentNumber(),
                addStudentRequest.getStudentName(), addStudentRequest.getParentCode());
        return ResponseEntity.status(HttpStatus.CREATED).build();
    }

    @PreAuthorize("hasRole('PARENTS')")
    @GetMapping("/children")
    public List<ChildResponse> getChildrenInfo(@LoginMember Long parentsId) {
        return memberService.getChildrenInfo(parentsId);
    }

    @PreAuthorize("hasRole('STUDENT')")
    @PostMapping("/communication")
    public AttendanceResponse receiveCommunication(@LoginMember Long studentId, @RequestParam Long classroomId,
                                                   @RequestParam boolean success) {
        return attendanceService.updateAttendanceStatus(studentId, classroomId, success);
    }

    @GetMapping("/attendance/{studentId}")
    public AttendanceResponse getAttendance(@PathVariable Long studentId) {
        return attendanceService.getAttendanceStatus(studentId);
    }

    @PreAuthorize("hasRole('TEACHER')")
    @GetMapping("/attendances")
    public List<AttendanceResponse> getAttendancesByClassroom(@RequestParam Long classroomId) {
        return attendanceService.getClassroomAttendanceStatus(classroomId);
    }

    @PreAuthorize("hasRole('TEACHER')")
    @GetMapping("/attendances/monthly")
    public List<MonthlyAttendanceResponse> getMonthlyAttendance(@RequestParam Long studentId) {
        return attendanceService.getMonthlyAttendance(studentId);
    }

    @PreAuthorize("hasRole('TEACHER')")
    @GetMapping("/classrooms/{classroomId}/students")
    public Map<Long, String> getStudentsByClassroom(@PathVariable Long classroomId) {
        return attendanceService.getStudentsByClassroom(classroomId);
    }

    //선생님 ID 구하기
    @GetMapping("/get-teacherId")
    public Long getTeacherId(@RequestParam Long classroomId) {
        return memberService.getTeacherId(classroomId);
    }
}
