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