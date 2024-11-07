package com.ssafy.padlock.location.service;

import com.ssafy.padlock.common.util.ScheduleCalculator;
import com.ssafy.padlock.location.domain.Location;
import com.ssafy.padlock.location.repository.LocationRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class LocationService {

    private final LocationRepository locationRepository;
    private final ScheduleCalculator scheduleCalculator;

    public void saveLocation(Long classroomId, Long memberId, double latitude, double longitude) {
        LocalDateTime now = LocalDateTime.now();
        LocalTime currentTime = now.toLocalTime(); // 현재 시간

        Map<String, LocalTime> startEndTime = scheduleCalculator.calculateScheduleTime(classroomId);

        // 등교 시간: 1교시 시작 1시간 전부터 1교시 시작 시간까지
        LocalTime startTime = startEndTime.get("startTime");
        LocalTime rangeStart = startTime.minusHours(1);

        // 하교 시간: 마지막 교시 끝나는 시간부터 마지막 교시 끝난 후 1시간까지
        LocalTime endTime = startEndTime.get("endTime");
        LocalTime rangeEnd = endTime.plusHours(1);

        if ((currentTime.isAfter(rangeStart) && currentTime.isBefore(startTime)) ||
                (currentTime.isAfter(endTime) && currentTime.isBefore(rangeEnd))) {
            Location location = new Location(memberId, latitude, longitude, now);
            locationRepository.save(location);
        }
    }

    @Scheduled(cron = "0 0 0,13 * * MON-FRI") //평일 12시, 00시에 데이터 삭제
    public void deleteLocation(){
        DayOfWeek dayOfWeek = LocalDate.now().getDayOfWeek();

        if(dayOfWeek != DayOfWeek.SATURDAY && dayOfWeek != DayOfWeek.SUNDAY){
            locationRepository.deleteAll();
        }
    }
}