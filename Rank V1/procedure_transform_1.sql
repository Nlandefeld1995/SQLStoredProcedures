#Rank/row count V1 
#DO NOT ALTER OR CHANGE THIS CODE

CREATE PROCEDURE global_rank(IN `table_name` varchar(255), IN `order_by` varchar(255),`delimiter` varchar(255))

BEGIN
-- ----------------------------------------------------
#Set all vairiables to NULL to avoid using values from another source.
SET @table_name		= NULL;
SET @order_by 		= NULL;
SET @delimiter 		= NULL;
SET @column_list 	= NULL;
SET @var_1			= NULL;
SET @d_commas 		= NULL;
SET @var_2			= NULL;
SET @rank			= NULL;
SET @prev_1			= NULL;
SET @var_3			= NULL;
-- ---------------
#Drop All tables using to avoid pulling data from another source.
DROP TABLE IF EXISTS global_rank ;
-- ----------------------------------------------------
#Create variables from user input. 
SET @table_name 	= `table_name`; 
SET @order_by 		= `order_by`;
SET @delimiter		= `delimiter`;
-- ---------------
#Create other needed variables

-- Start create column_list
-- Create list of all columns from dataset store them in variable to use in future quieries
SET @column_list 	= (
  CONCAT(
    "SET @column_list = (SELECT CONCAT('a.`',GROUP_CONCAT(COLUMN_NAME SEPARATOR '`, a.`'),'`') FROM information_schema.columns WHERE TABLE_NAME = '",@table_name,"');"
   )
  );
PREPARE STMT FROM @column_list;
EXECUTE STMT;
-- End create column_list
-- ---------------
-- Start number of commas in delimiter
-- This will return the number of commas in the delimiter section. This will help me write query later to know when to re-start rank/row count
SET @d_commas = 
(
	CONCAT(
      "SET @d_commas = (SELECT LENGTH('",@delimiter,"') - LENGTH(REPLACE('",@delimiter,"',',','')) );"
    )
);

PREPARE STMT FROM @d_commas;
EXECUTE STMT;
-- End number of commas in delimiter
-- ----------------------------------------------------
#START IF_1

-- If no delimiter is added create table with Rank column ADDED
IF @delimiter = '' 
THEN 


SET @var_1 = (
	CONCAT(
		'CREATE TABLE global_rank AS( SELECT ',@column_list,', @rank:=@rank+1 `Rank` FROM ',@table_name,' a, (SELECT @rank:=0) b ORDER BY ',@order_by,');'
    )   
);


PREPARE STMT FROM @var_1;
EXECUTE STMT;
-- Table global_rank is now created with rank column

-- ---------------
#ELSE IF_1
-- If user only selects one delimiter creates table with this query
 ELSEIF @d_commas = 0 
 THEN 

SET @var_2 = (
	CONCAT(
		'CREATE TABLE global_rank AS( SELECT ',@column_list,', @rank:= IF( @prev_1 !=',@delimiter,',1, @rank+1) `Rank`, @prev_1:= ',@delimiter,' `Prev_value` FROM ',@table_name,' a, (SELECT @rank:=0) b, (SELECT @prev_1=NULL) c ORDER BY ',@order_by,');'
    )   
);


PREPARE STMT FROM @var_2;
EXECUTE STMT;

ALTER TABLE global_rank DROP COLUMN Prev_value;


-- ---------------
#ELSE IF_1
-- If user selects more than one delimiter creates table with this query
 ELSEIF @d_commas > 0 
 THEN 

SET @var_3 = (
	CONCAT(
		"CREATE TABLE global_rank AS( SELECT ",@column_list,", @rank:= IF( @prev_1 !=concat(",@delimiter,"),1, @rank+1) `Rank`, @prev_1:= concat(",@delimiter,") `Prev_value` FROM ",@table_name," a, (SELECT @rank:=0) b, (SELECT @prev_1=NULL) c ORDER BY ",@order_by,");"
    )   
);


PREPARE STMT FROM @var_3;
EXECUTE STMT;

ALTER TABLE global_rank DROP COLUMN Prev_value;
-- ---------------
#FAIL ERROR
ELSE  CREATE TABLE global_rank AS (SELECT 'FAIL IF_1, Please contact Support support@domo.com');

#END IF_1
END IF;
-- ----------------------------------------------------




END;