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


-- =============================================================================================================================
-- 3) Trigger RN17: Un alumno solo puede tener una nota por asignatura, convocatoria y año
-- =============================================================================================================================
DELIMITER //
CREATE OR REPLACE TRIGGER t_biu_grades_rn17
BEFORE INSERT OR UPDATE ON grades
FOR EACH ROW
BEGIN 
	DECLARE v_subject_id INT;
	DECLARE v_academic_year YEAR;
	DECLARE v_exists INT;
	
	-- Asignatura y año académico del grupo de la nota
	SELECT subject_id, academic_year INTO v_subject_id, v_academic_year
	FROM groups
	WHERE group_id = NEW.group_id;
	
	-- Otras notas del alumno en esa asignatura, convocatoria y año, en cualquier grupo
	SELECT COUNT(*) INTO v_exists
	FROM grades g
	JOIN groups gr ON gr.group_id = g.group_id
	WHERE g.student_id = NEW.student_id AND g.exam_call = NEW.exam_call AND gr.subject_id = v_subject_id AND gr.academic_year = v_academic_year
	-- para excluir la propia fila al actualizar (en INSERT, NEW.grade_id vale 0)
		AND g.grade_id <> NEW.grade_id;
	
	IF v_exists > 0 THEN
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'RN17: Ya existe una nota para la misma asignatura, convocatoria y año académico';
	END IF;
END // 
	




