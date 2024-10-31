package com.ssafy.padlock.counsel.repository;

import com.ssafy.padlock.counsel.domain.Counsel;
import com.ssafy.padlock.counsel.domain.CounselAvailableTime;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface CounselRepository extends JpaRepository<Counsel, Integer> {
    Optional<Counsel> findByCounselAvailableTime(CounselAvailableTime counselAvailableTime);
    void deleteById(Long id);
    List<Counsel> findByParentId(Long parentId);
    List<Counsel> findByTeacherId(Long teacherId);
}
