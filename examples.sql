DROP DATABASE deanery;
CREATE DATABASE deanery;

DROP TABLE marks;
DROP TABLE subjects;
DROP TABLE teachers;
DROP TABLE students;
DROP TABLE groups;

CREATE TABLE IF NOT EXISTS groups (
	group_id int PRIMARY KEY,
	group_name varchar(100)
);

CREATE TABLE IF NOT EXISTS students (
	student_id int PRIMARY KEY,
	student_name varchar(100),
	phone_number varchar(14),
	group_id int REFERENCES groups (group_id)
);

CREATE TABLE IF NOT EXISTS teachers (
	teacher_id int PRIMARY KEY,
	teacher_name varchar(50)
);

CREATE TABLE IF NOT EXISTS subjects (
	subject_id int PRIMARY KEY,
	subject_name varchar(50),
	teacher_id int REFERENCES teachers (teacher_id)
);

CREATE TABLE IF NOT EXISTS marks (
	mark_value int,
	mark_date date,
	subject_id int not null REFERENCES subjects (subject_id),
	student_id int not null REFERENCES students (student_id),
	PRIMARY KEY (subject_id, student_id)
);

INSERT INTO groups (group_id, group_name)
	VALUES (1, 'M3439'),
		   (2, 'M3339'),
		   (3, 'M3239'),
		   (4, 'M3139'),
		   (5, 'M3438');

INSERT INTO students (student_id, student_name, phone_number, group_id) 
	VALUES (1, 'Ivan Belonogov', '79112249311', 1),
		   (2, 'Evgeny Nemchenko', '79522876791', 5), 
		   (3, 'Michail Putilin', '71234567890', 4), 
		   (4, 'Appolinaria Romanova', '7995213139', 3), 
		   (5, 'Anna Rodionova', '77777777777', 2),
		   (6, 'Vyacheslav Moklev', '88888888888', 1);

INSERT INTO teachers (teacher_id, teacher_name)
	VALUES (1, 'Georgiy Korneev'),
		   (2, 'Andrew Stankevich'),
		   (3, 'Oksana Pavlova');

		   
INSERT INTO subjects (subject_id, subject_name, teacher_id)
	VALUES (1, 'Java', 1),
		   (2, 'Algorithm and Data Structures', 2),
		   (3, 'English', 3),
		   (4, 'Databases', 1),
		   (5, 'DMath', 2);		   		   

INSERT INTO marks (mark_value, mark_date, subject_id, student_id)
	VALUES (100, '31-01-15', 2, 1),
		   (100, '31-01-15', 2, 2),
		   (100, '31-01-15', 2, 3),
		   (100, '31-01-15', 2, 4),
		   (100, '31-01-15', 2, 5);

select * from groups;
select * from students;
select * from teachers;		   
select * from subjects;
select * from marks;

SELECT students.student_name
	, groups.group_name 
FROM students 
INNER JOIN groups 
	ON students.group_id = groups.group_id;
SELECT students.student_name
	, marks.mark_value
	, subjects.subject_name 
FROM students 
INNER JOIN marks 
	ON students.student_id = marks.student_id
INNER JOIN subjects
	ON marks.subject_id = subjects.subject_id;

DROP DATABASE students;
CREATE DATABASE students;

DROP TABLE marks;
DROP TABLE lecturer;
DROP TABLE courses;
DROP TABLE lecturers;
DROP TABLE students;
DROP TABLE groups;

CREATE TABLE IF NOT EXISTS groups (
	group_id int PRIMARY KEY,
	group_name varchar(100)
);

CREATE TABLE IF NOT EXISTS students (
	student_id int PRIMARY KEY,
	student_name varchar(100),
	group_id int REFERENCES groups (group_id)
);

CREATE TABLE IF NOT EXISTS lecturers (
	lecturer_id int PRIMARY KEY,
	lecturer_name varchar(50)
);


CREATE TABLE IF NOT EXISTS courses (
	course_id int PRIMARY KEY,
	course_name varchar(50)
);

CREATE TABLE IF NOT EXISTS marks (
	mark_value int,
	course_id int not null REFERENCES courses (course_id),
	student_id int not null REFERENCES students (student_id),
	PRIMARY KEY (course_id, student_id)
);

CREATE TABLE IF NOT EXISTS lecturer (
	lecturer_id int,
	course_id int not null REFERENCES courses (course_id),
	group_id int not null REFERENCES groups (group_id),
	PRIMARY KEY (course_id, group_id)
);


INSERT INTO groups (group_id, group_name)
	VALUES (1, 'M3439'),
		   (2, 'M3339'),
		   (3, 'M3239'),
		   (4, 'M3139'),
		   (5, 'M3438');

INSERT INTO students (student_id, student_name, group_id) 
	VALUES (1, 'Ivan Belonogov', 1),
		   (2, 'Evgeny Nemchenko', 5), 
		   (3, 'Michail Putilin', 4), 
		   (4, 'Appolinaria Romanova', 3), 
		   (5, 'Anna Rodionova', 2),
		   (6, 'Vyacheslav Moklev', 1);

