/*
 * Sample functionalites
 */


/*
 * Get sample information
 */
  
CREATE OR REPLACE FUNCTION sample_information(sampleid INT)
RETURNS json
AS
$$
BEGIN
RETURN (SELECT json_agg(json_build_object('id',id, 'user',user_id,'origin',origin))
	FROM sample WHERE id = sampleid);
END;
$$ LANGUAGE plpgsql;



/*
 * Get samples registered by a given user
 */
 
CREATE OR REPLACE FUNCTION sample_list_for_user(userid INT)
RETURNS json
AS 
$$
BEGIN
RETURN (SELECT json_agg(json_build_object(t)) FROM sample t WHERE t.user_id = userid); 
END;
$$ LANGUAGE plpgsql;


/*
 * Register new sample
 */
 
CREATE OR REPLACE PROCEDURE register_new_sample(userid INT, origin TEXT, patientid INT, tumortypeid INT, tissuetypeid INT, temperatureid INT, containerid INT, "location" JSON, entrydate TIMESTAMP DEFAULT CURRENT_TIMESTAMP)
AS
$$
BEGIN

	INSERT INTO sample (user_id, origin, patient_id, tumor_type_id, tissue_type_id, entry_date, temperature_id, container_id, "location")
	VALUES (userid, origin, patientid, tumortypeid, tissuetypeid, entrydate, temperatureid, containerid, "location");
	
COMMIT;
RAISE INFO 'Sample registered successfully';
END;
$$ LANGUAGE plpgsql;
