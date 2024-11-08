package com.ssafy.padlock.location.controller;

import com.ssafy.padlock.location.controller.request.LocationRequest;
import com.ssafy.padlock.location.controller.response.LocationResponse;
import com.ssafy.padlock.location.service.LocationService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

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

    //위치 전체 조회
    @PreAuthorize("hasRole('PARENTS')")
    @GetMapping("/location/total")
    public ResponseEntity<List<LocationResponse>> getTotalLocation(@RequestParam Long studentId) {
        List<LocationResponse> locations = locationService.findAllByStudentId(studentId);
        return ResponseEntity.ok(locations);
    }

    //최신 위치 조회
    @PreAuthorize("hasRole('PARENTS')")
    @GetMapping("/location/recent")
    public ResponseEntity<LocationResponse> getNewLocation(@RequestParam Long studentId) {
        LocationResponse location = locationService.findOneByStidentId(studentId);
        return ResponseEntity.ok(location);
    }
}
