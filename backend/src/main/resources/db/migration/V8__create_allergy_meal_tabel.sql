CREATE TABLE IF NOT EXISTS meal (
    meal_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    calorie VARCHAR(255) NOT NULL,
    meal_date VARCHAR(255) NOT NULL,
    menu TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    allergy_code VARCHAR(255) NOT NULL,
    school_id BIGINT NOT NULL,
    FOREIGN KEY (school_id) REFERENCES school(id)
    ) CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS allergy (
    allergy_id INT PRIMARY KEY,
    food_name VARCHAR(255)
    )CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

UPDATE padlock.school t SET t.school_name = '서울역삼초등학교' WHERE t.id = 1
