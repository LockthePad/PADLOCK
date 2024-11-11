package com.ssafy.padlock.member.repository;

import com.ssafy.padlock.member.domain.Attendance;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface AttendanceRepository extends JpaRepository<Attendance, Long> {
    Optional<Attendance> findByMemberIdAndAttendanceDate(Long memberId, LocalDate date);
    List<Attendance> findByMemberIdInAndAttendanceDate(List<Long> memberIds, LocalDate attendanceDate);
}