INSERT INTO lecturers (lecturer_id, lecturer_name)
	VALUES (1, 'Georgiy Korneev'),
		   (2, 'Andrew Stankevich'),
		   (3, 'Oksana Pavlova');

		   
INSERT INTO courses (course_id, course_name)
	VALUES (1, 'Java'),
		   (2, 'Algorithm and Data Structures'),
		   (3, 'English'),
		   (4, 'Databases'),
		   (5, 'DMath');		   		   

INSERT INTO marks (mark_value, course_id, student_id)
	VALUES (100, 2, 1),
		   (100, 2, 2),
		   (100, 2, 3),
		   (100, 2, 4),
		   (100, 2, 5);

INSERT INTO lecturer (lecturer_id, course_id, group_id)
	VALUES (1, 1, 1),
		   (1, 4, 2),
		   (2, 2, 3),
		   (2, 5, 4),
		   (3, 3, 5);

select * from groups;
select * from students;
select * from lecturers;		   
select * from courses;
select * from marks;

SELECT students.student_name
	, groups.group_name 
FROM students 
INNER JOIN groups 
	ON students.group_id = groups.group_id;
SELECT students.student_name
	, marks.mark_value
	, courses.course_name 
FROM students 
INNER JOIN marks 
	ON students.student_id = marks.student_id
INNER JOIN courses
	ON marks.course_id = courses.course_id;

DROP DATABASE deanery5;
CREATE DATABASE deanery5;

DROP TABLE academicplan CASCADE;
DROP TABLE marks CASCADE;
DROP TABLE lecturers CASCADE;
DROP TABLE courses CASCADE;
DROP TABLE students CASCADE;
DROP TABLE groups CASCADE;

CREATE TABLE IF NOT EXISTS groups (
	group_id int PRIMARY KEY,
	group_name varchar(100)
);

CREATE TABLE IF NOT EXISTS students (
	student_id int PRIMARY KEY,
	student_name varchar(100),
	group_id int REFERENCES groups (group_id)
);

CREATE TABLE IF NOT EXISTS lecturers (
	lecturer_id int PRIMARY KEY,
	lecturer_name varchar(50)
);


CREATE TABLE IF NOT EXISTS courses (
	course_id int PRIMARY KEY,
	course_name varchar(50)
);

CREATE TABLE IF NOT EXISTS marks (
	mark_value int,
	course_id int not null REFERENCES courses (course_id),
	student_id int not null REFERENCES students (student_id),
	CHECK (mark_value BETWEEN 0 AND 100),
	PRIMARY KEY (course_id, student_id)
);

CREATE TABLE IF NOT EXISTS academicplan (
	lecturer_id int not null REFERENCES lecturers (lecturer_id),
	course_id int not null REFERENCES courses (course_id),
	group_id int not null REFERENCES groups (group_id),
	PRIMARY KEY (lecturer_id, course_id, group_id)
);


INSERT INTO groups (group_id, group_name)
	VALUES (1, 'M3439'),
		   (2, 'M3339'),
		   (3, 'M3239'),
		   (4, 'M3139'),
		   (5, 'M3438');

INSERT INTO students (student_id, student_name, group_id) 
	VALUES (1, 'Ivan Belonogov', 1),
		   (2, 'Evgeny Nemchenko', 5), 
		   (3, 'Michail Putilin', 1), 
		   (4, 'Appolinaria Romanova', 3), 
		   (5, 'Anna Rodionova', 2),
		   (6, 'Vyacheslav Moklev', 1),
		   (7, 'Daniil Prokopenko', 5);

INSERT INTO lecturers (lecturer_id, lecturer_name)
	VALUES (1, 'Georgiy Korneev'),
		   (2, 'Andrew Stankevich'),
		   (3, 'Oksana Pavlova');

		   
INSERT INTO courses (course_id, course_name)
	VALUES (1, 'Java'),
		   (2, 'Algorithm and Data Structures'),
		   (3, 'English'),
		   (4, 'Databases'),
		   (5, 'DMath');		   		   

INSERT INTO marks (mark_value, course_id, student_id)
	VALUES (100, 4, 1),
		   (100, 2, 1),
		   (99, 2, 3),
		   (40, 4, 3),		   
		   (92, 1, 6),
		   (98, 4, 6),
		   (100, 2, 2),
		   (100, 4, 4),
		   (88, 1, 4),
		   (100, 2, 5);

INSERT INTO academicplan (lecturer_id, course_id, group_id)
	VALUES (1, 1, 1),
		   (2, 2, 1),
		   (1, 4, 1),
		   (1, 4, 2),
		   (2, 2, 3),
		   (2, 5, 4),
		   (1, 1, 3),
		   (1, 4, 3),
		   (3, 2, 2),
		   (3, 3, 5),
		   (2, 2, 5);

SELECT * 
FROM students;

-- 1		   
SELECT students.student_name
	, marks.mark_value
FROM students 
NATURAL JOIN courses
NATURAL JOIN marks 
WHERE courses.course_name = 'Databases';

