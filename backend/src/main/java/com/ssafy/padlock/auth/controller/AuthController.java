package com.ssafy.padlock.auth.controller;

import com.ssafy.padlock.auth.controller.request.LoginRequest;
import com.ssafy.padlock.auth.controller.response.LoginResponse;
import com.ssafy.padlock.auth.service.AuthService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
public class AuthController {
    private final AuthService authService;

    @PostMapping("/login")
    public LoginResponse login(@RequestBody LoginRequest request) {
        return authService.login(request);
    }
}
