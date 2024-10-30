package com.ssafy.padlock.member.controller.response;

import com.ssafy.padlock.member.domain.Member;
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
    private Long classroomId;

    public static ChildResponse from(Member member) {
        String schoolInfo = member.getClassRoom().getSchool().getSchoolName() + " "
                + member.getClassRoom().getGrade() + "학년 "
                + member.getClassRoom().getClassNumber() + "반";

        return new ChildResponse(
                member.getId(),
                member.getName(),
                schoolInfo,
                member.getClassRoom().getId()
        );
    }
}
