package com.ssafy.padlock.classroom.repository;

import com.ssafy.padlock.classroom.domain.Notice;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface NoticeRepository extends JpaRepository<Notice, Long> {
    List<Notice> findAllByClassroomIdOrderByCreatedAtDesc(Long classroomId);
}
