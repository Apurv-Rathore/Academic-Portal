CREATE or REPLACE FUNCTION create_student_tables() 
    RETURNS TRIGGER 
    LANGUAGE PLPGSQL
AS $$
DECLARE
    s1 varchar;
    s2 varchar;
    i record;
BEGIN
    s1 = CONCAT('CREATE TABLE student_transcript_', NEW.student_id ,'(offering_id integer not null,
                                                                        year integer not null,
                                                                        semester integer not null,
                                                                        grade integer,
                                                                        credits double precision,
                                                                        PRIMARY KEY (offering_id)
                                                                        )');
    execute s1;
    s2 = CONCAT('CREATE TABLE student_ticket_table_', NEW.student_id, '(offering_id integer not null, 
                                                                        is_accepted boolean, 
                                                                        recognized_by_instructor boolean not null default false,
                                                                        PRIMARY KEY (offering_id),
                                                                        FOREIGN KEY (offering_id) REFERENCES course_offering(offering_id)
                                                                        )');
    execute s2;

    for i in select instructor_id from instructor
		loop
			s1 = CONCAT('GRANT SELECT, UPDATE ON student_transcript_',NEW.student_id,' to instructor_',i.instructor_id );
			EXECUTE s1;
		end loop;
    
    for i in select instructor_id from instructor
		loop
			s1 = CONCAT('GRANT SELECT, UPDATE ON student_ticket_table_',NEW.student_id,' to instructor_',i.instructor_id );
			EXECUTE s1;
		end loop;

    s1 = CONCAT('GRANT SELECT, INSERT ON student_ticket_table_',NEW.student_id,' to student_', NEW.student_id);
    EXECUTE s1;

    s1 = CONCAT('GRANT SELECT ON student_transcript_',NEW.student_id,' to student_', NEW.student_id);
    EXECUTE s1;

    s1 = CONCAT('GRANT SELECT, INSERT, UPDATE, DELETE ON student_transcript_',NEW.student_id,' to dean' );
        EXECUTE s1;
    s1 = CONCAT('GRANT SELECT ON student_transcript_',NEW.student_id,' to batch_advisor' );
        EXECUTE s1;
    s1 = CONCAT('GRANT SELECT ON student_ticket_table_',NEW.student_id,' to dean');
    EXECUTE s1;

RETURN NULL;
END;
$$;

CREATE TRIGGER trigger_student_tables
    AFTER INSERT ON student
    FOR EACH ROW
    EXECUTE PROCEDURE create_student_tables();



CREATE or REPLACE FUNCTION create_offering_grade_table() 
    RETURNS TRIGGER 
    LANGUAGE PLPGSQL
AS $$
DECLARE
    s1 varchar;
    s2 varchar;
    i record;
    cond integer;
BEGIN
    s1 = CONCAT('CREATE TABLE IF NOT EXISTS course_offering_grades_', NEW.offering_id ,' ( student_id varchar(10) not null, 
                                                                                            grade integer,
                                                                                            FOREIGN KEY (student_id) REFERENCES student(student_id),
                                                                                            PRIMARY KEY (student_id)
                                                                                            )');
    
    execute s1;

    for i in select offering_id, instructor_id from course_offering
		loop
			s1 = CONCAT('GRANT SELECT ON course_offering_grades_',i.offering_id,' to instructor_',i.instructor_id );
			EXECUTE s1;
		end loop;
    s1 = CONCAT('GRANT SELECT ON course_offering_grades_',NEW.offering_id,' to batch_advisor');
    EXECUTE s1;
    s1 = CONCAT('GRANT SELECT ON course_offering_grades_',NEW.offering_id,' to dean');
    EXECUTE s1;

RETURN NULL;
END;
$$;



CREATE TRIGGER trigger_grade_table
    AFTER INSERT ON course_offering
    FOR EACH ROW
    EXECUTE PROCEDURE create_offering_grade_table();



CREATE or REPLACE FUNCTION create_instructor_ticket_table() 
    RETURNS TRIGGER 
    LANGUAGE PLPGSQL
AS $$
DECLARE
    s1 varchar;
BEGIN
    s1 = CONCAT('CREATE TABLE IF NOT EXISTS instructor_ticket_table_', NEW.instructor_id, ' (student_id varchar(20) not null,
                                                                                            offering_id integer not null,
                                                                                            has_accepted_instructor boolean,
                                                                                            recognized_by_batch_advisor boolean not null default false,
                                                                                            PRIMARY KEY (student_id, offering_id),
                                                                                            FOREIGN KEY (student_id) REFERENCES student(student_id),
                                                                                            FOREIGN KEY (offering_id) REFERENCES course_offering(offering_id)
                                                                                            )');
    EXECUTE s1;

    s1 = CONCAT('GRANT SELECT, UPDATE ON instructor_ticket_table_',NEW.instructor_id, ' to batch_advisor');
    execute s1;
    s1 = CONCAT('GRANT SELECT, INSERT, UPDATE ON instructor_ticket_table_',NEW.instructor_id, ' to instructor_',NEW.instructor_id);
    execute s1;


RETURN NULL;
END;
$$;

CREATE TRIGGER trigger_instructor_ticket_table
    AFTER INSERT ON instructor
    FOR EACH ROW
    EXECUTE PROCEDURE create_instructor_ticket_table();    
