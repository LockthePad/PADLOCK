package com.ssafy.padlock.ocr.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;

import static lombok.AccessLevel.PROTECTED;

@Entity
@Getter
@Table(name = "Ocr")
@NoArgsConstructor(access = PROTECTED)
public class Ocr {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "content", nullable = false)
    private String content;

    @Column(name = "create_date")
    private String createDate;

    @Column(name = "member_id", nullable = false)
    private Long memberId;

    public Ocr(Long memberId, String content, String createDate) {
        this.memberId = memberId;
        this.content = content;
        this.createDate = createDate;
    }
}
