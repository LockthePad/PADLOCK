package com.ssafy.padlock.member.repository;

import com.ssafy.padlock.member.domain.Member;
import com.ssafy.padlock.member.domain.Role;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface MemberRepository extends JpaRepository<Member, Long> {
    Optional<Member> findByMemberCode(String memberCode);
    List<Member> findAllByParentsId(Long parentsId);
    List<Member> findByRole(Role role);
}
