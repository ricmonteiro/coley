/* Programatically delete all content from tables and restart all sequences */

DO $$
DECLARE
	tab record;
	seq record;
BEGIN

/* Content deletion */
FOR tab IN SELECT table_name from information_schema.tables WHERE table_schema NOT IN ('information_schema','pg_catalog')
	LOOP
	EXECUTE 'DELETE FROM "' || tab.table_name ||'" ';
	RAISE NOTICE 'All rows from table % deleted!', tab.table_name;
	END LOOP;
	
/* Sequence restart */	
FOR seq IN SELECT sequencename from pg_sequences 
	LOOP
	EXECUTE 'ALTER SEQUENCE ' || seq.sequencename ||' RESTART';
	RAISE NOTICE 'Sequence % restarted!', seq.sequencename;
	END LOOP;
END
$$;

COMMIT;

