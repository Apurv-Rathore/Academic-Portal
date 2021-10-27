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

-- faculty
GRANT CONNECT ON DATABASE project1 TO faculty;
GRANT SELECT, REFERENCES ON course_catalogue to faculty;
GRANT SELECT ON prerequisites to faculty;
GRANT SELECT ON department to faculty;
GRANT SELECT, REFERENCES ON department to faculty;
GRANT SELECT ON instructor to faculty;
GRANT SELECT, REFERENCES ON time_slots to faculty;
-- GRANT SELECT, INSERT, DELETE, UPDATE ON student_transcript to faculty; grant that instrcutor the premission to do these when a student resgisters on his course

-- GRANT SELECT, INSERT, UPDATE ON course_offering_instid to faculty;
GRANT SELECT ON instructor_ticket_table to faculty;


-- student 
GRANT CONNECT ON DATABASE project1 TO student_role;
GRANT SELECT ON prerequisites to student_role;
GRANT SELECT ON department to student_role;
GRANT SELECT ON time_slots to student_role;
GRANT USAGE ON SCHEMA project_schema TO student_role;
GRANT SELECT ON TABLE instructor, taken, student,  TO student_role;
-- GRANT SELECT ON TABLE course_offering_instid TO student_role;

-- to do student_transcript
ALTER DEFAULT PRIVILEGES IN SCHEMA project_schema GRANT SELECT ON TABLES TO student_role;


-- batch advisor
GRANT CONNECT ON DATABASE project1 TO batch_advisor_role;
GRANT USAGE, CREATE ON SCHEMA project_schema TO batch_advisor_role;
GRANT SELECT ON TABLE course_catalogue, prerequisites, student, instructor, taken, student_transcript, course_offered_grades, TO batch_advisor_role;
-- to do student_transcript
-- SELECT ON TABLE course_offering_instid to batch_advisor_role;
GRANT SELECT ON time_slots to batch_advisor_role;
GRANT SELECT ON department to batch_advisor_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE ____ TO batch_advisor_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA project_schema GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO batch_advisor_role;


--  dean 

GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES ON course_catalogue to dean_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON prerequisites to dean_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON department to dean_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON instructor to dean_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON time_slots to dean_role;
-- GRANT SELECT on course_offering_instid to dean_role;
-- to do student_transcript
