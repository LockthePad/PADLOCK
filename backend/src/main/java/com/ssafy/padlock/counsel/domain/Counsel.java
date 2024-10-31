package com.ssafy.padlock.counsel.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Getter
@NoArgsConstructor
@Table(name = "counsel")
public class Counsel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "counsel_id")
    private Long id;

    @Column(name = "parent_id", nullable = false)
    private Long parentId;

    @Column(name = "teacher_id", nullable = false)
    private Long teacherId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "available_time_id", referencedColumnName = "counsel_available_time_id")
    private CounselAvailableTime counselAvailableTime;

    public Counsel(Long parentId, Long teacherId, CounselAvailableTime counselAvailableTime) {
        this.parentId = parentId;
        this.teacherId = teacherId;
        this.counselAvailableTime = counselAvailableTime;
    }
}
