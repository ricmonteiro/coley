CREATE OR REPLACE PROCEDURE register_new_analysis(userid INT, cutid INT, submitdate TEXT, xlsxfile TEXT)
AS
$$
BEGIN

	INSERT INTO analysis (user_id, cut_id, submit_date, result_xlsx_path)
	VALUES (userid, cutid, submitdate, xlsxfile);
	
COMMIT;
RAISE INFO 'Analysis submition procedure created successfully';
END;
$$ LANGUAGE plpgsql;