-- 2a
SELECT students.student_name
FROM students 
EXCEPT
SELECT students.student_name
FROM students 
NATURAL JOIN courses
NATURAL JOIN marks 
WHERE courses.course_name = 'Databases';

-- 2b Информацию о студентах не имеющих оценки по предмету «Базы данных» 
--    среди студентов, у которых есть этот предмет
SELECT students.student_name
FROM students 
NATURAL JOIN academicplan
NATURAL JOIN courses
WHERE courses.course_name = 'Databases'
EXCEPT
SELECT students.student_name
FROM students 
NATURAL JOIN marks 
NATURAL JOIN courses
WHERE courses.course_name = 'Databases';

-- 3 Информацию о студентах, имеющих хотя бы одну оценку у заданного лектора 
SELECT DISTINCT students.student_name
FROM students 
NATURAL JOIN academicplan
NATURAL JOIN courses
NATURAL JOIN lecturers
INNER JOIN marks
	ON students.student_id = marks.student_id AND courses.course_id = marks.course_id
WHERE lecturers.lecturer_name = 'Georgiy Korneev';

-- 4 Идентификаторы студентов, не имеющих ни одной оценки у заданного лектора
SELECT students.student_name
FROM students 
EXCEPT
SELECT DISTINCT students.student_name
FROM students 
NATURAL JOIN academicplan
NATURAL JOIN courses
NATURAL JOIN lecturers
INNER JOIN marks
	ON students.student_id = marks.student_id AND courses.course_id = marks.course_id
WHERE lecturers.lecturer_name = 'Georgiy Korneev';

-- 5 ?? деление, умею только count
-- Студентов, имеющих оценки по всем предметам заданного лектора

SELECT students.student_name
FROM students 
NATURAL JOIN academicplan
NATURAL JOIN courses
NATURAL JOIN lecturers
INNER JOIN marks
	ON students.student_id = marks.student_id AND courses.course_id = marks.course_id
WHERE lecturers.lecturer_name = 'Georgiy Korneev' 
GROUP BY students.student_id
HAVING COUNT(lecturers.lecturer_name) = (
		SELECT COUNT(DISTINCT academicplan.course_id)
		FROM academicplan
		INNER JOIN lecturers
			ON academicplan.lecturer_id = lecturers.lecturer_id
		WHERE lecturers.lecturer_name = 'Georgiy Korneev'
	)
;


-- 6 Для каждого студента имя и предметы, которые он должен посещать 
SELECT students.student_name
	, courses.course_name
FROM students 
NATURAL JOIN academicplan
NATURAL JOIN courses
ORDER BY students.student_name;

-- 7 По лектору всех студентов, у которых он хоть что-нибудь преподавал 
SELECT DISTINCT students.student_name
FROM students 
NATURAL JOIN academicplan
NATURAL JOIN lecturers
WHERE lecturers.lecturer_name = 'Georgiy Korneev';

-- 8  ??

-- 9 ??
                             
-- 10a Средний балл студента по идентификатору

-- всех студентов
SELECT students.student_id
	, AVG(marks.mark_value) 
FROM students 
LEFT JOIN marks
	ON students.student_id = marks.student_id
GROUP BY students.student_id
ORDER BY students.student_id;

-- конкретного
SELECT AVG(marks.mark_value) 
FROM students
NATURAL JOIN marks
WHERE students.student_id = 3;


-- 10b Средний балл студента для каждого студента

SELECT students.student_name
	, AVG(marks.mark_value) 
FROM students 
LEFT JOIN marks
	ON students.student_id = marks.student_id
GROUP BY students.student_id
ORDER BY students.student_name;

-- 11 Средний балл средних баллов студентов каждой группы 

SELECT groups.group_name
	, AVG(marks.mark_value) 
FROM groups
NATURAL JOIN students
NATURAL JOIN marks
GROUP BY groups.group_id
ORDER BY groups.group_name;



-- 12   ????

SELECT students.student_name
	, COUNT(courses.course_id) AS Total
	, passed  AS Passed-- 
	, total - passed AS Failed
FROM students
WHERE total = 2 AND passed = 1;


DROP DATABASE deanery6;
CREATE DATABASE deanery6;

DROP TABLE academicplan CASCADE;
DROP TABLE marks CASCADE;
DROP TABLE lecturers CASCADE;
DROP TABLE courses CASCADE;
DROP TABLE students CASCADE;
DROP TABLE groups CASCADE;

CREATE TABLE IF NOT EXISTS groups (
	group_id int PRIMARY KEY,
	group_name varchar(100)
);

CREATE TABLE IF NOT EXISTS students (
	student_id int PRIMARY KEY,
	student_name varchar(100),
	group_id int REFERENCES groups (group_id)
);

CREATE TABLE IF NOT EXISTS lecturers (
	lecturer_id int PRIMARY KEY,
	lecturer_name varchar(50)
);


CREATE TABLE IF NOT EXISTS courses (
	course_id int PRIMARY KEY,
	course_name varchar(50)
);

