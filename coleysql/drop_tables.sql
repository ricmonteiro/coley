/* 
	Drop tables programatically
*/
	
DO $$
DECLARE
	tab record;
BEGIN

FOR tab IN SELECT table_name from information_schema.tables WHERE table_schema NOT IN ('information_schema','pg_catalog')
	LOOP
	EXECUTE 'DROP TABLE IF EXISTS "' || tab.table_name ||'" CASCADE ;';
	RAISE NOTICE 'Table % dropped!', tab.table_name;
	END LOOP;
END
$$;

COMMIT;

