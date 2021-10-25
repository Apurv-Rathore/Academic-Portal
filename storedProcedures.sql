-- Register student for course (imp 1.25 times). 
-- A record will be inserted in taken table. 
-- The time slot of the course offering will be checked with the courses already taken by the student. 
-- Prerequisites will also be checked.

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
    completed integer := 0;
    eligible integer := 1;
    course_offering_id integer := -1;
begin

    for i in select *
             from taken
    loop
        if i.offering_id.course_id = register_course_id then
            raise notice 'You are already registered in this course.';
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
        raise notice 'Registration Unsuccessful';
        return;
    end if;

    -- checking for time table collision
    
    select offering_id into course_offering_id
    from course_offering
    where semester = curr_semester and year = curr_year and course_id = register_course_id and section_id = required_section_id;

    if course_offering_id = -1 then
        raise notice 'Course is not yet offered';
    end if;

    for i in select offering_id
             from taken
             where student_id = my_student_id;
    loop
        -- checking logic to be implemented
    end loop;

end
$$;