CREATE TABLE IF NOT EXISTS marks (
	mark_value int,
	course_id int not null REFERENCES courses (course_id),
	student_id int not null REFERENCES students (student_id),
	CHECK (mark_value BETWEEN 0 AND 100),
	PRIMARY KEY (course_id, student_id)
);

CREATE TABLE IF NOT EXISTS academicplan (
	lecturer_id int not null REFERENCES lecturers (lecturer_id),
	course_id int not null REFERENCES courses (course_id),
	group_id int not null REFERENCES groups (group_id),
	PRIMARY KEY (lecturer_id, course_id, group_id)
);


INSERT INTO groups (group_id, group_name)
	VALUES (1, 'M3439'),
		   (2, 'M3339'),
		   (3, 'M3239'),
		   (4, 'M3139'),
		   (5, 'M3438');

INSERT INTO students (student_id, student_name, group_id) 
	VALUES (1, 'Ivan Belonogov', 1),
		   (2, 'Evgeny Nemchenko', 5), 
		   (3, 'Michail Putilin', 1), 
		   (4, 'Appolinaria Romanova', 3), 
		   (5, 'Anna Rodionova', 2),
		   (6, 'Vyacheslav Moklev', 1),
		   (7, 'Daniil Prokopenko', 5);

INSERT INTO lecturers (lecturer_id, lecturer_name)
	VALUES (1, 'Georgiy Korneev'),
		   (2, 'Andrew Stankevich'),
		   (3, 'Oksana Pavlova');

		   
INSERT INTO courses (course_id, course_name)
	VALUES (1, 'Java'),
		   (2, 'Algorithm and Data Structures'),
		   (3, 'English'),
		   (4, 'Databases'),
		   (5, 'DMath');		   		   

INSERT INTO marks (mark_value, course_id, student_id)
	VALUES (100, 4, 1),
		   (100, 2, 1),
		   (99, 2, 3),
		   (40, 4, 3),		   
		   (92, 1, 6),
		   (98, 4, 6),
		   (100, 2, 2),
		   (100, 4, 4),
		   (88, 1, 4),
		   (100, 2, 5);

INSERT INTO academicplan (lecturer_id, course_id, group_id)
	VALUES (1, 1, 1),
		   (2, 2, 1),
		   (1, 4, 1),
		   (1, 4, 2),
		   (2, 2, 3),
		   (2, 5, 4),
		   (1, 1, 3),
		   (1, 4, 3),
		   (3, 2, 2),
		   (3, 3, 5),
		   (2, 2, 5);

SELECT * 
FROM students;

-- 1		   

SELECT students.student_name
FROM students 
WHERE 
	EXISTS (
		SELECT * 
		FROM marks 
		WHERE (
			students.student_id = marks.student_id 
			AND marks.mark_value = 100 
			AND marks.course_id in (
				SELECT courses.course_id 
				FROM courses 
				WHERE courses.course_name = 'Databases'
			)
		)
	);


-- 2a

SELECT students.student_name
FROM students 
WHERE 
	NOT EXISTS (
		SELECT * 
		FROM marks 
		WHERE (
			students.student_id = marks.student_id 
			AND marks.course_id in (
				SELECT courses.course_id 
				FROM courses 
				WHERE courses.course_name = 'Databases'
			)
		)
	);

-- 2b Информацию о студентах не имеющих оценки по предмету «Базы данных» 
--    среди студентов, у которых есть этот предмет

SELECT students.student_name
FROM students 
WHERE 
	students.group_id IN (
		SELECT academicplan.group_id
		FROM academicplan
		WHERE students.group_id = academicplan.group_id AND academicplan.course_id in (
				SELECT courses.course_id 
				FROM courses 
				WHERE courses.course_name = 'Databases'
		)
	) AND NOT EXISTS (
		SELECT * 
		FROM marks 
		WHERE (
			students.student_id = marks.student_id 
			AND marks.course_id in (
				SELECT courses.course_id 
				FROM courses 
				WHERE courses.course_name = 'Databases'
			)
		)
	);

-- 3 Информацию о студентах, имеющих хотя бы одну оценку у заданного лектора 
SELECT students.student_name
FROM students 
WHERE 
	students.student_id IN (
		SELECT marks.student_id
		FROM marks
		WHERE marks.course_id IN (
				SELECT academicplan.course_id 
				FROM academicplan
				WHERE academicplan.lecturer_id IN (
					SELECT lecturers.lecturer_id
					FROM lecturers
					WHERE lecturers.lecturer_name = 'Georgiy Korneev'
				)			
		)
	) ;

-- 4 Идентификаторы студентов, не имеющих ни одной оценки у заданного лектора
SELECT students.student_name
FROM students 
EXCEPT 
SELECT DISTINCT students.student_name
FROM students 
WHERE 
	students.student_id IN (
		SELECT marks.student_id
		FROM marks
		WHERE marks.course_id IN (
				SELECT academicplan.course_id 
				FROM academicplan
				WHERE academicplan.lecturer_id IN (
					SELECT lecturers.lecturer_id
					FROM lecturers
					WHERE lecturers.lecturer_name = 'Georgiy Korneev'
				)			
		)
	) ;

