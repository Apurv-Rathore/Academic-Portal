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
