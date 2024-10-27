CREATE TABLE school
(
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    school_name VARCHAR(255) NOT NULL,
    region_code VARCHAR(50)  NOT NULL
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4;

CREATE TABLE member
(
    id           BIGINT AUTO_INCREMENT PRIMARY KEY,
    role         VARCHAR(255) NOT NULL,
    member_code  VARCHAR(255) NOT NULL UNIQUE,
    password     VARCHAR(255) NOT NULL,
    name         VARCHAR(255),
    parent_id    BIGINT,
    classroom_id BIGINT
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4;

CREATE TABLE classroom
(
    id            BIGINT AUTO_INCREMENT PRIMARY KEY,
    school_id     BIGINT NOT NULL,
    grade         INT    NOT NULL,
    class_number  INT    NOT NULL,
    student_count INT,
    teacher_id    BIGINT
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4;

ALTER TABLE classroom
    ADD CONSTRAINT fk_classroom_school FOREIGN KEY (school_id) REFERENCES school (id) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT fk_classroom_teacher FOREIGN KEY (teacher_id) REFERENCES member (id) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE member
    ADD CONSTRAINT fk_member_parent FOREIGN KEY (parent_id) REFERENCES member (id) ON DELETE SET NULL ON UPDATE CASCADE,
    ADD CONSTRAINT fk_member_classroom FOREIGN KEY (classroom_id) REFERENCES classroom (id) ON DELETE SET NULL ON UPDATE CASCADE;
