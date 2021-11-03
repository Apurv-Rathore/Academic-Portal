CREATE or REPLACE PROCEDURE create_ticket(_student_id varchar(20), _offering_id integer)
    AS
    $$
    DECLARE 
        student_tablename varchar;
        s1 varchar;
    BEGIN
        student_tablename = CONCAT('student_ticket_table_', _student_id);
        s1 = CONCAT('INSERT INTO ',student_tablename,'(offering_id, recognized_by_instructor)
        VALUES (',_offering_id,', false);');
        EXECUTE s1;
        
    END;
    $$
    LANGUAGE plpgsql;

CREATE or REPLACE PROCEDURE update_ticket_instructor(_inst_id varchar(20), _student_id varchar(20), _offering_id integer, _has_accepted_instructor varchar)
    AS
    $$
    DECLARE 
        inst_tablename varchar;
        s1 varchar;
    BEGIN
        inst_tablename = CONCAT('instructor_ticket_table_',_inst_id);

        s1 = CONCAT('UPDATE ', inst_tablename,
        ' SET has_accepted_instructor = ', _has_accepted_instructor, 
        ' WHERE student_id = ''', _student_id, ''' AND offering_id = ', _offering_id);
         
        EXECUTE s1;
    END;
    $$
    LANGUAGE plpgsql;

CREATE or REPLACE PROCEDURE update_ticket_batch_advisor(_student_id varchar(20), _offering_id integer, _has_accepted_batch_advisor boolean)
    AS
    $$
    DECLARE
        _has_accepted_instructor boolean;
    BEGIN
        UPDATE batch_advisor_ticket_table
        SET has_accepted_batch_advisor = _has_accepted_batch_advisor
        WHERE student_id = _student_id AND offering_id = _offering_id;
    END;
    $$
    LANGUAGE plpgsql;


CREATE or REPLACE PROCEDURE update_ticket_dean_academics(_student_id varchar(20), _offering_id integer, _has_accepted_dean varchar)
    AS
    $$
    DECLARE
        s1 varchar;
        student_tablename varchar;
    BEGIN
        student_tablename = CONCAT('student_ticket_table_', _student_id);

        s1 = CONCAT('UPDATE ', student_tablename,
        ' SET is_accepted = ', _has_accepted_dean, 
        ' WHERE offering_id = ', _offering_id);
        EXECUTE s1;

        s1 = CONCAT('UPDATE dean_academics_ticket_table 
         SET has_accepted_dean = ', _has_accepted_dean, 
        ' WHERE student_id = ''', ''' AND offering_id = ', _offering_id);
    END;
    $$
    LANGUAGE plpgsql;

CREATE or REPLACE PROCEDURE get_student_tickets(_inst_id varchar(20))
    AS
    $$
    DECLARE
        i record;
        j record;
        s1 varchar;
        s2 varchar;
        inst_tablename varchar;
        student_tablename varchar;
    BEGIN
        CREATE TABLE inst_offering_ids(offering_id integer);
        
        for i in select offering_id 
            from course_offering 
            where instructor_id = _inst_id
        LOOP
            INSERT INTO inst_offering_ids(offering_id) 
            VALUES (i.offering_id);
        END LOOP;

        inst_tablename = CONCAT('instructor_ticket_table_',_inst_id);
        for i in select student_id 
            from student
        LOOP
            student_tablename = CONCAT('student_ticket_table_',i.student_id);
            s1 = CONCAT('select st.offering_id from ',student_tablename, 
            ' st, inst_offering_ids io where st.offering_id = io.offering_id and recognized_by_instructor = false');
            for j in EXECUTE s1
            LOOP
                s2 = CONCAT('INSERT INTO ',inst_tablename,'(student_id, offering_id) 
                            VALUES(', i.student_id, ', ',j.offering_id, ')');
                
                EXECUTE s2;

                s2 = CONCAT('UPDATE ',student_tablename, 
                ' SET recognized_by_instructor = true 
                 WHERE offering_id = ', j.offering_id);
                  
                EXECUTE s2;
            END LOOP;
        END LOOP;

        DROP TABLE inst_offering_ids;

    END;
    $$
    LANGUAGE plpgsql;


CREATE or REPLACE PROCEDURE get_instructor_tickets()
    AS
    $$
    DECLARE
        i record;
        j record;
        s1 varchar;
        s2 varchar;
        inst_tablename varchar;
    BEGIN
        for i in select instructor_id 
            from instructor
        LOOP
            inst_tablename = CONCAT('instructor_ticket_table_',i.instructor_id);
            s1 = CONCAT('select it.student_id, it.offering_id, it.has_accepted_instructor from ',inst_tablename, 
                    ' it where (it.has_accepted_instructor = true or it.has_accepted_instructor = false)
                     and it.recognized_by_batch_advisor = false');

            for j in EXECUTE s1
            LOOP
                INSERT INTO batch_advisor_ticket_table(student_id, offering_id, has_accepted_instructor) 
                VALUES (j.student_id, j.offering_id, j.has_accepted_instructor);
                
                s2 = CONCAT('UPDATE ', inst_tablename, 
                ' SET recognized_by_batch_advisor = true 
                 WHERE student_id = ''', j.student_id, ''' AND offering_id = ', j.offering_id);
                EXECUTE s2;

            END LOOP;
        END LOOP;

    END;
    $$
    LANGUAGE plpgsql;


CREATE or REPLACE PROCEDURE get_batch_advisor_tickets()
    AS
    $$
    DECLARE
        i record;
        j record;
        s1 varchar;
    BEGIN

        for j in select bt.student_id, bt.offering_id, bt.has_accepted_instructor, bt.has_accepted_batch_advisor
            from batch_advisor_ticket_table bt
            where (bt.has_accepted_batch_advisor = true or bt.has_accepted_batch_advisor = false) and bt.recognized_by_dean = false
        LOOP

            INSERT INTO dean_academics_ticket_table(student_id, offering_id, has_accepted_instructor, has_accepted_batch_advisor) 
            VALUES (j.student_id, j.offering_id, j.has_accepted_instructor, j.has_accepted_batch_advisor);

            s1 = CONCAT('UPDATE batch_advisor_ticket_table
                 SET recognized_by_dean = true 
                 WHERE student_id = ''', j.student_id, ''' AND offering_id = ', j.offering_id);
            
            EXECUTE s1;

        END LOOP;

    END;
    $$
    LANGUAGE plpgsql;



-- call create_ticket('2', 4);   -- inst = 4
-- call create_ticket('3', 2);   -- inst = 3

-- call get_student_tickets('1');
-- call get_student_tickets('2');
-- call get_student_tickets('3');
-- call get_student_tickets('4');

-- call update_ticket_instructor('3', '3', 2, 'true');
-- call update_ticket_instructor('4', '2', 4, 'true');

-- call get_instructor_tickets();

-- call update_ticket_batch_advisor('3', 2, 'true');
-- call update_ticket_batch_advisor('2', 4, 'false');

-- call get_batch_advisor_tickets();

-- call update_ticket_dean_academics('3', 2, 'true');
-- call update_ticket_dean_academics('2', 4, 'false');
