CREATE TABLE notice
(
    id           BIGINT AUTO_INCREMENT PRIMARY KEY,
    title        VARCHAR(255) NOT NULL,
    content      TEXT         NOT NULL,
    classroom_id BIGINT       NOT NULL,
    created_at   TIMESTAMP    NOT NULL,
    CONSTRAINT fk_notice_classroom FOREIGN KEY (classroom_id) REFERENCES classroom (id) ON DELETE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4;
