CREATE TABLE course_catalogue (
	course_id varchar(10) not null,
	name varchar(50) not null,
	L integer not null,
	T integer not null,
	P integer not null,
	PRIMARY KEY (id)
);
	
CREATE TABLE instructor (
	instructor_id varchar(255) not null,
	name varchar(50) not null,
);

Create table course_offering(
	offering_id varchar(10) not null,
	course_id varchar(10) not null,
	instructor_id varchar(10) not null, 
	year integer not null,
	semester integer not null,
	section_id varchar(10) not null,
	timeslot  varchar(5) not null,
	duration integer not null, // interval data type
	classroom varchar(5) not null,
	cgpa_requirement double precision, 
);

CREATE TABLE taken(
	student_id varchar(10),
	offering_id varchar(10) not null,
	FOREIGN KEY (offering_id)  
	REFERENCES course_offering (offering_id),
	PRIMARY KEY (student_id , offering_id)
);

CREATE TABLE student(
	student_id varchar(10) not null,
	name varchar(50) not null,
	CGPA double precision
);

CREATE TABLE student_transcript(
	student_id varchar(10) not null,
	course_id varchar(10),
	grade integer
);

CREATE TABLE course_offered_grades(
	student_id varchar(10) not null,
	grade integer
);

create ROLE student; 
create ROLE faculty WITH  CREATE ROLE "Faculty" WITH
	LOGIN
	NOSUPERUSER
	NOCREATEDB
	NOCREATEROLE
	INHERIT
	NOREPLICATION
	CONNECTION LIMIT -1;

create ROLE faculty WITH  CREATE ROLE "Batch_Advisor" WITH
	LOGIN
	NOSUPERUSER
	NOCREATEDB
	NOCREATEROLE
	INHERIT
	NOREPLICATION
	CONNECTION LIMIT -1;
    
create ROLE faculty WITH  CREATE ROLE "Dean_Academics_Office" WITH
	LOGIN
	NOSUPERUSER
	NOCREATEDB
	NOCREATEROLE
	INHERIT
	NOREPLICATION
	CONNECTION LIMIT -1;

-- psql -U apurv  -h 127.0.0.1 -d postgres