--
-- PostgreSQL database dump
--

-- Dumped from database version 12.16 (Ubuntu 12.16-0ubuntu0.20.04.1)
-- Dumped by pg_dump version 12.16 (Ubuntu 12.16-0ubuntu0.20.04.1)

-- Started on 2023-11-21 22:26:02 WET

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 253 (class 1255 OID 42789)
-- Name: authenticated_user(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.authenticated_user(userid integer) RETURNS json
    LANGUAGE plpgsql
    AS $$
BEGIN


RETURN (SELECT json_build_object('id',id,'first_name', first_name, 'last_name', last_name,'username', username) FROM auth_user WHERE id = userid);

END$$;


ALTER FUNCTION public.authenticated_user(userid integer) OWNER TO postgres;

--
-- TOC entry 237 (class 1255 OID 51091)
-- Name: create_new_patient(text, date, text); Type: PROCEDURE; Schema: public; Owner: postgres
--

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

--
-- TOC entry 258 (class 1255 OID 42894)
-- Name: create_new_user(character varying, character varying, character varying, character varying, character varying, numeric[]); Type: PROCEDURE; Schema: public; Owner: postgres
--

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

--
-- TOC entry 255 (class 1255 OID 42881)
-- Name: get_all_cuts_from_sample(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

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

--
-- TOC entry 238 (class 1255 OID 51122)
-- Name: register_new_analysis(integer, integer, text, text); Type: PROCEDURE; Schema: public; Owner: postgres
--

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

--
-- TOC entry 259 (class 1255 OID 51139)
-- Name: register_new_cut(integer, character varying, integer, date); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.register_new_cut(userid integer, prps character varying, sampleid integer, cutdate date)
    LANGUAGE plpgsql
    AS $$BEGIN

	INSERT INTO cut(user_id, purpose, sample_id, cut_date)
	VALUES (userid, prps, sampleid, cutdate);

 
COMMIT;

END;$$;


ALTER PROCEDURE public.register_new_cut(userid integer, prps character varying, sampleid integer, cutdate date) OWNER TO postgres;

--
-- TOC entry 254 (class 1255 OID 42819)
-- Name: register_new_sample(integer, text, integer, integer, integer, integer, integer, json, timestamp without time zone); Type: PROCEDURE; Schema: public; Owner: postgres
--

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

--
-- TOC entry 257 (class 1255 OID 42891)
-- Name: sample_information(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sample_information(sampleid integer) RETURNS json
    LANGUAGE plpgsql
    AS $$
BEGIN
RETURN (SELECT json_agg(json_build_object('id',id, 'user',user_id,'origin',origin))
	FROM sample WHERE id = sampleid);
END;
$$;


ALTER FUNCTION public.sample_information(sampleid integer) OWNER TO postgres;

--
-- TOC entry 256 (class 1255 OID 42890)
-- Name: sample_list_for_user(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sample_list_for_user(userid integer) RETURNS json
    LANGUAGE plpgsql
    AS $$
BEGIN

RETURN (SELECT json_agg(json_build_object('sample',t)) FROM sample t WHERE t.user_id = userid); 
	
END;
$$;


ALTER FUNCTION public.sample_list_for_user(userid integer) OWNER TO postgres;

--
-- TOC entry 240 (class 1255 OID 42788)
-- Name: user_available_roles(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.user_available_roles(userid integer) RETURNS json
    LANGUAGE plpgsql
    AS $$
 BEGIN
 RETURN (SELECT json_agg(json_build_object('role_id', group_id, 'role', name)) FROM auth_user_groups 
INNER JOIN auth_group ON auth_user_groups.group_id = auth_group.id WHERE auth_user_groups.user_id = userid);
 END$$;


ALTER FUNCTION public.user_available_roles(userid integer) OWNER TO postgres;

--
-- TOC entry 239 (class 1255 OID 42782)
-- Name: user_list(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.user_list() RETURNS json
    LANGUAGE plpgsql
    AS $$
BEGIN
RETURN (SELECT json_agg(json_build_object('id',id,'user',json_build_object('username',username,'password',password,'first_name', first_name, 'last_name', last_name,'email', email,'last_login', last_login,'is_superuser', is_superuser, 'is_staff', is_staff, 'is_active', is_active, 'date_joined', date_joined))) 
	FROM auth_user);
END$$;


ALTER FUNCTION public.user_list() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 217 (class 1259 OID 42857)
-- Name: analysis; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.analysis (
    id integer NOT NULL,
    user_id integer NOT NULL,
    cut_id integer NOT NULL,
    result_xlsx_path text,
    submit_date text
);


ALTER TABLE public.analysis OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 42855)
-- Name: analysis_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.analysis ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.analysis_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 225 (class 1259 OID 59519)
-- Name: auth_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(150) NOT NULL
);


ALTER TABLE public.auth_group OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 59517)
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_group ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 227 (class 1259 OID 59528)
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_group_permissions (
    id bigint NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 59526)
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_group_permissions ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 223 (class 1259 OID 59512)
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE public.auth_permission OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 59510)
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_permission ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 229 (class 1259 OID 59535)
-- Name: auth_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    username character varying(150) NOT NULL,
    first_name character varying(150) NOT NULL,
    last_name character varying(150) NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL
);


ALTER TABLE public.auth_user OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 59544)
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_user_groups (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.auth_user_groups OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 59542)
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_user_groups ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 228 (class 1259 OID 59533)
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_user ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 233 (class 1259 OID 59551)
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_user_user_permissions (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_user_user_permissions OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 59549)
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_user_user_permissions ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_user_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 207 (class 1259 OID 42687)
-- Name: containers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.containers (
    id integer NOT NULL,
    container_name character varying(255) NOT NULL,
    container_description json NOT NULL
);


