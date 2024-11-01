package com.ssafy.padlock.counsel.controller;

import com.ssafy.padlock.auth.supports.LoginMember;
import com.ssafy.padlock.counsel.controller.request.CounselParentRequest;
import com.ssafy.padlock.counsel.controller.request.CounselTeacherRequest;
import com.ssafy.padlock.counsel.controller.response.CounselAvailableTimeResponse;
import com.ssafy.padlock.counsel.domain.CounselAvailableTime;
import com.ssafy.padlock.counsel.service.CounselService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

        import java.time.LocalDate;
import java.util.List;

@RestController
@RequiredArgsConstructor
public class CounselController {

    private final CounselService counselService;

    @GetMapping("/counsel-available-time")
    public ResponseEntity<List<CounselAvailableTime>> getCounselAvailableTimeTeacher(@LoginMember Long teacherId, @RequestParam LocalDate date) {
        List<CounselAvailableTime> availableTimes = counselService.getAvailableTimes(teacherId, date);
        return ResponseEntity.ok(availableTimes);
    }

    @PostMapping("/add-counsel")
    public ResponseEntity<?> addCounsel(@RequestBody CounselParentRequest counselParentRequest, @LoginMember Long parentId) {
        counselService.addCounsel(counselParentRequest, parentId);
        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/cancel-counsel/teacher")
    public ResponseEntity<?> cancelCounselTeacher(@RequestBody CounselTeacherRequest counselTeacherRequest, @LoginMember Long teacherId) {
        counselService.cancelCounselTeacher(counselTeacherRequest, teacherId);
        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/cancel-counsel/parent")
    public ResponseEntity<?> cancelCounselParent(@RequestBody CounselParentRequest counselParentRequest, @LoginMember Long parentId) {
        counselService.cancelCounselParent(counselParentRequest, parentId);
        return ResponseEntity.ok().build();
    }

    @PostMapping("/post-counsel-data/{month}")
    public ResponseEntity<?> postCounselData(@PathVariable int month) {
        counselService.insertCounselAvailableTime(month);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/user-counsel")
    public ResponseEntity<?> getParentCounsel(@LoginMember Long id) {
        List<CounselAvailableTimeResponse> parentCounsel = counselService.getUserCounsel(id);
        return ResponseEntity.ok(parentCounsel);
    }

    @GetMapping("/today-counsel")
    public ResponseEntity<?> getTodayCounsel(@LoginMember Long id) {
        List<CounselAvailableTimeResponse> counselForToday = counselService.getCounselForToday(id);
        return ResponseEntity.ok(counselForToday);
    }

    @PreAuthorize("hasRole('TEACHER')")
    @PutMapping("/change-counsel/{counselAvailableTimeId}")
    public ResponseEntity<?> changeCounsel(@LoginMember Long id, @PathVariable Long counselAvailableTimeId){
        counselService.openCounsel(id, counselAvailableTimeId);
        return ResponseEntity.ok().build();
    }
}
