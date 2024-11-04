package com.ssafy.padlock.location.service;

import com.ssafy.padlock.location.domain.Location;
import com.ssafy.padlock.location.repository.LocationRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class LocationService {

    private final LocationRepository locationRepository;

    public void saveLocation(Long memberId, double latitude, double longitude) {
        Location location = new Location(memberId, latitude, longitude, LocalDateTime.now());
        locationRepository.save(location);
    }
}
