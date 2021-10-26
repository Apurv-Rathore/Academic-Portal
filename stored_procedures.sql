CREATE or REPLACE PROCEDURE create_ticket(_student_id varchar(10), _offering_id integer)
    AS
    $$
    BEGIN
        INSERT INTO student_ticket_table(student_id, offering_id)
        VALUES (_student_id, _offering_id);
        INSERT INTO instructor_ticket_table(student_id, offering_id)
        VALUES (_student_id, _offering_id);
    END;
    $$
    LANGUAGE plpgsql;

CREATE or REPLACE PROCEDURE update_ticket_instructor(_student_id varchar(10), _offering_id integer, _has_accepted_instructor boolean)
    AS
    $$
    BEGIN
        INSERT INTO batch_advisor_ticket_table(student_id, offering_id, has_accepted_instructor)
        VALUES (_student_id, _offering_id, _has_accepted_instructor);
        DELETE FROM instructor_ticket_table 
        WHERE student_id = _student_id AND offering_id = _offering_id;
    END;
    $$
    LANGUAGE plpgsql;

CREATE or REPLACE PROCEDURE update_ticket_batch_advisor(_student_id varchar(10), _offering_id integer, _has_accepted_batch_advisor boolean)
    AS
    $$
    DECLARE
        _has_accepted_instructor boolean;
    BEGIN
        SELECT has_accepted_instructor 
        INTO _has_accepted_instructor 
        FROM batch_advisor_ticket_table 
        WHERE student_id = _student_id AND offering_id = _offering_id;

        INSERT INTO dean_academics_ticket_table(student_id, offering_id, has_accepted_instructor, has_accepted_batch_advisor)
        VALUES (_student_id, _offering_id, _has_accepted_instructor, _has_accepted_batch_advisor);

        DELETE FROM batch_advisor_ticket_table
        WHERE student_id = _student_id AND offering_id = _offering_id;
    END;
    $$
    LANGUAGE plpgsql;

CREATE or REPLACE PROCEDURE update_ticket_dean_academics(_student_id varchar(10), _offering_id integer, _has_accepted_dean_academics boolean)
    AS
    $$
    BEGIN
        UPDATE student_ticket_table
        SET has_accepted = _has_accepted_dean_academics
        WHERE student_id = _student_id AND offering_id = _offering_id;

        DELETE FROM dean_academics_ticket_table
        WHERE student_id = _student_id AND offering_id = _offering_id;
    END;
    $$
    LANGUAGE plpgsql;

-- call create_ticket('2', 4, false);
-- call create_ticket('3', 2, false);

-- call update_ticket_instructor('2', 4, true);
-- call update_ticket_instructor('3', 2, false);

-- call update_ticket_batch_advisor('2', 4, false);
-- call update_ticket_batch_advisor('3', 2, true);

-- call update_ticket_dean_academics('2', 4, false);
-- call update_ticket_dean_academics('3', 2, true);


CREATE or REPLACE PROCEDURE get_CGPA(
    IN student_id varchar(10),
    INOUT CGPA double precision)
    AS
    $$
    DECLARE
        tablename varchar(200);
        query_tcredits varchar;
        query_tgrades varchar;
        total_credits integer;
        total_grades integer;
    BEGIN
        -- ########### UPDATE THIS ########### 
        SELECT CONCAT('---student_transcript_----', student_id) into tablename;
        query_tcredits = CONCAT('select sum(credits) from ', tablename, ' where grade > 4');
        query_tgrades = CONCAT('select sum(credits*grade) from ', tablename , ' where grade > 4');
        execute query_tcredits into total_credits;
        execute query_tgrades into total_grades;
        CGPA = round(total_grades/total_credits, 2);
    END
    $$
    LANGUAGE plpgsql;




\copy section_offered_grades FROM 'D:\Semester 5\CS 301 Database\Phase 1\section_offered_grades.csv' delimiter ',' csv header;
