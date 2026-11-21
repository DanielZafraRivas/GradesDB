USE grados_db;

-- Sesión B:
-- =====================================================================================================
-- Con REPEATABLE READ 
-- =====================================================================================================
SELECT @@transaction_isolation;

SET SESSION TRANSACTION 
ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;

SELECT grade_value FROM grades WHERE grade_id = 3; -- 5.4

SELECT grade_value FROM grades WHERE grade_id = 3; -- 5.4

COMMIT;
SELECT grade_value FROM grades WHERE grade_id = 3; -- 6.4