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