package com.ssafy.padlock.app.repository;

import com.ssafy.padlock.app.domain.App;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface AppRepository extends JpaRepository<App, Long> {
    Optional<App> findAppByClassroomIdAndAppName(Long classroomId, String appName);
    List<App> findByClassroomIdAndDeleteStateTrue(Long classroomId);
    Optional<App> findByClassroomIdAndAppId(Long classroomId, Long appId);
}
