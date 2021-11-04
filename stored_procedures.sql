CREATE or REPLACE PROCEDURE create_ticket(_student_id varchar(10), _offering_id integer)
    AS
    $$
    BEGIN
        INSERT INTO student_ticket_table(student_id, offering_id)
        VALUES (_student_id, _offering_id);
        INSERT INTO instructor_ticket_table(student_id, offering_id)
        VALUES (_student_id, _offering_id);
    END;
    $$
    LANGUAGE plpgsql;

CREATE or REPLACE PROCEDURE update_ticket_instructor(_student_id varchar(10), _offering_id integer, _has_accepted_instructor boolean)
    AS
    $$
    BEGIN
        INSERT INTO batch_advisor_ticket_table(student_id, offering_id, has_accepted_instructor)
        VALUES (_student_id, _offering_id, _has_accepted_instructor);
        DELETE FROM instructor_ticket_table 
        WHERE student_id = _student_id AND offering_id = _offering_id;
    END;
    $$
    LANGUAGE plpgsql;

CREATE or REPLACE PROCEDURE update_ticket_batch_advisor(_student_id varchar(10), _offering_id integer, _has_accepted_batch_advisor boolean)
    AS
    $$
    DECLARE
        _has_accepted_instructor boolean;
    BEGIN
        SELECT has_accepted_instructor 
        INTO _has_accepted_instructor 
        FROM batch_advisor_ticket_table 
        WHERE student_id = _student_id AND offering_id = _offering_id;

        INSERT INTO dean_academics_ticket_table(student_id, offering_id, has_accepted_instructor, has_accepted_batch_advisor)
        VALUES (_student_id, _offering_id, _has_accepted_instructor, _has_accepted_batch_advisor);

        DELETE FROM batch_advisor_ticket_table
        WHERE student_id = _student_id AND offering_id = _offering_id;
    END;
    $$
    LANGUAGE plpgsql;

CREATE or REPLACE PROCEDURE update_ticket_dean_academics(_student_id varchar(10), _offering_id integer, _has_accepted_dean_academics boolean)
    AS
    $$
    BEGIN
        UPDATE student_ticket_table
        SET has_accepted = _has_accepted_dean_academics
        WHERE student_id = _student_id AND offering_id = _offering_id;

        DELETE FROM dean_academics_ticket_table
        WHERE student_id = _student_id AND offering_id = _offering_id;
    END;
    $$
    LANGUAGE plpgsql;

-- call create_ticket('2', 4, false);
-- call create_ticket('3', 2, false);

-- call update_ticket_instructor('2', 4, true);
-- call update_ticket_instructor('3', 2, false);

-- call update_ticket_batch_advisor('2', 4, false);
-- call update_ticket_batch_advisor('3', 2, true);

-- call update_ticket_dean_academics('2', 4, false);
-- call update_ticket_dean_academics('3', 2, true);


CREATE or REPLACE PROCEDURE get_CGPA(
    IN student_id varchar(10),
    INOUT CGPA double precision)
    AS
    $$
    DECLARE
        tablename varchar(200);
        query_tcredits varchar;
        query_tgrades varchar;
        total_credits integer;
        total_grades integer;
    BEGIN
        -- ########### UPDATE THIS ########### 
        SELECT CONCAT('student_transcript_', student_id) into tablename;
        query_tcredits = CONCAT('select sum(credits) from ', tablename, ' where grade > 4');
        query_tgrades = CONCAT('select sum(credits*grade) from ', tablename , ' where grade > 4');
        execute query_tcredits into total_credits;
        execute query_tgrades into total_grades;
        CGPA = round(total_grades/total_credits, 2);
        raise notice 'Value of cgpa: %', CGPA;
    END
    $$
LANGUAGE plpgsql;


create or replace PROCEDURE offer_course(
    cgpa_constraint_inp double precision, 
    course_idd varchar(10), 
    instructor_idd varchar(10), 
    year_inp integer,
    semester_inp integer,
    section_id_inp varchar(10),
    allowed_batches_ INT[],
    slot_number integer) 
AS
$$
declare 
    array_length INTEGER;
    offering_id integer;
    offering_id_record record;
begin   

    INSERT INTO course_offering(
        course_id, instructor_id, year, semester, section_id, slot_number, cgpa_requirement, allowed_batches
    )
    VALUES (course_idd, instructor_idd, year_inp, semester_inp, section_id_inp, slot_number, cgpa_constraint_inp, allowed_batches_);
end;
$$
language plpgsql;


