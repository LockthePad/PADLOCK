package com.ssafy.padlock.auth.service;

import com.ssafy.padlock.auth.controller.request.LoginRequest;
import com.ssafy.padlock.auth.controller.response.LoginResponse;
import com.ssafy.padlock.auth.supports.JwtTokenProvider;
import com.ssafy.padlock.member.domain.Member;
import com.ssafy.padlock.member.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class AuthService {
    private final MemberRepository memberRepository;
    private final JwtTokenProvider jwtTokenProvider;
    private final PasswordEncoder passwordEncoder;

    @Transactional
    public LoginResponse login(LoginRequest loginRequest) {
        Member member = memberRepository.findByMemberCode(loginRequest.getMemberCode())
                .orElseThrow(() -> new IllegalArgumentException("등록된 회원 코드가 아닙니다"));

        if (passwordEncoder.matches(loginRequest.getPassword(), member.getPassword())) {
            String accessToken = jwtTokenProvider.createAccessToken(member);
            String refreshToken = jwtTokenProvider.createRefreshToken(member);
            return LoginResponse.from(member, accessToken, refreshToken);
        }
        throw new IllegalArgumentException("비밀번호가 틀렸습니다.");
    }
}