ALTER TABLE public.containers OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 42685)
-- Name: containers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.containers ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.containers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 215 (class 1259 OID 42835)
-- Name: cut; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cut (
    id integer NOT NULL,
    parent_cut_id integer,
    user_id integer NOT NULL,
    purpose character varying(255) NOT NULL,
    cut_date timestamp(0) without time zone NOT NULL,
    sample_id integer NOT NULL
);


ALTER TABLE public.cut OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 42833)
-- Name: cut_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.cut ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.cut_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 235 (class 1259 OID 59610)
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id integer NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


ALTER TABLE public.django_admin_log OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 59608)
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.django_admin_log ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_admin_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 221 (class 1259 OID 59492)
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 59490)
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.django_content_type ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_content_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 219 (class 1259 OID 59482)
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_migrations (
    id bigint NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE public.django_migrations OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 59480)
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.django_migrations ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 236 (class 1259 OID 59640)
-- Name: django_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE public.django_session OWNER TO postgres;

--
-- TOC entry 203 (class 1259 OID 42669)
-- Name: patients; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.patients (
    id integer NOT NULL,
    patient_name character varying(255) NOT NULL,
    patient_dob date NOT NULL,
    gender character(255) NOT NULL,
    CONSTRAINT gender_check CHECK ((gender = ANY (ARRAY['male'::bpchar, 'female'::bpchar, 'other'::bpchar])))
);


ALTER TABLE public.patients OWNER TO postgres;

--
-- TOC entry 202 (class 1259 OID 42667)
-- Name: patients_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.patients ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.patients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 211 (class 1259 OID 42741)
-- Name: sample; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sample (
    id integer NOT NULL,
    user_id integer NOT NULL,
    origin character varying(255) NOT NULL,
    patient_id integer NOT NULL,
    tumor_type_id integer NOT NULL,
    entry_date date DEFAULT CURRENT_TIMESTAMP NOT NULL,
    temperature_id integer NOT NULL,
    container_id smallint NOT NULL,
    location json,
    tissue_type_id integer NOT NULL
);


ALTER TABLE public.sample OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 42739)
-- Name: sample_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.sample ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.sample_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 209 (class 1259 OID 42697)
-- Name: temperature; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.temperature (
    id integer NOT NULL,
    temperature_desc character varying(255) NOT NULL
);


ALTER TABLE public.temperature OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 42695)
-- Name: temperature_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.temperature ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.temperature_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 213 (class 1259 OID 42795)
-- Name: tissuetype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tissuetype (
    id smallint NOT NULL,
    tissue_description character varying(255) NOT NULL
);


ALTER TABLE public.tissuetype OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 42793)
-- Name: tissuetype_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tissuetype ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.tissuetype_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 205 (class 1259 OID 42680)
-- Name: tumortype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tumortype (
    id smallint NOT NULL,
    tumor_description character varying(255) NOT NULL
);


ALTER TABLE public.tumortype OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 42678)
-- Name: tumortype_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tumortype ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.tumortype_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 3176 (class 0 OID 42857)
-- Dependencies: 217
-- Data for Name: analysis; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.analysis (id, user_id, cut_id, result_xlsx_path, submit_date) FROM stdin;
\.


--
-- TOC entry 3184 (class 0 OID 59519)
-- Dependencies: 225
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_group (id, name) FROM stdin;
1	Admin
2	Supervisor
3	Technician
4	Student
\.


