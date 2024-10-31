CREATE TABLE counsel_available_time (
    counsel_available_time_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    teacher_id BIGINT NOT NULL,
    counsel_available_date DATE NOT NULL,
    counsel_available_time TIME NOT NULL,
    closed BOOLEAN NOT NULL,
    FOREIGN KEY (teacher_id) REFERENCES member(id)
);

CREATE TABLE counsel (
    counsel_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    parent_id BIGINT,
    teacher_id BIGINT,
    available_time_id BIGINT,
    FOREIGN KEY (available_time_id) REFERENCES counsel_available_time(counsel_available_time_id)
);