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
