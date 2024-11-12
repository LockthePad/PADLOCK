package com.ssafy.padlock.app.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ssafy.padlock.app.controller.request.AppRequest;
import com.ssafy.padlock.app.controller.response.AppResponse;
import com.ssafy.padlock.app.domain.App;
import com.ssafy.padlock.app.repository.AppRepository;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.WebClient;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class AppService {

    private final WebClient.Builder webClientBuilder;
    @Value("${app.fastapi.url}")
    private String fastApiUrl;

    private final AppRepository appRepository;
    private WebClient webClient;
    private final ObjectMapper objectMapper;

    @PostConstruct
    public void init() {
        this.webClient = webClientBuilder.build();
    }

    @Transactional
    public List<AppResponse> addApp(AppRequest appRequest) {
        App app = appRepository.findAppByClassroomIdAndAppName(appRequest.getClassroomId(), appRequest.getAppName())
                .orElse(null);

        String appImgUrl;
        if (app == null) {
            try {
                String url = fastApiUrl + "/get-app-image";
                String responseBody = webClient.post()
                        .uri(url)
                        .header(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE)
                        .body(BodyInserters.fromValue(Map.of("appName", appRequest.getAppName())))
                        .retrieve()
                        .bodyToMono(String.class)
                        .block();

                Map<String, String> responseMap = objectMapper.readValue(responseBody, new TypeReference<Map<String, String>>() {});
                appImgUrl = responseMap.get("appImgUrl");

                // appImgUrl이 null인 경우 예외 처리
                if (appImgUrl == null) {
                    throw new IllegalArgumentException("FastAPI에서 유효한 appImgUrl을 반환하지 않았습니다.");
                }

            } catch (Exception e) {
                throw new RuntimeException("앱 이미지 URL 크롤링 중 오류 발생", e);
            }
        } else {
            // 이미 존재하는 경우 기존 이미지 URL 사용
            appImgUrl = app.getAppImg();
        }

        return List.of(new AppResponse(
                app.getClassroomId(),
                app.getAppName(),
                appImgUrl,
                app.getAppPackage(),
                app.getDeleteState()
        ));
    }

    public List<AppResponse> getAppList(Long classroomId) {
        return appRepository.findByClassroomIdAndDeleteStateFalse(classroomId).stream()
                .map(app -> new AppResponse(
                        app.getClassroomId(),
                        app.getAppName(),
                        app.getAppImg(),
                        app.getAppPackage(),
                        app.getDeleteState()
                ))
                .collect(Collectors.toList());
    }
}
