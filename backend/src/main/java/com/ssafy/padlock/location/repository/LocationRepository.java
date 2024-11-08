package com.ssafy.padlock.location.repository;

import com.ssafy.padlock.location.domain.Location;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface LocationRepository extends JpaRepository<Location, Long> {
    List<Location> findAllByMemberId(Long memberId);
    Optional<Location> findTopByMemberIdOrderByRecordedAtDesc(Long memberId);
}
