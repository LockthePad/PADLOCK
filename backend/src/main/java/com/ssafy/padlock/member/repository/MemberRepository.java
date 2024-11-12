package com.ssafy.padlock.member.repository;

import com.ssafy.padlock.classroom.domain.Classroom;
import com.ssafy.padlock.member.domain.Member;
import com.ssafy.padlock.member.domain.Role;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface MemberRepository extends JpaRepository<Member, Long> {
    Optional<Member> findByMemberCode(String memberCode);
    List<Member> findAllByParentsId(Long parentsId);
    List<Member> findByRole(Role role);

    @Query("SELECT m.id FROM Member m WHERE m.classRoom.id = :classroomId AND m.role = :role")
    List<Long> findStudentIdsByClassroomId(@Param("classroomId") Long classroomId, @Param("role") Role role);

    @Query("SELECT m.parents.id FROM Member m WHERE m.id = :studentId")
    Long findParentIdByStudentId(@Param("studentId") Long studentId);

    Optional<Member> findByClassRoomAndRole(Classroom classroom, Role role);

    List<Member> findByClassRoom_IdAndRole(Long classroomId, Role role);
}