--
-- TOC entry 3186 (class 0 OID 59528)
-- Dependencies: 227
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- TOC entry 3182 (class 0 OID 59512)
-- Dependencies: 223
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add log entry	1	add_logentry
2	Can change log entry	1	change_logentry
3	Can delete log entry	1	delete_logentry
4	Can view log entry	1	view_logentry
5	Can add permission	2	add_permission
6	Can change permission	2	change_permission
7	Can delete permission	2	delete_permission
8	Can view permission	2	view_permission
9	Can add group	3	add_group
10	Can change group	3	change_group
11	Can delete group	3	delete_group
12	Can view group	3	view_group
13	Can add user	4	add_user
14	Can change user	4	change_user
15	Can delete user	4	delete_user
16	Can view user	4	view_user
17	Can add content type	5	add_contenttype
18	Can change content type	5	change_contenttype
19	Can delete content type	5	delete_contenttype
20	Can view content type	5	view_contenttype
21	Can add session	6	add_session
22	Can change session	6	change_session
23	Can delete session	6	delete_session
24	Can view session	6	view_session
25	Can add analysis	7	add_analysis
26	Can change analysis	7	change_analysis
27	Can delete analysis	7	delete_analysis
28	Can view analysis	7	view_analysis
29	Can add auth group	8	add_authgroup
30	Can change auth group	8	change_authgroup
31	Can delete auth group	8	delete_authgroup
32	Can view auth group	8	view_authgroup
33	Can add auth group permissions	9	add_authgrouppermissions
34	Can change auth group permissions	9	change_authgrouppermissions
35	Can delete auth group permissions	9	delete_authgrouppermissions
36	Can view auth group permissions	9	view_authgrouppermissions
37	Can add auth permission	10	add_authpermission
38	Can change auth permission	10	change_authpermission
39	Can delete auth permission	10	delete_authpermission
40	Can view auth permission	10	view_authpermission
41	Can add auth user	11	add_authuser
42	Can change auth user	11	change_authuser
43	Can delete auth user	11	delete_authuser
44	Can view auth user	11	view_authuser
45	Can add auth user groups	12	add_authusergroups
46	Can change auth user groups	12	change_authusergroups
47	Can delete auth user groups	12	delete_authusergroups
48	Can view auth user groups	12	view_authusergroups
49	Can add auth user user permissions	13	add_authuseruserpermissions
50	Can change auth user user permissions	13	change_authuseruserpermissions
51	Can delete auth user user permissions	13	delete_authuseruserpermissions
52	Can view auth user user permissions	13	view_authuseruserpermissions
53	Can add containers	14	add_containers
54	Can change containers	14	change_containers
55	Can delete containers	14	delete_containers
56	Can view containers	14	view_containers
57	Can add cut	15	add_cut
58	Can change cut	15	change_cut
59	Can delete cut	15	delete_cut
60	Can view cut	15	view_cut
61	Can add django admin log	16	add_djangoadminlog
62	Can change django admin log	16	change_djangoadminlog
63	Can delete django admin log	16	delete_djangoadminlog
64	Can view django admin log	16	view_djangoadminlog
65	Can add django content type	17	add_djangocontenttype
66	Can change django content type	17	change_djangocontenttype
67	Can delete django content type	17	delete_djangocontenttype
68	Can view django content type	17	view_djangocontenttype
69	Can add django migrations	18	add_djangomigrations
70	Can change django migrations	18	change_djangomigrations
71	Can delete django migrations	18	delete_djangomigrations
72	Can view django migrations	18	view_djangomigrations
73	Can add django session	19	add_djangosession
74	Can change django session	19	change_djangosession
75	Can delete django session	19	delete_djangosession
76	Can view django session	19	view_djangosession
77	Can add patients	20	add_patients
78	Can change patients	20	change_patients
79	Can delete patients	20	delete_patients
80	Can view patients	20	view_patients
81	Can add sample	21	add_sample
82	Can change sample	21	change_sample
83	Can delete sample	21	delete_sample
84	Can view sample	21	view_sample
85	Can add temperature	22	add_temperature
86	Can change temperature	22	change_temperature
87	Can delete temperature	22	delete_temperature
88	Can view temperature	22	view_temperature
89	Can add tumortype	23	add_tumortype
90	Can change tumortype	23	change_tumortype
91	Can delete tumortype	23	delete_tumortype
92	Can view tumortype	23	view_tumortype
93	Can add tissuetype	24	add_tissuetype
94	Can change tissuetype	24	change_tissuetype
95	Can delete tissuetype	24	delete_tissuetype
96	Can view tissuetype	24	view_tissuetype
\.


--
-- TOC entry 3188 (class 0 OID 59535)
-- Dependencies: 229
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) FROM stdin;
1	pbkdf2_sha256$390000$k4Zp8ru2ts2WysHR3b4ih0$RJCQl0EYCOnWM/u7t4FnKgSOFAVwlYknQPcNaBjjUW0=	2023-11-21 22:05:13.794778+00	t	admin				t	t	2023-11-21 20:38:13.426796+00
\.


--
-- TOC entry 3190 (class 0 OID 59544)
-- Dependencies: 231
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_user_groups (id, user_id, group_id) FROM stdin;
1	1	1
\.


