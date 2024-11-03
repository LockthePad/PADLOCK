package com.ssafy.padlock.ocr.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ssafy.padlock.ocr.controller.response.OcrResponse;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.WebClient;

@Service
@RequiredArgsConstructor
public class OcrService {

    private final WebClient.Builder webClientBuilder;
    private WebClient webClient;
    private final ObjectMapper objectMapper;

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

            return objectMapper.readValue(responseBody, OcrResponse.class);

        } catch (Exception e) {
            throw new RuntimeException("OCR 요청 중 오류 발생", e);
        }
    }
}