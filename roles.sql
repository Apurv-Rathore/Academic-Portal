create ROLE student_role; 
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
    
create ROLE dean_role WITH   
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
GRANT SELECT ON "program_cores_batch_number" to student_role;
GRANT SELECT ON "open_elective_batch_number" to student_role;
GRANT SELECT ON "program_elective_batch_number" to student_role;
GRANT SELECT ON "science_core_batch_number" to student_role;
GRANT SELECT ON "credit_requirenment_to_graduate" to student_role;


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
GRANT SELECT ON "program_cores_batch_number" to faculty_role;
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
GRANT SELECT ON "program_cores_batch_number" to batch_advisor_role;
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
GRANT SELECT ON "program_cores_batch_number" to batch_advisor_role;
GRANT SELECT ON "open_elective_batch_number" to batch_advisor_role;
GRANT SELECT ON "program_elective_batch_number" to batch_advisor_role;
GRANT SELECT ON "science_core_batch_number" to batch_advisor_role;
GRANT SELECT ON "credit_requirenment_to_graduate" to batch_advisor_role;


GRANT CONNECT ON DATABASE project1 TO dean_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON course_catalogue to dean_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON prerequisites to dean_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON department to dean_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON instructor to dean_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON time_slots to dean_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON student to dean_role;
GRANT SELECT ON course_offering to dean_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON "course_offering_year_semester" to dean_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON "student_transcript_student_id" to dean_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON "course_offering_grades_offering_id" to dean_role;
GRANT UPDATE ON "student_ticket_table_student_id" to dean_role;
GRANT SELECT ON batch_advisor_ticket_table to dean_role;
GRANT SELECT, INSERT, UPDATE ON dean_academics_ticket_table to dean_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON "program_cores_batch_number" to dean_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON "open_elective_batch_number" to dean_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON "program_elective_batch_number" to dean_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON "science_core_batch_number" to dean_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON "credit_requirenment_to_graduate" to dean_role;
