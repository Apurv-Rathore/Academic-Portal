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
        query_tcredits = CONCAT('select sum(credits) from ', tablename, ' where grade > 0');
        query_tgrades = CONCAT('select sum(credits*grade) from ', tablename , ' where grade > 0');
        execute query_tcredits into total_credits;
        execute query_tgrades into total_grades;
        CGPA = round(total_grades/total_credits, 2);
        raise notice 'Value of cgpa: %', CGPA;
    END
    $$
LANGUAGE plpgsql;

CREATE or REPLACE PROCEDURE show_CGPA(
    IN student_id varchar(10)
    )
    AS
    $$
    DECLARE
        tablename varchar(200);
        query_tcredits varchar;
        query_tgrades varchar;
        total_credits integer;
        total_grades integer;
        CGPA double precision;
    BEGIN
        -- ########### UPDATE THIS ########### 
        SELECT CONCAT('student_transcript_', student_id) into tablename;
        query_tcredits = CONCAT('select sum(credits) from ', tablename, ' where grade > 0');
        query_tgrades = CONCAT('select sum(credits*grade) from ', tablename , ' where grade > 0');
        execute query_tcredits into total_credits;
        execute query_tgrades into total_grades;
        CGPA = round(total_grades/total_credits, 2);
        raise notice 'Value of cgpa: %', CGPA;
    END
    $$
LANGUAGE plpgsql;

