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