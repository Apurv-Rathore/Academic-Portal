create ROLE student; 
create ROLE faculty WITH 
	LOGIN 
	NOSUPERUSER 
	NOCREATEDB 
	NOCREATEROLE 
	INHERIT 
	NOREPLICATION 
	CONNECTION LIMIT -1;

create ROLE faculty WITH   
	LOGIN 
	NOSUPERUSER 
	NOCREATEDB 
	NOCREATEROLE 
	INHERIT 
	NOREPLICATION 
	CONNECTION LIMIT -1;
    
create ROLE dean WITH   
	LOGIN 
	NOSUPERUSER 
	NOCREATEDB 
	NOCREATEROLE 
	INHERIT 
	NOREPLICATION 
	CONNECTION LIMIT -1;



-- SELECT , INSERT , UPDATE , DELETE , TRUNCATE , REFERENCES , TRIGGER , CREATE , CONNECT , TEMPORARY , EXECUTE , and USAGE 

-- faculty_role
GRANT CONNECT ON DATABASE project1 TO faculty_role;
GRANT SELECT, REFERENCES ON course_catalogue to faculty_role;
GRANT SELECT ON prerequisites to faculty_role;
GRANT SELECT ON department to faculty_role;
GRANT SELECT, REFERENCES ON department to faculty_role;
GRANT SELECT ON instructor to faculty_role;
GRANT SELECT, REFERENCES ON student to faculty_role;
GRANT SELECT, REFERENCES ON time_slots to faculty_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON "course_offering_inst_id" to faculty_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON "student_transcript_student_id" to faculty_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON "course_year_sem_sec_grades" to faculty_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON "instructor_ticket_table_inst_id" to faculty_role;
GRANT INSERT ON batch_advisor_ticket_table to faculty_role;


-- GRANT SELECT, INSERT, DELETE, UPDATE ON student_transcript to faculty; grant that instrcutor the premission to do these when a student resgisters on his course

-- GRANT SELECT, INSERT, UPDATE ON course_offering_instid to faculty;
GRANT SELECT ON instructor_ticket_table to faculty;


-- student 
GRANT CONNECT ON DATABASE project1 TO student_role;
GRANT SELECT ON course_catalogue to student_role;
GRANT SELECT ON prerequisites to student_role;
GRANT SELECT ON department to student_role;
GRANT SELECT ON time_slots to student_role;
GRANT SELECT ON instructor to student_role;
-- GRANT SELECT ON student to student_role;
GRANT SELECT ON "course_offering_inst_id" to student_role;
GRANT SELECT, INSERT ON "student_transcript_student_id" to student_role;
GRANT INSERT ON "instructor_ticket_table_inst_id" to student_role;


GRANT USAGE ON SCHEMA project_schema TO student_role;
-- GRANT SELECT ON TABLE course_offering_instid TO student_role;

-- to do student_transcript
ALTER DEFAULT PRIVILEGES IN SCHEMA project_schema GRANT SELECT ON TABLES TO student_role;


--  dean 

GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES ON course_catalogue to dean_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON prerequisites to dean_role;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES ON department to dean_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON instructor to dean_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON time_slots to dean_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON student to dean_role;
GRANT SELECT ON "student_transcript_student_id" to dean_role;
GRANT SELECT ON "course_year_sem_sec_grades" to dean_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON dean_academics_ticket_table to dean_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON "student_ticket_table_student_id" to dean_role;


-- GRANT SELECT on course_offering_instid to dean_role;
-- to do student_transcript



-- batch advisor
GRANT CONNECT ON DATABASE project1 TO batch_advisor_role;
GRANT USAGE, CREATE ON SCHEMA project_schema TO batch_advisor_role;
GRANT SELECT ON TABLE course_catalogue, prerequisites, student, instructor, taken, student_transcript, course_offered_grades, TO batch_advisor_role;
-- to do student_transcript
-- SELECT ON TABLE course_offering_instid to batch_advisor_role;
GRANT SELECT ON time_slots to batch_advisor_role;
GRANT SELECT ON department to batch_advisor_role;
GRANT INSERT ON dean_academics_ticket_table to batch_advisor_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON batch_advisor_ticket_table to batch_advisor_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE ____ TO batch_advisor_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA project_schema GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO batch_advisor_role;
