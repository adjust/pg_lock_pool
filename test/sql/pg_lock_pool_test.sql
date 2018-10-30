SELECT get_lock_pool(999,3,1);
SELECT get_lock_pool(999,3);
SELECT pg_advisory_unlock(999,1);
BEGIN;
SELECT get_xact_lock_pool(999,3,1);
SELECT get_xact_lock_pool(999,3);
END;