create or replace PROCEDURE delete_course_offering(_offering_id integer)
AS
$$
begin
    DELETE FROM course_offering
    WHERE offering_id = _offering_id;
end;
$$
language plpgsql;



-- to run :::  select offer_course(10,'HS202','1',2019,1,'1','1', ARRAY [2019], '{"01:00:00", "01:50:00", "01:00:00", "01:50:00", "01:00:00", "01:50:00", "01:00:00", "01:50:00", "01:00:00", "01:50:00"}'::TIME[] );
CALL offer_course(1,'NS103','1',2019,1,'1', ARRAY [2019,20120,2021], '{"01:00:00", "01:50:00", "01:00:00", "01:50:00", "01:00:00", "01:50:00", "01:00:00", "01:50:00", "01:00:00", "01:50:00"}'::TIME[] );

CALL delete_course_offering(1);


\copy section_offered_grades FROM 'D:\Semester 5\CS 301 Database\Phase 1\section_offered_grades.csv' delimiter ',' csv header;



-- course_offering_grades: This table is dynamically created for every course offering. It contains student_ids and grades of the students registered in this course. The instructor who is taking this course can edit this table.

-- CREATE TABLE course_offering_grades_offering_id(
--     student_id varchar(20) not null,
--     grade integer,
--     offering_id varchar(20) not null
--     FOREIGN KEY (student_id) REFERENCES student(student_id),
--     PRIMARY KEY (student_id)
-- );

create or replace PROCEDURE update_student_transcript()
AS
$$
DECLARE 
t_row course_offering%rowtype;
i record;
s1 varchar;
s2 varchar;
begin
    -- find all the required tables 
    -- get the student id
    FOR t_row in SELECT * FROM course_offering loop
        s1 = CONCAT('course_offering_grades_' , t_row.offering_id);
        s2 = CONCAT('select ' ,'course_offering_grades_' , t_row.offering_id,'.','offering_id, ','course_offering_grades_' , t_row.offering_id,'.','student_id,','course_offering_grades_' , t_row.offering_id,'.','grade from course_offering_grades_' , t_row.offering_id);
        for i in execute s2 LOOP
            s2 = CONCAT('UPDATE ', 'student_transcript_',i.student_id,' SET grade=',i.grade,' WHERE offering_id=',i.offering_id);


            -- s2 = CONCAT('INSERT INTO ', 'student_transcript_',i.student_id,'(offering_id,year,semester,grade) VALUES (',i.offering_id,',',t_row.year,',',t_row.semester,',',i.grade,')');
            execute s2;
        END LOOP;
    END LOOP;
end;
$$
language plpgsql;

call update_student_transcript();

create or replace PROCEDURE update_course_catalogue(
course_id_inp varchar(20),
name_inp varchar(20),
l_inp integer,
t_inp integer,
p_inp integer,
s_inp integer,
c_inp integer
) AS 
$$
begin
insert into course_catalogue(course_id, name, L, T, P, S, C) values (course_id_inp,name_inp,l_inp,t_inp,p_inp,s_inp,c_inp);
end;
$$
language plpgsql;




-- call update_course_catalogue('CS101','Introduction to Programming',1,1,1,1,1);


create or replace procedure which_course_from_offering_id( offering_id_ integer,  INOUT course_id_inout varchar(20))
language plpgsql as 
$$
declare
course_id_record record;
begin
select course_id into course_id_record from course_offering where offering_id=offering_id;
course_id_inout = course_id_record.course_id;

end;
$$;


create or replace procedure get_credits_from_course_id(course_id_ varchar(20),  INOUT credit DOUBLE precision)
language plpgsql as 
$$
declare
course_id_record record;
begin
select c into course_id_record from course_catalogue where course_catalogue.course_id=course_id_;
credit = course_id_record.c;

end;
$$;

create or replace procedure is_it_program_core(course_id_ varchar(50),  INOUT c1 integer)
language plpgsql as 
$$
declare
    i record ;
begin
select * into i from program_core_elective_2021 where program_core_elective_2021.course_id=course_id_;
-- raise notice 'Value: %', i;
if i is not null then
c1 = 1;
end if;
if i is null then
c1 = 0;
end if;
end;
$$;

create or replace procedure is_it_science_core(course_id_ varchar(50),  INOUT c1 integer)
language plpgsql as 
$$
declare
    i record ;
begin
select * into i from science_core_elective_2021 where science_core_elective_2021.course_id=course_id_;
-- raise notice 'Value: %', i;
if i is not null then
c1 = 1;
end if;
if i is null then
c1 = 0;
end if;
end;
$$;

