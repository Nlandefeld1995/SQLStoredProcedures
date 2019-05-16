#Missing Dates V1
#DO NOT ALTER OR CHANGE CODE

CREATE PROCEDURE missing_dates(IN `table_name` varchar(130), IN `date_column` varchar(130))
BEGIN

-- ------------
#NULL any variables that will use in procedure
SET @table_name		= NULL;
SET @date_column 	= NULL;
SET @column_list	= NULL;
SET @var_1			= NULL;
SET @var_2			= NULL;
SET @var_3			= NULL;
-- ------------
#DROP any tables that will use in procedure
DROP TABLE IF EXISTS calendar;
DROP TABLE IF EXISTS ints;
DROP TABLE IF EXISTS tb_1;
-- ------------
#SET user defined variables
SET @table_name		= `table_name`;
SET @date_column 	= `date_column`;
-- ------------------------------------------------
#Create calendar
-- create table declare primary key and columns
CREATE TABLE calendar (
	`date` DATE NOT NULL PRIMARY KEY,
	y SMALLINT NULL,
	q tinyint NULL,
	m tinyint NULL,
	d tinyint NULL
	
);
-- ------------
-- create table to use 
CREATE TABLE ints ( i tinyint );
-- ------------
-- add values 0-9 into table as values
INSERT INTO ints VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9);
 -- ------------
-- create date column 
INSERT INTO calendar (`date`)
SELECT DATE('2010-01-01') + INTERVAL a.i*10000 + b.i*1000 + c.i*100 + d.i*10 + e.i DAY
FROM ints a JOIN ints b JOIN ints c JOIN ints d JOIN ints e
WHERE (a.i*10000 + b.i*1000 + c.i*100 + d.i*10 + e.i) <= 11322
ORDER BY 1;
-- ------------
-- Set other column values
UPDATE calendar
SET 
	y = YEAR(`date`),
	q = quarter(`date`),
	m = MONTH(`date`),
	d = dayofmonth(`date`);
-- ------------    
#END CALENDAR 
-- ------------------------------------------------
#Create variable for all columns not including date column.

-- Start create column_list
-- Create list of all columns from dataset store them in variable to use in future quieries
SET @column_list 	= (
  CONCAT(
    "SET @column_list = (SELECT CONCAT('a.`',GROUP_CONCAT(COLUMN_NAME SEPARATOR '`, a.`'),'`') FROM information_schema.columns WHERE TABLE_NAME = '",@table_name,"' AND COLUMN_NAME NOT LIKE '",REPLACE(@date_column,'`',''),"');"
   )
  );
PREPARE STMT FROM @column_list;
EXECUTE STMT;
-- End create column_list
-- ---------------


SET @var_1 = (
CONCAT('CREATE TABLE tb_1 AS (SELECT b.`date` AS ',@date_column,' , ',@column_list,' FROM calendar b LEFT JOIN ',@table_name,' a on b.`date` = a.',@date_column,' WHERE YEAR(b.`date`) <= YEAR((SELECT MAX(',@date_column,') FROM ',@table_name,')) AND YEAR(b.`date`) >= YEAR((SELECT MIN(',@date_column,') FROM ',@table_name,')));') 
);
create table test as (select @var_1);

PREPARE STMT FROM @var_1;
EXECUTE STMT;

-- ---------------
#Drop table and replace it
SET @var_2 = (concat('drop table ',@table_name,';'));
PREPARE STMT FROM @var_2;
EXECUTE STMT;

SET @var_3 = (CONCAT('CREATE TABLE ',@table_name,' AS(SELECT * FROM tb_1);'));
PREPARE STMT FROM @var_3;
EXECUTE STMT;

DROP TABLE tb_1;
-- ---------------

END; 