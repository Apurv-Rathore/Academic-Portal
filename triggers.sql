CREATE or REPLACE FUNCTION create_student_tables() 
    RETURNS TRIGGER 
    LANGUAGE PLPGSQL
AS $$
DECLARE
    s1 varchar;
    s2 varchar;
BEGIN
    s1 = CONCAT('CREATE TABLE student_transcript_', NEW.student_id ,'(offering_id integer, grade integer)');
    execute s1;
    s2 = CONCAT('CREATE TABLE student_ticket_table_', NEW.student_id, '(offering_id integer, has_accepted boolean)');
    execute s2;
RETURN NULL;
END;
$$;

CREATE TRIGGER check_student_insert
    AFTER INSERT ON student
    FOR EACH ROW
    EXECUTE PROCEDURE create_student_tables();




CREATE or REPLACE FUNCTION create_section_grade_table() 
    RETURNS TRIGGER 
    LANGUAGE PLPGSQL
AS $$
DECLARE
    s1 varchar;
    s2 varchar;
    cond integer;
BEGIN
    -- s2 = CONCAT('section_grades_', NEW.offering_id);
    s1 = CONCAT('CREATE TABLE IF NOT EXISTS section_grades_', NEW.offering_id ,' ( student_id varchar(10) not null, grade integer)');
    
    execute s1;
RETURN NULL;
END;
$$;


CREATE TRIGGER check_section_grade_table
    AFTER INSERT ON course_offering
    FOR EACH ROW
    EXECUTE PROCEDURE create_section_grade_table();
