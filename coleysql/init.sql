BEGIN;
/* create coley tables */
CREATE TABLE "patients"(
    "id" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "patient_name" VARCHAR(255) NOT NULL,
    "patient_dob" DATE NOT NULL,
    "gender" CHAR(255) NOT NULL CONSTRAINT gender_check CHECK ( gender IN ('male', 'female','other') )
);


CREATE TABLE "tumortype"(
    "id" SMALLINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "tumor_description" VARCHAR(255) NOT NULL
);


CREATE TABLE "tissuetype"(
    "id" SMALLINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "tissue_description" VARCHAR(255) NOT NULL
);


CREATE TABLE "containers"(
    "id" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "container_name" VARCHAR(255) NOT NULL,
    "container_description" JSON NOT NULL
);


CREATE TABLE "temperature"(
    "id" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "temperature_desc" VARCHAR(255) NOT NULL
);


CREATE TABLE "cut"(
    "id" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "parent_cut_id" INTEGER NULL REFERENCES "cut"("id"),
    "user_id" INTEGER NOT NULL REFERENCES "auth_user"("id"),
    "purpose" VARCHAR(255) NOT NULL,
    "cut_date" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "sample_id" INTEGER NOT NULL REFERENCES "sample"("id")
);


CREATE TABLE "analysis"(
    "id" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "user_id" INTEGER NOT NULL REFERENCES "auth_user"("id"),
    "cut_id" INTEGER NOT NULL REFERENCES "cut"("id"),
    "date" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
    "result_xlsx_path" VARCHAR(255) NULL,
    "state" JSON NULL
);

    
CREATE TABLE "sample"(
    "id" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "user_id" INTEGER NOT NULL REFERENCES "auth_user"("id"),
    "origin" VARCHAR(255) NOT NULL,
    "patient_id" INTEGER NOT NULL REFERENCES "patients"("id"),
    "tumor_type_id" INTEGER NOT NULL REFERENCES "tumortype"("id"),
    "tissue_type_id" INTEGER NOT NULL REFERENCES "tissuetype"("id"),
    "entry_date" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "temperature_id" INTEGER NOT NULL REFERENCES "temperature"("id"),
    "container_id" SMALLINT NOT NULL REFERENCES "containers"("id"),
    "location" JSON NOT NULL
);


/* insert baseline data*/

    INSERT INTO auth_group (name) VALUES
    ('Admin'),
    ('Supervisor'),
    ('Technician'),
    ('Student');
	
   
    INSERT INTO auth_user_groups (user_id, group_id) VALUES
    (1,  1), -- admin as Admin, Supervisor, Technician and Student
    (1,  2),
    (1,  3),
    (1,  4);
           

    INSERT INTO temperature (temperature_desc) VALUES 
    ('-80ºC'),
    ('4ºC'),
    ('other');   
    
    INSERT INTO containers (container_name, container_desc) VALUES
    ('main freezer', {})
    
    /*"drawer 1": {
    "box 1": {
      "slot 1": 0, /* insert sample */
      "slot 2": 0,
      "slot 3": 0,
      "slot 4": 0,
      "slot 5": 0,
      "slot 6": 0
    },
    "box 2": {
      "slot 1": 0,
      "slot 2": 0,
      "slot 3": 0,
      "slot 4": 0,
      "slot 5": 0,
      "slot 6": 0
    },
    "box 3": {
      "slot 1": 0,
      "slot 2": 0,
      "slot 3": 0,
      "slot 4": 0,
      "slot 5": 0,
      "slot 6": 0
    }
  },
  "drawer 2": {
    "box 1": {
      "slot 1": 0,
      "slot 2": 0,
      "slot 3": 0,
      "slot 4": 0,
      "slot 5": 0,
      "slot 6": 0w
    },
    "box 2": {
      "slot 1": 0,
      "slot 2": 0,
      "slot 3": 0,
      "slot 4": 0,
      "slot 5": 0,
      "slot 6": 0
    },
    "box 3": {
      "slot 1": 0,
      "slot 2": 0,
      "slot 3": 0,
      "slot 4": 0,
      "slot 5": 0,
      "slot 6": 0
    }
  }});*/

    INSERT INTO tumortype (tumor_description) VALUES
    ('pancreatic cancer'),
    ('liver cancer'),
    ('bladder cancer');
    
    INSERT INTO tissuetype (tissue_description) VALUES
    ('blood'),
    ('liver'),
    ('connective tissue'),
    ('skin');


/* create functions and procedures */

CREATE FUNCTION public.authenticated_user(userid integer) RETURNS json
    LANGUAGE plpgsql
    AS $$
BEGIN


RETURN (SELECT json_build_object('id',id,'first_name', first_name, 'last_name', last_name,'username', username) FROM auth_user WHERE id = userid);

END$$;


ALTER FUNCTION public.authenticated_user(userid integer) OWNER TO postgres;

CREATE PROCEDURE public.create_new_patient(name text, dob date, pgender text)
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO patients(patient_name, patient_dob, gender)
	VALUES (name, dob, pgender);
	
COMMIT;
RAISE INFO 'Patient registered successfully';
END;
$$;

ALTER PROCEDURE public.create_new_patient(name text, dob date, pgender text) OWNER TO postgres;


