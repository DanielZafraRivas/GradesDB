USE grados;

-- ===========================================================================================================================
-- 1) Trigger RN08: Edad mínima para selectividad (debe tener al menos 16 años)
-- ===========================================================================================================================

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


-- =============================================================================================================================
-- 2) Trigger RN02: Un alumno solo puede tener notas en los grupos a los que pertenece (en los que está matriculado)
-- =============================================================================================================================
DELIMITER //
CREATE OR REPLACE TRIGGER t_biu_grades_rn02
BEFORE INSERT OR UPDATE ON grades
FOR EACH ROW
BEGIN 
	DECLARE v_count INT;
	-- Para comprobar si el alumno está en el grupo de la nota
	SELECT COUNT(*) INTO v_count
	FROM group_enrollments
	WHERE student_id = NEW.student_id AND group_id = NEW.group_id;
	
	if v_count = 0 then
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'RN02: El alumno no pertenece al grupo indicado';
	END if;
END // 




