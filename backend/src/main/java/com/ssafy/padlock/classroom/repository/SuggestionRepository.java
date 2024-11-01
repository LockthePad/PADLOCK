package com.ssafy.padlock.classroom.repository;

import com.ssafy.padlock.classroom.domain.Suggestion;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface SuggestionRepository extends JpaRepository<Suggestion, Long> {
    List<Suggestion> findAllByClassroomIdOrderByTimeDesc(Long classroomId);
}
