package com.ssafy.padlock.app.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ssafy.padlock.app.controller.request.AppDeleteRequest;
import com.ssafy.padlock.app.controller.request.AppRequest;
import com.ssafy.padlock.app.controller.response.AppResponse;
import com.ssafy.padlock.app.domain.App;
import com.ssafy.padlock.app.repository.AppRepository;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.WebClient;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Slf4j
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
    public List<AppResponse> addApp(List<AppRequest> appRequestList) {
        List<AppResponse> appResponses = new ArrayList<>();

        for (AppRequest appRequest : appRequestList) {
            App app = appRepository.findAppByClassroomIdAndAppName(appRequest.getClassroomId(), appRequest.getAppName())
                    .orElse(null);

            String appImgUrl;
            if (app == null) {
                try {
                    String url = fastApiUrl + "/get-app-image";

                    String responseBody = webClient.post()
                            .uri(url)
                            .header(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE)
                            .body(BodyInserters.fromValue(Collections.singletonMap("appName", appRequest.getAppName())))
                            .retrieve()
                            .bodyToMono(String.class)
                            .block();

                    Map<String, String> responseMap = objectMapper.readValue(responseBody, Map.class);
                    appImgUrl = responseMap.get("imageUrl");

                    app = App.createApp(appRequest.getClassroomId(), appRequest.getAppName(), appRequest.getPackageName(), appImgUrl);
                    appRepository.save(app);

                } catch (Exception e) {
                    throw new RuntimeException("앱 이미지 URL 크롤링 중 오류 발생", e);
                }
            } else {
                appImgUrl = app.getAppImg();
            }

            AppResponse appResponse = new AppResponse(
                    app.getClassroomId(),
                    app.getAppId(),
                    app.getAppName(),
                    appImgUrl,
                    app.getAppPackage(),
                    app.getDeleteState()
            );
            appResponses.add(appResponse);
        }
        return appResponses;
    }

    // 허용된 앱 리스트 조회
    public List<AppResponse> getAppList(Long classroomId) {
        return appRepository.findByClassroomIdAndDeleteStateTrue(classroomId).stream()
                .map(app -> new AppResponse(
                        app.getClassroomId(),
                        app.getAppId(),
                        app.getAppName(),
                        app.getAppImg(),
                        app.getAppPackage(),
                        app.getDeleteState()
                ))
                .collect(Collectors.toList());
    }

    @Transactional
    public void updateDeleteState(AppDeleteRequest appDeleteRequest) {
        App app = appRepository.findByClassroomIdAndAppId(appDeleteRequest.getClassroomId(), appDeleteRequest.getAppId())
                .orElseThrow(() -> new IllegalArgumentException("해당 ID를 가진 앱이 존재하지 않습니다: " + appDeleteRequest.getAppId()));

        if (app.getDeleteState()) {
            app.activate();  // 비활성 상태에서 활성화
        } else {
            app.deactivate();  // 활성 상태에서 비활성화
        }
    }
}
