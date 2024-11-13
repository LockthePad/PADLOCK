package com.ssafy.padlock.ocr.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ssafy.padlock.ocr.controller.request.OcrRequest;
import com.ssafy.padlock.ocr.controller.response.OcrResponse;
import com.ssafy.padlock.ocr.controller.response.OcrTotalResponse;
import com.ssafy.padlock.ocr.domain.Ocr;
import com.ssafy.padlock.ocr.repository.OcrRepository;
import jakarta.annotation.PostConstruct;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.WebClient;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class OcrService {

    private final WebClient.Builder webClientBuilder;
    private final OcrRepository ocrRepository;
    private WebClient webClient;
    private final ObjectMapper objectMapper;
    private final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy.MM.dd EEEE");

    @PostConstruct
    public void init() {
        this.webClient = webClientBuilder.build();
    }

    @Value("${app.fastapi.url}")
    private String fastApiUrl;

    public OcrResponse ocrFastApi(MultipartFile image) {
        if (image == null) {
            throw new IllegalArgumentException("image is null");
        }
        try {
            String url = fastApiUrl + "/process-image";

            String responseBody = webClient.post()
                    .uri(url)
                    .header(HttpHeaders.CONTENT_TYPE, MediaType.MULTIPART_FORM_DATA_VALUE)
                    .body(BodyInserters.fromMultipartData("image", image.getResource()))
                    .retrieve()
                    .bodyToMono(String.class)
                    .block();

            if (responseBody == null || responseBody.isEmpty()) {
                throw new RuntimeException("탐지된 문자가 없습니다");
            }

            log.info("OCR 반환 데이터" + responseBody);
            return objectMapper.readValue(responseBody, OcrResponse.class);

        } catch (Exception e) {
            throw new RuntimeException("탐지된 칠판이 없습니다", e);
        }
    }

    public void saveOcr(Long memberId, OcrRequest ocrRequest) {
        try {
            // List<String> content를 JSON 문자열로 변환
            String content = objectMapper.writeValueAsString(ocrRequest.getContent());
            String date = ocrRequest.getCreateDate();

            Ocr ocr = new Ocr(memberId, content, date);
            ocrRepository.save(ocr);
        } catch (Exception e) {
            throw new RuntimeException("OCR content를 String으로 변환하는 중 오류 발생", e);
        }
    }

    public List<OcrTotalResponse> getOcrList(Long memberId) {
        List<Ocr> ocrList = ocrRepository.findByMemberId(memberId);

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy.MM.dd");

        return ocrList.stream()
                .sorted(Comparator.comparing(ocr -> LocalDate.parse(ocr.getCreateDate().substring(0, 10), formatter), Comparator.reverseOrder())) // 날짜 부분만 파싱하여 최신순 정렬
                .map(ocr -> new OcrTotalResponse(
                        ocr.getId(),
                        Arrays.asList(ocr.getContent().split(",")), // 문자열을 리스트로 변환
                        ocr.getCreateDate()
                ))
                .collect(Collectors.toList());
    }

    @Transactional
    public void deleteOcr(Long memberId, Long ocrId) {
        Ocr ocr = ocrRepository.findByMemberIdAndId(memberId, ocrId)
                .orElseThrow(() -> new EntityNotFoundException("해당 OCR 데이터를 찾을 수 없습니다."));

        ocrRepository.delete(ocr);
    }
}