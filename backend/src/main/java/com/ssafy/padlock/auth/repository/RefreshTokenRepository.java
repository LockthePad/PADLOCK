package com.ssafy.padlock.auth.repository;

import com.ssafy.padlock.auth.domain.RefreshToken;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface RefreshTokenRepository extends JpaRepository<RefreshToken, Long> {
    void deleteByRefreshToken(String refreshToken);
    Optional<RefreshToken> findByRefreshToken(String refreshToken);
}
