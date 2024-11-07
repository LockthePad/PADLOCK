package com.ssafy.padlock.member.service;

import com.ssafy.padlock.common.util.ScheduleCalculator;
import com.ssafy.padlock.member.controller.response.AttendanceResponse;
import com.ssafy.padlock.member.domain.Attendance;
import com.ssafy.padlock.member.domain.Member;
import com.ssafy.padlock.member.domain.Status;
import com.ssafy.padlock.member.repository.AttendanceRepository;
import com.ssafy.padlock.member.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.TaskScheduler;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.*;

@Service
@RequiredArgsConstructor
public class AttendanceService {
    private final MemberRepository memberRepository;
    private final AttendanceRepository attendanceRepository;
    private final ScheduleCalculator scheduleCalculator;
    private final TaskScheduler taskScheduler;

    @Transactional
    public AttendanceResponse updateAttendanceStatus(Long memberId, Long classroomId, boolean communicationSuccess) {
        Attendance attendance = attendanceRepository
                .findByMemberIdAndAttendanceDate(memberId, LocalDate.now())
                .orElseGet(() -> attendanceRepository.save(new Attendance(memberId)));

        var time = scheduleCalculator.calculateScheduleTime(classroomId);
        LocalTime currentTime = LocalTime.now();

        if (communicationSuccess) {
            attendance.updateLastCommunication(LocalDateTime.now());

            if (attendance.getStatus() == Status.UNREPORTED) {
                if (currentTime.isBefore(time.get("startTime"))) {
                    attendance.updateStatus(Status.PRESENT);
                } else if (currentTime.isBefore(time.get("endTime"))) {
                    attendance.updateStatus(Status.LATE);
                }
            }
        }

        return new AttendanceResponse(attendance.getStatus(), attendance.isAway());
    }

    @Scheduled(cron = "0 0 0 * * ?")
    public void initializeDailyAttendance() {
        LocalDate today = LocalDate.now();

        memberRepository.findAll().forEach(member -> {
            attendanceRepository.save(new Attendance(member.getId()));

            LocalTime endTime = scheduleCalculator.calculateScheduleTime(member.getClassRoom().getId()).get("endTime");
            LocalDateTime endDateTime = LocalDateTime.of(today, endTime);

            Instant endInstant = endDateTime.atZone(ZoneId.systemDefault()).toInstant();
            taskScheduler.schedule(() -> updateUnreportedToAbsent(member, today), endInstant);
        });
    }

    public void updateUnreportedToAbsent(Member member, LocalDate date) {
        attendanceRepository.findByMemberIdAndAttendanceDate(member.getId(), date)
                .filter(attendance -> attendance.getStatus() == Status.UNREPORTED)
                .ifPresent(attendance -> attendance.updateStatus(Status.ABSENT));
    }
}
