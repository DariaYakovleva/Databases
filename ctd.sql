create Database CTD;
create table Groups (group_id int, group_no char(5));
create table Students (student_id int, name varchar(30), group_id int);

insert into Groups (group_id, group_no) values (1, 'M3438'), (2, 'M3439');
insert into Students (student_id, name, group_id) values (1, 'Ruslan Ahundov', 1), 
(2, 'Pavel Asadchy', 2), (3, 'Eugene Varlamov', 2);

select group_id, group_no from Groups;
select student_id, name, group_id from Students;
select name, group_no from Students natural join Groups;
select Students.name, Groups.group_no from Students inner join Groups on Students.group_id = Groups.group_id;

delete from Groups where group_no = 'M3437';

alter table Groups add constraint group_id_unique unique (group_id);
