USE grados;

-- 1) Trigger RN08: Edad mínima para selectividad

DELIMITER //
CREATE OR REPLACE TRIGGER t_biu_students_rn08
BEFORE INSERT OR UPDATE ON students
FOR EACH ROW
BEGIN 
	DECLARE v_age TINYINT;
	IF NEW.access_method = 'Selectividad' THEN 
		SELECT age INTO v_age FROM people WHERE person_id = NEW.student_id;
		if v_age < 16 then 
			SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'RN08: No se puede acceder por Selectividad con menos de 16 años';
		END if;
	END if;
END // 