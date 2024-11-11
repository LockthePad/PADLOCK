package com.ssafy.padlock.app.controller;

import com.ssafy.padlock.app.controller.request.AppRequest;
import com.ssafy.padlock.app.service.AppService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
public class AppController {
    private final AppService appService;

    @PreAuthorize("hasRole('TEACHER')")
    @PostMapping("/app")
    public ResponseEntity<?> addApp(@RequestBody AppRequest appRequest) {
        appService.addApp(appRequest);
        return ResponseEntity.ok().build();
    }
}
