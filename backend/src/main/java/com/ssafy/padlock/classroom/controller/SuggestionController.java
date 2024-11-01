package com.ssafy.padlock.classroom.controller;

import com.ssafy.padlock.auth.supports.LoginMember;
import com.ssafy.padlock.classroom.controller.request.SuggestionRequest;
import com.ssafy.padlock.classroom.controller.response.SuggestionResponse;
import com.ssafy.padlock.classroom.service.SuggestionService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
public class SuggestionController {
    private final SuggestionService suggestionService;

    @PreAuthorize("hasRole('STUDENT')")
    @PostMapping("/suggestions")
    public void suggest(@LoginMember Long studentId, @RequestBody SuggestionRequest suggestionRequest) {
        suggestionService.suggest(studentId, suggestionRequest);
    }

    @PreAuthorize("hasRole('TEACHER')")
    @GetMapping("/classrooms/{classroomId}/suggestions")
    public List<SuggestionResponse> getSuggestions(@PathVariable Long classroomId) {
        return suggestionService.getSuggestions(classroomId);
    }

    @PreAuthorize("hasRole('TEACHER')")
    @GetMapping("/suggestions/{suggestionId}")
    public SuggestionResponse getSuggestion(@PathVariable Long suggestionId) {
        return suggestionService.getSuggestion(suggestionId);
    }

    @PreAuthorize("hasRole('TEACHER')")
    @PostMapping("/suggestions/{suggestionId}")
    public void checkSuggestion(@PathVariable Long suggestionId) {
        suggestionService.changeSuggestionStatus(suggestionId);
    }
}
