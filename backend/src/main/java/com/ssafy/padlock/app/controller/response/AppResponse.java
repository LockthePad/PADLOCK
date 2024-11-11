package com.ssafy.padlock.app.controller.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class AppResponse {
    private Long classroomId;
    private String appName;
    private String appImgUrl;
    private String packageName;
}
