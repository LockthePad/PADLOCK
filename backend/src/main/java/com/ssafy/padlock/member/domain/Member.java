package com.ssafy.padlock.member.domain;

import com.ssafy.padlock.classroom.domain.Classroom;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

import static jakarta.persistence.EnumType.STRING;
import static lombok.AccessLevel.PROTECTED;

@Entity
@Getter
@Table(name = "member")
@NoArgsConstructor(access = PROTECTED)
public class Member {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Enumerated(value = STRING)
    @Column(name = "role", nullable = false)
    private Role role;

    @Column(name = "member_code", nullable = false, unique = true)
    private String memberCode;

    @Column(name = "password", nullable = false)
    private String password;

    @Column(name = "name")
    private String name;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_id")
    private Member parent;

    @OneToMany(mappedBy = "parent")
    private List<Member> children = new ArrayList<>();

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "classroom_id")
    private Classroom classRoom;

    private Member(Role role, String memberCode, String password, String name, Member parent, Classroom classRoom) {
        this.role = role;
        this.memberCode = memberCode;
        this.password = password;
        this.name = name;
        this.parent = parent;
        this.classRoom = classRoom;
    }

    public static Member student(String memberCode, String password, String name, Member parent, Classroom classRoom) {
        return new Member(Role.STUDENT, memberCode, password, name, parent, classRoom);
    }

    public static Member parent(String memberCode, String password) {
        return new Member(Role.PARENTS, memberCode, password, null, null, null);
    }

    public static Member teacher(String memberCode, String password, String name) {
        return new Member(Role.TEACHER, memberCode, password, name, null, null);
    }
}
