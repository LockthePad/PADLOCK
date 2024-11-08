package com.ssafy.padlock.schedule.controller.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class CurrentPeriodResponse {
    private String code;
    private int period;
    private String subject;

    public CurrentPeriodResponse(String code) {
        this.code = code;
    }
}
