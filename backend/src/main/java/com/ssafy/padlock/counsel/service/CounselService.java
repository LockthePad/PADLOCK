package com.ssafy.padlock.counsel.service;

import com.ssafy.padlock.counsel.controller.request.CounselParentRequest;
import com.ssafy.padlock.counsel.controller.request.CounselTeacherRequest;
import com.ssafy.padlock.counsel.controller.response.CounselAvailableTimeResponse;
import com.ssafy.padlock.counsel.domain.Counsel;
import com.ssafy.padlock.counsel.domain.CounselAvailableTime;
import com.ssafy.padlock.counsel.repository.CounselAvailableTimeRepository;
import com.ssafy.padlock.counsel.repository.CounselRepository;
import com.ssafy.padlock.member.domain.Member;
import com.ssafy.padlock.member.domain.Role;
import com.ssafy.padlock.member.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.YearMonth;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CounselService {
    private final CounselRepository counselRepository;
    private final CounselAvailableTimeRepository counselAvailableTimeRepository;
    private final MemberRepository memberRepository;

    //교사 상담 취소
    @Transactional
    public void cancelCounselTeacher(CounselTeacherRequest counselTeacherRequest, Long teacherId) {
        memberRepository.findById(counselTeacherRequest.getParentId())
                .orElseThrow(() -> new IllegalArgumentException("해당 학부모가 존재하지 않습니다."));

        CounselAvailableTime counselAvailableTime = counselAvailableTimeRepository.findById(counselTeacherRequest.getCounselAvailableTimeId())
                .orElseThrow(() -> new IllegalArgumentException("해당하는 상담가능 시간이 없습니다."));

        Member teacher = memberRepository.findById(teacherId)
                .orElseThrow(() -> new IllegalArgumentException("선생님이 존재하지 않습니다."));

        if(!teacher.getRole().equals(Role.TEACHER)){
            throw new IllegalArgumentException("선생님만 취소가 가능합니다.");
        }

        Counsel counsel = counselRepository.findByCounselAvailableTime(counselAvailableTime)
                        .orElseThrow(() -> new IllegalArgumentException("해당 시간에 예약이 없습니다."));

        counselAvailableTime.changeClosed(1);
        counselRepository.deleteById(counsel.getId());
    }

    //학부모 상담 취소
    @Transactional
    public void cancelCounselParent(CounselParentRequest counselParentRequest, Long parentId) {
        memberRepository.findById(counselParentRequest.getTeacherId())
                .orElseThrow(() -> new IllegalArgumentException("해당 선생님이 존재하지 않습니다."));

        CounselAvailableTime counselAvailableTime = counselAvailableTimeRepository.findById(counselParentRequest.getCounselAvailableTimeId())
                .orElseThrow(() -> new IllegalArgumentException("해당하는 상담가능 시간이 없습니다."));

        Member parent = memberRepository.findById(parentId)
                .orElseThrow(() -> new IllegalArgumentException("학부모가 존재하지 않습니다."));

        if(!parent.getRole().equals(Role.PARENTS)){
            throw new IllegalArgumentException("학부모만 취소가 가능합니다.");
        }

        Counsel counsel = counselRepository.findByCounselAvailableTime(counselAvailableTime)
                .orElseThrow(() -> new IllegalArgumentException("해당 시간에 예약이 없습니다."));

        counselAvailableTime.changeClosed(2);
        counselRepository.deleteById(counsel.getId());
    }

    //학부모 상담 신청
    @Transactional
    public void addCounsel(CounselParentRequest counselParentRequest, Long parentId) {
        Member member = memberRepository.findById(parentId)
                .orElseThrow(() -> new IllegalArgumentException("해당 학부모가 존재하지 않습니다."));

        if(!member.getRole().equals(Role.PARENTS)){
            throw new IllegalArgumentException("학부모만 조회가 가능합니다.");
        }

        CounselAvailableTime counselAvailableTime = counselAvailableTimeRepository.findById(counselParentRequest.getCounselAvailableTimeId())
                .orElseThrow(() -> new IllegalArgumentException("해당하는 상담가능 시간이 없습니다."));

        if(counselAvailableTime.getClosed() == 1 || counselAvailableTime.getClosed() == 3){
            throw new IllegalArgumentException("예약이 불가능한 시간입니다.");
        }

        Member teacher = memberRepository.findById(counselParentRequest.getTeacherId())
                .orElseThrow(() -> new IllegalArgumentException("해당 교사가 존재하지 않습니다."));

        Member student = memberRepository.findById(counselParentRequest.getStudentId())
                .orElseThrow(() -> new IllegalArgumentException("해당 학생이 존재하지 않습니다."));

        if(!Objects.equals(teacher.getId(), counselAvailableTime.getTeacherId())){
            throw new IllegalArgumentException("상담 신청이 불가능합니다.(교사에 해당하지 않는 상담 시간)");
        }

        if(!student.getRole().equals(Role.STUDENT) && teacher.getRole().equals(Role.TEACHER)){
            throw new IllegalArgumentException("신청 불가능");
        }

        if(student.getClassRoom().getClassNumber() != teacher.getClassRoom().getClassNumber()){
            throw new IllegalArgumentException("신청 불가능(해당 담임선생님이 아닙니다)");
        }

        if (counselAvailableTime.getCounselAvailableDate().isBefore(LocalDate.now())) {
            throw new IllegalArgumentException("지난 날짜로 상담을 신청할 수 없습니다.");
        }

        Counsel counsel = new Counsel(parentId, counselParentRequest.getTeacherId(), counselParentRequest.getStudentId(), counselAvailableTime);

        counselAvailableTime.changeClosed(3);
        counselRepository.save(counsel);
    }

    //날짜별 선생님 상담 목록 조회
    public List<CounselAvailableTime> getAvailableTimes(Long teacherId, LocalDate date) {
        memberRepository.findById(teacherId)
                .orElseThrow(() -> new IllegalArgumentException("선생님의 정보가 존재하지 않습니다."));

        return counselAvailableTimeRepository.findByTeacherIdAndCounselAvailableDate(teacherId, date);
    }

    //날짜별 학부모 상담 목록 조회
    public List<CounselAvailableTime> getAvailableTimesParent(Long parentId, Long teacherId, LocalDate date) {
        memberRepository.findById(parentId)
                        .orElseThrow(() -> new IllegalArgumentException("학부모의 정보가 존재하지 않습니다."));

        memberRepository.findById(teacherId)
                .orElseThrow(() -> new IllegalArgumentException("선생님의 정보가 존재하지 않습니다."));

        return counselAvailableTimeRepository.findByTeacherIdAndCounselAvailableDate(teacherId, date);
    }

    //선생님 상담 열고닫기
    @Transactional
    public void openCounsel(Long teacherId, Long counselId) {
        memberRepository.findById(teacherId)
                .orElseThrow(() -> new IllegalArgumentException("선생님의 정보가 존재하지 않습니다."));

        CounselAvailableTime counselAvailableTime = counselAvailableTimeRepository.findById(counselId)
                .orElseThrow(() -> new IllegalArgumentException("해당 상담시간이 존재하지 않습니다."));

        if(!Objects.equals(counselAvailableTime.getTeacherId(), teacherId)){
            throw new IllegalArgumentException("해당하는 선생님의 상담 시간이 아닙니다.");
        }

        if(counselAvailableTime.getClosed() == 1){
            counselAvailableTime.changeClosed(2);
        }else if(counselAvailableTime.getClosed() == 2){
            counselAvailableTime.changeClosed(1);
        }
        counselAvailableTimeRepository.save(counselAvailableTime);
    }

    //자신의 상담 신청 현황 -> 학부모, 교사 모두 확인 가능해야함
    public List<CounselAvailableTimeResponse> getUserCounsel(Long id) {
        Member member = memberRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("사용자의 정보가 존재하지 않습니다."));

        List<Counsel> counsels;
        LocalDate currentDate = LocalDate.now();
        LocalTime currentTime = LocalTime.now();

        if (member.getRole().equals(Role.PARENTS)) {
            counsels = counselRepository.findByParentId(id);
        } else if (member.getRole().equals(Role.TEACHER)) {
            counsels = counselRepository.findByTeacherId(id);
        } else {
            throw new IllegalArgumentException("학부모와 선생만 조회 가능합니다.");
        }

        return counsels.stream()
                .filter(counsel -> {
                    CounselAvailableTime availableTime = counsel.getCounselAvailableTime();
                    return availableTime != null &&
                            (availableTime.getCounselAvailableDate().isAfter(currentDate) ||
                                    (availableTime.getCounselAvailableDate().isEqual(currentDate) &&
                                            availableTime.getCounselAvailableTime().isAfter(currentTime)));
                })
                .map(counsel -> {
                    String studentName = null;
                    if (counsel.getStudentId() != null) {
                        Member student = memberRepository.findById(counsel.getStudentId())
                                .orElseThrow(() -> new IllegalArgumentException("해당 학생이 존재하지 않습니다."));
                        studentName = student.getName();
                    }

                    return new CounselAvailableTimeResponse(
                            counsel.getId(),
                            counsel.getParentId(),
                            counsel.getTeacherId(),
                            studentName,  // 조회한 이름 전달
                            counsel.getCounselAvailableTime().getId(),
                            counsel.getCounselAvailableTime().getCounselAvailableDate(),
                            counsel.getCounselAvailableTime().getCounselAvailableTime()
                    );
                })
                .collect(Collectors.toList());
    }

    public List<CounselAvailableTimeResponse> getCounselForToday(Long id){
        List<CounselAvailableTimeResponse> userCounsel = getUserCounsel(id);
        LocalDate currentDate = LocalDate.now();
        return userCounsel.stream()
                .filter(counsel -> counsel.getCounselAvailableDate().isEqual(currentDate))
                .collect(Collectors.toList());
    }


    //예약 가능 시간 데이터베이스에 추가
    @Transactional
    public void insertCounselAvailableTime(int month){
        List<Member> teachers = memberRepository.findByRole(Role.TEACHER);

        // 현재 연도와 주어진 월에 대한 정보를 사용하여 평일 목록 생성
        YearMonth yearMonth = YearMonth.of(LocalDate.now().getYear(), month);
        LocalDate startDate = yearMonth.atDay(1); // 해당 월의 첫 날
        LocalDate endDate = yearMonth.atEndOfMonth(); // 해당 월의 마지막 날

        // 상담 가능한 시간 목록
        List<LocalTime> availableTimes = List.of(
                LocalTime.of(16, 0),
                LocalTime.of(16, 30),
                LocalTime.of(17, 0),
                LocalTime.of(17, 30)
        );

        for (LocalDate date = startDate; !date.isAfter(endDate); date = date.plusDays(1)) {
            // 평일만 처리 (월요일 ~ 금요일)
            if (date.getDayOfWeek() != DayOfWeek.SATURDAY && date.getDayOfWeek() != DayOfWeek.SUNDAY) {
                for (Member teacher : teachers) {
                    for (LocalTime time : availableTimes) {
                        // CounselAvailableTime 엔티티 생성 및 저장
                        CounselAvailableTime counselAvailableTime = new CounselAvailableTime(
                                teacher.getId(),
                                date,
                                time,
                                1
                        );
                        counselAvailableTimeRepository.save(counselAvailableTime);
                    }
                }
            }
        }
    }
}
