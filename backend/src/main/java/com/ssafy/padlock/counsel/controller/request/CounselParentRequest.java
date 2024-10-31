package com.ssafy.padlock.counsel.controller.request;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class CounselParentRequest {
    private Long teacherId;
    private Long studentId;
    private Long counselAvailableTimeId;

    public CounselParentRequest(Long teacherId, Long counselAvailableTimeId) {
        this.teacherId = teacherId;
        this.counselAvailableTimeId = counselAvailableTimeId;
    }
}
