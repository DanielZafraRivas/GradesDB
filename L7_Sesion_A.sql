USE grados_db;

-- Sesión A: 
-- =====================================================================================================
-- Con REPEATABLE READ 
-- =====================================================================================================
SELECT @@transaction_isolation;

CALL p_populate(); 
-- ejecucion 1

UPDATE grades
SET grade_value = grade_value + 1 WHERE grade_id = 3;
-- Ejecucion 4


-- =====================================================================================================
-- Con READ COMMITTED
-- =====================================================================================================

CALL p_populate();
-- Ejecucion 1
 
UPDATE grades 
SET grade_value = grade_value + 1 WHERE grade_id = 3;
-- Ejecucion 4


-- =====================================================================================================
-- EJERCICIO PROPUESTO 3:
-- =====================================================================================================
-- Con REPEATABLE READ: 

CALL p_populate(); 
-- Ejecucion 0

START TRANSACTION;
UPDATE grades SET grade_value = 9 WHERE grade_id = 1; -- (era 9.8)
-- Ejecucion 2

COMMIT;
-- Ejecucion 4

-- Reutilizo el código de arriba para el READ COMMITTED