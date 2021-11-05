create USER student_ WITH
	PASSWORD 'student'
	NOSUPERUSER 
	NOCREATEDB 
	NOCREATEROLE 
	INHERIT 
	NOREPLICATION 
	CONNECTION LIMIT -1;

create ROLE batch_advisor_role WITH 
	LOGIN 
	NOSUPERUSER 
	NOCREATEDB 
	NOCREATEROLE 
	INHERIT 
	NOREPLICATION 
	CONNECTION LIMIT -1;

create ROLE faculty_role WITH   
	LOGIN 
	NOSUPERUSER 
	NOCREATEDB 
	NOCREATEROLE 
	INHERIT 
	NOREPLICATION 
	CONNECTION LIMIT -1;
    
create USER dean WITH   
	LOGIN 
	NOSUPERUSER 
	NOCREATEDB 
	NOCREATEROLE 
	INHERIT 
	NOREPLICATION 
	CONNECTION LIMIT -1;


-- student 
GRANT CONNECT ON DATABASE project1 TO student_role;
GRANT SELECT ON course_catalogue to student_role;
GRANT SELECT ON prerequisites to student_role;
GRANT SELECT ON department to student_role;
GRANT SELECT ON instructor to student_role;
GRANT SELECT ON time_slots to student_role;
GRANT SELECT ON student to student_role;
GRANT SELECT ON course_offering to student_role;
GRANT SELECT ON "course_offering_year_semester" to student_role;
GRANT SELECT ON "student_transcript_student_id" to student_role;
GRANT SELECT, INSERT ON "student_ticket_table_student_id" to student_role;
GRANT SELECT ON "program_core_batch_number" to student_role;
GRANT SELECT ON "open_elective_batch_number" to student_role;
GRANT SELECT ON "program_elective_batch_number" to student_role;
GRANT SELECT ON "science_core_batch_number" to student_role;
GRANT SELECT ON "credit_requirenment_to_graduate" to student_role;

GRANT student_role TO student_user

GRANT CONNECT ON DATABASE project1 TO faculty_role;
GRANT SELECT ON course_catalogue to faculty_role;
GRANT SELECT ON prerequisites to faculty_role;
GRANT SELECT ON department to faculty_role;
GRANT SELECT ON instructor to faculty_role;
GRANT SELECT ON time_slots to faculty_role;
GRANT SELECT ON student to faculty_role;
GRANT SELECT, INSERT ON course_offering to faculty_role;
GRANT SELECT ON "course_offering_year_semester" to faculty_role;
GRANT SELECT ON "student_transcript_student_id" to faculty_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON "course_offering_grades_offering_id" to faculty_role;
GRANT SELECT ON "student_ticket_table_student_id" to faculty_role;
GRANT SELECT, INSERT, UPDATE ON "instructor_ticket_table_inst_id" to faculty_role;
GRANT SELECT ON "program_core_batch_number" to faculty_role;
GRANT SELECT ON "open_elective_batch_number" to faculty_role;
GRANT SELECT ON "program_elective_batch_number" to faculty_role;
GRANT SELECT ON "science_core_batch_number" to faculty_role;
GRANT SELECT ON "credit_requirenment_to_graduate" to faculty_role;


GRANT CONNECT ON DATABASE project1 TO batch_advisor_role;
GRANT SELECT ON course_catalogue to batch_advisor_role;
GRANT SELECT ON prerequisites to batch_advisor_role;
GRANT SELECT ON department to batch_advisor_role;
GRANT SELECT ON instructor to batch_advisor_role;
GRANT SELECT ON time_slots to batch_advisor_role;
GRANT SELECT ON student to batch_advisor_role;
GRANT SELECT ON course_offering to batch_advisor_role;
GRANT SELECT ON "course_offering_year_semester" to batch_advisor_role;
GRANT SELECT ON "student_transcript_student_id" to batch_advisor_role;
GRANT SELECT ON "course_offering_grades_offering_id" to batch_advisor_role;
GRANT SELECT ON "instructor_ticket_table_inst_id" to batch_advisor_role;
GRANT SELECT, INSERT, UPDATE ON batch_advisor_ticket_table to batch_advisor_role;
GRANT SELECT ON "program_core_batch_number" to batch_advisor_role;
GRANT SELECT ON "open_elective_batch_number" to batch_advisor_role;
GRANT SELECT ON "program_elective_batch_number" to batch_advisor_role;
GRANT SELECT ON "science_core_batch_number" to batch_advisor_role;
GRANT SELECT ON "credit_requirenment_to_graduate" to batch_advisor_role;


