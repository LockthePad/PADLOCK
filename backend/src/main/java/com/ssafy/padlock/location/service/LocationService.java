package com.ssafy.padlock.location.service;

import com.ssafy.padlock.location.domain.Location;
import com.ssafy.padlock.location.repository.LocationRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.LocalTime;

@Service
@RequiredArgsConstructor
public class LocationService {

    private final LocationRepository locationRepository;

    public void saveLocation(Long memberId, double latitude, double longitude) {
        LocalDateTime now = LocalDateTime.now();
        // 시간 부분 추출
        LocalTime currentTime = now.toLocalTime();
        LocalTime startTime = LocalTime.of(8,0);
        LocalTime endTime = LocalTime.of(9,0);

        Location location = new Location(memberId, latitude, longitude, LocalDateTime.now());
        locationRepository.save(location);
    }
}
