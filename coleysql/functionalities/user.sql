/*
 * Functionalites for user management
 */
 
 
/*
 * Get all users list
 */

CREATE OR REPLACE FUNCTION user_list()
RETURNS json
AS
$$
BEGIN
RETURN (SELECT json_agg(json_build_object('id',id,'user',json_build_object('username',username,'password',password,'first_name', first_name, 'last_name', last_name,'email', email,'last_login', last_login,'is_superuser', is_superuser, 'is_staff', is_staff, 'is_active', is_active, 'date_joined', date_joined))) 
	FROM auth_user);
END$$
LANGUAGE plpgsql;

 
/* 
 * Get user available roles for a user
 */
 
 CREATE OR REPLACE FUNCTION user_available_roles(userid INT)
 RETURNS json
 AS
 $$
 BEGIN
 RETURN (SELECT json_agg(json_build_object('role_id', group_id, 'role', name)) FROM auth_user_groups 
INNER JOIN auth_group ON auth_user_groups.group_id = auth_group.id WHERE auth_user_groups.user_id = userid);
 END$$
 LANGUAGE plpgsql;
 
/*
 * Get authenticated user basic information
 */
 
CREATE OR REPLACE FUNCTION authenticated_user(userid INT)
RETURNS json
AS
$$
BEGIN
RETURN (SELECT json_build_object('id',id,'first_name', first_name, 'last_name', last_name,'username', username) FROM auth_user WHERE id = userid);
END$$
LANGUAGE plpgsql;

/*
 * Create new user
 */
 

CREATE OR REPLACE PROCEDURE create_new_user(username VARCHAR, firstname VARCHAR, lastname VARCHAR, email VARCHAR, password VARCHAR, roles numeric[])
AS
$$
DECLARE 
	i numeric;
	newuserid numeric;
BEGIN

	INSERT INTO auth_user (username, first_name, last_name, email, password) /* introduced password must be hashed */
	VALUES (username, firstname, lastname,  email, password);
	

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
	
END$$
LANGUAGE plpgsql;

/*
 * Delete user
 */

CREATE OR REPLACE PROCEDURE delete_user(userid INT)
AS 
$$
BEGIN
DELETE FROM auth_user_groups where user_id = userid;
DELETE FROM auth_user WHERE id = userid;


END$$
LANGUAGE plpgsql;
