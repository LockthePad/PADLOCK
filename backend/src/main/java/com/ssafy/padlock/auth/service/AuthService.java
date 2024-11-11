package com.ssafy.padlock.auth.service;

import com.ssafy.padlock.auth.controller.request.LoginRequest;
import com.ssafy.padlock.auth.controller.response.LoginResponse;
import com.ssafy.padlock.auth.controller.response.RefreshResponse;
import com.ssafy.padlock.auth.domain.RefreshToken;
import com.ssafy.padlock.auth.exception.ExpiredRefreshTokenException;
import com.ssafy.padlock.auth.repository.RefreshTokenRepository;
import com.ssafy.padlock.auth.supports.JwtTokenProvider;
import com.ssafy.padlock.member.domain.Member;
import com.ssafy.padlock.member.repository.MemberRepository;
import jakarta.persistence.EntityNotFoundException;
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
    private final RefreshTokenRepository refreshTokenRepository;

    @Transactional
    public LoginResponse login(LoginRequest loginRequest) {
        Member member = memberRepository.findByMemberCode(loginRequest.getMemberCode())
                .orElseThrow(() -> new IllegalArgumentException("등록된 회원 코드가 아닙니다"));

        if (passwordEncoder.matches(loginRequest.getPassword(), member.getPassword())) {
            String accessToken = jwtTokenProvider.createAccessToken(member);
            String refreshToken = jwtTokenProvider.createRefreshToken(member);
            refreshTokenRepository.save(new RefreshToken(refreshToken));
            return LoginResponse.from(member, accessToken, refreshToken);
        }
        throw new IllegalArgumentException("비밀번호가 틀렸습니다.");
    }

    @Transactional
    public RefreshResponse refresh(String token) {
        refreshTokenRepository.findByRefreshToken(token)
                .orElseThrow(() -> new EntityNotFoundException("유효하지 않은 리프레시 토큰"));

        if (jwtTokenProvider.validateRefreshToken(token)) {
            Member member = memberRepository.findById(
                    jwtTokenProvider.getMemberIdFromRefreshToken(token)).orElseThrow();

            refreshTokenRepository.deleteByRefreshToken(token);
            String accessToken = jwtTokenProvider.createAccessToken(member);
            String refreshToken = jwtTokenProvider.createRefreshToken(member);
            refreshTokenRepository.save(new RefreshToken(refreshToken));

            return new RefreshResponse(accessToken, refreshToken);
        }

        throw new ExpiredRefreshTokenException("리프레시 토큰 만료. 다시 로그인");
    }

    @Transactional
    public void logout(String refreshToken) {
        refreshTokenRepository.deleteByRefreshToken(refreshToken);
    }
}
