package com.ssafy.padlock.location.service;

import com.ssafy.padlock.common.util.ScheduleCalculator;
import com.ssafy.padlock.location.controller.response.LocationResponse;
import com.ssafy.padlock.location.domain.Location;
import com.ssafy.padlock.location.repository.LocationRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class LocationService {

    private final LocationRepository locationRepository;
    private final ScheduleCalculator scheduleCalculator;


    public void saveLocation(Long classroomId, Long memberId, double latitude, double longitude) {
        LocalDateTime now = LocalDateTime.now();
        LocalTime currentTime = now.toLocalTime(); // 현재 시간

        // 임시로 startTime과 endTime을 24시간 전체를 포함하는 범위로 설정
        LocalTime rangeStart = LocalTime.MIN; // 00:00:00
        LocalTime rangeEnd = LocalTime.MAX;   // 23:59:59.999999999

        // 조건문 제거 (혹은 rangeStart와 rangeEnd로 조건 설정)
        Location location = new Location(memberId, latitude, longitude, now);
        System.out.println("저장할 위치: " + location);
        locationRepository.save(location);
    }

    @Scheduled(cron = "0 0 0,13 * * MON-FRI") //평일 12시, 00시에 데이터 삭제
    public void deleteLocation() {
        DayOfWeek dayOfWeek = LocalDate.now().getDayOfWeek();

        if (dayOfWeek != DayOfWeek.SATURDAY && dayOfWeek != DayOfWeek.SUNDAY) {
            locationRepository.deleteAll();
        }
    }

    // GPS 전체 조회
    public List<LocationResponse> findAllByStudentId(Long studentId) {
        // memberId와 studentId가 같은 Location 데이터 조회
        List<Location> locations = locationRepository.findAllByMemberId(studentId);
        return locations.stream()
                .map(location -> new LocationResponse(
                        location.getLatitude(),
                        location.getLongitude()
                ))
                .collect(Collectors.toList());
    }

    //최신 GPS 조회
    public LocationResponse findOneByStidentId(Long studentId) {
        Location location = locationRepository.findTopByMemberIdOrderByRecordedAtDesc(studentId).orElseThrow(() -> new IllegalArgumentException("데이터 없음"));
        return new LocationResponse(location.getLatitude(), location.getLongitude());
    }
}