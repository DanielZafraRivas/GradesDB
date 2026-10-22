USE Grados;

-- Ejemplo 1: Procedimiento para borrar notas de un alumno (RF02) =============================================================================================================

DELIMITER // 
CREATE OR REPLACE PROCEDURE p_delete_student_grades( IN p_student_dni CHAR(9))
BEGIN 
	DECLARE v_student_id INT;
	
	-- El DNI está en people y el id_alumno es id_persona (herencia)
	SELECT student_id INTO v_student_id
	FROM people p
	JOIN students s ON s.student_id = p.person_id
	WHERE p.dni = p_student_dni;
	
	DELETE FROM grades WHERE student_id = v_student_id;

END //
DELIMITER ;

-- Borrar las notas del estudiante con DNI '10000006F'
CALL p_delete_student_grades('10000006F');

-- Verificar que se han borrado
SELECT * FROM grades g
JOIN students s ON s.student_id = g.student_id
JOIN people p ON p.person_id = s.student_id
WHERE p.dni = '10000006F';




