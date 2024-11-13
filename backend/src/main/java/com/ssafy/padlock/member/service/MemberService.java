package com.ssafy.padlock.member.service;

import com.ssafy.padlock.classroom.domain.Classroom;
import com.ssafy.padlock.classroom.repository.ClassroomRepository;
import com.ssafy.padlock.member.controller.response.ChildResponse;
import com.ssafy.padlock.member.domain.Member;
import com.ssafy.padlock.member.repository.MemberRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class MemberService {
    private final MemberRepository memberRepository;
    private final ClassroomRepository classroomRepository;
    private final PasswordEncoder passwordEncoder;

    @Transactional
    public void saveMembers(String memberData) {
        List<Member> members = new ArrayList<>();

        String[] rows = memberData.replaceAll("\\r\\n|\\r|\\n", "").split("\\),\\(");
        for (String row : rows) {
            String[] parts = row.replace("(", "")
                    .replace(")", "").replace("'", "").trim().split(", ");
            members.add(parseMember(parts));
        }

        memberRepository.saveAll(members);
    }

    @Transactional
    public void addStudent(Long classroomId, int studentNumber, String studentName, String parentCode) {
        Classroom classroom = findClassroomById(classroomId);
        String memberCode = String.format("STD-%d-%d-%02d", classroom.getGrade(), classroom.getClassNumber(), studentNumber);
        String password = generateRandomString(6);
        memberRepository.save(
                Member.student(memberCode, passwordEncoder.encode(password), studentName, createParents(parentCode), classroom)
        );
        classroom.addStudent();
    }

    private Member createParents(String parentCode) {
        if (parentCode == null) {
            String code = "PAR-" + generateRandomString(3);
            String password = generateRandomString(6);
            return memberRepository.save(Member.parent(code, passwordEncoder.encode(password)));
        }
        return memberRepository.findByMemberCode(parentCode)
                .orElseThrow(() -> new EntityNotFoundException("부모 코드가 존재하지 않습니다: " + parentCode));
    }

    public List<ChildResponse> getChildrenInfo(Long parentsId) {
        return memberRepository.findAllByParentsId(parentsId).stream()
                .map(ChildResponse::from)
                .collect(Collectors.toList());
    }

    public String generateRandomString(int length) {
        return UUID.randomUUID().toString().replaceAll("-", "").substring(0, length);
    }

    private Member parseMember(String[] parts) {
        String role = parts[0];
        String memberCode = parts[1];
        String encodedPassword = passwordEncoder.encode(parts[2]);
        String name = parts.length > 3 ? parts[3] : null;

        Member parent = parts.length > 4
                ? memberRepository.findByMemberCode(parts[4])
                .orElseThrow(() -> new IllegalArgumentException("부모 코드가 잘못되었습니다: " + parts[4]))
                : null;

        Classroom classroom = parts.length > 5
                ? classroomRepository.findById(Long.parseLong(parts[5]))
                .orElseThrow(() -> new IllegalArgumentException("유효하지 않은 Classroom ID: " + parts[5]))
                : null;

        return switch (role) {
            case "STUDENT" -> Member.student(memberCode, encodedPassword, name, parent, classroom);
            case "PARENTS" -> Member.parent(memberCode, encodedPassword);
            case "TEACHER" -> Member.teacher(memberCode, encodedPassword, name);
            default -> throw new IllegalArgumentException("유효하지 않은 ROLE: " + role);
        };
    }

    private Classroom findClassroomById(Long classroomId) {
        return classroomRepository.findById(classroomId)
                .orElseThrow(() -> new EntityNotFoundException(
                        String.format("학급(classroomId: %d)이 존재하지 않습니다.", classroomId)
                ));
    }

    public Long getTeacherId(Long classroomId) {
        return memberRepository.findTeacherIdByClassroomId(classroomId)
                .orElseThrow(() -> new EntityNotFoundException("담임 선생님을 찾을 수 없습니다."));
    }
}
