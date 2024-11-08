package com.ssafy.padlock.ocr.repository;

import com.ssafy.padlock.ocr.domain.Ocr;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface OcrRepository extends JpaRepository<Ocr, Long> {
    List<Ocr> findByMemberId(Long memberId);
}
