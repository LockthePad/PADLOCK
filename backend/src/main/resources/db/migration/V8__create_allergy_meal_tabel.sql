CREATE TABLE IF NOT EXISTS meal (
    meal_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    calorie VARCHAR(255) NOT NULL,
    meal_date DATE NOT NULL,
    menu VARCHAR(255) NOT NULL,
    allergy_code VARCHAR(255) NOT NULL,
    school_id BIGINT NOT NULL,
    FOREIGN KEY (school_id) REFERENCES school(id)
);

CREATE TABLE IF NOT EXISTS allergy (
    allergy_id INT PRIMARY KEY,
    food_name VARCHAR(255)
);

UPDATE padlock.school t SET t.school_name = '서울역삼초등학교' WHERE t.id = 1