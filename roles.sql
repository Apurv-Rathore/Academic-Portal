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
    
create ROLE faculty WITH   
	LOGIN 
	NOSUPERUSER 
	NOCREATEDB 
	NOCREATEROLE 
	INHERIT 
	NOREPLICATION 
	CONNECTION LIMIT -1;

GRANT SELECT, REFERENCES ON course_catalogue to faculty;
GRANT SELECT, INSERT, UPDATE, DELETE ON prerequisites to faculty;
GRANT SELECT, REFERENCES ON department to faculty;
GRANT SELECT ON instructor to faculty;
GRANT SELECT, INSERT, UPDATE ON time_slots to faculty;
GRANT SELECT, INSERT, UPDATE ON course_offering to faculty;
GRANT SELECT ON instructor_ticket_table to faculty;

GRANT CONNECT ON DATABASE project1 TO student_role;
GRANT USAGE ON SCHEMA project_schema TO student_role;
GRANT SELECT ON TABLE instructor, course_offering, taken, student,  TO student_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA project_schema GRANT SELECT ON TABLES TO student_role;

GRANT CONNECT ON DATABASE project1 TO batch_advisor_role;
GRANT USAGE, CREATE ON SCHEMA project_schema TO batch_advisor_role;
GRANT SELECT ON TABLE course_catalogue, prerequisites, student, instructor, course_offering, taken, student_transcript, course_offered_grades, TO batch_advisor_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE ____ TO batch_advisor_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA project_schema GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO batch_advisor_role;
