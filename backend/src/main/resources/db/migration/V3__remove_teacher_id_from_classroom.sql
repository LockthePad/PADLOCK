ALTER TABLE classroom
    DROP FOREIGN KEY fk_classroom_teacher;

ALTER TABLE classroom
    DROP COLUMN teacher_id;