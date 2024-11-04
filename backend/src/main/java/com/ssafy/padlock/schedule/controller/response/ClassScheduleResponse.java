package com.ssafy.padlock.schedule.controller.response;

import com.ssafy.padlock.schedule.domain.ClassSchedule;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class ClassScheduleResponse {
    private Long scheduleId;
    private String day;
    private int period;
    private String subject;

    public static ClassScheduleResponse from(ClassSchedule classSchedule) {
        return new ClassScheduleResponse(classSchedule.getId(), classSchedule.getDay(),
                classSchedule.getPeriod(), classSchedule.getSubject());
    }
}
