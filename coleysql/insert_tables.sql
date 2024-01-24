/*
 * Standard insertions
 * Apply insertions only after migrations from Django
*/

BEGIN;

/* 
 *Django native tables
 *
 */
 
/* auth */
    INSERT INTO auth_user (password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined)  VALUES 							   
    ('pbkdf2_sha256$390000$6NCUcyLFgwe6JDU2pA1mN7$44eqcoyN7nkpRnH0hD4nCAn0uZEdnqB8UmKbPko+Bgo=',null, False,'markus','Markus','Maeurer','markus.maeurer@fchampalimaud.org', True, True, CURRENT_TIMESTAMP), -- pw markuspw
    ('pbkdf2_sha256$390000$72yYL4D5P1alJ3GHbmQ0Wb$+xxS9G9s4MHf05VaRd0YRUuAqfjxIv6HJ8sKNMbExJs=',null, True,'eric.desousa','Eric','de Sousa','eric.desousa@research.fundacaochampalimaud.pt', True, True, CURRENT_TIMESTAMP), -- pw ericpw
    ('pbkdf2_sha256$390000$SL7hh56BmGOySa8O5pmue1$VSRr8pLjU1J2hEHfF6XHvaVGISMrcjPNoc/04BOUdrM=',null, False,'rodrigo.eduardo','Rodrigo','Eduardo','rodrigo.eduardo@research.fundacaochampalimaud.pt',False,True, CURRENT_TIMESTAMP), -- pw rodrigopw
    ('pbkdf2_sha256$390000$8oe8N8lYQzVH1njAybshMl$v9D7jnEdf8NXmilJ8rMofSOvaw2TxY9/oiA5Z5xY4Cs=',null, False,'jessika.kamiki','Jessica','Kamiki','jessica.kamiki@research.fundacaochampalimaud.pt', False, True, CURRENT_TIMESTAMP), -- pw jessicapw
    ('pbkdf2_sha256$390000$5O94x1EvDTgWd1Rbnqsxsa$hxd5v0IV3FEmixTA//iI/O93A7FVeAxrgSHj3QgCrJY=',null, True,'ricardo.monteiro','Ricardo','Monteiro','ricardo.monteiro@research.fundacaochampalimaud.pt', True, True, CURRENT_TIMESTAMP); -- pw ricardopw
        
    INSERT INTO auth_group (name) VALUES
    ('Admin'),
    ('Supervisor'),
    ('Technician'),
    ('Student');
    
    INSERT INTO auth_user_groups (user_id, group_id) VALUES
    (1 , 2), -- Markus as Supervisor and Technician
    
    (2,  1), -- Eric as an Admin, Technician and Student
    (2,  3),
    (2,  4),
    
    (3,  3), -- Rodrigo as a Technician
    
    (4,  4), -- Jessica as a Student
    
    (5,  1), -- Ricardo as Admin, Supervisor, Technician and Student
    (5,  2),
    (5,  3),
    (5,  4);
    
    
    INSERT INTO auth_permission (name, content_type_id, codename) VALUES 
    ('Can add log entry',	1, 'add_logentry'),
    ('Can change log entry',	1, 'change_logentry'),
    ('Can delete log entry',	1, 'delete_logentry'),
    ('Can view log entry',	1, 'view_logentry'),
    ('Can add permission',	2, 'add_permission'),
    ('Can change permission',	2, 'change_permission'),
    ('Can delete permission',	2, 'delete_permission'),
    ('Can view permission',	2, 'view_permission'),
    ('Can add group',	3, 'add_group'),
    ('Can change group',	3, 'change_group'),
    ('Can delete group',	3, 'delete_group'),
    ('Can view group',	3, 'view_group'),
    ('Can add user',	4, 'add_user'),
    ('Can change user',	4, 'change_user'),
    ('Can delete user',	4, 'delete_user'),
    ('Can view user',	4, 'view_user'),
    ('Can add content type',	5, 'add_contenttype'),
    ('Can change content type',	5, 'change_contenttype'),
    ('Can delete content type',	5, 'delete_contenttype'),
    ('Can view content type',	5, 'view_contenttype'),
    ('Can add session',	6, 'add_session'),
    ('Can change session',	6, 'change_session'),
    ('Can delete session',	6, 'delete_session'),
    ('Can view session',	6, 'view_session'),
    ('Can add analysis',	7, 'add_analysis'),
    ('Can change analysis',	7, 'change_analysis'),
    ('Can delete analysis',	7, 'delete_analysis'),
    ('Can view analysis',	7, 'view_analysis'),
    ('Can add auth group',	8, 'add_authgroup'),
    ('Can change auth group',	8, 'change_authgroup'),
    ('Can delete auth group',	8, 'delete_authgroup'),
    ('Can view auth group',	8, 'view_authgroup'),
    ('Can add auth group permissions',	9, 'add_authgrouppermissions'),
    ('Can change auth group permissions',	9, 'change_authgrouppermissions'),
    ('Can delete auth group permissions',	9, 'delete_authgrouppermissions'),
    ('Can view auth group permissions',	9, 'view_authgrouppermissions'),
    ('Can add auth permission',	10, 'add_authpermission'),
    ('Can change auth permission',	10, 'change_authpermission'),
    ('Can delete auth permission',	10, 'delete_authpermission'),
    ('Can view auth permission',	10, 'view_authpermission'),
    ('Can add auth user',	11, 'add_authuser'),
    ('Can change auth user',	11, 'change_authuser'),
    ('Can delete auth user',	11, 'delete_authuser'),
    ('Can view auth user',	11, 'view_authuser'),
    ('Can add auth user groups',	12, 'add_authusergroups'),
    ('Can change auth user groups',	12, 'change_authusergroups'),
    ('Can delete auth user groups',	12, 'delete_authusergroups'),
    ('Can view auth user groups',	12, 'view_authusergroups'),
    ('Can add auth user user permissions',	13, 'add_authuseruserpermissions'),
    ('Can change auth user user permissions',	13, 'change_authuseruserpermissions'),
    ('Can delete auth user user permissions',	13, 'delete_authuseruserpermissions'),
    ('Can view auth user user permissions',	13, 'view_authuseruserpermissions'),
    ('Can add containers',	14, 'add_containers'),
    ('Can change containers',	14, 'change_containers'),
    ('Can delete containers',	14, 'delete_containers'),
    ('Can view containers', 14, 'view_containers'),
    ('Can add cut',	15, 'add_cut'),
    ('Can change cut',	15, 'change_cut'),
    ('Can delete cut',	15, 'delete_cut'),
    ('Can view cut',	15, 'view_cut'),
    ('Can add django admin log',	16, 'add_djangoadminlog'),
    ('Can change django admin log',	16, 'change_djangoadminlog'),
    ('Can delete django admin log',	16, 'delete_djangoadminlog'),
    ('Can view django admin log',	16, 'view_djangoadminlog'),
    ('Can add django content type',	17, 'add_djangocontenttype'),
    ('Can change django content type',	17, 'change_djangocontenttype'),
    ('Can delete django content type',	17, 'delete_djangocontenttype'),
    ('Can view django content type',	17, 'view_djangocontenttype'),
    ('Can add django migrations',	18, 'add_djangomigrations'),
    ('Can change django migrations',	18, 'change_djangomigrations'),
    ('Can delete django migrations',	18, 'delete_djangomigrations'),
    ('Can view django migrations',	18, 'view_djangomigrations'),
    ('Can add django session',	19, 'add_djangosession'),
    ('Can change django session',	19, 'change_djangosession'),
    ('Can delete django session',	19, 'delete_djangosession'),
    ('Can view django session',	19, 'view_djangosession'),
    ('Can add patients',	20, 'add_patients'),
    ('Can change patients',	20, 'change_patients'),
    ('Can delete patients',	20, 'delete_patients'),
    ('Can view patients',	20, 'view_patients'),
    ('Can add sample',	21, 'add_sample'),
    ('Can change sample',	21, 'change_sample'),
    ('Can delete sample',	21, 'delete_sample'),
    ('Can view sample',	21, 'view_sample'),
    ('Can add temperature',	22, 'add_temperature'),
    ('Can change temperature',	22, 'change_temperature'),
    ('Can delete temperature',	22, 'delete_temperature'),
    ('Can view temperature',	22, 'view_temperature'),
    ('Can add tumortype',	23, 'add_tumortype'),
    ('Can change tumortype',	23, 'change_tumortype'),
    ('Can delete tumortype',	23, 'delete_tumortype'),
    ('Can view tumortype',	23, 'view_tumortype');
      

        
