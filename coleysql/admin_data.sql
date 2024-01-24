INSERT INTO auth_group (name) VALUES
    ('Admin'),
    ('Supervisor'),
    ('Technician'),
    ('Student');


INSERT INTO auth_user_groups (user_id, group_id) VALUES
    (1 , 1),
    (1 , 2),
    (1 , 3),
    (1 , 4);   
    
    
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
  }
}');


INSERT INTO tumortype (tumor_description) VALUES
    ('pancreatic cancer'),
    ('liver cancer'),
    ('bladder cancer');   
    
    
INSERT INTO tissuetype (tissue_description) VALUES
    ('blood'),
    ('liver'),
    ('connective tissue'),
    ('skin');
