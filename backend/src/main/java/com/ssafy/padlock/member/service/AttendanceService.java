package com.ssafy.padlock.member.service;

import com.ssafy.padlock.common.util.ScheduleCalculator;
import com.ssafy.padlock.member.controller.response.AttendanceResponse;
import com.ssafy.padlock.member.domain.Attendance;
import com.ssafy.padlock.member.domain.Role;
import com.ssafy.padlock.member.domain.Status;
import com.ssafy.padlock.member.repository.AttendanceRepository;
import com.ssafy.padlock.member.repository.MemberRepository;
import com.ssafy.padlock.member.repository.ScheduledTaskRepository;
import com.ssafy.padlock.member.scheduler.AttendanceUpdater;
import com.ssafy.padlock.member.scheduler.ScheduledTask;
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
    private final AttendanceUpdater attendanceUpdater;
    private final ScheduledTaskRepository scheduledTaskRepository;

    @Transactional
    public AttendanceResponse updateAttendanceStatus(Long memberId, Long classroomId, boolean communicationSuccess) {
        Attendance attendance = attendanceRepository
                .findByMemberIdAndAttendanceDate(memberId, LocalDate.now())
                .orElseGet(() -> attendanceRepository.save(new Attendance(memberId)));

        if (!communicationSuccess) {
            return new AttendanceResponse(attendance.getStatus(), attendance.isCurrentlyAway());
        }

        attendance.updateLastCommunication(LocalDateTime.now());
        updateStatusBasedOnTime(attendance, classroomId);

        return new AttendanceResponse(attendance.getStatus(), attendance.isCurrentlyAway());
    }

    private void updateStatusBasedOnTime(Attendance attendance, Long classroomId) {
        var scheduleTimes = scheduleCalculator.calculateScheduleTime(classroomId);
        LocalTime currentTime = LocalTime.now();

        if (attendance.getStatus() == Status.UNREPORTED) {
            if (currentTime.isBefore(scheduleTimes.get("startTime"))) {
                attendance.updateStatus(Status.PRESENT);
            } else if (currentTime.isBefore(scheduleTimes.get("endTime"))) {
                attendance.updateStatus(Status.LATE);
            }
        }
    }

    @Scheduled(cron = "0 0 0 * * MON-FRI")
    public void initializeDailyAttendance() {
        memberRepository.findByRole(Role.STUDENT).forEach(member -> {
            attendanceRepository.save(new Attendance(member.getId()));

            LocalTime endTime = scheduleCalculator.calculateScheduleTime(member.getClassRoom().getId()).get("endTime");
            ScheduledTask task = new ScheduledTask(member.getId(), LocalDateTime.of(LocalDate.now(), endTime));
            scheduledTaskRepository.save(task);

            scheduleAttendanceTask(task);
        });
    }

    public void scheduleAttendanceTask(ScheduledTask task) {
        Instant endInstant = task.getScheduledTime().atZone(ZoneId.systemDefault()).toInstant();
        taskScheduler.schedule(
                () -> attendanceUpdater.updateUnreportedToAbsent(task), endInstant);
    }
}
