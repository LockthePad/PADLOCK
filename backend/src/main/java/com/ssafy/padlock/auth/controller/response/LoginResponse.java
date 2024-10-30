package com.ssafy.padlock.auth.controller.response;

import com.ssafy.padlock.member.domain.Member;
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

    public static LoginResponse from(Member member, String accessToken, String refreshToken) {
        Long classroomId = (member.getClassRoom() != null) ? member.getClassRoom().getId() : null;
        return new LoginResponse(member.getId(), classroomId, member.getRole().name(), accessToken, refreshToken);
    }
}