GRANT CONNECT ON DATABASE project1 TO batch_advisor_role;
GRANT SELECT ON course_catalogue to batch_advisor_role;
GRANT SELECT ON prerequisites to batch_advisor_role;
GRANT SELECT ON department to batch_advisor_role;
GRANT SELECT ON instructor to batch_advisor_role;
GRANT SELECT ON time_slots to batch_advisor_role;
GRANT SELECT ON student to batch_advisor_role;
GRANT SELECT ON course_offering to batch_advisor_role;
GRANT SELECT ON "course_offering_year_semester" to batch_advisor_role;
GRANT SELECT ON "student_transcript_student_id" to batch_advisor_role;
GRANT SELECT ON "course_offering_grades_offering_id" to batch_advisor_role;
GRANT SELECT ON "instructor_ticket_table_inst_id" to batch_advisor_role;
GRANT SELECT, INSERT, UPDATE ON batch_advisor_ticket_table to batch_advisor_role;
GRANT SELECT ON "program_core_batch_number" to batch_advisor_role;
GRANT SELECT ON "open_elective_batch_number" to batch_advisor_role;
GRANT SELECT ON "program_elective_batch_number" to batch_advisor_role;
GRANT SELECT ON "science_core_batch_number" to batch_advisor_role;
GRANT SELECT ON "credit_requirenment_to_graduate" to batch_advisor_role;


GRANT CONNECT ON DATABASE project1 TO dean;
GRANT SELECT, INSERT, UPDATE, DELETE ON course_catalogue to dean;
GRANT SELECT, INSERT, UPDATE, DELETE ON prerequisites to dean;
GRANT SELECT, INSERT, UPDATE, DELETE ON department to dean;
GRANT SELECT, INSERT, UPDATE, DELETE ON instructor to dean;
GRANT SELECT, INSERT, UPDATE, DELETE ON time_slots to dean;
GRANT SELECT, INSERT, UPDATE, DELETE ON student to dean;
GRANT SELECT ON course_offering to dean;
-- GRANT SELECT, INSERT, UPDATE, DELETE ON "course_offering_year_semester" to dean;
-- GRANT SELECT, INSERT, UPDATE, DELETE ON "student_transcript_student_id" to dean;
-- GRANT SELECT, INSERT, UPDATE, DELETE ON "course_offering_grades_offering_id" to dean;
-- GRANT UPDATE ON "student_ticket_table_student_id" to dean;
GRANT SELECT ON batch_advisor_ticket_table to dean;
GRANT SELECT, INSERT, UPDATE ON dean_academics_ticket_table to dean;
-- GRANT SELECT, INSERT, UPDATE, DELETE ON "program_core_batch_number" to dean;
-- GRANT SELECT, INSERT, UPDATE, DELETE ON "open_elective_batch_number" to dean;
-- GRANT SELECT, INSERT, UPDATE, DELETE ON "program_elective_batch_number" to dean;
-- GRANT SELECT, INSERT, UPDATE, DELETE ON "science_core_batch_number" to dean;
-- GRANT SELECT, INSERT, UPDATE, DELETE ON "credit_requirenment_to_graduate" to dean;

GRANT SELECT, UPDATE, DELETE ON regster_student_requests to dean;




