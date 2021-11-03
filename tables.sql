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

CREATE TABLE department(
    name varchar(20),
    PRIMARY KEY (name)
);

CREATE TABLE instructor (
    instructor_id varchar(20) not null,
    name varchar(50) not null,
    dept_name varchar(20),
    PRIMARY KEY (instructor_id),
    FOREIGN KEY (dept_name) REFERENCES department(name)
);

CREATE TABLE time_slots(
    slot_number serial PRIMARY KEY,
    monday_start TIME,
    monday_end TIME,
    tuesday_start TIME,
    tuesday_end TIME,
    wednesday_start TIME,
    wednesday_end TIME,
    thursday_start TIME,
    thursday_end TIME,
    friday_start TIME,
    friday_end TIME
);

CREATE TABLE student(
    student_id varchar(20) not null,
    name varchar(50) not null,
    dept_name varchar(20) not null,
    batch integer not null,
    PRIMARY KEY (student_id),
    FOREIGN KEY (dept_name) REFERENCES department(name)
);

CREATE TABLE course_offering(
    offering_id SERIAL PRIMARY KEY,
    course_id varchar(20) not null,
    year integer not null,
    semester integer not null,
    section_id varchar(20) not null,
    instructor_id varchar(20) not null,
    slot_number integer not null,
    cgpa_requirement double precision,
    allowed_batches integer [] not null,
    FOREIGN KEY (course_id) REFERENCES course_catalogue(course_id),
    FOREIGN KEY (slot_number) REFERENCES time_slots(slot_number)
);

CREATE TABLE course_offering_year_semester(
    offering_id integer not null,
    course_id varchar(20) not null,
    section_id varchar(20) not null,
    instructor_id varchar(20) not null,
    cgpa_requirement double precision,
    allowed_batches integer [] not null,
    PRIMARY KEY (offering_id)
);

CREATE TABLE student_transcript_student_id(
    offering_id integer not null,
    year integer not null,
    semester integer not null,
    grade integer,
    PRIMARY KEY (offering_id)
);

CREATE TABLE course_offering_grades_offering_id(
    student_id varchar(20) not null,
    grade integer,
    offering_id varchar(20) not null,
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    PRIMARY KEY (student_id)
);

CREATE TABLE student_ticket_table_student_id(
    offering_id integer not null,
    is_accepted boolean,
    recognized_by_instructor boolean not null default false,
    PRIMARY KEY (offering_id),
    FOREIGN KEY (offering_id) REFERENCES course_offering(offering_id)
);

CREATE TABLE instructor_ticket_table_inst_id(
    student_id varchar(20) not null,
    offering_id integer not null,
    has_accepted_instructor boolean,
    recognized_by_batch_advisor boolean not null default false,
    PRIMARY KEY (student_id, offering_id),
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    FOREIGN KEY (offering_id) REFERENCES course_offering(offering_id)
);

CREATE TABLE batch_advisor_ticket_table(
    student_id varchar(20) not null,
    offering_id integer not null,
    recognized_by_dean boolean not null default false,
    has_accepted_instructor boolean,
    has_accepted_batch_advisor boolean,
    PRIMARY KEY (student_id, offering_id),
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    FOREIGN KEY (offering_id) REFERENCES course_offering(offering_id)
);

CREATE TABLE dean_academics_ticket_table(
    offering_id integer not null,
    student_id varchar(20) not null,
    has_accepted_instructor boolean,
    has_accepted_batch_advisor boolean,
    has_accepted_dean boolean,
    PRIMARY KEY (student_id, offering_id),
    FOREIGN KEY (student_id) REFERENCES student(student_id)
);

CREATE TABLE program_cores_batch_number(
    course_id varchar(20) not null,
    department varchar(20) not null,
    PRIMARY KEY(course_id)
);

CREATE TABLE open_elective_batch_number(
    course_id varchar(20) not null,
    department varchar(20) not null,
    PRIMARY KEY(course_id)
);

CREATE TABLE program_elective_batch_number(
    course_id varchar(20) not null,
    department varchar(20) not null,
    PRIMARY KEY(course_id)
);

CREATE TABLE sciece_core_batch_number(
    course_id varchar(20) not null,
    department varchar(20) not null,
    PRIMARY KEY(course_id)
);

CREATE TABLE credit_requirement_to_graduate(
    batch integer not null,
    program_core_credit double precision not null,
    science_core_credit double precision not null,
    open_elective_credit double precision not null,
    program_elective_credit double precision not null
);
