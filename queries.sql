-- 
-- Autor: [Daniel Zafra Rivas]
-- Fecha: 15/10/2026
-- Descripción: Consultas SQL de ejemplo para GradesDB
--              Cubre conceptos de consultas simples y avanzadas
-- 

USE Grados;

-- Consulta 1: Todas las asignaturas ================================================================================================0
-- Recupera todos los campos de todas las asignaturas en la base de datos.
SELECT * 
FROM subjects;

-- Consulta 2: Asignatura con acrónimo específico ==========================================
-- Busca la asignatura con acrónimo ‘IISSI-1’.
SELECT *
FROM subjects s
WHERE s.acronym = 'IISSI-1';


SELECT s.subject_name, s.acronym
FROM subjects s;


SELECT s.subject_name, s.acronym, s.subject_type
FROM subjects s
WHERE s.subject_type = 'Formación Básica';


SELECT p.first_name, p.last_name, st.access_method
FROM students st
JOIN people p ON st.student_id = p.person_id
WHERE st.access_method = 'Selectividad';


SELECT p.first_name, p.last_name, pr.category
FROM professors pr
JOIN people p ON pr.professor_id = p.person_id
WHERE pr.category = 'Catedrático';


CREATE OR REPLACE VIEW v_professors AS
SELECT
	pr.category,
	pr.professor_id,
	p.person_id,
	p.dni,
	p.first_name,
	p.last_name,
	p.age,
	p.email
FROM professors pr
JOIN people p ON pr.professor_id = person_id;


CREATE OR REPLACE VIEW v_students AS
SELECT
	st.student_id,
	st.access_method,
	p.person_id,
	p.dni,
	p.first_name,
	p.last_name,
	p.age,
	p.email
FROM students st
JOIN people p ON st.student_id = p.person_id;


SELECT AVG(g.grade_value) AS average_grade
FROM grades g
WHERE g.group_id = 1;


SELECT SUM(s.credits) AS total_credits
FROM subjects s
WHERE degree_id = 3;


SELECT COUNT(*) AS total_students
FROM students;


SELECT activity, COUNT(*) AS total_groups
FROM groups
GROUP BY activity;


SELECT MAX(g.grade_value) AS max_grade
FROM grades g;


SELECT MIN(g.grade_value) AS min_grade
FROM grades g;


SELECT g.grade_id, g.grade_value, g.exam_call
FROM grades g
WHERE g.grade_value < 5 OR g.grade_value > 9;


SELECT g.grade_id, g.grade_value, g.exam_call
FROM grades g
WHERE g.grade_value BETWEEN 5 AND 7;


SELECT s.subject_name, s.credits
FROM subjects s
WHERE s.credits IN (6, 12);


SELECT p.first_name, p.last_name, p.age
FROM people p
WHERE p.age BETWEEN 20 AND 30;


SELECT DISTINCT g.group_name
FROM groups g;


SELECT DISTINCT s.subject_type
FROM subjects s;


SELECT DISTINCT g.academic_year
FROM groups g
ORDER BY g.academic_year DESC; 


-- SUBCONSULTAS ============================================================================================

SELECT MAX(g.grade_value) AS max_grade
FROM grades g
WHERE g.student_id = 6;


SELECT DISTINCT ge.student_id
FROM group_enrollments ge
WHERE ge.group_id IN (
	SELECT g.group_id
	FROM groups g
	WHERE g.academic_year = 2024
);


SELECT s.subject_name, s.credits
FROM subjects s
WHERE s.credits > (SELECT AVG(credits) FROM subjects);


-- Patrones con LIKE ============================================================================================

SELECT p.first_name, p.last_name, p.dni
FROM people p
WHERE p.dni LIKE '%A';


SELECT s.subject_name
FROM subjects s
WHERE s.subject_name LIKE 'Fundamentos%';


SELECT p.first_name, p.last_name
FROM people p
WHERE p.first_name LIKE '_____';

