ALTER TABLE app
    ADD CONSTRAINT unique_classroom_app UNIQUE (classroom_id, app_name);

ALTER TABLE app CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
