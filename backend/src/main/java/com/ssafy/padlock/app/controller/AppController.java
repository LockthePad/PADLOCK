package com.ssafy.padlock.app.controller;

import com.ssafy.padlock.app.controller.request.AppRequest;
import com.ssafy.padlock.app.controller.response.AppResponse;
import com.ssafy.padlock.app.service.AppService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
public class AppController {
    private final AppService appService;

    @PreAuthorize("hasRole('TEACHER')")
    @PostMapping("/app")
    public List<AppResponse> addApp(@RequestBody List<AppRequest> appRequestList) {
        return appService.addApp(appRequestList);
    }

    @GetMapping("/app")
    public List<AppResponse> getAppList(@RequestParam Long classroomId){
        return appService.getAppList(classroomId);
    }
}
