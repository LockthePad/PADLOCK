package com.ssafy.padlock.classroom.service;

import com.ssafy.padlock.classroom.controller.request.SuggestionRequest;
import com.ssafy.padlock.classroom.controller.response.SuggestionResponse;
import com.ssafy.padlock.classroom.domain.Suggestion;
import com.ssafy.padlock.classroom.repository.SuggestionRepository;
import com.ssafy.padlock.member.domain.Member;
import com.ssafy.padlock.member.domain.Role;
import com.ssafy.padlock.member.repository.MemberRepository;
import com.ssafy.padlock.notification.domain.Notification;
import com.ssafy.padlock.notification.domain.NotificationType;
import com.ssafy.padlock.notification.repository.NotificationRepository;
import com.ssafy.padlock.notification.service.NotificationService;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class SuggestionService {
    private final MemberRepository memberRepository;
    private final SuggestionRepository suggestionRepository;
    private final NotificationService notificationService;
    private final NotificationRepository notificationRepository;

    @Transactional
    public void suggest(Long studentId, SuggestionRequest request) {
        Member student = memberRepository.findById(studentId)
                .orElseThrow(() -> new EntityNotFoundException(
                        String.format("학생(studentId: %d)이 존재하지 않습니다.", studentId)
                ));

        Long teacherId = memberRepository.findByClassRoomAndRole(student.getClassRoom(), Role.TEACHER)
                .orElseThrow(() -> new EntityNotFoundException(
                        String.format("교사(classroomId: %s)를 찾을 수 없습니다.", student.getClassRoom().getId())
                )).getId();

        suggestionRepository.save(new Suggestion(request.getContent(), student.getClassRoom(), student));

        notificationRepository.save(new Notification(teacherId, NotificationType.SUGGESTION));
        notificationService.sendMessageToMember(NotificationType.SUGGESTION, teacherId);
    }

    public List<SuggestionResponse> getSuggestions(Long classroomId) {
        return suggestionRepository.findAllByClassroomIdOrderByTimeDesc(classroomId).stream()
                .map(SuggestionResponse::from)
                .toList();
    }

    public SuggestionResponse getSuggestion(Long suggestionId) {
        return SuggestionResponse.from(findSuggestionById(suggestionId));
    }

    @Transactional
    public void changeSuggestionStatus(Long suggestionId) {
        findSuggestionById(suggestionId).changeStatus();
    }

    private Suggestion findSuggestionById(Long suggestionId) {
        return suggestionRepository.findById(suggestionId)
                .orElseThrow(() -> new EntityNotFoundException(
                        String.format("건의(suggestionId: %d)가 존재하지 않습니다.", suggestionId)
                ));
    }
}
