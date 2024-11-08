package com.ssafy.padlock.member.scheduler;

import com.ssafy.padlock.member.repository.ScheduledTaskRepository;
import com.ssafy.padlock.member.service.AttendanceService;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.List;

@Component
@RequiredArgsConstructor
public class TaskInitializer implements ApplicationRunner {
    private final ScheduledTaskRepository scheduledTaskRepository;
    private final AttendanceService attendanceService;

    @Override
    public void run(ApplicationArguments args) {
        List<ScheduledTask> tasks = scheduledTaskRepository.findByExecutedFalseAndScheduledTimeAfter(LocalDateTime.now());
        tasks.forEach(attendanceService::scheduleAttendanceTask);
    }
}
