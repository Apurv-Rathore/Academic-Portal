insert into course_catalogue(course_id, name, L, T, P) values ('CS303', 'Operating System', 5, 5, 5);
insert into course_catalogue(course_id, name, L, T, P) values ('CS203', 'Pta nahi System', 5, 5, 5);
insert into course_catalogue(course_id, name, L, T, P) values ('CS201', 'Data sturcture', 5, 5, 5);
insert into course_catalogue(course_id, name, L, T, P) values ('CS202', 'Dekh lo', 5, 5, 5);
insert into prerequisites(course_id, prerequisite_course_id) values ('CS303', 'CS203');
insert into prerequisites(course_id, prerequisite_course_id) values ('CS303', 'CS202');
insert into prerequisites(course_id, prerequisite_course_id) values ('CS303', 'CS201');
insert into course_offering(course_id, year, semester, section_id, instructor_id, classroom, cgpa_requirement, slot_number)
values ('CS301', 2000, 2, 'two', 'VSCS301', 'dekh lo', 8.2, 3);
insert into time_slots(monday_start, monday_end, tuesday_start, tuesday_end, wednesday_start, wednesday_end, thursday_start, thursday_end, friday_start, friday_end) values ('16:00', '17:00', '10:20', '11:20', '9:00', '10:00', '14:45', '15:20', '8:00', '8:30');
insert into taken(offering_id, student_id) values (3, '2019CS1067');