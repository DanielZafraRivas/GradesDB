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
-- Con READ COMMITED
-- =====================================================================================================

CALL p_populate();
-- Ejecucion 1
 
UPDATE grades 
SET grade_value = grade_value + 1 WHERE grade_id = 3;
-- Ejecucion 4