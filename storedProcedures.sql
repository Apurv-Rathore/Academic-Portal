-- Register student for course (imp 1.25 times). 
-- A record will be inserted in taken table. 
-- The time slot of the course offering will be checked with the courses already taken by the student. 
-- Prerequisites will also be checked.

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

create or replace procedure register_student(
    my_student_id varchar(10),
    register_course_id varchar(10),
    curr_year integer,
    curr_semester integer,
    required_section_id varchar(10)
)
language plpgsql as
$$
declare
    i record;
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
begin

    -- check if already registered
    for i in select *
             from taken
             where student_id = my_student_id
    loop

        course_offering_id = i.offering_id;

        select course_id into course_check_id
        from course_offering
        where offering_id = course_offering_id;

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
        from course_completed
        where course_completed.course_id = i.prerequisite_course_id;

        if completed = 0 then
            raise notice 'You are not eligible for this course. Course % not completed.', i.prerequisite_course_id;
            eligible = 0;
        end if;

    end loop;
    
    if eligible = 0 then
        raise notice 'Prerequisites not completed. Registration Unsuccessful';
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
    
    course_offering_id := -1;

    select offering_id into course_offering_id
    from course_offering
    where semester = curr_semester and year = curr_year and course_id = register_course_id and section_id = required_section_id;

    raise notice '% course_offering_id',course_offering_id;

    if not found then
        raise notice 'Course is not yet offered';
        return;
    end if;

    select slot_number into curr_slot_number
    from course_offering
    where offering_id = course_offering_id;

    select * into curr_time_table
    from time_slots
    where slot_number = curr_slot_number;

    for i in select offering_id
             from taken
             where student_id = my_student_id
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

    insert into taken(offering_id,student_id) values (course_offering_id, my_student_id);
    raise notice 'Registration Successfully Completed';
end
$$;

\copy time_slots FROM '/home/captain/Academic-Portal/time_slots.csv' delimiter ',' csv header;

-- call register_student('2019CS1067', 'CS301', 2000, 2, 'two');