-- 5 ?? деление, умею только count
-- Студентов, имеющих оценки по всем предметам заданного лектора

SELECT students.student_name
FROM students 
WHERE 
	students.student_id IN (
		SELECT marks.student_id
		FROM marks
		WHERE marks.course_id IN (
				SELECT academicplan.course_id 
				FROM academicplan
				WHERE academicplan.lecturer_id IN (
					SELECT lecturers.lecturer_id
					FROM lecturers
					WHERE lecturers.lecturer_name = 'Georgiy Korneev'
				)			
		) AND marks.course_id NOT IN (
			SELECT courses.course_id
			FROM courses
			WHERE courses.course_id NOT IN (
				SELECT academicplan.course_id 
				FROM academicplan
				where academicplan.group_id = students.group_id
			)
		)
	) ;


-- 6 Для каждого студента имя и предметы, которые он должен посещать 

SELECT students.student_name, courses.course_name
FROM students, courses
WHERE students.group_id IN (
	SELECT academicplan.group_id
	FROM academicplan
	WHERE courses.course_id = academicplan.course_id
	)
ORDER BY students.student_name;

-- 7 По лектору всех студентов, у которых он хоть что-нибудь преподавал 
SELECT students.student_name
FROM students 
WHERE 
	students.group_id IN (
			SELECT academicplan.group_id 
			FROM academicplan
			WHERE academicplan.lecturer_id IN (
				SELECT lecturers.lecturer_id
				FROM lecturers
				WHERE lecturers.lecturer_name = 'Georgiy Korneev'
			)			
	);

-- 8  ??

                             
DROP DATABASE deanery7;
CREATE DATABASE deanery7;

DROP TABLE academicplan CASCADE;
DROP TABLE marks CASCADE;
DROP TABLE lecturers CASCADE;
DROP TABLE courses CASCADE;
DROP TABLE students CASCADE;
DROP TABLE groups CASCADE;
DROP TABLE LoserT CASCADE;

CREATE TABLE IF NOT EXISTS groups (
	group_id int PRIMARY KEY,
	group_name varchar(100)
);

