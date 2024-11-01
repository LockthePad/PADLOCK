CREATE TABLE suggestion
(
    id           BIGINT AUTO_INCREMENT PRIMARY KEY,
    content      TEXT NOT NULL,
    student_id   BIGINT       NOT NULL,
    classroom_id BIGINT       NOT NULL,
    time         DATETIME     NOT NULL,
    is_read         BOOLEAN      NOT NULL DEFAULT FALSE,
    CONSTRAINT fk_student FOREIGN KEY (student_id) REFERENCES member (id),
    CONSTRAINT fk_classroom FOREIGN KEY (classroom_id) REFERENCES classroom (id)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4;
