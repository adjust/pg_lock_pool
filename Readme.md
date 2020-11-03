![Build Status](https://github.com/adjust/pg_lock_pool/workflows/CI/badge.svg)

# pg_lock_pool

A postgres Extension to wait on a lock pool

The functions
get_lock_pool(pool int, poolsize int, timeout int )
get_xact_lock_pool(pool int, poolsize int, timeout int )
waits on a lock pool defined by key until timeout occurs.
The poolsize can be defined by the application for each call.
The timeout can be defined in seconds (defaults to 10).

On success the function returns a positive integer which can be used
to manually release the lock.
If timeout occurs the return value is -1.

Otherwise the lock is automatically released on session end (get_lock_pool)
or transaction end (get_xact_lock_pool)



### Usage

see test/expected/pg_lock_pool_test.out for examples

Session Level Lock

```SQL
-- wait 30 sec to get a lock from the pool of size 3
SELECT get_lock_pool(999, 3, 30);
 get_lock_pool
---------------
             1
(1 row)

-- release lock
SELECT pg_advisory_unlock(999, 1);
 pg_advisory_unlock
--------------------
 t
(1 row)

```

Transaction Level Lock

```SQL
-- wait 30 sec to get a lock from the pool of size 3
BEGIN;
SELECT get_xact_lock_pool(999, 3, 30);
 get_xact_lock_pool 
--------------------
                  1
(1 row)
END;
-- lock will be released on transaction end
```

### Installation

```shell
$ make install
```

```SQL
CREATE EXTENSION pg_lock_pool;
```
