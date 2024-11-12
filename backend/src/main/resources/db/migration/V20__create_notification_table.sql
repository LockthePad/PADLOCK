CREATE TABLE notification
(
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    receiver_id BIGINT,
    type        VARCHAR(255) NOT NULL,
    timestamp   TIMESTAMP    NOT NULL
) ENGINE = InnoDB;

CREATE TABLE notification_read_status
(
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    notification_id BIGINT NOT NULL,
    member_id       BIGINT NOT NULL
) ENGINE = InnoDB;
