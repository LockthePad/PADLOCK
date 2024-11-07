CREATE TABLE attendance
(
    id                 BIGINT      NOT NULL AUTO_INCREMENT PRIMARY KEY,
    member_id          BIGINT      NOT NULL,
    attendance_date    DATE        NOT NULL,
    status             VARCHAR(20) NOT NULL,
    last_communication DATETIME,
    is_away            TINYINT(1) DEFAULT 0
);

