#STRING SPLIT V1
#DO NOT ALTER OR CHANGE CODE


CREATE PROCEDURE string_split_procedure(IN `table` varchar(255), IN `column` varchar(255), IN `delimiter` varchar(500))
BEGIN
-- Drop the world (if exists)


-- declare needed variables for input
SET @tb = `table`;
SET @col = `column`;
SET @col2 = (SELECT REPLACE(`column`,'`',''));
SET @del = `delimiter`;
###
-- Set Column List (needed to call future columns) --------------------------
SET @col_list 	= (
  CONCAT(
    "SET @col_list = (SELECT CONCAT('a.`',GROUP_CONCAT(COLUMN_NAME SEPARATOR '`, a.`'),'`') FROM information_schema.columns WHERE TABLE_NAME = '",@tb,"');"
   )
  );
PREPARE STMT FROM @col_list;
EXECUTE STMT;
-- Find number of rows we will need to loop through
SET @var_tot = (SELECT CONCAT("SET @total = (SELECT COUNT(*) FROM ",@tb,");"));
PREPARE STMT FROM @var_tot;
EXECUTE STMT;

--  Give ever row a unique id --------------------------

SET @var1 = (CONCAT("CREATE TABLE main AS (SELECT ",@col_list,", @row:=@row+1 `Row`, CASE WHEN LENGTH('",@del,"') IS NULL THEN 0 WHEN LENGTH('",@del,"') = 0 THEN 0 ELSE ((LENGTH(",@col,") - LENGTH(REPLACE(",@col,",'",@del,"','')))/(LENGTH('",@del,"'))-1) END as 'del_len' FROM ",@tb," a, (SELECT @row:=0) b)"));
PREPARE STMT FROM @var1;
EXECUTE STMT;
###############################################

-- create output dataset
SET @var2 = (CONCAT('CREATE TABLE final AS (select *, CAST(NULL AS CHAR(1024)) `New ',@col2,'` FROM ',@tb,' LIMIT 0);'));
PREPARE STMT FROM @var2;
EXECUTE STMT;

-- Create main loop
SET @counter = 0;
WHILE (@counter <= @total) DO
	-- create loop per row
    SET @var_del_leng = (SELECT CONCAT("SET @del_leng = (SELECT `del_len` FROM main WHERE `row` = ",@counter,");"));
        PREPARE STMT FROM @var_del_leng;
        EXECUTE STMT;
	IF(@del_leng <= 0) THEN    
    	SET @var3 = (CONCAT('INSERT INTO final (SELECT ',@col_list,', a.',@col,' AS `New ',@col2,'`  FROM main a  WHERE a.`row` = ',@counter,');'));
        PREPARE STMT FROM @var3;
		EXECUTE STMT;
    ELSE 
    	SET @counter2 = 0;
        
        WHILE (@counter2 <= @del_leng) DO
        SET @counter2 = @counter2 +1;
        	SET @var4 = (CONCAT('INSERT INTO final (SELECT ',@col_list,', SUBSTRING_INDEX(SUBSTRING_INDEX(a.',@col,',\'',@del,'\',',@counter2 ,'+1),\'',@del,'\',-1) AS `New ',@col2,'`  FROM main a  WHERE a.`row` = ',@counter,');'));
        	PREPARE STMT FROM @var4;
			EXECUTE STMT;
            
        END WHILE;
        
    END IF;
    
    

set @counter = @counter + 1;
END WHILE;

END;