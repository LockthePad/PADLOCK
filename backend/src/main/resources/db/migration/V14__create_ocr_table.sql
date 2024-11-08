CREATE TABLE IF NOT EXISTS ocr (
                                   id BIGINT AUTO_INCREMENT PRIMARY KEY,
                                   member_id BIGINT NOT NULL,
                                   content VARCHAR(255) NOT NULL,
    create_date VARCHAR(255)
    );