CREATE or REPLACE FUNCTION create_user_student()
	RETURNS TRIGGER
    AS
    $$
    DECLARE 
        s1 varchar;
		s2 varchar;
		username varchar;
		i record;
    BEGIN
		username = CONCAT('student_', NEW.student_id);

        s1 = CONCAT('create USER ', username, ' WITH
			PASSWORD ''student''
			NOSUPERUSER 
			NOCREATEDB 
			NOCREATEROLE 
			INHERIT 
			NOREPLICATION 
			CONNECTION LIMIT -1;');
		EXECUTE s1;

		s1 = CONCAT('GRANT USAGE ON SCHEMA public TO ', username);
		EXECUTE s1;

		s1 = CONCAT('GRANT CONNECT ON DATABASE project TO ', username);
		EXECUTE s1;
		s1 = CONCAT('GRANT SELECT ON course_catalogue to ', username);
		EXECUTE s1;
		s1 = CONCAT('GRANT SELECT ON prerequisites to ', username);
		EXECUTE s1;
		s1 = CONCAT('GRANT SELECT ON department to ', username);
		EXECUTE s1;
		s1 = CONCAT('GRANT SELECT ON instructor to ', username);
		EXECUTE s1;
		s1 = CONCAT('GRANT SELECT ON time_slots to ', username);
		EXECUTE s1;

		s1 = CONCAT('GRANT SELECT ON student to ', username);
		EXECUTE s1;
		s1 = CONCAT('GRANT SELECT ON course_offering to ', username);
		EXECUTE s1;
		s1 = CONCAT('GRANT SELECT ON program_core to ', username);
		EXECUTE s1;
		s1 = CONCAT('GRANT SELECT ON open_elective to ', username);
		EXECUTE s1;
		s1 = CONCAT('GRANT SELECT ON program_elective to ', username);
		EXECUTE s1;
		s1 = CONCAT('GRANT SELECT ON science_core to ', username);
		EXECUTE s1;
		s1 = CONCAT('GRANT SELECT ON credit_requirement_to_graduate to ', username);
		EXECUTE s1;
		s1 = CONCAT('GRANT INSERT ON register_student_requests to ', username);
		EXECUTE s1;
	RETURN NULL;
    END;
    $$
    LANGUAGE plpgsql;

CREATE TRIGGER create_user_student_trigger
    AFTER INSERT ON student
    FOR EACH ROW
    EXECUTE PROCEDURE create_user_student();


CREATE or REPLACE FUNCTION create_user_instructor()	
	RETURNS TRIGGER
    AS
    $$
    DECLARE 
        s1 varchar;
		s2 varchar;
		username varchar;
    BEGIN
		username = CONCAT('instructor_', NEW.instructor_id);

        s1 = CONCAT('create USER ', username, ' WITH
			PASSWORD ''instructor''
			NOSUPERUSER 
			NOCREATEDB 
			NOCREATEROLE 
			INHERIT 
			NOREPLICATION 
			CONNECTION LIMIT -1;');
		EXECUTE s1;

		s1 = CONCAT('GRANT USAGE ON SCHEMA public TO ', username);
		EXECUTE s1;
		s1 = CONCAT('GRANT CONNECT ON DATABASE project TO ', username);
		EXECUTE s1;
		s1 = CONCAT('GRANT SELECT, REFERENCES ON course_catalogue to ', username);
		EXECUTE s1;
		s1 = CONCAT('GRANT SELECT ON prerequisites to ', username);
		EXECUTE s1;
		s1 = CONCAT('GRANT SELECT ON department to ', username);
		EXECUTE s1;
		s1 = CONCAT('GRANT SELECT ON instructor to ', username);
		EXECUTE s1;
		s1 = CONCAT('GRANT SELECT ON time_slots to ', username);
		EXECUTE s1;

		s1 = CONCAT('GRANT SELECT, REFERENCES ON student to ', username);
		EXECUTE s1;
		s1 = CONCAT('GRANT SELECT, INSERT ON course_offering to ', username);
		EXECUTE s1;

		s1 = CONCAT('GRANT SELECT ON program_core to ', username);
		EXECUTE s1;
		s1 = CONCAT('GRANT SELECT ON open_elective to ', username);
		EXECUTE s1;
		s1 = CONCAT('GRANT SELECT ON program_elective to ', username);
		EXECUTE s1;
		s1 = CONCAT('GRANT SELECT ON science_core to ', username);
		EXECUTE s1;
		s1 = CONCAT('GRANT SELECT ON credit_requirement_to_graduate to ', username);
		EXECUTE s1;
	RETURN NULL;
    END;
    $$
    LANGUAGE plpgsql;

CREATE TRIGGER create_user_instructor_trigger
    AFTER INSERT ON instructor
    FOR EACH ROW
    EXECUTE PROCEDURE create_user_instructor();