/* content type */    
    INSERT INTO django_content_type (app_label, model) VALUES
    
    ('admin', 'logentry'),
    ('auth', 'permission'),
    ('auth', 'group'),
    ('auth', 'user'),
    ('contenttypes', 'contenttype'),
    ('sessions', 'session'),
    ('coleyapi', 'analysis'),
    ('coleyapi', 'authgroup'),
    ('coleyapi', 'authgrouppermissions'),
    ('coleyapi', 'authpermission'),
    ('coleyapi', 'authuser'),
    ('coleyapi', 'authusergroups'),
    ('coleyapi', 'authuseruserpermissions'),
    ('coleyapi', 'containers'),
    ('coleyapi', 'cut'),
    ('coleyapi', 'djangoadminlog'),
    ('coleyapi', 'djangocontenttype'),
    ('coleyapi', 'djangomigrations'),
    ('coleyapi', 'djangosession'),
    ('coleyapi', 'patients'),
    ('coleyapi', 'sample'),
    ('coleyapi', 'temperature'),
    ('coleyapi', 'tumortype');  
     
/*
 * End of Django native tables
 */ 
    
/* 
 * Coleyapp tables
 */    
    INSERT INTO temperature (temperature_desc) VALUES 
    ('-80ºC'),
    ('4ºC'),
    ('other');
    
    
    INSERT INTO containers (container_name, container_desc) VALUES
    ('main freezer', {
  "drawer 1": {
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
  }
});

    INSERT INTO tumortype (tumor_description) VALUES
    ('pancreatic cancer');
    ('liver cancer');
    ('bladder cancer');
    
    INSERT INTO tissuetype (tissue_description) VALUES
    ('blood');
    ('liver');
    ('connective tissue');
    ('skin');

   
COMMIT;




