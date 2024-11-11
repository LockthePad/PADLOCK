package com.ssafy.padlock.app.repository;

import com.ssafy.padlock.app.domain.App;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface AppRepository extends JpaRepository<App, Long> {
    Optional<App> findByClassroomIdAndAppName(Long classroomId, String appName);
}
