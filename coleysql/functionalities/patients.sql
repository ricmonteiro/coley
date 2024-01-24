/*
 * Patients functionalities
 */
 
 
/*
 * Register new patient
 */
  
CREATE OR REPLACE PROCEDURE register_new_patient(name TEXT, dob DATE, pgender TEXT)
AS
$$
BEGIN
	INSERT INTO patients(patient_name, patient_dob, gender)
	VALUES (name, dob, pgender);
	
COMMIT;
RAISE INFO 'Patient registered successfully';
END;
$$ LANGUAGE plpgsql;
