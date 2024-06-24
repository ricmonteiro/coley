/* 
	Main table creation script 
	
	To implement this schema in Django: 
	1 - do the python3 manage.py inspectdb
	2 - drop all tables from postgresql
	3 - write the models in models.py
	4 - make migrations and migrate in django 
	
*/

BEGIN;

/* User table as defined in the prebuilt user model from Django */

/*

CREATE TABLE "user"(
    "id" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY
    	CONSTRAINT user_id_unique UNIQUE,
    "username" VARCHAR(15) NOT NULL
    	CONSTRAINT username_unique UNIQUE,
    "first_name" VARCHAR(255),
    "last_name" VARCHAR(255),
    "email" VARCHAR(255) NOT NULL
    	CONSTRAINT email_unique UNIQUE,
    "password" VARCHAR(127) NOT NULL,
    "groups" INTEGER,
    "user_permissions" INTEGER ,
    "is_staff" BOOLEAN NOT NULL DEFAULT False,
    "is_active" BOOLEAN NOT NULL DEFAULT True,
    "is_superuser" BOOLEAN NOT NULL DEFAULT False,
    "last_login" TIMESTAMP(0) WITHOUT TIME ZONE,
    "date_joined" TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

*/


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

CREATE REPLACE TABLE "sample"(
    "id" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "user_id" INTEGER NOT NULL REFERENCES "auth_user"("id"),
    "origin" VARCHAR(255) NOT NULL,
    "patient_id" INTEGER NOT NULL REFERENCES "patients"("id"),
    "tumor_type_id" INTEGER NOT NULL REFERENCES "tumortype"("id"),
    "tissue_type_id" INTEGER NOT NULL REFERENCES "tissuetype"("id"),
    "entry_date" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "temperature_id" INTEGER NOT NULL REFERENCES "temperature"("id"),
    "container_id" SMALLINT NOT NULL REFERENCES "containers"("id"),
    "location" JSON NULL
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


COMMIT;
