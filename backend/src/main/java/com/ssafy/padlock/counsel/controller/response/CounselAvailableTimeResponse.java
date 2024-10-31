package com.ssafy.padlock.counsel.controller.response;

import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalTime;

@Getter
@NoArgsConstructor
public class CounselAvailableTimeResponse {
    private Long counselId;
    private Long parentId;
    private Long teacherId;
    private String studentName;
    private Long counselAvailableTimeId;
    private LocalDate counselAvailableDate;
    private LocalTime counselAvailableTime;


    public CounselAvailableTimeResponse(Long counselId, Long parentId, Long teacherId, String studentName, Long counselAvailableTimeId, LocalDate counselAvailableDate, LocalTime counselAvailableTime) {
        this.counselId = counselId;
        this.parentId = parentId;
        this.teacherId = teacherId;
        this.studentName = studentName;
        this.counselAvailableTimeId = counselAvailableTimeId;
        this.counselAvailableTime = counselAvailableTime;
        this.counselAvailableDate = counselAvailableDate;
    }
}