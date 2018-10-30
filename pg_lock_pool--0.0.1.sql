-- complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "CREATE EXTENSION pg_lock_pool" to load this file. \quit


CREATE OR REPLACE FUNCTION get_xact_lock_pool(key int, poolsize int, timeout int DEFAULT 10) RETURNS int AS $_$
DECLARE
    i int;
    j int;
    got_lock bool;

BEGIN
    i := 0;
    got_lock := false;

    WHILE NOT got_lock LOOP
        FOR j IN 1..poolsize LOOP
            got_lock := pg_try_advisory_xact_lock(key,j) ;
            IF got_lock THEN
                RETURN j;
            END IF;
        END LOOP;

        IF i >= timeout THEN
            RETURN -1;
        END IF;
        i := i+1;
        PERFORM pg_sleep(1);
    END LOOP;
END;
$_$ LANGUAGE plpgsql VOLATILE;

CREATE OR REPLACE FUNCTION get_lock_pool(key int, poolsize int, timeout int DEFAULT 10) RETURNS int AS $_$
DECLARE
    i int;
    j int;
    got_lock bool;

BEGIN
    i := 0;
    got_lock := false;

    WHILE NOT got_lock LOOP
        FOR j IN 1..poolsize LOOP
            got_lock := pg_try_advisory_lock(key,j) ;
            IF got_lock THEN
                RETURN j;
            END IF;
        END LOOP;

        IF i >= timeout THEN
            RETURN -1;
        END IF;
        i := i+1;
        PERFORM pg_sleep(1);
    END LOOP;
END;
$_$ LANGUAGE plpgsql VOLATILE;
