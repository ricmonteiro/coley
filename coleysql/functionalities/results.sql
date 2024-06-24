/*
 * Get all results associated with a given sample
 */
 
 
CREATE OR REPLACE FUNCTION get_results_for_sample(sampleid INT)
RETURNS json
AS
$$
DECLARE
    result_list JSON;
BEGIN
    WITH cuts AS (
        SELECT * FROM cut WHERE sample_id = sampleid
    )
    SELECT json_agg(json_build_object(
        'user', (SELECT username FROM auth_user WHERE auth_user.id = analysis.user_id,
        'result_path', analysis.result_xlsl_path,
        'cut_id', cuts.id,
        'sample_id', sample_id
    )) INTO result_list
    FROM results
    INNER JOIN cuts ON cut.id = analysis.cut_id;
    
    RETURN result_list;
END;
$$ LANGUAGE plpgsql;

 

