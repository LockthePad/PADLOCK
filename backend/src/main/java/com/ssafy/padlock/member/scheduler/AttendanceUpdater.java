package com.ssafy.padlock.member.scheduler;

import com.ssafy.padlock.member.domain.Status;
import com.ssafy.padlock.member.repository.AttendanceRepository;
import com.ssafy.padlock.member.repository.ScheduledTaskRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

@Component
@RequiredArgsConstructor
public class AttendanceUpdater {
    private final AttendanceRepository attendanceRepository;
    private final ScheduledTaskRepository scheduledTaskRepository;

    @Transactional
    public void updateUnreportedToAbsent(ScheduledTask task) {
        attendanceRepository.findByMemberIdAndAttendanceDate(task.getMemberId(), task.getScheduledTime().toLocalDate())
                .filter(attendance -> attendance.getStatus() == Status.UNREPORTED)
                .ifPresent(attendance -> attendance.updateStatus(Status.ABSENT));

        task.updateExecuted();
        scheduledTaskRepository.saveAndFlush(task);
    }
}
