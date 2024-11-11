package com.ssafy.padlock.member.controller.response;

import com.ssafy.padlock.member.domain.Attendance;
import com.ssafy.padlock.member.domain.Status;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class AttendanceResponse {
    private Long studentId;
    private String studentName;
    private Status status;
    private boolean isAway;

    public static AttendanceResponse from(Attendance attendance, String studentName) {
        return new AttendanceResponse(
                attendance.getMemberId(), studentName, attendance.getStatus(), attendance.isCurrentlyAway()
        );
    }

    public static AttendanceResponse from(Attendance attendance) {
        return new AttendanceResponse(
                attendance.getMemberId(), null, attendance.getStatus(), attendance.isCurrentlyAway()
        );
    }
}