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
