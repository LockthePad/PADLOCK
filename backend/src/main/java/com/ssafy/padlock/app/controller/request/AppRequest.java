package com.ssafy.padlock.app.controller.request;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class AppRequest {
    private Long classroomId;
    private String appName;
    private String appPackage;
}
