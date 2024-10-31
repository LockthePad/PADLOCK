package com.ssafy.padlock.counsel.controller.request;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class CounselParentRequest {
    private Long teacherId;
    private Long counselAvailableTimeId;
}