--
-- TOC entry 3192 (class 0 OID 59551)
-- Dependencies: 233
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- TOC entry 3166 (class 0 OID 42687)
-- Dependencies: 207
-- Data for Name: containers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.containers (id, container_name, container_description) FROM stdin;
1	main freezer	{\n  "drawer 1": {\n    "box 1": {\n      "slot 1": 0,\n      "slot 2": 0,\n      "slot 3": 0,\n      "slot 4": 0,\n      "slot 5": 0,\n      "slot 6": 0\n    },\n    "box 2": {\n      "slot 1": 0,\n      "slot 2": 0,\n      "slot 3": 0,\n      "slot 4": 0,\n      "slot 5": 0,\n      "slot 6": 0\n    },\n    "box 3": {\n      "slot 1": 0,\n      "slot 2": 0,\n      "slot 3": 0,\n      "slot 4": 0,\n      "slot 5": 0,\n      "slot 6": 0\n    }\n  },\n  "drawer 2": {\n    "box 1": {\n      "slot 1": 0,\n      "slot 2": 0,\n      "slot 3": 0,\n      "slot 4": 0,\n      "slot 5": 0,\n      "slot 6": 0\n    },\n    "box 2": {\n      "slot 1": 0,\n      "slot 2": 0,\n      "slot 3": 0,\n      "slot 4": 0,\n      "slot 5": 0,\n      "slot 6": 0\n    },\n    "box 3": {\n      "slot 1": 0,\n      "slot 2": 0,\n      "slot 3": 0,\n      "slot 4": 0,\n      "slot 5": 0,\n      "slot 6": 0\n    }\n  }\n}
2	secondary freezer	{}
\.


--
-- TOC entry 3174 (class 0 OID 42835)
-- Dependencies: 215
-- Data for Name: cut; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cut (id, parent_cut_id, user_id, purpose, cut_date, sample_id) FROM stdin;
\.


--
-- TOC entry 3194 (class 0 OID 59610)
-- Dependencies: 235
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
\.


--
-- TOC entry 3180 (class 0 OID 59492)
-- Dependencies: 221
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_content_type (id, app_label, model) FROM stdin;
1	admin	logentry
2	auth	permission
3	auth	group
4	auth	user
5	contenttypes	contenttype
6	sessions	session
7	coleyapi	analysis
8	coleyapi	authgroup
9	coleyapi	authgrouppermissions
10	coleyapi	authpermission
11	coleyapi	authuser
12	coleyapi	authusergroups
13	coleyapi	authuseruserpermissions
14	coleyapi	containers
15	coleyapi	cut
16	coleyapi	djangoadminlog
17	coleyapi	djangocontenttype
18	coleyapi	djangomigrations
19	coleyapi	djangosession
20	coleyapi	patients
21	coleyapi	sample
22	coleyapi	temperature
23	coleyapi	tumortype
24	coleyapi	tissuetype
\.


--
-- TOC entry 3178 (class 0 OID 59482)
-- Dependencies: 219
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2023-11-21 20:37:03.148965+00
2	auth	0001_initial	2023-11-21 20:37:38.311775+00
3	admin	0001_initial	2023-11-21 20:37:38.329724+00
4	admin	0002_logentry_remove_auto_add	2023-11-21 20:37:38.337147+00
5	admin	0003_logentry_add_action_flag_choices	2023-11-21 20:37:38.345353+00
6	contenttypes	0002_remove_content_type_name	2023-11-21 20:37:38.359597+00
7	auth	0002_alter_permission_name_max_length	2023-11-21 20:37:38.366724+00
8	auth	0003_alter_user_email_max_length	2023-11-21 20:37:38.374744+00
9	auth	0004_alter_user_username_opts	2023-11-21 20:37:38.382174+00
10	auth	0005_alter_user_last_login_null	2023-11-21 20:37:38.389616+00
11	auth	0006_require_contenttypes_0002	2023-11-21 20:37:38.391607+00
12	auth	0007_alter_validators_add_error_messages	2023-11-21 20:37:38.398829+00
13	auth	0008_alter_user_username_max_length	2023-11-21 20:37:38.41113+00
14	auth	0009_alter_user_last_name_max_length	2023-11-21 20:37:38.419212+00
15	auth	0010_alter_group_name_max_length	2023-11-21 20:37:38.428638+00
16	auth	0011_update_proxy_permissions	2023-11-21 20:37:38.436182+00
17	auth	0012_alter_user_first_name_max_length	2023-11-21 20:37:38.444302+00
18	coleyapi	0001_initial	2023-11-21 20:37:38.462626+00
19	coleyapi	0002_tissuetype	2023-11-21 20:37:38.465391+00
20	coleyapi	0003_alter_tissuetype_options	2023-11-21 20:37:38.468691+00
21	sessions	0001_initial	2023-11-21 20:37:38.479542+00
\.


