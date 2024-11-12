package com.ssafy.padlock.app.controller;

import com.ssafy.padlock.app.controller.request.AppDeleteRequest;
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

    // 허용된 앱 리스트 조회
    @GetMapping("/app")
    public List<AppResponse> getAppList(@RequestParam Long classroomId) {
        return appService.getAppList(classroomId);
    }

    @PreAuthorize("hasRole('TEACHER')")
    @PutMapping("/app")
    public ResponseEntity<?> updateDeleteState(@RequestBody AppDeleteRequest appDeleteRequest) {
        appService.updateDeleteState(appDeleteRequest);
        return ResponseEntity.ok().build();
    }
}
