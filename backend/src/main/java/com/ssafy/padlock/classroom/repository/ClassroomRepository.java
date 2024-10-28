package com.ssafy.padlock.classroom.repository;

import com.ssafy.padlock.classroom.domain.Classroom;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ClassroomRepository extends JpaRepository<Classroom, Long> {
}
