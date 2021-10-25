create or replace function offer_course(cgpa_constraint double precision, start_time VARCHAR(10), intervall integer, course_id varchar(10), instructor_id varchar(10), 
year integer,
semester integer,
section_id varchar(10),
classroom varchar(10),
cgpa_requirement double precision) RETURNS INTEGER
AS
$$
declare 
    variable_name record;
begin
    select slot_number
    into variable_name 
    from time_slots
    where time_slots.start = start_time AND time_slots.interval = intervall;
    INSERT INTO course_offering(
        course_id, instructor_id, year, semester, section_id, slot_number, classroom, cgpa_requirement
    )
    VALUES (course_id, instructor_id, year, semester, section_id, variable_name.slot_number, classroom, cgpa_constraint);
    RETURN 1;
end;
$$
language plpgsql;


\copy section_offered_grades FROM 'D:\Semester 5\CS 301 Database\Phase 1\section_offered_grades.csv' delimiter ',' csv header;
\copy section_offered_grades from '/Users/EDB1/Downloads/usa.csv' delimiter ',' csv header;

