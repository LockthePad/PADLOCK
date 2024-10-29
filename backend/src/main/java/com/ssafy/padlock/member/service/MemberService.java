package com.ssafy.padlock.member.service;

import com.ssafy.padlock.classroom.domain.Classroom;
import com.ssafy.padlock.classroom.repository.ClassroomRepository;
import com.ssafy.padlock.member.controller.response.ChildResponse;
import com.ssafy.padlock.member.domain.Member;
import com.ssafy.padlock.member.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
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

    public List<ChildResponse> getChildrenInfo(Long parentsId) {
        return memberRepository.findAllByParentsId(parentsId).stream()
                .map(member -> ChildResponse.from(
                        member.getId(),
                        member.getName(),
                        member.getClassRoom().getSchool().getSchoolName() + " "
                                + member.getClassRoom().getGrade() + "학년 "
                                + member.getClassRoom().getClassNumber() + "반"))
                .collect(Collectors.toList());
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
}
