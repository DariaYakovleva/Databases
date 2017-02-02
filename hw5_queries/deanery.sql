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

