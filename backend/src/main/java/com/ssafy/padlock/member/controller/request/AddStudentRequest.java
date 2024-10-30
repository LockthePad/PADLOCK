package com.ssafy.padlock.member.controller.request;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class AddStudentRequest {
    private Long classroomId;
    private int studentNumber;
    private String studentName;
    private String parentCode;
}