--
-- TOC entry 3195 (class 0 OID 59640)
-- Dependencies: 236
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_session (session_key, session_data, expire_date) FROM stdin;
0bkhejw97kjgfkji9gvtel3mhp9hz3qc	.eJxVjMsOwiAQRf-FtSF0mPJw6d5vIAwDUjU0Ke3K-O_apAvd3nPOfYkQt7WGreclTCzOYhCn341ieuS2A77Hdptlmtu6TCR3RR60y-vM-Xk53L-DGnv91jR6QosJGEflMKWCELUmg4YjeGeVxmItWacRcDDKOPZsqSgHpEGL9wfFDTa4:1r5XVx:9MF4204umsa8tsMxjyrszlxQDNfFr-sFJ5MoUpsIisI	2023-12-05 20:38:33.674756+00
efzq9jzxiihyo30xsr302ygkkxv3ssdo	.eJxVjMsOwiAQRf-FtSF0mPJw6d5vIAwDUjU0Ke3K-O_apAvd3nPOfYkQt7WGreclTCzOYhCn341ieuS2A77Hdptlmtu6TCR3RR60y-vM-Xk53L-DGnv91jR6QosJGEflMKWCELUmg4YjeGeVxmItWacRcDDKOPZsqSgHpEGL9wfFDTa4:1r5XX0:pJgIO-5v1L1BVPrONsGvdivCd936TDT2xIT2jHsgToY	2023-12-05 20:39:38.014751+00
49d14uy1s59mg25h0v7pf8cmel79vfae	.eJxVjMsOwiAQRf-FtSF0mPJw6d5vIAwDUjU0Ke3K-O_apAvd3nPOfYkQt7WGreclTCzOYhCn341ieuS2A77Hdptlmtu6TCR3RR60y-vM-Xk53L-DGnv91jR6QosJGEflMKWCELUmg4YjeGeVxmItWacRcDDKOPZsqSgHpEGL9wfFDTa4:1r5XXU:9zKqwudjggYlXq8zUjPRJro6wO7I9NouCcRKwBMUMK8	2023-12-05 20:40:08.287869+00
l51xx6or4o1hi7e9zlr4v25hpdstnsca	.eJxVjMsOwiAQRf-FtSF0mPJw6d5vIAwDUjU0Ke3K-O_apAvd3nPOfYkQt7WGreclTCzOYhCn341ieuS2A77Hdptlmtu6TCR3RR60y-vM-Xk53L-DGnv91jR6QosJGEflMKWCELUmg4YjeGeVxmItWacRcDDKOPZsqSgHpEGL9wfFDTa4:1r5XY9:XsgWLSFg5d5WlEusjp0EzNrfG62YbzA19bR_ke2Ui4A	2023-12-05 20:40:49.386404+00
075lnz2o6qhbirzcl8rbjb9lbf4691cz	.eJxVjMsOwiAQRf-FtSF0mPJw6d5vIAwDUjU0Ke3K-O_apAvd3nPOfYkQt7WGreclTCzOYhCn341ieuS2A77Hdptlmtu6TCR3RR60y-vM-Xk53L-DGnv91jR6QosJGEflMKWCELUmg4YjeGeVxmItWacRcDDKOPZsqSgHpEGL9wfFDTa4:1r5XYU:4dY6TbPVExVF0j20-6MtsNxNDoasYmRsGVMagL1R9J4	2023-12-05 20:41:10.65437+00
8sa15q6zqes7oppm43glz1w4sc50rh25	.eJxVjMsOwiAQRf-FtSF0mPJw6d5vIAwDUjU0Ke3K-O_apAvd3nPOfYkQt7WGreclTCzOYhCn341ieuS2A77Hdptlmtu6TCR3RR60y-vM-Xk53L-DGnv91jR6QosJGEflMKWCELUmg4YjeGeVxmItWacRcDDKOPZsqSgHpEGL9wfFDTa4:1r5Xdd:MkQMKp_FkTtDY4Z4fkmZBBNSx2aNwjTvqNkox2pz1r4	2023-12-05 20:46:29.576586+00
bbbzv6hg9phnbckbkunl06pokewt0wez	.eJxVjMsOwiAQRf-FtSF0mPJw6d5vIAwDUjU0Ke3K-O_apAvd3nPOfYkQt7WGreclTCzOYhCn341ieuS2A77Hdptlmtu6TCR3RR60y-vM-Xk53L-DGnv91jR6QosJGEflMKWCELUmg4YjeGeVxmItWacRcDDKOPZsqSgHpEGL9wfFDTa4:1r5Xdv:LLhS0hZ0crsK3itEqziz83RdsChtePQB-8vESA7-E-M	2023-12-05 20:46:47.318401+00
edg0xh99a73b6u5qu2wpqgd1rv6urwnw	.eJxVjMsOwiAQRf-FtSF0mPJw6d5vIAwDUjU0Ke3K-O_apAvd3nPOfYkQt7WGreclTCzOYhCn341ieuS2A77Hdptlmtu6TCR3RR60y-vM-Xk53L-DGnv91jR6QosJGEflMKWCELUmg4YjeGeVxmItWacRcDDKOPZsqSgHpEGL9wfFDTa4:1r5Xet:e58HorZlkvaue4SOLFtcy6pl2Am9rcK3b7fTaeE_FMc	2023-12-05 20:47:47.355954+00
6tamr2l106ed1l8t8p3hbo4leizvzghq	.eJxVjMsOwiAQRf-FtSF0mPJw6d5vIAwDUjU0Ke3K-O_apAvd3nPOfYkQt7WGreclTCzOYhCn341ieuS2A77Hdptlmtu6TCR3RR60y-vM-Xk53L-DGnv91jR6QosJGEflMKWCELUmg4YjeGeVxmItWacRcDDKOPZsqSgHpEGL9wfFDTa4:1r5Y9I:qJ-MtE_fSZzI3WVRPSjEX313TeMIhRQMm4o0Q9T2s7I	2023-12-05 21:19:12.126008+00
0ztxf12bm2e6bum9ikudi2cennx4u16t	.eJxVjMsOwiAQRf-FtSF0mPJw6d5vIAwDUjU0Ke3K-O_apAvd3nPOfYkQt7WGreclTCzOYhCn341ieuS2A77Hdptlmtu6TCR3RR60y-vM-Xk53L-DGnv91jR6QosJGEflMKWCELUmg4YjeGeVxmItWacRcDDKOPZsqSgHpEGL9wfFDTa4:1r5YHy:wL7FtvKnWjQLM0eVbbhjzfqndiLFo8ERseFQdEtVe4A	2023-12-05 21:28:10.793304+00
0yeggh79idujge1lcloosx4e04hlq221	.eJxVjMsOwiAQRf-FtSF0mPJw6d5vIAwDUjU0Ke3K-O_apAvd3nPOfYkQt7WGreclTCzOYhCn341ieuS2A77Hdptlmtu6TCR3RR60y-vM-Xk53L-DGnv91jR6QosJGEflMKWCELUmg4YjeGeVxmItWacRcDDKOPZsqSgHpEGL9wfFDTa4:1r5YLT:uR_lWS_s-f93NlV5qO6BDc8XL6FvrbVjCZz6sybsdCY	2023-12-05 21:31:47.588648+00
lwxtsxlskt0nstqme51ta3vn6ei3v0u7	.eJxVjMsOwiAQRf-FtSF0mPJw6d5vIAwDUjU0Ke3K-O_apAvd3nPOfYkQt7WGreclTCzOYhCn341ieuS2A77Hdptlmtu6TCR3RR60y-vM-Xk53L-DGnv91jR6QosJGEflMKWCELUmg4YjeGeVxmItWacRcDDKOPZsqSgHpEGL9wfFDTa4:1r5YPp:1rSbqM1_afxdPNvQWvnBKldb_Tb8NRo3lqAOo6OO-QA	2023-12-05 21:36:17.672153+00
x4fvsivfxgcac6bwqro7kv3yramnd9bf	.eJxVjMsOwiAQRf-FtSF0mPJw6d5vIAwDUjU0Ke3K-O_apAvd3nPOfYkQt7WGreclTCzOYhCn341ieuS2A77Hdptlmtu6TCR3RR60y-vM-Xk53L-DGnv91jR6QosJGEflMKWCELUmg4YjeGeVxmItWacRcDDKOPZsqSgHpEGL9wfFDTa4:1r5YU6:ASUDhZVT0hEav9GQILKnAHY3wuwefeaaE6uBFxa2jEw	2023-12-05 21:40:42.729003+00
17kc4bwpp3se7mwaz3m906ovg62erocq	.eJxVjMsOwiAQRf-FtSF0mPJw6d5vIAwDUjU0Ke3K-O_apAvd3nPOfYkQt7WGreclTCzOYhCn341ieuS2A77Hdptlmtu6TCR3RR60y-vM-Xk53L-DGnv91jR6QosJGEflMKWCELUmg4YjeGeVxmItWacRcDDKOPZsqSgHpEGL9wfFDTa4:1r5YjC:Y9btsA4htVFUX00d7SP_RetpXCKYwjuDeR4AB-dcB1s	2023-12-05 21:56:18.123185+00
ounv1sqx9n4r2e1zhnbxsoq6sok0rpv6	.eJxVjMsOwiAQRf-FtSF0mPJw6d5vIAwDUjU0Ke3K-O_apAvd3nPOfYkQt7WGreclTCzOYhCn341ieuS2A77Hdptlmtu6TCR3RR60y-vM-Xk53L-DGnv91jR6QosJGEflMKWCELUmg4YjeGeVxmItWacRcDDKOPZsqSgHpEGL9wfFDTa4:1r5Yrp:e0wQM_POatZWnNCAxDEm5ztxTnt9LOIvqixoyF4dhLw	2023-12-05 22:05:13.799046+00
\.


