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


