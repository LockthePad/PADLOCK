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
        LocalTime currentTime = now.toLocalTime();

        Map<String, LocalTime> startEndTime = scheduleCalculator.calculateScheduleTime(classroomId);
        LocalTime startTime = startEndTime.get("startTime");
        LocalTime endTime = startEndTime.get("endTime");

        if (startTime == null || endTime == null) {
            throw new IllegalArgumentException("startTime 또는 endTime 값이 없습니다.");
        }

        LocalTime rangeStart = startTime.minusHours(5);
        boolean isWithinStartRange = (currentTime.isAfter(rangeStart) || currentTime.equals(rangeStart)) &&
                (currentTime.isBefore(startTime) || currentTime.equals(startTime));

        LocalTime rangeEnd = endTime.plusHours(5);
        boolean isWithinEndRange = (currentTime.isAfter(endTime) || currentTime.equals(endTime)) &&
                (currentTime.isBefore(rangeEnd) || currentTime.equals(rangeEnd));

        if (isWithinStartRange || isWithinEndRange) {
            Location location = new Location(memberId, latitude, longitude, now);
            System.out.println("저장할 위치: " + location);
            locationRepository.save(location);
        } else {
            throw new IllegalStateException("현재 시간은 지정된 범위에 포함되지 않습니다.");
        }
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