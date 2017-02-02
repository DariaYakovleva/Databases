drop Database CTD;
create Database CTD;

drop table Groups;
drop table Students;

create table if not exists Groups (group_id int, group_no char(5));
create table if not exists Students (student_id int, name varchar(30), group_id int);

insert into Groups (group_id, group_no) values (1, 'M3438'), (2, 'M3439');
insert into Students (student_id, name, group_id) values (1, 'Ruslan Ahundov', 1), 
(2, 'Pavel Asadchy', 2), (3, 'Eugene Varlamov', 2);

select group_id, group_no from Groups;
select student_id, name, group_id from Students;
select name, group_no from Students natural join Groups;
select Students.name, Groups.group_no from Students inner join Groups on Students.group_id = Groups.group_id;

delete from Groups where group_no = 'M3437';

alter table Groups add constraint group_id_unique unique (group_id);

insert into Students (student_id, name, group_id) values (4, 'Иван Петров', 1), 
(5, 'Иван Сидоров', 2), (6, 'Яков Сергеев', 2);

select count(*) from Groups;
select count(*) from Students;
select count(*) from Students where name like '%ван%' or name like '%ов';

delete from Groups; 
delete from Students; 
delete from Groups; 

insert into Groups (group_id, group_no) values (1, 'M3137'), (2, 'M3138'), (3, 'M3139');

insert into Students (student_id, name, group_id) values (1, 'Нина Жевтяк', 1), (2, 'Дарья Бин', 2), 
(3, 'Андрей Яценко', 2), (4, 'Михаил Путилин', 3), (5, 'Станислав Наумов', 3), (6, 'Виктория Ерохина', 3);

select group_no, count(*)
from Groups inner join Students on Groups.group_id = Students.group_id
group by group_no order by group_no desc; 