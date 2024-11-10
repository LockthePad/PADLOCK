package com.ssafy.padlock.auth.controller.response;

import com.ssafy.padlock.member.domain.Member;
import com.ssafy.padlock.member.domain.Role;
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class LoginResponse {
    private Long memberId;
    private Long classroomId;
    private String role;
    private String accessToken;
    private String refreshToken;
    private String memberInfo;

    public static LoginResponse from(Member member, String accessToken, String refreshToken) {
        Long classroomId = null;
        String memberInfo = null;

        if (member.getRole() != Role.PARENTS && member.getClassRoom() != null) {
            classroomId = member.getClassRoom().getId();

            memberInfo = String.format("%s %d학년 %d반 %s",
                    member.getClassRoom().getSchool().getSchoolName(),
                    member.getClassRoom().getGrade(),
                    member.getClassRoom().getClassNumber(),
                    member.getName());
        }

        return new LoginResponse(
                member.getId(),
                classroomId,
                member.getRole().name(),
                accessToken,
                refreshToken,
                memberInfo
        );
    }
}
