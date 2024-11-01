package com.ssafy.padlock.classroom.service;

import com.ssafy.padlock.classroom.controller.request.NoticeRequest;
import com.ssafy.padlock.classroom.controller.request.NoticeUpdateRequest;
import com.ssafy.padlock.classroom.controller.response.NoticeResponse;
import com.ssafy.padlock.classroom.domain.Classroom;
import com.ssafy.padlock.classroom.domain.Notice;
import com.ssafy.padlock.classroom.repository.ClassroomRepository;
import com.ssafy.padlock.classroom.repository.NoticeRepository;
import com.ssafy.padlock.member.domain.Member;
import com.ssafy.padlock.member.repository.MemberRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class NoticeService {
    private final MemberRepository memberRepository;
    private final NoticeRepository noticeRepository;
    private final ClassroomRepository classroomRepository;

    @Transactional
    public Long createNotice(Long teacherId, Long classroomId, NoticeRequest request) {
        Classroom classroom = findClassroomById(classroomId);
        validateTeacherOfClassroom(findMemberById(teacherId), classroom);
        return noticeRepository.save(new Notice(request.getTitle(), request.getContent(), classroom)).getId();
    }

    public NoticeResponse getNotice(Long noticeId) {
        return NoticeResponse.from(findNoticeById(noticeId));
    }

    public List<NoticeResponse> getAllNotices(Long classroomId) {
        return noticeRepository.findAllByClassroomIdOrderByCreatedAtDesc(classroomId).stream()
                .map(NoticeResponse::from)
                .collect(Collectors.toList());
    }

    @Transactional
    public Long updateNotice(Long teacherId, Long noticeId, NoticeUpdateRequest request) {
        Notice notice = findNoticeById(noticeId);
        validateTeacherOfClassroom(findMemberById(teacherId), notice.getClassroom());
        notice.updateContent(request.getTitle(), request.getContent());
        return notice.getId();
    }

    @Transactional
    public void deleteNotice(Long teacherId, Long noticeId) {
        Notice notice = findNoticeById(noticeId);
        validateTeacherOfClassroom(findMemberById(teacherId), notice.getClassroom());
        noticeRepository.delete(notice);
    }

    private void validateTeacherOfClassroom(Member teacher, Classroom classroom) {
        if (!teacher.getClassRoom().equals(classroom)) {
            throw new IllegalArgumentException("해당 반의 담임 교사만 가능합니다.");
        }
    }

    private Classroom findClassroomById(Long classroomId) {
        return classroomRepository.findById(classroomId)
                .orElseThrow(() -> new EntityNotFoundException(
                        String.format("학급(classroomId: %d)이 존재하지 않습니다.", classroomId)
                ));
    }

    private Member findMemberById(Long memberId) {
        return memberRepository.findById(memberId)
                .orElseThrow(() -> new EntityNotFoundException(
                        String.format("회원(memberId: %d)이 존재하지 않습니다.", memberId)
                ));
    }

    private Notice findNoticeById(Long noticeId) {
        return noticeRepository.findById(noticeId)
                .orElseThrow(() -> new EntityNotFoundException(
                        String.format("공지(noticeId: %d)가 존재하지 않습니다.", noticeId)
                ));
    }
}
