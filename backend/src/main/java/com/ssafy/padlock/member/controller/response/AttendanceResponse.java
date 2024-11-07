package com.ssafy.padlock.member.controller.response;

import com.ssafy.padlock.member.domain.Status;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class AttendanceResponse {
    private Status status;
    private boolean isAway;
}