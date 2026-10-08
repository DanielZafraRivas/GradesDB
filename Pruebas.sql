USE grados;

-- Prueba 1: Edad fuera de rango ==========================================
INSERT INTO people (dni, first_name, last_name, age, email) VALUES
	 ('99999999Z', 'Juan', 'Test', 15, 'juan@test.es');
		('88888888A', 'Ana', 'Test', 25, 'ana@test.es'),
		('88888888A', 'Pedro', 'Test', 30, 'pedro@test.es');
		
		
-- Prueba 2: DNI duplicado ================================================
-- Primero inserta una persona válida:
INSERT INTO people (dni, first_name, last_name, age, email) VALUES 
	 ('88888888A', 'Ana', 'Test', 25, 'ana@test.es');

-- Ahora intenta insertar otra con el mismo DNI:
INSERT INTO people (dni, first_name, last_name, age, email) VALUES
	 ('88888888A', 'Pedro', 'Test', 30, 'pedro@test.es');


-- Prueba 3: Profesor de categoría no válida ===============================
-- Primero necesitamos una persona en la tabla people
INSERT INTO people (person_id, dni, first_name, last_name, age, email)
VALUES (1000, '11111111A', 'Carlos', 'Profesor', 45, 'carlos@us.es');

-- Ahora intentamos crear el profesor con categoría inválida
INSERT INTO professors (professor_id, category)
VALUES (1000, 'Adjunto');


-- Prueba a insertar un estudiante con método de acceso no válido =========
-- Primero necesitamos una persona
INSERT INTO people (person_id, dni, first_name, last_name, age, email)
VALUES (2000, '22222222B', 'María', 'Estudiante', 20, 'maria@us.es');

-- Intentamos crear estudiante con método inválido
INSERT INTO students (student_id, access_method)
VALUES (2000, 'Erasmus');