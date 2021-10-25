insert into course_catalogue(course_id, name, L, T, P) values ('CS303', 'Operating System', 5, 5, 5);
insert into course_catalogue(course_id, name, L, T, P) values ('CS203', 'Pta nahi System', 5, 5, 5);
insert into course_catalogue(course_id, name, L, T, P) values ('CS201', 'Data sturcture', 5, 5, 5);
insert into course_catalogue(course_id, name, L, T, P) values ('CS202', 'Dekh lo', 5, 5, 5);
insert into prerequisites(course_id, prerequisite_course_id) values ('CS303', 'CS203');
insert into prerequisites(course_id, prerequisite_course_id) values ('CS303', 'CS202');
insert into prerequisites(course_id, prerequisite_course_id) values ('CS303', 'CS201');