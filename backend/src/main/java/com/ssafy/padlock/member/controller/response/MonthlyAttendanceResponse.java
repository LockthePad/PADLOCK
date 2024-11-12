package com.ssafy.padlock.member.controller.response;

import com.ssafy.padlock.member.domain.Attendance;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class MonthlyAttendanceResponse {
    private int day;
    private String attendanceRecords;

    public static MonthlyAttendanceResponse from(Attendance attendance) {
        return new MonthlyAttendanceResponse(
                attendance.getAttendanceDate().getDayOfMonth(),
                attendance.getStatus().name()
        );
    }
}