CREATE TABLE IF NOT EXISTS students (
	student_id int PRIMARY KEY,
	student_name varchar(100),
	group_id int REFERENCES groups (group_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS lecturers (
	lecturer_id int PRIMARY KEY,
	lecturer_name varchar(50)
);


CREATE TABLE IF NOT EXISTS courses (
	course_id int PRIMARY KEY,
	course_name varchar(50)
);

CREATE TABLE IF NOT EXISTS marks (
	mark_value int,
	course_id int not null REFERENCES courses (course_id) ON DELETE CASCADE ON UPDATE CASCADE,
	student_id int not null REFERENCES students (student_id) ON DELETE CASCADE ON UPDATE CASCADE,
	CHECK (mark_value BETWEEN 0 AND 100),
	PRIMARY KEY (course_id, student_id)
);

CREATE TABLE IF NOT EXISTS academicplan (
	lecturer_id int not null REFERENCES lecturers (lecturer_id) ON DELETE CASCADE ON UPDATE CASCADE,
	course_id int not null REFERENCES courses (course_id) ON DELETE CASCADE ON UPDATE CASCADE,
	group_id int not null REFERENCES groups (group_id) ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY (lecturer_id, course_id, group_id)
);


INSERT INTO groups (group_id, group_name)
	VALUES (1, 'M3439'),
		   (2, 'M3339'),
		   (3, 'M3239'),
		   (4, 'M3139'),
		   (5, 'M3438');

INSERT INTO students (student_id, student_name, group_id) 
	VALUES (1, 'Ivan Belonogov', 1),
		   (2, 'Evgeny Nemchenko', 5), 
		   (3, 'Michail Putilin', 1), 
		   (4, 'Appolinaria Romanova', 3), 
		   (5, 'Anna Rodionova', 2),
		   (6, 'Vyacheslav Moklev', 1),
		   (7, 'Daniil Prokopenko', 5);

INSERT INTO lecturers (lecturer_id, lecturer_name)
	VALUES (1, 'Georgiy Korneev'),
		   (2, 'Andrew Stankevich'),
		   (3, 'Oksana Pavlova');

		   
INSERT INTO courses (course_id, course_name)
	VALUES (1, 'Java'),
		   (2, 'Algorithm and Data Structures'),
		   (3, 'English'),
		   (4, 'Databases'),
		   (5, 'DMath');		   		   

INSERT INTO marks (mark_value, course_id, student_id)
	VALUES 
		   (99, 2, 3),
		   (40, 4, 3),		   
		   (44, 1, 6),
		   (98, 4, 6),
		   (100, 2, 2),
		   (100, 4, 4),
		   (88, 1, 4),
		   (33, 1, 1),
		   (22, 2, 1),
		   (44, 4, 1),
		   (100, 2, 5);

INSERT INTO academicplan (lecturer_id, course_id, group_id)
	VALUES (1, 1, 1),
		   (2, 2, 1),
		   (1, 4, 1),
		   (1, 4, 2),
		   (2, 2, 3),
		   (2, 5, 4),
		   (1, 1, 3),
		   (1, 4, 3),
		   (3, 2, 2),
		   (3, 3, 5),
		   (2, 2, 5);

SELECT * 
FROM students;

-- 1. Запрос, удаляющий всех студентов, не имеющих долгов


--DELETE
SELECT *
FROM students 
WHERE student_id NOT IN 
(
	SELECT marks.student_id
	FROM marks 
	WHERE marks.mark_value <= 60 AND marks.course_id IN
	(
		SELECT academicplan.course_id
		FROM academicplan
		WHERE students.group_id = academicplan.group_id
    )	
);



-- 2. Запрос, удаляющий всех студентов, имеющих 3 и более долгов

--DELETE
SELECT * 
FROM students 
WHERE student_id IN 
(
	SELECT marks.student_id
	FROM marks 
	WHERE marks.mark_value <= 60 AND marks.course_id IN
	(
		SELECT academicplan.course_id
		FROM academicplan
		WHERE students.group_id = academicplan.group_id
    )
    GROUP BY marks.student_id
    HAVING COUNT(marks.student_id) >= 3	
);

-- 3. Запрос, удаляющий все группы, в которых нет студентов

--DELETE
SELECT * 
FROM groups
WHERE group_id NOT IN 
(
	SELECT students.group_id
	FROM students
);

-- 4. View Losers в котором для каждого студента, имеющего долги указано их количество
CREATE VIEW Losers AS
SELECT students.student_name AS name, COUNT(marks.student_id) AS fails
FROM students
NATURAL JOIN marks
WHERE marks.mark_value <= 60 AND marks.course_id IN
(
	SELECT academicplan.course_id
	FROM academicplan
	WHERE students.group_id = academicplan.group_id
)	
GROUP BY students.student_id;

SELECT * FROM Losers;


--5. Таблица LoserT, в которой содержится та же информация, что во view Losers. 
-- Эта таблица должна автоматически обновляться при изменении таблицы с баллами.

CREATE TABLE LoserT AS SELECT * FROM Losers;


INSERT INTO marks (mark_value, course_id, student_id)
	VALUES (55, 2, 7);


CREATE OR REPLACE FUNCTION loser_procedure() RETURNS TRIGGER AS $LoserTrig$
    BEGIN
		DELETE FROM LoserT *;
		INSERT INTO LoserT (SELECT * FROM Losers);
		RETURN NEW;
    END;
$LoserTrig$ LANGUAGE plpgsql;


CREATE TRIGGER LoserTrig
AFTER INSERT OR UPDATE OR DELETE ON marks
FOR EACH ROW EXECUTE PROCEDURE loser_procedure();


SELECT * FROM LoserT;

INSERT INTO marks (mark_value, course_id, student_id)
	VALUES (56, 3, 7);

SELECT * FROM LoserT;


-- 6. Отключить автоматическое обновление таблицы LoserT

DROP TRIGGER IF EXISTS LoserTrig ON marks;


-- 9. Триггер, не позволяющий уменьшить баллы студента по предмету. 
--При попытке такого изменения, баллы изменяться не должны


CREATE OR REPLACE FUNCTION marks_procedure() RETURNS TRIGGER AS $LoserTrig$
    BEGIN
    	IF (NEW.mark_value < OLD.mark_value) THEN 
	    	NEW.mark_value = OLD.mark_value;
    		RETURN NEW;
    	END IF;
    	RETURN NULL;
    END;
$LoserTrig$ LANGUAGE plpgsql;


CREATE TRIGGER marksUpdate
BEFORE UPDATE ON marks
FOR EACH ROW EXECUTE PROCEDURE marks_procedure();

--DROP TRIGGER IF EXISTS marksUpdate ON marks;

UPDATE marks SET mark_value = 44 
	WHERE course_id = 3 AND student_id = 7;

SELECT * FROM marks;

-- 8. Проверка того, что все студенты одной группы изучают один и тот же набор курсов

CREATE ASSERTION NonEmptyGroup CHECK (NOT EXISTS
    (select * from Group g where not exists 
        (select * from Students s where s.GId = g.GId)))


DROP DATABASE airline2;
CREATE DATABASE airline2;

DROP TABLE planes CASCADE;
DROP TABLE flights CASCADE;
DROP TABLE seats CASCADE;

CREATE TABLE IF NOT EXISTS planes (
	plane_id int PRIMARY KEY,
	capacity int not null
);

CREATE TABLE IF NOT EXISTS flights (
	flight_id SERIAL PRIMARY KEY,
	flight_num int,
	flight_time timestamp without time zone,
	plane_id int not null REFERENCES planes (plane_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS seats (
	flight_id int REFERENCES flights (flight_id) ON DELETE CASCADE ON UPDATE CASCADE,
	seat_no int not null,
	status int not null, --  1 -- reserved, 2 -- bought
	reserved_time timestamp without time zone,
	PRIMARY KEY(flight_id, seat_no)
);

INSERT INTO planes (plane_id, capacity)
	VALUES (1, 100),
		   (2, 120),
		   (3, 50);

INSERT INTO flights (flight_num, flight_time, plane_id)
	VALUES (1, timestamp '2016-11-28 20:38:40', 1),
		   (2, timestamp '2016-11-29 19:38:40', 2),
		   (3, timestamp '2016-12-01 01:38:20', 1),
		   (4, timestamp '2016-12-14 03:38:40', 2),
		   (5, timestamp '2016-12-16 13:38:10', 2);

INSERT INTO seats (flight_id, seat_no, status, reserved_time)
	VALUES (1, 1, 1, timestamp '2016-11-28 13:38:10'),
		   (1, 2, 2, timestamp '2016-11-28 10:38:10'),
		   (1, 3, 1, timestamp '2016-11-27 13:38:10'),
		   (2, 2, 2, timestamp '2016-11-26 13:38:10'),
		   (2, 5, 1, timestamp '2016-11-29 13:38:10');
		   
SELECT * FROM flights;
SELECT * FROM seats;

CREATE OR REPLACE FUNCTION seats_action() RETURNS TRIGGER AS $SeatsAct$
	DECLARE
		timespent interval;
		cur_bought int;
		flight_time interval;
		cur_capacity int;
    BEGIN
    	timespent := NEW.reserved_time - (SELECT flight_time FROM flights WHERE NEW.flights_id = flights.flights_id);
    	flight_time := now() - (SELECT flight_time FROM flights WHERE NEW.flights_id = flights.flights_id);
    	cur_capacity := SELECT capacity FROM planes WHERE plane_id = (
	    	SELECT plane_id FROM flights WHERE flight_id = NEW.flight_id);

	    IF (NEW.seat_no > cur_capacity) 
	    THEN
	    	NEW := OLD;
	    	RETURN NULL;
	    END IF;

    	IF (NEW.status = 2 
    		AND 
    		(SELECT EXTRACT (DAY FROM timespent)) = 0 
    		AND 
    		(SELECT EXTRACT (HOUR FROM timespent)) < 2) 
    		OR 
    		(NEW.status = 1 
    		AND 
    		(SELECT EXTRACT (DAY FROM timespent)) < 1
    		AND (SELECT EXTRACT (DAY FROM flight_time)) > 0) 
    	THEN
    		NEW := OLD;
    		RETURN OLD;
    	END IF;  
    	
    	cur_bought := (SELECT count(seats_no) FROM seats WHERE flight_id = NEW.flight_id);

    	IF cur_bought = cur_capacity
	    THEN
	    	NEW := OLD;
	    	RETURN NULL;
	    END IF; 		


        IF (TG_OP = 'UPDATE') AND (NEW.status = 1) AND (OLD.status = 1)
        THEN
            NEW.reserved_time := now();
            RETURN NEW;
        ELSIF (TG_OP = 'INSERT') 
        THEN
			IF (
				SELECT count(*) 
	    		FROM seats
		    	WHERE flight_id = NEW.flight_id AND
    				  seat_no = NEW.seat_no) > 0 
    			AND (
    			SELECT status
	    		FROM seats
		    	WHERE flight_id = NEW.flight_id AND
    				  seat_no = NEW.seat_no) = 1
    		THEN
    			IF (now() - (SELECT reserved_time
		    		FROM seats
	    			WHERE flight_id = NEW.flight_id AND
	    			  seat_no = NEW.seat_no)) > 24
	    		THEN
	    			DELETE 
		    		FROM seats       	
	    			WHERE flight_id = NEW.flight_id AND
    			  		seat_no = NEW.seat_no;
    			  	RETURN NEW;
    			ELSE
    				NEW := OLD;
    				RETURN NULL;
    			END IF;
    		END IF;        			
    	END IF;
    	RETURN NEW;
    END;
$SeatsAct$ LANGUAGE plpgsql;


CREATE TRIGGER SeatsAct
BEFORE INSERT OR UPDATE ON seats
FOR EACH ROW EXECUTE PROCEDURE seats_action();


DROP DATABASE airline3;
CREATE DATABASE airline3;

DROP TABLE planes CASCADE;
DROP TABLE flights CASCADE;
DROP TABLE seats CASCADE;

CREATE TABLE IF NOT EXISTS planes (
	plane_id int PRIMARY KEY,
	capacity int not null
);

CREATE TABLE IF NOT EXISTS flights (
	flight_id SERIAL PRIMARY KEY,
	flight_num int,
	flight_time timestamp without time zone,
	plane_id int not null REFERENCES planes (plane_id) ON DELETE CASCADE ON UPDATE CASCADE,
	end_sales int not null
);

CREATE TABLE IF NOT EXISTS seats (
	flight_id int REFERENCES flights (flight_id) ON DELETE CASCADE ON UPDATE CASCADE,
	seat_no int not null,
	status int not null, --  1 -- reserved, 2 -- bought
	reserved_time timestamp without time zone,
	PRIMARY KEY(flight_id, seat_no)
);

INSERT INTO planes (plane_id, capacity)
	VALUES (1, 100),
		   (2, 120),
		   (3, 50);

INSERT INTO flights (flight_num, flight_time, plane_id, end_sales)
	VALUES (1, timestamp '2016-11-28 20:38:40', 1, 0),
		   (2, timestamp '2016-11-29 19:38:40', 2, 0),
		   (3, timestamp '2016-12-01 01:38:20', 1, 0),
		   (4, timestamp '2016-12-14 03:38:40', 2, 0),
		   (5, timestamp '2016-12-16 13:38:10', 2, 0);

INSERT INTO seats (flight_id, seat_no, status, reserved_time)
	VALUES (1, 1, 1, timestamp '2016-11-28 13:38:10'),
		   (1, 2, 2, timestamp '2016-11-28 10:38:10'),
		   (1, 3, 1, timestamp '2016-11-27 13:38:10'),
		   (2, 2, 2, timestamp '2016-11-26 13:38:10'),
		   (2, 5, 1, timestamp '2016-11-29 13:38:10');
		   
SELECT * FROM flights;
SELECT * FROM seats;


-- 1. FreeSeats(FlightId) — список мест, доступных для продажи и бронирования. 
DROP FUNCTION free_seats(fid int);
CREATE OR REPLACE FUNCTION free_seats(fid int) RETURNS TABLE(seat int) AS $$
	DECLARE
		cap int;
	BEGIN
    	cap := (SELECT capacity FROM planes WHERE plane_id = (
	    	SELECT plane_id FROM flights WHERE flight_id = fid));

	    RETURN QUERY (SELECT * FROM generate_series(1, cap) AS X WHERE X NOT IN 
    		(SELECT seat_no FROM seats WHERE flight_id = fid));

    END;
$$ LANGUAGE plpgsql;

SELECT * FROM free_seats(1);
SELECT * FROM free_seats(2);

-- 2. Reserve(FlightId, SeatNo) — пытается забронировать место. 
-- Возвращает истину, если удалось и ложь — в противном случае. 
DROP FUNCTION reserve(fid int, snum int);
CREATE OR REPLACE FUNCTION reserve(fid int, snum int) RETURNS BOOLEAN AS $$
    BEGIN
	   	INSERT INTO seats (flight_id, seat_no, status, reserved_time)
				VALUES (fid, snum, 1, now());
		RETURN FOUND;
    END;
$$ LANGUAGE plpgsql;

SELECT reserve(1, 1);


-- 3. ExtendReservation(FlightId, SeatNo) — пытается продлить бронь места. 
-- Возвращает истину, если удалось и ложь — в противном случае. 

DROP FUNCTION extend_reservation(fid int, snum int);
CREATE OR REPLACE FUNCTION extend_reservation(fid int, snum int) RETURNS BOOLEAN AS $$
    BEGIN
		UPDATE seats SET reserved_time = now() WHERE flight_id = fid AND seat_no = snum;
	    RETURN FOUND;
    END;
$$ LANGUAGE plpgsql;

SELECT extend_reservation(1, 1);


--4.BuyFree(FlightId, SeatNo) — пытается купить свободное место. 
--Возвращает истину, если удалось и ложь — в противном случае. 

DROP FUNCTION buy_free(fid int, snum int);
CREATE OR REPLACE FUNCTION buy_free(fid int, snum int) RETURNS BOOLEAN AS $$
    BEGIN
		INSERT INTO seats (flight_id, seat_no, status, reserved_time)
			VALUES (fid, snum, 2, now());
		RETURN FOUND;		    	
    END;
$$ LANGUAGE plpgsql;

SELECT buy_free(1, 1);

-- 5. BuyReserved(FlightId, SeatNo) — пытается выкупить забронированное место. 
-- Возвращает истину, если удалось и ложь — в противном случае. 
DROP FUNCTION buy_reserved(fid int, snum int);
CREATE OR REPLACE FUNCTION buy_reserved(fid int, snum int) RETURNS BOOLEAN AS $$
    BEGIN
		UPDATE seats SET status = 2 WHERE flight_id = fid AND seat_no = snum;
	    RETURN FOUND;
    END;
$$ LANGUAGE plpgsql;

SELECT buy_reserved(1, 1);

-- 6.FlightStatistics() — возвращает статистику по рейсам: 
-- возможность бронирования и покупки, число свободных, забронированных и проданных мест. 
DROP FUNCTION flight_statistics();
CREATE OR REPLACE FUNCTION flight_statistics() RETURNS TABLE(fid int, fnum int, 
	reserve boolean, buy boolean, frees int, reserveds int, boughts int) AS $$
	DECLARE
		cap int;
	BEGIN
	    RETURN QUERY (SELECT  FROM generate_series(1, cap) AS X WHERE X NOT IN 
    		(SELECT seat_no FROM seats WHERE flight_id = fid));

    END;
$$ LANGUAGE plpgsql;

SELECT * FROM flight_statistics();


