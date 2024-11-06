package com.ssafy.padlock.location.controller;

import com.ssafy.padlock.location.controller.request.LocationRequest;
import com.ssafy.padlock.location.service.LocationService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
public class LocationController {
    private final LocationService locationService;

    @PreAuthorize("hasRole('STUDENT')")
    @PostMapping("/location/save")
    public ResponseEntity<String> saveLocation(@RequestBody LocationRequest locationRequest) {
        locationService.saveLocation(
                locationRequest.getClassroomId(),
                locationRequest.getMemberId(),
                locationRequest.getLatitude(),
                locationRequest.getLongitude()
        );
        return ResponseEntity.ok("Saved success");
    }
}
