CREATE TABLE course_catalogue (
    course_id varchar(20) not null,
    name varchar(50) not null,
    L integer not null,
    T integer not null,
    P integer not null,
    S integer not null,
    C integer not null,
    PRIMARY KEY (course_id)
);

CREATE TABLE prerequisites (
    course_id varchar(20) not null,
    prerequisite_course_id varchar(20) not null,
    FOREIGN KEY (course_id) REFERENCES course_catalogue(course_id),
    FOREIGN KEY (prerequisite_course_id) REFERENCES course_catalogue(course_id)
);

CREATE TABLE department(name varchar(20), PRIMARY KEY (name));

CREATE TABLE instructor (
    instructor_id varchar(20) not null,
    name varchar(50) not null,
    dept_name varchar(20),
    PRIMARY KEY (instructor_id),
    FOREIGN KEY (dept_name) REFERENCES department(name)
);

CREATE TABLE time_slots(
    slot_number serial PRIMARY KEY,
    monday_start TIME ,
    monday_end TIME ,
    tuesday_start TIME ,
    tuesday_end TIME ,
    wednesday_start TIME ,
    wednesday_end TIME ,
    thursday_start TIME ,
    thursday_end TIME ,
    friday_start TIME ,
    friday_end TIME 
);

-- Create table course_offering(
--     offering_id serial PRIMARY KEY,
--     course_id varchar(20) not null,
--     year integer not null,
--     semester integer not null,
--     section_id varchar(20) not null,
--     instructor_id varchar(20) not null,
--     slot_number integer not null,
--     cgpa_requirement double precision,
--     FOREIGN KEY (instructor_id) REFERENCES instructor(instructor_id),
--     FOREIGN KEY (course_id) REFERENCES course_catalogue(course_id),
--     FOREIGN KEY (slot_number) REFERENCES time_slots(slot_number)
--     -- PRIMARY KEY at top
-- );

CREATE TABLE student(
    student_id varchar(20) not null,
    name varchar(50) not null,
    dept_name varchar(20) not null,
    CGPA double precision,
    credit1 double precision,
    credit2 double precision,
    batch integer not null,
    PRIMARY KEY (student_id)
);

-- dynamicly created
CREATE TABLE course_offering_instid(
    course_id varchar(20) not null,
    year integer not null,
    semester integer not null,
    section_id varchar(20) not null,
    slot_number integer not null,
    cgpa_requirement double precision,
    PRIMARY KEY (year, semester, section_id, course_id),
    FOREIGN KEY (course_id) REFERENCES course_catalogue(course_id),
    FOREIGN KEY (slot_number) REFERENCES time_slots(slot_number)
);

CREATE TABLE student_transcript(
    -- student_transcript_student_id
    course_id integer,
    grade integer,
    PRIMARY KEY (course_id)
);

CREATE TABLE section_offered_grades(
    -- section_offered_grades_offering id
    student_id varchar(20) not null,
    grade integer,
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    PRIMARY KEY (student_id)
);

CREATE TABLE instructor_ticket_table(
    student_id varchar(20) not null,
    PRIMARY KEY (student_id),
    FOREIGN KEY (student_id) REFERENCES student(student_id)
);

CREATE TABLE dean_academics_ticket_table(
    year integer not null,
    semester integer not null,
    section_id varchar(20) not null,
    course_id varchar(20) not null, 
    student_id varchar(20) not null,
    has_accepted_instructor boolean,
    has_accepted_batch_advisor boolean,
    PRIMARY KEY (year, semester, section_id, course_id, student_id),
    FOREIGN KEY (student_id) REFERENCES student(student_id)
);

CREATE TABLE batch_advisor_ticket_table(
    student_id varchar(20) not null,
    year integer not null,
    semester integer not null,
    section_id varchar(20) not null,
    course_id varchar(20) not null, 
    has_accepted_instructor boolean,
    PRIMARY KEY (year, semester, section_id, course_id, student_id),
    FOREIGN KEY (student_id) REFERENCES student(student_id)
);

CREATE TABLE student_ticket_table(
    student_id varchar(20) not null,
    year integer not null,
    semester integer not null,
    section_id varchar(20) not null,
    course_id varchar(20) not null, 
    has_accepted boolean,
    PRIMARY KEY (year, semester, section_id, course_id, student_id),
    FOREIGN KEY (student_id) REFERENCES student(student_id)
);

CREATE TABLE course_completed(
    student_id varchar(20) not null,
    course_id varchar(20) not null
);


