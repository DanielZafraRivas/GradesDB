USE grados_db;

-- Sesión B:
-- =====================================================================================================
-- Con REPEATABLE READ 
-- =====================================================================================================
SELECT @@transaction_isolation;

SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;
-- Ejecucion 2

SELECT grade_value FROM grades WHERE grade_id = 3; -- 5.4
-- Ejecucion 3

SELECT grade_value FROM grades WHERE grade_id = 3; -- 5.4
-- Ejecucion 5

COMMIT;
SELECT grade_value FROM grades WHERE grade_id = 3; -- 6.4
-- Ejecución 6

-- EXPLICACIÓN 
-- Podemos ver que dentro de la transacción, B lee los datos como estaban en su primera lectura, no ve la subida, aunque en A la hayamos confirmado. Al cerrar su transacción (COMMIT) si la ve.


-- =====================================================================================================
-- Con READ COMMITED 
-- =====================================================================================================

-- Cambiamos el aislamiento en esta sesión
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;

SELECT @@transaction_isolation;
-- Ejecución 2

SELECT grade_value FROM grades WHERE grade_id = 3; -- 5.4
-- Ejecucion 3

SELECT grade_value FROM grades WHERE grade_id = 3; -- 6.4
-- Ejecucion 5

COMMIT;
SELECT grade_value FROM grades WHERE grade_id = 3; -- 6.4
-- Ejecucion 6

-- EXPLICACIÓN 
-- Vemos que dentro de la misma transacción, la consulta de B ve dos valores distintos (5.4 y la actualizacion a 6.4) lo cual se evita con REPEATABLE READ 

-- =====================================================================================================
-- EJERCICIO PROPUESTO 3:
-- =====================================================================================================
-- Con REPEATABLE READ: 
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

START TRANSACTION;
-- Ejecucion 1

SELECT grade_value FROM grades WHERE grade_id = 1; -- 9.8  (todavia ni siquiera se ha confirmado la transacción en A)
-- Ejecucion 3

SELECT grade_value FROM grades WHERE grade_id = 1; -- 9.8 (aunque se haya confirmado la transacción en A, como estamos usando repeatable read y aun no hemos hecho commit en B, veremos el mismo valor)
-- Ejecucion 5

COMMIT;
SELECT grade_value FROM grades WHERE grade_id = 1; -- 9 (ya si lo hemos confirmado tanto en A como en B)