CREATE TABLE IF NOT EXISTS location (
                                        location_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                                        member_id BIGINT NOT NULL,
                                        latitude DOUBLE NOT NULL,
                                        longitude DOUBLE NOT NULL,
                                        recorded_at DATETIME NOT NULL
);