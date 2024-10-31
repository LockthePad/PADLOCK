package com.ssafy.padlock.counsel.repository;

import com.ssafy.padlock.counsel.domain.CounselAvailableTime;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.time.LocalDate;
import java.util.List;
@Repository
public interface CounselAvailableTimeRepository extends JpaRepository<CounselAvailableTime, Long> {
    List<CounselAvailableTime> findByTeacherId(Long teacherId);
    List<CounselAvailableTime> findByTeacherIdAndCounselAvailableDate(Long teacherId, LocalDate counselAvailableDate);
}