CREATE PROCEDURE public.create_new_user(username character varying, firstname character varying, lastname character varying, email character varying, password character varying, roles numeric[])
    LANGUAGE plpgsql
    AS $$
DECLARE 
	i numeric;
	newuserid numeric;
BEGIN

	INSERT INTO auth_user (is_superuser, is_staff, is_active, date_joined, username, first_name, last_name, email, password) /* introduced password must be hashed */
	VALUES ('false','true','true', CURRENT_TIMESTAMP, username, firstname, lastname,  email, password);
	

/* 
 * add roles to user
 */
 	newuserid := (SELECT currval(pg_get_serial_sequence('auth_user', 'id')));
	FOREACH i IN ARRAY roles LOOP
		INSERT INTO auth_user_groups (user_id, group_id) 
		VALUES (newuserid, i);
		RAISE NOTICE 'Inserted role % in user %', i, newuserid;
	END LOOP;

	COMMIT;
	RAISE INFO 'User created successfully';	
	
END$$;


ALTER PROCEDURE public.create_new_user(username character varying, firstname character varying, lastname character varying, email character varying, password character varying, roles numeric[]) OWNER TO postgres;

CREATE FUNCTION public.get_all_cuts_from_sample(sampleid integer) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
result JSON;
BEGIN

	SELECT json_agg(cuts) INTO result
	FROM (SELECT id, purpose, user_id, cut_date FROM cut WHERE sample_id = sampleid) cuts;
	RETURN result;
	
END;
$$;


ALTER FUNCTION public.get_all_cuts_from_sample(sampleid integer) OWNER TO postgres;


CREATE PROCEDURE public.register_new_analysis(userid integer, cutid integer, submitdate text, xlsxfile text)
    LANGUAGE plpgsql
    AS $$
BEGIN

	INSERT INTO analysis (user_id, cut_id, submit_date, result_xlsx_path)
	VALUES (userid, cutid, submitdate, xlsxfile);
	
COMMIT;
RAISE INFO 'Analysis submition procedure created successfully';
END;
$$;


ALTER PROCEDURE public.register_new_analysis(userid integer, cutid integer, submitdate text, xlsxfile text) OWNER TO postgres;


CREATE PROCEDURE public.register_new_cut(userid integer, prps character varying, sampleid integer, cutdate date)
    LANGUAGE plpgsql
    AS $$BEGIN

	INSERT INTO cut(user_id, purpose, sample_id, cut_date)
	VALUES (userid, prps, sampleid, cutdate);

COMMIT;

END;$$;


ALTER PROCEDURE public.register_new_cut(userid integer, prps character varying, sampleid integer, cutdate date) OWNER TO postgres;


CREATE PROCEDURE public.register_new_sample(userid integer, origin text, patientid integer, tumortypeid integer, tissuetypeid integer, temperatureid integer, containerid integer, location json, entrydate timestamp without time zone DEFAULT CURRENT_TIMESTAMP)
    LANGUAGE plpgsql
    AS $$
BEGIN

	INSERT INTO sample (user_id, origin, patient_id, tumor_type_id, tissue_type_id, entry_date, temperature_id, container_id, "location")
	VALUES (userid, origin, patientid, tumortypeid, tissuetypeid, entrydate, temperatureid, containerid, "location");
	
COMMIT;
RAISE INFO 'Sample registered successfully';
END$$;


ALTER PROCEDURE public.register_new_sample(userid integer, origin text, patientid integer, tumortypeid integer, tissuetypeid integer, temperatureid integer, containerid integer, location json, entrydate timestamp without time zone) OWNER TO postgres;


CREATE FUNCTION public.sample_information(sampleid integer) RETURNS json
    LANGUAGE plpgsql
    AS $$
BEGIN
RETURN (SELECT json_agg(json_build_object('id',id, 'user',user_id,'origin',origin))
	FROM sample WHERE id = sampleid);
END;
$$;


ALTER FUNCTION public.sample_information(sampleid integer) OWNER TO postgres;


CREATE FUNCTION public.sample_list_for_user(userid integer) RETURNS json
    LANGUAGE plpgsql
    AS $$
BEGIN

RETURN (SELECT json_agg(json_build_object('sample',t)) FROM sample t WHERE t.user_id = userid); 
	
END;
$$;


ALTER FUNCTION public.sample_list_for_user(userid integer) OWNER TO postgres;


CREATE FUNCTION public.user_available_roles(userid integer) RETURNS json
    LANGUAGE plpgsql
    AS $$
 BEGIN
 RETURN (SELECT json_agg(json_build_object('role_id', group_id, 'role', name)) FROM auth_user_groups 
INNER JOIN auth_group ON auth_user_groups.group_id = auth_group.id WHERE auth_user_groups.user_id = userid);
END$$;


ALTER FUNCTION public.user_available_roles(userid integer) OWNER TO postgres;


CREATE FUNCTION public.user_list() RETURNS json
    LANGUAGE plpgsql
    AS $$
BEGIN
RETURN (SELECT json_agg(json_build_object('id',id,'user',json_build_object('username',username,'password',password,'first_name', first_name, 'last_name', last_name,'email', email,'last_login', last_login,'is_superuser', is_superuser, 'is_staff', is_staff, 'is_active', is_active, 'date_joined', date_joined))) 
	FROM auth_user);
END$$;

ALTER FUNCTION public.user_list() OWNER TO postgres;
 
COMMIT;
