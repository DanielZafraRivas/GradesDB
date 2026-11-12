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
	

-- =============================================================================================================================
-- 4) Trigger RN05: Una nota no puede modificarse en más de 4 puntos (solo cuando al insertar no haya valor anterior)
-- =============================================================================================================================
DELIMITER //
CREATE OR REPLACE TRIGGER t_bu_grades_rn05
BEFORE UPDATE ON grades   -- Notemos que es solo BEFORE UPDATE (no aplica a INSERT)
FOR EACH ROW 
BEGIN 
	-- ABS (valor absoluto) para contar igual una subida que una bajada de nota
	IF ABS(NEW.grade_value - OLD.grade_value) > 4 then
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'RN05: No se puede modificar la nota en más de 4 puntos';
	END IF;
END // 


-- =============================================================================================================================
-- 5) Trigger RN03: Un grupo no puede tener más de 2 profesores asignados
-- =============================================================================================================================
DELIMITER //
CREATE OR REPLACE TRIGGER t_biu_teaching_loads_rn03
BEFORE INSERT OR UPDATE ON teaching_loads
FOR EACH ROW
BEGIN
	DECLARE v_count INT;
	
	IF NOT (NEW.group_id <=> OLD.group_id) THEN
		SELECT COUNT(*) INTO v_count
		FROM teaching_loads
		WHERE group_id = NEW.group_id;
		
		IF v_count >= 2 THEN
			SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'RN03: El grupo ya tiene 2 profesores asignados';
		END IF;
	END IF;
END // 


-- =============================================================================================================================
-- 6) Trigger RN04: Un alumno solo debe estar en 1 grupo de teoria y 1 de laboratorio por asignatura
-- 7) Trigger RN07: Un alumno debe estar matriculado en la asignatura antes de unirse a un grupo
-- =============================================================================================================================
DELIMITER //
CREATE OR REPLACE TRIGGER t_biu_students_groups_rn04_rn07
BEFORE INSERT OR UPDATE ON group_enrollments
FOR EACH ROW
BEGIN 
	DECLARE v_subject_id INT;
	DECLARE v_activity VARCHAR(15);
	DECLARE v_old_subject_id INT;
	DECLARE v_old_activity VARCHAR(15);
	
	-- Asignatura y actividad del grupo nuevo (NEW)
	SELECT subject_id, activity INTO v_subject_id, v_activity
	FROM groups 
	WHERE group_id = NEW.group_id;
	
	-- Asignatura y actividad del grupo anterior (OLD)
	-- CUIDADO: en INSERT, OLD.group_id vale NULL y quedan a NULL, por eso se hace con SET
	SET v_old_subject_id = (SELECT subject_id FROM groups WHERE group_id = OLD.group_id);
	SET v_old_activity = (SELECT activity FROM groups WHERE group_id = OLD.group_id);
	
	if NOT f_is_student_enrolled(NEW.student_id, v_subject_id) then 
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'RN07: El alumno debe estar matriculado en la asignatura';
	END if;
	
	-- RN04 solo se comprueba si el alumno entra en un grupo de otra asignatura o actividad (cambiar de L1 a L2 de la misma asignatura está permitido)
	-- CUIDADO: En INSERT, OLD y las variables v_old_* valen NULL: se comprueba siempre
	if NOT (NEW.student_id <=> OLD.student_id AND v_subject_id <=> v_old_subject_id AND v_activity <=> v_old_activity)
		AND f_student_group_limit(NEW.student_id, v_subject_id, v_activity) then 
			if v_activity = 'Teoría' then
				SIGNAL SQLSTATE '45000'
					SET MESSAGE_TEXT = 'RN04: Solo puede haber un grupo de teoría por asignatura y alumno';
			ELSE 
				SIGNAL SQLSTATE '45000'
					SET MESSAGE_TEXT = 'RN04: Solo puede haber un grupo de laboratorio por asignatura y alumno';
			END if;
	END if;
END //