create or replace procedure is_it_open(course_id_ varchar(50),  INOUT c1 integer)
language plpgsql as 
$$
declare
    i record ;
begin
select * into i from open_elective_2021 where open_elective_2021.course_id=course_id_;
-- raise notice 'Valuefffffffffffffffffffff: %', i;
if i is not null then
c1 = 1;
end if;
if i is null then
c1 = 0;
end if;
end;
$$;


create or replace procedure is_it_program(course_id_ varchar(50),  INOUT c1 integer)
language plpgsql as 
$$
declare
    i record ;
begin
select * into i from program_elective_2021 where program_elective_2021.course_id=course_id_;
-- raise notice 'Value: %', i;
if i is not null then
c1 = 1;
end if;
if i is null then
c1 = 0;
end if;
end;
$$;





create or replace function is_ready_to_graduate(
    my_student_id varchar(20)
)
returns boolean
language plpgsql
as
$$
declare
    CGPA double precision;
    is_ready boolean;
    credits_required record;
    program_core_credit_comp double precision default 0;
    science_core_credit_comp double precision default 0;
    open_elective_credit_comp double precision default 0;
    program_elective_credit_comp double precision default 0;

    c1 integer;
    c2 integer;
    c3 integer;
    c4 integer;

    p1 double precision;
    p2 double precision;
    p3 double precision;
    p4 double precision;

    i record;
    s1 varchar(70);
    s2 varchar(70);
    s3 varchar(70);
    s5 varchar(70);
    s6 varchar(70);
    which_batch integer;
    which_course varchar(20);
begin
    is_ready = true;
    -- required credit completed
    call get_CGPA(my_student_id,CGPA);
    -- raise notice 'Value: %', CGPA;
    if CGPA<=5 then 
        is_ready = false;
    end if;
    s1 = CONCAT('courses_of_this_student',my_student_id);

    select program_core_credit,science_core_credit ,open_elective_credit ,program_elective_credit into credits_required from credit_requirement_to_graduate where batch in (select student.batch from student where student.student_id=my_student_id);



    select batch into which_batch from student where student.student_id=my_student_id;
    -- create table s1(offering_id integer, course_id varchar(20), credit double precision);


    -- iterate through all the courses offering of the students from student transcript and add it into a table 
    -- find their course_id 
    -- for each course id, check in which of the four buckets the course lies and add its credit into the 
    s2 = CONCAT('student_transcript_',my_student_id);
    s3 = CONCAT('select * from ',s2);
    -- raise notice 'Value: %', s2;
    
    for i in execute s3 LOOP


        call which_course_from_offering_id(i.offering_id,which_course);
        -- raise notice 'Value course: %', which_course;


        c1 = 0;
        p1 = 0;
        call is_it_program_core(which_course,c1);
        if c1=1 then 
            call get_credits_from_course_id(which_course,p1);
            program_core_credit_comp = program_core_credit_comp + p1;
        end if;

        c1 = 0;
        p1 = 0;
        call is_it_science_core(which_course,c1);
        if c1=1 then 
            call get_credits_from_course_id(which_course,p1);
            science_core_credit_comp = science_core_credit_comp + p1;
        end if;

        c1 = 0;
        p1 = 0;
        call is_it_open(which_course,c1);
        if c1=1 then 
            call get_credits_from_course_id(which_course,p1);
            open_elective_credit_comp = open_elective_credit_comp + p1;
            -- raise notice 'Value of p1: %', p1;
        end if;

        c1 = 0;
        p1 = 0;
        call is_it_program(which_course,c1);
        if c1=1 then 
            call get_credits_from_course_id(which_course,p1);
            program_elective_credit_comp = program_elective_credit_comp + p1;
        end if;
    end LOOP;
    
    -- raise notice 'Value of program_core_credit_comp: %', program_core_credit_comp;
    -- raise notice 'Value of open_elective_credit_comp: %', open_elective_credit_comp;
    -- raise notice 'Value of program_elective_credit_comp: %', program_elective_credit_comp;
    -- raise notice 'Value of science_core_credit_comp: %', science_core_credit_comp;
    

    if program_core_credit_comp>=credits_required.program_core_credit AND science_core_credit_comp>=credits_required.science_core_credit AND open_elective_credit_comp>=credits_required.open_elective_credit AND program_elective_credit_comp>=credits_required.program_elective_credit AND is_ready=true then
        return true;
    end if;

    return false;
end;
$$;

select is_ready_to_graduate('1');
