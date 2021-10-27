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
        select course_id into course_name
        from course_offering
        where offering_id = i.offering_id;

        raise notice '% %',i.course_name,i.grade;
    end loop;
end
$$;
