USE grados_db;

-- Sesión A: 
-- =====================================================================================================
-- Con REPEATABLE READ 
-- =====================================================================================================
SELECT @@transaction_isolation;

CALL p_populate(); 

UPDATE grades
SET grade_value = grade_value + 1 WHERE grade_id = 3;