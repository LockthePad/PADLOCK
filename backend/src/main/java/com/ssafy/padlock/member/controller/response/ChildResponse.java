package com.ssafy.padlock.member.controller.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class ChildResponse {
    private Long studentId;
    private String studentName;
    private String schoolInfo;
//    private String attendanceStatus;

    public static ChildResponse from(Long studentId, String studentName, String schoolInfo) {
        return new ChildResponse(studentId, studentName, schoolInfo);
    }
}
