package com.ssafy.padlock.classroom.service;

import com.ssafy.padlock.classroom.controller.request.NoticeRequest;
import com.ssafy.padlock.classroom.controller.response.NoticeResponse;
import com.ssafy.padlock.classroom.domain.Classroom;
import com.ssafy.padlock.classroom.domain.Notice;
import com.ssafy.padlock.classroom.repository.ClassroomRepository;
import com.ssafy.padlock.classroom.repository.NoticeRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class NoticeService {
    private final NoticeRepository noticeRepository;
    private final ClassroomRepository classroomRepository;

    @Transactional
    public Long createNotice(Long classroomId, NoticeRequest request) {
        Notice savedNotice = noticeRepository.save(
                new Notice(request.getTitle(), request.getContent(), findClassroomById(classroomId))
        );
        return savedNotice.getId();
    }

    public NoticeResponse getNotice(Long noticeId) {
        Notice notice = noticeRepository.findById(noticeId)
                .orElseThrow(() -> new EntityNotFoundException(
                        String.format("공지(noticeId: %d)가 존재하지 않습니다.", noticeId)
                ));
        return NoticeResponse.from(notice);
    }

    public List<NoticeResponse> getAllNotices(Long classroomId) {
        return noticeRepository.findAllByClassroomIdOrderByCreatedAtDesc(classroomId).stream()
                .map(NoticeResponse::from)
                .collect(Collectors.toList());
    }

    private Classroom findClassroomById(Long classroomId) {
        return classroomRepository.findById(classroomId)
                .orElseThrow(() -> new EntityNotFoundException(
                        String.format("학급(classroomId: %d)이 존재하지 않습니다.", classroomId)
                ));
    }
}
