insert into course_catalogue(course_id, name, L, T, P, S, C) values ('HS202', 'HGSN', 1, 1, 4, 3, 3);
insert into course_catalogue(course_id, name, L, T, P, S, C) values ('HS104', 'PE', 1, 1, 1, 2, 1);
insert into course_catalogue(course_id, name, L, T, P, S, C) values ('GE111', 'EVS', 3, 1, 0, 5, 3);
insert into course_catalogue(course_id, name, L, T, P, S, C) values ('NS103', 'NSS', 0, 0, 2, 1, 1);

insert into course_catalogue(course_id, name, L, T, P, S, C) values ('CS303', 'OS', 3, 1, 2, 6, 4);
insert into course_catalogue(course_id, name, L, T, P, S, C) values ('CS301', 'DBMS', 3, 1, 2, 6, 4);
insert into course_catalogue(course_id, name, L, T, P, S, C) values ('CS302', 'ADA', 3, 1, 0, 5, 3);
insert into course_catalogue(course_id, name, L, T, P, S, C) values ('CS517', 'DIPA', 2, 1, 2, 4, 3);

insert into course_catalogue(course_id, name, L, T, P, S, C) values ('CS201', 'DSA', 3, 1, 2, 6, 4);
insert into course_catalogue(course_id, name, L, T, P, S, C) values ('CS203', 'DLD', 3, 1, 3, 6, 4);
insert into course_catalogue(course_id, name, L, T, P, S, C) values ('CS204', 'CA', 3, 1, 2, 6, 4);


insert into prerequisites(course_id, prerequisite_course_id) values ('CS303', 'CS204');
insert into prerequisites(course_id, prerequisite_course_id) values ('CS303', 'CS203');
insert into prerequisites(course_id, prerequisite_course_id) values ('CS302', 'CS201');
insert into prerequisites(course_id, prerequisite_course_id) values ('CS517', 'CS201');


insert into department(name) values ('CSE');
insert into department(name) values ('EE');

insert into instructor(instructor_id, name, dept_name) values ('1', 'Viswanath Gunturi', 'CSE');
insert into instructor(instructor_id, name, dept_name) values ('2', 'Balwinder Sodhi', 'CSE');
insert into instructor(instructor_id, name, dept_name) values ('3', 'Apurva Mudgal', 'CSE');
insert into instructor(instructor_id, name, dept_name) values ('4', 'Deepti R Bathula', 'CSE');


insert into time_slots(monday_start, monday_end, tuesday_start, tuesday_end, wednesday_start, wednesday_end, thursday_start, thursday_end, friday_start, friday_end)
values ('01:00:00', '01:50:00', '01:00:00', '01:50:00', '01:00:00', '01:50:00', '01:00:00', '01:50:00', '01:00:00', '01:50:00');
insert into time_slots(monday_start, monday_end, tuesday_start, tuesday_end, wednesday_start, wednesday_end, thursday_start, thursday_end, friday_start, friday_end)
values ('02:00:00', '02:50:00', '02:00:00', '02:50:00', '02:00:00', '02:50:00', '02:00:00', '02:50:00', '02:00:00', '02:50:00');
insert into time_slots(monday_start, monday_end, tuesday_start, tuesday_end, wednesday_start, wednesday_end, thursday_start, thursday_end, friday_start, friday_end)
values ('03:00:00', '03:50:00', '03:00:00', '03:50:00', '03:00:00', '03:50:00', '03:00:00', '03:50:00', '03:00:00', '03:50:00');
insert into time_slots(monday_start, monday_end, tuesday_start, tuesday_end, wednesday_start, wednesday_end, thursday_start, thursday_end, friday_start, friday_end)
values ('04:00:00', '04:50:00', '04:00:00', '04:50:00', '04:00:00', '04:50:00', '04:00:00', '04:50:00', '04:00:00', '04:50:00');

insert into course_offering(course_id, year, semester, section_id, instructor_id, slot_number, classroom, cgpa_requirement)
values ('CS303', 2021, 1, 1, '2', 1, 'CS1', 6.0);
insert into course_offering(course_id, year, semester, section_id, instructor_id, slot_number, classroom, cgpa_requirement)
values ('CS302', 2021, 1, 1, '3', 1, 'CS2', 7.0);
insert into course_offering(course_id, year, semester, section_id, instructor_id, slot_number, classroom)
values ('CS301', 2021, 1, 1, '1', 1, 'CS1');
insert into course_offering(course_id, year, semester, section_id, instructor_id, slot_number, classroom)
values ('CS517', 2021, 1, 1, '4', 1, 'CS2');


insert into student(student_id, name, dept_name) values ('1', 'Jaglike Makkar', 'CSE');
insert into student(student_id, name, dept_name) values ('2', 'Apurv Rathore', 'CSE');
insert into student(student_id, name, dept_name) values ('3', 'Aman Chourasiya', 'CSE');

insert into taken(student_id, offering_id) values ('1', 2);
insert into taken(student_id, offering_id) values ('1', 3);
insert into taken(student_id, offering_id) values ('1', 4);
insert into taken(student_id, offering_id) values ('2', 1);
insert into taken(student_id, offering_id) values ('2', 3);
insert into taken(student_id, offering_id) values ('3', 3);
insert into taken(student_id, offering_id) values ('3', 4);
