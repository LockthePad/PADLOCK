package com.ssafy.padlock.location.controller;

import com.ssafy.padlock.location.controller.request.LocationRequest;
import com.ssafy.padlock.location.service.LocationService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
public class LocationController {
    private final LocationService locationService;

    @PostMapping("/location/save")
    public ResponseEntity<String> saveLocation(@RequestBody LocationRequest locationRequest) {
        locationService.saveLocation(
                locationRequest.getMemberId(),
                locationRequest.getLatitude(),
                locationRequest.getLongitude()
        );
        return ResponseEntity.ok("Saved success");
    }
}
