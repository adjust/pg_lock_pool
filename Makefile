EXTENSION = pg_lock_pool
EXTVERSION = $(shell grep default_version $(EXTENSION).control | \
                sed -e "s/default_version[[:space:]]*=[[:space:]]*'\([^']*\)'/\1/")
PG_CONFIG ?= pg_config
DATA = $(wildcard *--*.sql)
PGXS := $(shell $(PG_CONFIG) --pgxs)
TESTS        = $(wildcard test/sql/*.sql)
REGRESS      = $(patsubst test/sql/%.sql,%,$(TESTS))
REGRESS_OPTS = --inputdir=test \
			   --load-extension=$(EXTENSION) 

SQLSRC = $(wildcard sql/*.sql)
include $(PGXS)

all: $(EXTENSION)--$(EXTVERSION).sql

$(EXTENSION)--$(EXTVERSION).sql: $(SQLSRC)
	@printf -- "-- complain if script is sourced in psql, rather than via CREATE EXTENSION\n" > $@
	@printf -- "\\\echo Use \"CREATE EXTENSION ${EXTENSION}\" to load this file. \quit\n\n" >> $@
	@cat $^ >> $@
