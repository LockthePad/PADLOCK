package com.ssafy.padlock.counsel.controller.request;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Getter
public class CounselTeacherRequest {
    private Long parentId;
    private Long counselAvailableTimeId;
}