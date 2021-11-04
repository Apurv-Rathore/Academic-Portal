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

insert into course_offering(course_id, year, semester, section_id, instructor_id, slot_number, cgpa_requirement, allowed_batches)
values ('CS303', 2021, 1, 1, '2', 1, 6.0, ARRAY[2018, 2019, 2020]);
insert into course_offering(course_id, year, semester, section_id, instructor_id, slot_number, cgpa_requirement, allowed_batches)
values ('CS302', 2021, 1, 1, '3', 1, 7.0, ARRAY[2018, 2019, 2020]);
insert into course_offering(course_id, year, semester, section_id, instructor_id, slot_number, allowed_batches)
values ('CS301', 2021, 1, 1, '1', 1, ARRAY[2018, 2019, 2020]);
insert into course_offering(course_id, year, semester, section_id, instructor_id, slot_number, allowed_batches)
values ('CS517', 2021, 1, 1, '4', 1, ARRAY[2018, 2019, 2020]);


insert into student(student_id, name, dept_name,batch) values ('1', 'Jaglike Makkar', 'CSE',2019);
insert into student(student_id, name, dept_name,batch) values ('2', 'Apurv Rathore', 'CSE',2019);
insert into student(student_id, name, dept_name,batch) values ('3', 'Aman Chourasiya', 'CSE',2019);



CREATE TABLE course_offering_grades_2(
    student_id varchar(20) not null,
    grade integer,
    offering_id varchar(20) not null,
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    PRIMARY KEY (student_id)
);
insert into course_offering_grades_2(student_id,grade,offering_id) values(1,10,2);



 CREATE TABLE student_transcript_1(
    offering_id integer not null,
    year integer not null,
    semester integer not null,
    grade integer,
     credits double precision not null,
    PRIMARY KEY (offering_id)
);

insert into course_offering_2020_2(
    offering_id,
    course_id,
    section_id,
    instructor_id,
    cgpa_requirement,
    allowed_batches
) values (5, 'CS201', '2', '1', 5, ARRAY[2018, 2019, 2020]);

insert into student_transcript_1(
    offering_id,
    year,
    semester,
    grade,
    credits
) values (5, 2020, 2, 8, 3);

