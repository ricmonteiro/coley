/*
 * Cut functionalites
 */
 
 
 
/*
 * List all cuts for a given sample
 */
 
 
CREATE OR REPLACE FUNCTION get_all_cuts_from_sample(sampleid INT)
RETURNS JSON
AS
$$
DECLARE
result JSON;
BEGIN

	SELECT json_agg(cuts) INTO result
	FROM (SELECT id, purpose, user_id, cut_date FROM cut WHERE sample_id = sampleid) cuts;
	RETURN result;
	
END;
$$ LANGUAGE plpgsql;
 
 
 
/*
 * Create new cut
 */ 

CREATE OR REPLACE PROCEDURE register_new_cut(sampleid INT, userid INT, prps VARCHAR, parentcutid INT DEFAULT NULL, cutdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP)
AS
$$
BEGIN

	INSERT INTO cut (user_id, purpose, sample_id, cut_date, parent_cut_id)
	VALUES (userid, prps, sampleid, cutdate, parentcutid);
	
COMMIT;
END;
$$ LANGUAGE plpgsql;	