--
-- TOC entry 3162 (class 0 OID 42669)
-- Dependencies: 203
-- Data for Name: patients; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.patients (id, patient_name, patient_dob, gender) FROM stdin;
\.


--
-- TOC entry 3170 (class 0 OID 42741)
-- Dependencies: 211
-- Data for Name: sample; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sample (id, user_id, origin, patient_id, tumor_type_id, entry_date, temperature_id, container_id, location, tissue_type_id) FROM stdin;
\.


--
-- TOC entry 3168 (class 0 OID 42697)
-- Dependencies: 209
-- Data for Name: temperature; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.temperature (id, temperature_desc) FROM stdin;
4	-80ºC
5	4ºC
6	other
\.


--
-- TOC entry 3172 (class 0 OID 42795)
-- Dependencies: 213
-- Data for Name: tissuetype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tissuetype (id, tissue_description) FROM stdin;
1	blood
2	liver
3	connective tissue
4	skin
\.


--
-- TOC entry 3164 (class 0 OID 42680)
-- Dependencies: 205
-- Data for Name: tumortype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tumortype (id, tumor_description) FROM stdin;
2	liver cancer
3	pancreatic cancer
4	bladder cancer
\.


--
-- TOC entry 3201 (class 0 OID 0)
-- Dependencies: 216
-- Name: analysis_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.analysis_id_seq', 12, true);


