CREATE TABLE schedule_time
(
    id         BIGINT AUTO_INCREMENT PRIMARY KEY,
    school_id  BIGINT NOT NULL,
    period INT NOT NULL,
    start_time TIME   NOT NULL,
    end_time   TIME   NOT NULL
);

CREATE TABLE grade_schedule
(
    id         BIGINT AUTO_INCREMENT PRIMARY KEY,
    school_id  BIGINT      NOT NULL,
    grade      INT         NOT NULL,
    day        VARCHAR(10) NOT NULL,
    end_period INT         NOT NULL,
    UNIQUE KEY unique_grade_day (school_id, grade, day)
);

CREATE TABLE class_schedule
(
    id           BIGINT AUTO_INCREMENT PRIMARY KEY,
    classroom_id BIGINT       NOT NULL,
    day          VARCHAR(10)  NOT NULL,
    period INT NOT NULL,
    subject      VARCHAR(255) NOT NULL,
    UNIQUE KEY unique_class_day_period (classroom_id, day, period)
);
