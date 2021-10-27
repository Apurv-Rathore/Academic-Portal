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


select offer_course(10,'HS202','1',2019,1,'1','1', ARRAY [2019], '{"01:00:00", "01:50:00", "01:00:00", "01:50:00", "01:00:00", "01:50:00", "01:00:00", "01:50:00", "01:00:00", "01:50:00"}'::TIME[] );

