CREATE TABLE scheduled_task
(
    id             BIGINT AUTO_INCREMENT PRIMARY KEY,
    member_id      BIGINT    NOT NULL,
    scheduled_time TIMESTAMP NOT NULL,
    executed       TINYINT(1) NOT NULL DEFAULT 0
);
