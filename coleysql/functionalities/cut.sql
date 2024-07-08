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

CREATE OR REPLACE PROCEDURE register_new_cut(sampleid INT, userid INT, prps TEXT, cutdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP)
AS
$$
BEGIN

	INSERT INTO cut (user_id, purpose, cut_date, sample_id)
	VALUES (userid, prps, cutdate, sampleid) ;
	
COMMIT;
END;
$$ LANGUAGE plpgsql;	