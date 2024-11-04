package com.ssafy.padlock.location.repository;

import com.ssafy.padlock.location.domain.Location;
import org.springframework.data.jpa.repository.JpaRepository;

public interface LocationRepository extends JpaRepository<Location, Long> {
}
