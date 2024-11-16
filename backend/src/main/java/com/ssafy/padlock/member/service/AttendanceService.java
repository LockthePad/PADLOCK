package com.ssafy.padlock.member.service;

import com.ssafy.padlock.common.util.ScheduleCalculator;
import com.ssafy.padlock.member.controller.response.AttendanceResponse;
import com.ssafy.padlock.member.controller.response.MonthlyAttendanceResponse;
import com.ssafy.padlock.member.domain.Attendance;
import com.ssafy.padlock.member.domain.Member;
import com.ssafy.padlock.member.domain.Role;
import com.ssafy.padlock.member.domain.Status;
import com.ssafy.padlock.member.repository.AttendanceRepository;
import com.ssafy.padlock.member.repository.MemberRepository;
import com.ssafy.padlock.member.repository.ScheduledTaskRepository;
import com.ssafy.padlock.member.scheduler.AttendanceUpdater;
import com.ssafy.padlock.member.scheduler.ScheduledTask;
import com.ssafy.padlock.notification.domain.Notification;
import com.ssafy.padlock.notification.domain.NotificationType;
import com.ssafy.padlock.notification.repository.NotificationRepository;
import com.ssafy.padlock.notification.service.NotificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.TaskScheduler;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.*;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class AttendanceService {
    private final MemberRepository memberRepository;
    private final AttendanceRepository attendanceRepository;
    private final ScheduleCalculator scheduleCalculator;
    private final TaskScheduler taskScheduler;
    private final AttendanceUpdater attendanceUpdater;
    private final ScheduledTaskRepository scheduledTaskRepository;
    private final NotificationService notificationService;
    private final NotificationRepository notificationRepository;

    @Transactional
    public AttendanceResponse updateAttendanceStatus(Long memberId, Long classroomId, boolean communicationSuccess) {
        DayOfWeek currentDay = LocalDate.now().getDayOfWeek();
        if (currentDay == DayOfWeek.SATURDAY || currentDay == DayOfWeek.SUNDAY) {
            throw new IllegalArgumentException("주말에는 출석 상태를 업데이트할 수 없습니다.");
        }

        Attendance attendance = getOrCreateAttendance(memberId);
        if (!communicationSuccess) {
            return AttendanceResponse.from(attendance);
        }

        attendance.updateLastCommunication(LocalDateTime.now());
        updateStatusBasedOnTime(attendance, classroomId, memberId);

        return AttendanceResponse.from(attendance);
    }

    private void updateStatusBasedOnTime(Attendance attendance, Long classroomId, Long studentId) {
        var scheduleTimes = scheduleCalculator.calculateScheduleTime(classroomId);
        LocalTime currentTime = LocalTime.now();

        if (attendance.getStatus() == Status.UNREPORTED) {
            Long parentId = memberRepository.findParentIdByStudentId(studentId);

            notificationRepository.save(new Notification(parentId, NotificationType.ATTENDANCE));
            notificationService.sendMessageToMember(NotificationType.ATTENDANCE, parentId);

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

    public AttendanceResponse getAttendanceStatus(Long studentId) {
        Attendance attendance = getOrCreateAttendance(studentId);
        return AttendanceResponse.from(attendance);
    }

    public List<AttendanceResponse> getClassroomAttendanceStatus(Long classroomId) {
        List<Long> memberIds = memberRepository.findStudentIdsByClassroomId(classroomId, Role.STUDENT);

        return attendanceRepository.findByMemberIdInAndAttendanceDate(memberIds, LocalDate.now())
                .stream()
                .map(attendance -> AttendanceResponse.from(attendance, findByMemberId(attendance.getMemberId()).getName()))
                .collect(Collectors.toList());
    }

    public List<MonthlyAttendanceResponse> getMonthlyAttendance(Long studentId) {
        if (findByMemberId(studentId).getRole() != Role.STUDENT) {
            throw new IllegalArgumentException("학생만 출석 조회가 가능합니다.");
        }

        LocalDate now = LocalDate.now();
        LocalDate startDate = now.withDayOfMonth(1);
        LocalDate endDate = now.withDayOfMonth(now.lengthOfMonth());

        List<Attendance> attendances = attendanceRepository.findByMemberIdAndAttendanceDateBetween(studentId, startDate, endDate);

        return attendances.stream()
                .map(MonthlyAttendanceResponse::from)
                .toList();
    }

    public Map<Long, String> getStudentsByClassroom(Long classroomId) {
        return memberRepository.findByClassRoom_IdAndRole(classroomId, Role.STUDENT)
                .stream()
                .sorted(Comparator.comparing(Member::getName))
                .collect(Collectors.toMap(
                        Member::getId,
                        Member::getName,
                        (existing, replacement) -> existing,
                        LinkedHashMap::new
                ));
    }

    private Attendance getOrCreateAttendance(Long memberId) {
        return attendanceRepository
                .findByMemberIdAndAttendanceDate(memberId, LocalDate.now())
                .orElseGet(() -> attendanceRepository.save(new Attendance(memberId)));
    }

    private Member findByMemberId(Long memberId) {
        return memberRepository.findById(memberId).orElseThrow();
    }
}
