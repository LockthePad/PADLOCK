package com.ssafy.padlock.member.controller;

import com.ssafy.padlock.auth.supports.LoginMember;
import com.ssafy.padlock.member.controller.request.AddStudentRequest;
import com.ssafy.padlock.member.controller.response.AttendanceResponse;
import com.ssafy.padlock.member.controller.response.ChildResponse;
import com.ssafy.padlock.member.service.AttendanceService;
import com.ssafy.padlock.member.service.MemberService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

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
}