--
-- TOC entry 3202 (class 0 OID 0)
-- Dependencies: 224
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 1, false);


--
-- TOC entry 3203 (class 0 OID 0)
-- Dependencies: 226
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 1, false);


--
-- TOC entry 3204 (class 0 OID 0)
-- Dependencies: 222
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 96, true);


--
-- TOC entry 3205 (class 0 OID 0)
-- Dependencies: 230
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_user_groups_id_seq', 1, false);


--
-- TOC entry 3206 (class 0 OID 0)
-- Dependencies: 228
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_user_id_seq', 1, true);


--
-- TOC entry 3207 (class 0 OID 0)
-- Dependencies: 232
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_user_user_permissions_id_seq', 1, false);


--
-- TOC entry 3208 (class 0 OID 0)
-- Dependencies: 206
-- Name: containers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.containers_id_seq', 2, true);


--
-- TOC entry 3209 (class 0 OID 0)
-- Dependencies: 214
-- Name: cut_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cut_id_seq', 18, true);


--
-- TOC entry 3210 (class 0 OID 0)
-- Dependencies: 234
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 1, false);


--
-- TOC entry 3211 (class 0 OID 0)
-- Dependencies: 220
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 24, true);


--
-- TOC entry 3212 (class 0 OID 0)
-- Dependencies: 218
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 21, true);


--
-- TOC entry 3213 (class 0 OID 0)
-- Dependencies: 202
-- Name: patients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patients_id_seq', 20, true);


--
-- TOC entry 3214 (class 0 OID 0)
-- Dependencies: 210
-- Name: sample_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sample_id_seq', 7, true);


--
-- TOC entry 3215 (class 0 OID 0)
-- Dependencies: 208
-- Name: temperature_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.temperature_id_seq', 6, true);


--
-- TOC entry 3216 (class 0 OID 0)
-- Dependencies: 212
-- Name: tissuetype_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tissuetype_id_seq', 4, true);


--
-- TOC entry 3217 (class 0 OID 0)
-- Dependencies: 204
-- Name: tumortype_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tumortype_id_seq', 4, true);


--
-- TOC entry 2970 (class 2606 OID 42864)
-- Name: analysis analysis_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.analysis
    ADD CONSTRAINT analysis_pkey PRIMARY KEY (id);


--
-- TOC entry 2984 (class 2606 OID 59638)
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- TOC entry 2989 (class 2606 OID 59566)
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- TOC entry 2992 (class 2606 OID 59532)
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 2986 (class 2606 OID 59523)
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- TOC entry 2979 (class 2606 OID 59557)
-- Name: auth_permission auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- TOC entry 2981 (class 2606 OID 59516)
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- TOC entry 3000 (class 2606 OID 59548)
-- Name: auth_user_groups auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- TOC entry 3003 (class 2606 OID 59581)
-- Name: auth_user_groups auth_user_groups_user_id_group_id_94350c0c_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_94350c0c_uniq UNIQUE (user_id, group_id);


--
-- TOC entry 2994 (class 2606 OID 59539)
-- Name: auth_user auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- TOC entry 3006 (class 2606 OID 59555)
-- Name: auth_user_user_permissions auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 3009 (class 2606 OID 59595)
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_permission_id_14a6b632_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_14a6b632_uniq UNIQUE (user_id, permission_id);


--
-- TOC entry 2997 (class 2606 OID 59632)
-- Name: auth_user auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- TOC entry 2959 (class 2606 OID 42694)
-- Name: containers containers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.containers
    ADD CONSTRAINT containers_pkey PRIMARY KEY (id);


--
-- TOC entry 2968 (class 2606 OID 42839)
-- Name: cut cut_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cut
    ADD CONSTRAINT cut_pkey PRIMARY KEY (id);


--
-- TOC entry 3012 (class 2606 OID 59618)
-- Name: django_admin_log django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- TOC entry 2974 (class 2606 OID 59498)
-- Name: django_content_type django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- TOC entry 2976 (class 2606 OID 59496)
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- TOC entry 2972 (class 2606 OID 59489)
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 3016 (class 2606 OID 59647)
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- TOC entry 2955 (class 2606 OID 42677)
-- Name: patients patients_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_pkey PRIMARY KEY (id);


--
-- TOC entry 2964 (class 2606 OID 42749)
-- Name: sample sample_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sample
    ADD CONSTRAINT sample_pkey PRIMARY KEY (id);


--
-- TOC entry 2961 (class 2606 OID 42701)
-- Name: temperature temperature_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.temperature
    ADD CONSTRAINT temperature_pkey PRIMARY KEY (id);


--
-- TOC entry 2966 (class 2606 OID 42799)
-- Name: tissuetype tissuetype_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tissuetype
    ADD CONSTRAINT tissuetype_pkey PRIMARY KEY (id);


