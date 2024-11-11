package com.ssafy.padlock.app.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;

import static lombok.AccessLevel.PROTECTED;

@Entity
@Getter
@Table(name = "app")
@NoArgsConstructor(access = PROTECTED)
public class App {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long appId;

    @Column(name = "classroom_id", nullable = false)
    private Long classroomId;

    @Column(name = "app_name", nullable = false)
    private String appName;

    @Column(name = "app_img", nullable = false)
    private String appImg;

    @Column(name = "delete_state", nullable = false)
    private Boolean deleteState = false;

    public static App createApp(Long classroomId, String appName, String appImg) {
        App app = new App();
        app.classroomId = classroomId;
        app.appName = appName;
        app.appImg = appImg;
        app.deleteState = false;
        return app;
    }

    // 이미 존재하는 앱을 다시 활성화
    public void activate() {
        this.deleteState = false;
    }

    // 이미 존재하는 앱을 다시 비활성화
    public void deactivate() {
        this.deleteState = true;
    }
}