CREATE or REPLACE PROCEDURE create_ticket(_student_id varchar(20), _offering_id integer)
    AS
    $$
    DECLARE 
        student_tablename varchar;
        s1 varchar;
    BEGIN
        student_tablename = CONCAT('student_ticket_table_', _student_id);
        s1 = CONCAT('INSERT INTO ',student_tablename,'(offering_id, recognized_by_instructor)
        VALUES (',_offering_id,', false);');
        EXECUTE s1;
        
    END;
    $$
    LANGUAGE plpgsql;

CREATE or REPLACE PROCEDURE update_ticket_instructor(_inst_id varchar(20), _student_id varchar(20), _offering_id integer, _has_accepted_instructor varchar)
    AS
    $$
    DECLARE 
        inst_tablename varchar;
        s1 varchar;
    BEGIN
        inst_tablename = CONCAT('instructor_ticket_table_',_inst_id);

        s1 = CONCAT('UPDATE ', inst_tablename,
        ' SET has_accepted_instructor = ', _has_accepted_instructor, 
        ' WHERE student_id = ''', _student_id, ''' AND offering_id = ', _offering_id);
         
        EXECUTE s1;
    END;
    $$
    LANGUAGE plpgsql SECURITY DEFINER;

CREATE or REPLACE PROCEDURE update_ticket_batch_advisor(_student_id varchar(20), _offering_id integer, _has_accepted_batch_advisor boolean)
    AS
    $$
    DECLARE
        _has_accepted_instructor boolean;
    BEGIN
        UPDATE batch_advisor_ticket_table
        SET has_accepted_batch_advisor = _has_accepted_batch_advisor
        WHERE student_id = _student_id AND offering_id = _offering_id;
    END;
    $$
    LANGUAGE plpgsql SECURITY DEFINER;


CREATE or REPLACE PROCEDURE update_ticket_dean_academics(_student_id varchar(20), _offering_id integer, _has_accepted_dean varchar)
    AS
    $$
    DECLARE
        s1 varchar;
        student_tablename varchar;
        _year integer;
        _semester integer;
        _course_id varchar;
        _credits double precision;
    BEGIN
        student_tablename = CONCAT('student_ticket_table_', _student_id);

        s1 = CONCAT('UPDATE ', student_tablename,
        ' SET is_accepted = ', _has_accepted_dean, 
        ' WHERE offering_id = ', _offering_id);
        EXECUTE s1;

        s1 = CONCAT('UPDATE dean_academics_ticket_table 
         SET has_accepted_dean = ', _has_accepted_dean, 
        ' WHERE student_id = ''', _student_id, ''' AND offering_id = ', _offering_id);
        EXECUTE s1;
        select year, semester, course_id into _year, _semester, _course_id from course_offering where offering_id = _offering_id;
        select C into _credits from course_catalogue where course_id = _course_id;

        if _has_accepted_dean
        then
            EXECUTE 'INSERT INTO student_transcript_' || _student_id || '(offering_id, year, semester, credits) VALUES($1, $2, $3, $4)' using  _offering_id, _year, _semester, _credits;
            EXECUTE 'INSERT INTO course_offering_grades_' || _offering_id || '(student_id) VALUES($1)' using  _student_id;
        end if;

    END;
    $$
    LANGUAGE plpgsql SECURITY DEFINER;

CREATE or REPLACE PROCEDURE get_student_tickets(_inst_id varchar(20))
    AS
    $$
    DECLARE
        i record;
        j record;
        s1 varchar;
        s2 varchar;
        inst_tablename varchar;
        student_tablename varchar;
    BEGIN
        CREATE TABLE inst_offering_ids(offering_id integer);
        
        for i in select offering_id 
            from course_offering 
            where instructor_id = _inst_id
        LOOP
            INSERT INTO inst_offering_ids(offering_id) 
            VALUES (i.offering_id);
        END LOOP;

        inst_tablename = CONCAT('instructor_ticket_table_',_inst_id);
        for i in select student_id 
            from student
        LOOP
            student_tablename = CONCAT('student_ticket_table_',i.student_id);
            s1 = CONCAT('select st.offering_id from ',student_tablename, 
            ' st, inst_offering_ids io where st.offering_id = io.offering_id and recognized_by_instructor = false');
            for j in EXECUTE s1
            LOOP
                s2 = CONCAT('INSERT INTO ',inst_tablename,'(student_id, offering_id) 
                            VALUES(', i.student_id, ', ',j.offering_id, ')');
                
                EXECUTE s2;

                s2 = CONCAT('UPDATE ',student_tablename, 
                ' SET recognized_by_instructor = true 
                 WHERE offering_id = ', j.offering_id);
                  
                EXECUTE s2;
            END LOOP;
        END LOOP;

        DROP TABLE inst_offering_ids;

    END;
    $$
    LANGUAGE plpgsql;


CREATE or REPLACE PROCEDURE get_instructor_tickets()
    AS
    $$
    DECLARE
        i record;
        j record;
        s1 varchar;
        s2 varchar;
        inst_tablename varchar;
    BEGIN
        for i in select instructor_id 
            from instructor
        LOOP
            inst_tablename = CONCAT('instructor_ticket_table_',i.instructor_id);
            s1 = CONCAT('select it.student_id, it.offering_id, it.has_accepted_instructor from ',inst_tablename, 
                    ' it where (it.has_accepted_instructor = true or it.has_accepted_instructor = false)
                     and it.recognized_by_batch_advisor = false');

            for j in EXECUTE s1
            LOOP
                INSERT INTO batch_advisor_ticket_table(student_id, offering_id, has_accepted_instructor) 
                VALUES (j.student_id, j.offering_id, j.has_accepted_instructor);
                
                s2 = CONCAT('UPDATE ', inst_tablename, 
                ' SET recognized_by_batch_advisor = true 
                 WHERE student_id = ''', j.student_id, ''' AND offering_id = ', j.offering_id);
                EXECUTE s2;

            END LOOP;
        END LOOP;

    END;
    $$
    LANGUAGE plpgsql SECURITY DEFINER;


CREATE or REPLACE PROCEDURE get_batch_advisor_tickets()
    AS
    $$
    DECLARE
        i record;
        j record;
        s1 varchar;
    BEGIN

        for j in select bt.student_id, bt.offering_id, bt.has_accepted_instructor, bt.has_accepted_batch_advisor
            from batch_advisor_ticket_table bt
            where (bt.has_accepted_batch_advisor = true or bt.has_accepted_batch_advisor = false) and bt.recognized_by_dean = false
        LOOP

            INSERT INTO dean_academics_ticket_table(student_id, offering_id, has_accepted_instructor, has_accepted_batch_advisor) 
            VALUES (j.student_id, j.offering_id, j.has_accepted_instructor, j.has_accepted_batch_advisor);

            s1 = CONCAT('UPDATE batch_advisor_ticket_table
                 SET recognized_by_dean = true 
                 WHERE student_id = ''', j.student_id, ''' AND offering_id = ', j.offering_id);
            
            EXECUTE s1;

        END LOOP;

    END;
    $$
    LANGUAGE plpgsql SECURITY DEFINER;



-- call create_ticket('2', 4);   -- inst = 4
-- call create_ticket('3', 2);   -- inst = 3

-- call get_student_tickets('1');
-- call get_student_tickets('2');
-- call get_student_tickets('3');
-- call get_student_tickets('4');

-- call update_ticket_instructor('3', '3', 2, 'true');
-- call update_ticket_instructor('4', '2', 4, 'true');

-- call get_instructor_tickets();

-- call update_ticket_batch_advisor('3', 2, 'true');
-- call update_ticket_batch_advisor('2', 4, 'false');

-- call get_batch_advisor_tickets();

-- call update_ticket_dean_academics('3', 2, 'true');
-- call update_ticket_dean_academics('2', 4, 'false');


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


-- CALL offer_course(1,'NS103','1',2019,1,'1', ARRAY [2019,2020,2021], 1);



create or replace PROCEDURE delete_course_offering(_offering_id integer)
AS
$$
begin
    DELETE FROM course_offering
    WHERE offering_id = _offering_id;
end;
$$
language plpgsql SECURITY DEFINER;



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
        s2 = CONCAT('select ' ,'course_offering_grades_' , t_row.offering_id,'.','student_id,','course_offering_grades_' , t_row.offering_id,'.','grade from course_offering_grades_' , t_row.offering_id);
        for i in execute s2 LOOP
            s2 = CONCAT('UPDATE ', 'student_transcript_',i.student_id,' SET grade=',i.grade,' WHERE offering_id=',t_row.offering_id);


            -- s2 = CONCAT('INSERT INTO ', 'student_transcript_',i.student_id,'(offering_id,year,semester,grade) VALUES (',i.offering_id,',',t_row.year,',',t_row.semester,',',i.grade,')');
            execute s2;
        END LOOP;
    END LOOP;
end;
$$
language plpgsql SECURITY DEFINER;


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
    language plpgsql SECURITY DEFINER;




create or replace function count_credits(
    my_student_id varchar(10),
    curr_year integer,
    curr_semester integer
)
returns double precision
language plpgsql SECURITY DEFINER
as
$$
declare
    credits double precision := 0;
    y1 integer;
    y2 integer;
    s1 integer;
    s2 integer;
    queryx text;
    i record;
    first_sem boolean := true;
    second_sem boolean := true;
begin
    if curr_semester = 2 then
        s2 = 1;
        s1 = 2;
        y2 = curr_year;
        y1 = curr_year - 1;
    else
        s2 = 2;
        s1 = 1;
        y2 = curr_year - 1;
        y1 = curr_year - 1;
    end if;
    queryx := 'select * from student_transcript_' || my_student_id;
    for i in execute queryx
    loop
        if (i.year = y1 and i.semester = s1) or (i.year = y2 and i.semester = s2) then
            credits := credits + i.credits;
        end if;
        if i.year = y1 and i.semester = s1 then
            first_sem = false;
        end if;
        if i.year = y2 and i.semester = s2 then
            second_sem = false;
        end if;
    end loop;
    if first_sem or second_sem then
        return 24;
    end if;
    return credits;
end;
$$;

create or replace function clash_decision(
    s1 time,
    e1 time,
    s2 time,
    e2 time
)
returns boolean
language plpgsql SECURITY DEFINER
as
$$
declare
    is_collision boolean := false;
begin
    if s1 <= e2 and e1 >= s2 then
        is_collision = true;
    end if;
    return is_collision;
end
$$; 



create or replace function offering_id_to_course_id(
    given_offering_id integer
)
returns varchar(20)
language plpgsql SECURITY DEFINER
as
$$
declare
    answer_course_id varchar(10) := 'NA';
    i record;
    query_past_courses text;
begin
    query_past_courses := 'select * from course_offering where offering_id = $1';
    for i in execute query_past_courses using given_offering_id
    loop
        answer_course_id := i.course_id;
        return answer_course_id;
    end loop;
    for i in select course_id
             from course_offering
             where offering_id = given_offering_id
    loop
        answer_course_id := i.course_id;
    end loop;

    return answer_course_id;
end
$$;



create or replace procedure transcript_generate(
    my_student_id varchar(10)
)
language plpgsql
as
$$
declare
    query text;
    i record;
    course_name text;
begin
    query := 'select * from student_transcript_'||my_student_id;
    raise notice 'course_name credits grade year semester';
    for i in execute query
    loop
        course_name:=offering_id_to_course_id(i.offering_id);
        raise notice '%     %     %     %     %',course_name,i.credits,i.grade,i.year,i.semester;
    end loop;
end
$$;

create or replace procedure insert_record_student_transcript(
    request_student_id varchar(20),
    request_offering_id integer,
    decision boolean
)
language plpgsql SECURITY DEFINER
as
$$
declare
    course_year integer;
    course_semester integer;
    credit_course double precision;
    course_name varchar(10);
begin
    select year, semester, course_id into course_year, course_semester, course_name
    from course_offering
    where offering_id = request_offering_id;

    select C into credit_course
    from course_catalogue
    where course_id = course_name;
    raise notice '% %',course_name, credit_course;

    if decision then
        delete from register_student_requests where student_id = request_student_id and offering_id = request_offering_id;
        EXECUTE 'INSERT INTO student_transcript_' || request_student_id || '(offering_id, year, semester, credits) VALUES($1, $2, $3, $4)' using  request_offering_id, course_year, course_semester, credit_course;
        EXECUTE 'INSERT INTO course_offering_grades_' || request_offering_id || '(student_id) VALUES($1)' using  request_student_id;
    else
        delete from register_student_requests where student_id = request_student_id and offering_id = request_offering_id;
    end if;
end
$$;


CREATE or REPLACE PROCEDURE grade_entry(
    IN request_student_id varchar(10),
    IN request_offering_id integer,
    IN grade_to_fill integer
)
AS
$$
DECLARE
BEGIN
    EXECUTE 'UPDATE course_offering_grades_' || request_offering_id || ' SET grade = $2 where student_id = $1' using  request_student_id, grade_to_fill;
END
$$
LANGUAGE plpgsql SECURITY DEFINER;


-- call insert_record_student_transcript('1', 3, true);

create or replace procedure register_student(
    my_student_id varchar(20),
    register_course_id varchar(20),
    curr_year integer,
    curr_semester integer,
    register_section_id varchar(20)
)
language plpgsql SECURITY DEFINER 
as
$$
declare
    i record;
    j record;
    grade_already integer;
    taken_slot_number integer;
    curr_slot_number integer;
    time_table record;
    curr_time_table record;
    completed integer := 0;
    eligible integer := 1;
    course_offering_id integer := -1;
    course_check_id varchar(10);
    taken_course_offering_id integer;
    time_clash boolean := false;
    student_batch integer;
    batches_allowed integer[];
    batch_itr integer;
    batch_eligibility boolean := false;
    queryx text;
    query_past_courses text;
    past_credits double precision;
    course_name_check varchar(20);
begin

    -- check if already registered
    queryx := 'select * from student_transcript_' || my_student_id || ' as st';

    for i in execute queryx
    loop

        execute 'select offering_id_to_course_id($3)' using i.year, i.semester, i.offering_id into course_check_id;

        if course_check_id = register_course_id then
            raise notice 'You are already registered in this course';
            return;
        end if;

    end loop;

    -- checking for prerequisites
    for i in select *
             from prerequisites
             where course_id = register_course_id
    loop

        completed := 0;
        for j in execute queryx
        loop
            execute 'select offering_id_to_course_id($3)' using j.year, j.semester, j.offering_id into course_name_check;
            if course_name_check = i.prerequisite_course_id then
                completed := 1;
            end if;
        end loop;

        if completed = 0 then
            raise notice 'You are not eligible for this course. Course % not completed.', i.prerequisite_course_id;
            eligible = 0;
        end if;

    end loop;
    
    if eligible = 0 then
        raise notice 'Prerequisites not completed. Registration Unsuccessful';
        return;
    end if;

    -- getting offering_id of course to be registered
    course_offering_id := -1;

    select offering_id into course_offering_id
    from course_offering
    where semester = curr_semester and year = curr_year and course_id = register_course_id and section_id = register_section_id;

    raise notice '% course_offering_id',course_offering_id;

    if not found then
        raise notice 'Course is not yet offered';
        return;
    end if;

    -- checking batch eligibility
    select allowed_batches into batches_allowed
    from course_offering
    where offering_id = course_offering_id;
    
    select batch into student_batch
    from student
    where student_id = my_student_id;

    foreach batch_itr in array batches_allowed
    loop
        if batch_itr = student_batch then
            batch_eligibility := true;
        end if;
    end loop;

    if not batch_eligibility then
        raise notice 'Batch Eligibility failed';
        return;
    end if;
    
    -- checking for time table collision

    select slot_number into curr_slot_number
    from course_offering
    where offering_id = course_offering_id;

    select * into curr_time_table
    from time_slots
    where slot_number = curr_slot_number;

    queryx := queryx || ' where st.grade = null';
    for i in execute queryx
    loop

        taken_course_offering_id = i.offering_id;

        select slot_number into taken_slot_number
        from course_offering
        where offering_id = taken_course_offering_id;

        select * into time_table
        from time_slots
        where slot_number = taken_slot_number;

        -- monday clash check
        time_clash = time_clash OR clash_decision(curr_time_table.monday_start, curr_time_table.monday_end, time_table.monday_start, time_table.monday_end);
        time_clash = time_clash OR clash_decision(curr_time_table.tuesday_start, curr_time_table.tuesday_end, time_table.tuesday_start, time_table.tuesday_end);
        time_clash = time_clash OR clash_decision(curr_time_table.wednesday_start, curr_time_table.wednesday_end, time_table.wednesday_start, time_table.wednesday_end);
        time_clash = time_clash OR clash_decision(curr_time_table.thursday_start, curr_time_table.thursday_end, time_table.thursday_start, time_table.thursday_end);
        time_clash = time_clash OR clash_decision(curr_time_table.friday_start, curr_time_table.friday_end, time_table.friday_start, time_table.friday_end);

        if time_clash then
            raise notice 'Time table clashes';
            return;
        end if;

    end loop;

    -- checking credit limit
    past_credits := 1.25 * count_credits(my_student_id, curr_year, curr_semester);
    
    insert into register_student_requests(offering_id,student_id) values (course_offering_id, my_student_id);
    raise notice 'Request for registration sent to the dean. Pending Approval.';
end
$$;

-- call register_student('1', 'CS302', 2021, 1, '1');


























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

create or replace procedure is_it_program_core(course_id_ varchar(50), _batch integer,  INOUT c1 integer)
language plpgsql as 
$$
declare
    i record ;
    s1 varchar;
begin

select * into i from program_core where program_core.course_id=course_id_ and batch = _batch;

-- raise notice 'Value: %', i;
if i is not null then
c1 = 1;
end if;
if i is null then
c1 = 0;
end if;
end;
$$;

create or replace procedure is_it_science_core(course_id_ varchar(50), _batch integer, INOUT c1 integer)
language plpgsql as 
$$
declare
    i record ;
begin
select * into i from science_core where science_core.course_id=course_id_ and batch = _batch;
-- raise notice 'Value: %', i;
if i is not null then
c1 = 1;
end if;
if i is null then
c1 = 0;
end if;
end;
$$;

create or replace procedure is_it_open(course_id_ varchar(50), _batch integer, INOUT c1 integer)
language plpgsql as 
$$
declare
    i record ;
begin
select * into i from open_elective where open_elective.course_id=course_id_ and batch = _batch;
if i is not null then
c1 = 1;
end if;
if i is null then
c1 = 0;
end if;
end;
$$;


create or replace procedure is_it_program(course_id_ varchar(50), _batch integer, INOUT c1 integer)
language plpgsql as 
$$
declare
    i record ;
begin
select * into i from program_elective where program_elective.course_id=course_id_ and batch = _batch;
-- raise notice 'Value: %', i;
if i is not null then
c1 = 1;
end if;
if i is null then
c1 = 0;
end if;
end;
$$;





create or replace procedure is_ready_to_graduate(
    my_student_id varchar(20)
)
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

    is_ready1 boolean;
begin
    is_ready = true;
    -- required credit completed
    call get_CGPA(my_student_id,CGPA);
    -- raise notice 'Value: %', CGPA;
    if CGPA<5 then 
        is_ready = false;
        raise notice 'CGPA < 5';
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

        select offering_id_to_course_id(i.offering_id) into which_course;
        -- raise notice 'Value course: %', which_course;


        c1 = 0;
        p1 = 0;
        call is_it_program_core(which_course, which_batch, c1);
        if c1=1 then 
            call get_credits_from_course_id(which_course,p1);
            program_core_credit_comp = program_core_credit_comp + p1;
        end if;

        c1 = 0;
        p1 = 0;
        call is_it_science_core(which_course, which_batch, c1);
        if c1=1 then 
            call get_credits_from_course_id(which_course,p1);
            science_core_credit_comp = science_core_credit_comp + p1;
        end if;

        c1 = 0;
        p1 = 0;
        call is_it_open(which_course, which_batch, c1);
        if c1=1 then 
            call get_credits_from_course_id(which_course,p1);
            open_elective_credit_comp = open_elective_credit_comp + p1;
            -- raise notice 'Value of p1: %', p1;
        end if;

        c1 = 0;
        p1 = 0;
        call is_it_program(which_course,which_batch, c1);
        if c1=1 then 
            call get_credits_from_course_id(which_course,p1);
            program_elective_credit_comp = program_elective_credit_comp + p1;
        end if;
    end LOOP;
    
    -- raise notice 'Value of program_core_credit_comp: %', program_core_credit_comp;
    -- raise notice 'Value of open_elective_credit_comp: %', open_elective_credit_comp;
    -- raise notice 'Value of program_elective_credit_comp: %', program_elective_credit_comp;
    -- raise notice 'Value of science_core_credit_comp: %', science_core_credit_comp;
    
    is_ready1 = true;

    if program_core_credit_comp<credits_required.program_core_credit
    then
        is_ready1 = false;
        raise notice 'Program core credits are less';
    end if;

    if science_core_credit_comp<credits_required.science_core_credit
    then
        is_ready1 = false;
        raise notice 'Science core credits are less';
    end if;

    if open_elective_credit_comp<credits_required.open_elective_credit
    then
        is_ready1 = false;
        raise notice 'Open elective credits are less';
    end if;

    if program_elective_credit_comp<credits_required.program_elective_credit
    then
        is_ready1 = false;
        raise notice 'Program elective credits are less';
    end if;

    if is_ready and is_ready1
    then 
        raise notice 'Ready to graduate.';
    else
        raise notice 'Not ready to graduate.';
    end if;
end;
$$;

-- call is_ready_to_graduate('1');






create or replace procedure grade_entry_csv (
in csv_path text,
in c_offering_id integer
)
language plpgsql security definer
as
$$
declare
   i record;
   _student_id varchar(20);
   put_grade integer;
   s1  varchar;
begin
 
   create table temp_table (
       student_id varchar(20) not null,
       grade varchar(20)
   );


   s1 = 'copy temp_table from ''' || csv_path || ''' with delimiter
   '','' CSV HEADER';
   execute s1;
   
   for i in select *
            from temp_table
   loop
       _student_id = i.student_id;
       put_grade = i.grade::int;
       EXECUTE 'UPDATE course_offering_grades_' || c_offering_id || ' SET grade = $2 WHERE student_id = $1' using  _student_id, put_grade;
   end loop;

   drop table temp_table;
end
$$;



create or replace procedure timeslots_entry_csv (
in csv_path text
)
language plpgsql security definer
as
$$
declare
    s1 varchar;
begin
   s1 = 'copy time_slots from ''' || csv_path || ''' with delimiter
   '','' CSV HEADER';
   execute s1;
end
$$;
