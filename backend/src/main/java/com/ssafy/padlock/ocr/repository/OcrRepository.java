package com.ssafy.padlock.ocr.repository;

import com.ssafy.padlock.ocr.domain.Ocr;
import org.springframework.data.jpa.repository.JpaRepository;

public interface OcrRepository extends JpaRepository<Ocr, Long> {
}
