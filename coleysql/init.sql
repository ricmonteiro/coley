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


/* insert baseline data*/

    INSERT INTO auth_group (name) VALUES
    ('Admin'),
    ('Supervisor'),
    ('Technician'),
    ('Student');
	

   INSERT INTO auth_user (password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined)  VALUES 							   
    ('pbkdf2_sha256$390000$6NCUcyLFgwe6JDU2pA1mN7$44eqcoyN7nkpRnH0hD4nCAn0uZEdnqB8UmKbPko+Bgo=',null, False,'markus','Markus','Maeurer','markus.maeurer@fchampalimaud.org', True, True, CURRENT_TIMESTAMP), -- pw markuspw
    ('pbkdf2_sha256$390000$5O94x1EvDTgWd1Rbnqsxsa$hxd5v0IV3FEmixTA//iI/O93A7FVeAxrgSHj3QgCrJY=',null, True,'ricardo','Ricardo','Monteiro','ricardo.monteiro@research.fundacaochampalimaud.pt', True, True, CURRENT_TIMESTAMP); -- pw ricardopw


    INSERT INTO auth_user_groups (user_id, group_id) VALUES
    (1,  1), -- admin as Admin, Supervisor, Technician and Student
    (1,  2),
    (1,  3),
    (1,  4);
             

    INSERT INTO temperature (temperature_desc) VALUES 
    ('-80ºC'),
    ('4ºC'),
    ('other');   
    
    INSERT INTO containers (container_name, container_description) VALUES
    ('main freezer', '{
    
    "drawer 1": {
    "box 1": {
      "slot 1": 0,
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
  }}');

    INSERT INTO tumortype (tumor_description) VALUES
    ('pancreatic cancer'),
    ('liver cancer'),
    ('bladder cancer');
    
    INSERT INTO tissuetype (tissue_description) VALUES
    ('blood'),
    ('liver'),
    ('connective tissue'),
    ('skin');

    COMMIT;