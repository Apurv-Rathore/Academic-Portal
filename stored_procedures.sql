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
        SELECT CONCAT('---student_transcript_----', student_id) into tablename;
        query_tcredits = CONCAT('select sum(credits) from ', tablename, ' where grade > 4');
        query_tgrades = CONCAT('select sum(credits*grade) from ', tablename , ' where grade > 4');
        execute query_tcredits into total_credits;
        execute query_tgrades into total_grades;
        CGPA = round(total_grades/total_credits, 2);
    END
    $$
    LANGUAGE plpgsql;


create or replace function offer_course(cgpa_constraint_inp double precision, course_idd varchar(10), instructor_idd varchar(10), 
year_inp integer,
semester_inp integer,
section_id_inp varchar(10),
classroom_inp varchar(10),
allowed_batches INT[],
time_slots_avaiable TIME[]) RETURNS INTEGER
AS
$$
declare 
    variable_name record;
    monday_start_var TIME ;
    monday_end_var TIME ;
    tuesday_start_var TIME ;
    tuesday_end_var TIME ;
    wednesday_start_var TIME ;
    wednesday_end_var TIME ;
    thursday_start_var TIME ;
    thursday_end_var TIME ;
    friday_start_var TIME ;
    friday_end_var TIME ;
    array_length INTEGER;
    offering_id integer;
    offering_id_record record;
begin


    monday_start_var := time_slots_avaiable[0];
    monday_end_var := time_slots_avaiable[1];
    tuesday_start_var := time_slots_avaiable[2];
    tuesday_end_var := time_slots_avaiable[3];
    wednesday_start_var := time_slots_avaiable[4];
    wednesday_end_var := time_slots_avaiable[5];
    thursday_start_var := time_slots_avaiable[6];
    thursday_end_var := time_slots_avaiable[7];
    friday_start_var := time_slots_avaiable[8];
    friday_end_var := time_slots_avaiable[9];

    for i in 1..10 loop
        raise notice 'Value: %', time_slots_avaiable[i];
    end loop;


    select slot_number
    into variable_name 
    from time_slots
    where 
    time_slots.monday_start  = time_slots_avaiable[1] AND 
    time_slots.monday_end  = time_slots_avaiable[2] AND 
    time_slots.tuesday_start = time_slots_avaiable[3] AND 
    time_slots.tuesday_end = time_slots_avaiable[4] AND 
    time_slots.wednesday_start  = time_slots_avaiable[5] AND 
    time_slots.wednesday_end = time_slots_avaiable[6] AND 
    time_slots.thursday_start  = time_slots_avaiable[7] AND 
    time_slots.thursday_end = time_slots_avaiable[8] AND 
    time_slots.friday_start  = time_slots_avaiable[9] AND 
    time_slots.friday_end = time_slots_avaiable[10] ; 

    raise notice 'Value: %', variable_name;

    INSERT INTO course_offering(
        course_id, instructor_id, year, semester, section_id, slot_number, classroom, cgpa_requirement
    )
    VALUES (course_idd, instructor_idd, year_inp, semester_inp, section_id_inp, variable_name.slot_number, classroom_inp, cgpa_constraint_inp);

    select course_offering.offering_id 
    into offering_id_record 
    from course_offering
    where 
    course_offering.course_id = course_idd AND 
    course_offering.instructor_id = instructor_idd AND 
    course_offering.year = year_inp AND 
    course_offering.semester = semester_inp AND 
    course_offering.section_id = section_id_inp AND 
    course_offering.slot_number = variable_name.slot_number AND 
    course_offering.classroom = classroom_inp AND 
    course_offering.cgpa_requirement = cgpa_constraint_inp;

    offering_id := offering_id_record.offering_id;

    array_length := array_length(allowed_batches,1);
    for i in 1..array_length loop
        insert into allowed_batches_for_offering(offering_id,batch) values (offering_id, allowed_batches[i]);
    end loop;

    RETURN 1;
end;
$$
language plpgsql;

-- to run :::  select offer_course(10,'HS202','1',2019,1,'1','1', ARRAY [2019], '{"01:00:00", "01:50:00", "01:00:00", "01:50:00", "01:00:00", "01:50:00", "01:00:00", "01:50:00", "01:00:00", "01:50:00"}'::TIME[] );



\copy section_offered_grades FROM 'D:\Semester 5\CS 301 Database\Phase 1\section_offered_grades.csv' delimiter ',' csv header;