--
-- TOC entry 2957 (class 2606 OID 42684)
-- Name: tumortype tumortype_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tumortype
    ADD CONSTRAINT tumortype_pkey PRIMARY KEY (id);


--
-- TOC entry 2982 (class 1259 OID 59639)
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);


--
-- TOC entry 2987 (class 1259 OID 59577)
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);


--
-- TOC entry 2990 (class 1259 OID 59578)
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);


--
-- TOC entry 2977 (class 1259 OID 59563)
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);


--
-- TOC entry 2998 (class 1259 OID 59593)
-- Name: auth_user_groups_group_id_97559544; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_groups_group_id_97559544 ON public.auth_user_groups USING btree (group_id);


--
-- TOC entry 3001 (class 1259 OID 59592)
-- Name: auth_user_groups_user_id_6a12ed8b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_groups_user_id_6a12ed8b ON public.auth_user_groups USING btree (user_id);


--
-- TOC entry 3004 (class 1259 OID 59607)
-- Name: auth_user_user_permissions_permission_id_1fbb5f2c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_user_permissions_permission_id_1fbb5f2c ON public.auth_user_user_permissions USING btree (permission_id);


--
-- TOC entry 3007 (class 1259 OID 59606)
-- Name: auth_user_user_permissions_user_id_a95ead1b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_user_permissions_user_id_a95ead1b ON public.auth_user_user_permissions USING btree (user_id);


--
-- TOC entry 2995 (class 1259 OID 59633)
-- Name: auth_user_username_6821ab7c_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_username_6821ab7c_like ON public.auth_user USING btree (username varchar_pattern_ops);


--
-- TOC entry 3010 (class 1259 OID 59629)
-- Name: django_admin_log_content_type_id_c4bce8eb; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);


--
-- TOC entry 3013 (class 1259 OID 59630)
-- Name: django_admin_log_user_id_c564eba6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);


--
-- TOC entry 3014 (class 1259 OID 59649)
-- Name: django_session_expire_date_a5c62663; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);


--
-- TOC entry 3017 (class 1259 OID 59648)
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);


--
-- TOC entry 2962 (class 1259 OID 42808)
-- Name: fki_sample_tissue_type_id_fkey; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_sample_tissue_type_id_fkey ON public.sample USING btree (tissue_type_id);


--
-- TOC entry 3025 (class 2606 OID 42870)
-- Name: analysis analysis_cut_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.analysis
    ADD CONSTRAINT analysis_cut_id_fkey FOREIGN KEY (cut_id) REFERENCES public.cut(id);


--
-- TOC entry 3028 (class 2606 OID 59572)
-- Name: auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3027 (class 2606 OID 59567)
-- Name: auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3026 (class 2606 OID 59558)
-- Name: auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3030 (class 2606 OID 59587)
-- Name: auth_user_groups auth_user_groups_group_id_97559544_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_97559544_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3029 (class 2606 OID 59582)
-- Name: auth_user_groups auth_user_groups_user_id_6a12ed8b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_6a12ed8b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3032 (class 2606 OID 59601)
-- Name: auth_user_user_permissions auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3031 (class 2606 OID 59596)
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3023 (class 2606 OID 42840)
-- Name: cut cut_parent_cut_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cut
    ADD CONSTRAINT cut_parent_cut_id_fkey FOREIGN KEY (parent_cut_id) REFERENCES public.cut(id);


--
-- TOC entry 3024 (class 2606 OID 42850)
-- Name: cut cut_sample_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cut
    ADD CONSTRAINT cut_sample_id_fkey FOREIGN KEY (sample_id) REFERENCES public.sample(id);


--
-- TOC entry 3033 (class 2606 OID 59619)
-- Name: django_admin_log django_admin_log_content_type_id_c4bce8eb_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3034 (class 2606 OID 59624)
-- Name: django_admin_log django_admin_log_user_id_c564eba6_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3022 (class 2606 OID 42770)
-- Name: sample sample_container_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sample
    ADD CONSTRAINT sample_container_id_fkey FOREIGN KEY (container_id) REFERENCES public.containers(id);


--
-- TOC entry 3019 (class 2606 OID 42755)
-- Name: sample sample_patient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sample
    ADD CONSTRAINT sample_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES public.patients(id);


--
-- TOC entry 3021 (class 2606 OID 42765)
-- Name: sample sample_temperature_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sample
    ADD CONSTRAINT sample_temperature_id_fkey FOREIGN KEY (temperature_id) REFERENCES public.temperature(id);


--
-- TOC entry 3018 (class 2606 OID 42803)
-- Name: sample sample_tissue_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sample
    ADD CONSTRAINT sample_tissue_type_id_fkey FOREIGN KEY (tissue_type_id) REFERENCES public.tissuetype(id) NOT VALID;


--
-- TOC entry 3020 (class 2606 OID 42760)
-- Name: sample sample_tumor_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sample
    ADD CONSTRAINT sample_tumor_type_id_fkey FOREIGN KEY (tumor_type_id) REFERENCES public.tumortype(id);


-- Completed on 2023-11-21 22:26:02 WET

--
-- PostgreSQL database dump complete
--

