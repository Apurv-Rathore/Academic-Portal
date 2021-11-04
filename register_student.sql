-- Register student for course (imp 1.25 times). 
-- A record will be inserted in taken table. 
-- The time slot of the course offering will be checked with the courses already taken by the student. 
-- Prerequisites will also be checked.

create or replace function count_credits(
    my_student_id varchar(10),
    curr_year integer,
    curr_semester integer
)
returns double precision
language plpgsql
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
language plpgsql
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
    given_year integer,
    given_semester integer,
    given_offering_id integer
)
returns varchar(20)
language plpgsql
as
$$
declare
    answer_course_id varchar(10) := 'NA';
    i record;
    query_past_courses text;
begin
    query_past_courses := 'select * course_offering_' || given_year || '_' || given_semester || ' where offering_id = given_offering_id';
    for i in execute query_past_courses
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

    for i in execute query
    loop
        course_name:=offering_id_to_course_id(i.year, i.semester, i.offering_id);
        raise notice '% % % % %',course_name,i.credits,i.grade,i.year,i.semester;
    end loop;
end
$$;

create or replace procedure insert_record_student_transcript(
    request_student_id varchar(20),
    request_offering_id integer,
    decision boolean
)
language plpgsql
as
$$
declare
    course_year integer;
    course_semester integer;
begin
    select year, semester into course_year, course_semester
    from course_offering
    where offering_id = request_offering_id;

    if decision then
        delete from register_student_requests where student_id = request_student_id and offering_id = request_offering_id;
        EXECUTE 'INSERT INTO student_transcript_' || request_student_id || '(offering_id, year, semester, grade) VALUES('|| request_offering_id ||', '|| course_year ||', '|| course_semester ||', ', null, ')';
    else
        delete from register_student_requests where student_id = request_student_id and offering_id = request_offering_id;
    end if;
end
$$;

create or replace procedure register_student(
    my_student_id varchar(20),
    register_course_id varchar(20),
    curr_year integer,
    curr_semester integer,
    register_section_id varchar(20)
)
language plpgsql as
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
begin

    -- check if already registered
    queryx := 'select * from student_transcript_' || my_student_id || ' as st';

    for i in execute queryx
    loop

        course_check_id := offering_id_to_course_id(i.year, i.semester, i.offering_id);

        if course_check_id = register_course_id then
            raise notice 'You are already registered in this course';
            return;
        end if;

    end loop;

    -- checking for prerequisites
    for i in select prerequisite_course_id
             from prerequisites
             where course_id = register_course_id
    loop

        select count(*) into completed
        from student_transcript as s
        where offering_id_to_course_id(s.year, s.semester, s.offering_id) = i.prerequisite_course_id and s.grade <> null;

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

call register_student('4', '1', 2020, 1, '1');

\copy time_slots FROM '/home/captain/Academic-Portal/time_slots.csv' delimiter ',' csv header;

-- call register_student('2019CS1067', 'CS301', 2000, 2, 'two');
