package com.ssafy.padlock.auth.controller.response;

import com.ssafy.padlock.member.domain.Member;
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class LoginResponse {
    private Long memberId;
    private String role;
    private String accessToken;
    private String refreshToken;

    public static LoginResponse from(Member member, String accessToken, String refreshToken) {
        return new LoginResponse(member.getId(), member.getRole().name(), accessToken, refreshToken);
    }
}
