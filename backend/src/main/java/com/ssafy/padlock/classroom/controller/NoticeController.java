package com.ssafy.padlock.classroom.controller;

import com.ssafy.padlock.classroom.controller.request.NoticeRequest;
import com.ssafy.padlock.classroom.controller.response.NoticeResponse;
import com.ssafy.padlock.classroom.service.NoticeService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
public class NoticeController {
    private final NoticeService noticeService;

    @PreAuthorize("hasRole('TEACHER')")
    @PostMapping("/classrooms/{classroomId}/notices")
    public Long createNotice(@PathVariable Long classroomId, @RequestBody NoticeRequest request) {
        return noticeService.createNotice(classroomId, request);
    }

    @GetMapping("/notices/{noticeId}")
    public NoticeResponse getNotice(@PathVariable Long noticeId) {
        return noticeService.getNotice(noticeId);
    }

    @GetMapping("/classrooms/{classroomId}/notices")
    public List<NoticeResponse> getNotices(@PathVariable Long classroomId) {
        return noticeService.getAllNotices(classroomId);
    }
}
