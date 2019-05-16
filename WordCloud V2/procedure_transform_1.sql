#Word Cloud V2
#DO NOT ALTER OR CHANGE THIS CODE

CREATE PROCEDURE word_cloud(IN `input_dataset` varchar(255), IN `column` varchar(255),IN `common words` varchar(255), IN `symbols` varchar(255))
BEGIN

-- Decalar Variables ---------------------
SET @input_dataset = `input_dataset`;
SET @column = `column`;
SET @column2 = (SELECT REPLACE(`column`,'`',''));
SET @common_word = `common words`;
SET @common_symbol = `symbols`;
SET @word_list = (CONCAT("","'1', '2', '3', '4', '5', '6', '7', '8', '9', '-', '.', '&', 'A', 'ABLE', 'ABOUT', 'ABSOLUTELY', 'AFTER', 'AGAIN', 'ALL', 'ALONG', 'ALSO', 'ALWAYS', 'AM', 'AN', 'AND', 'ANOTHER', 'ANY', 'ANYONE', 'ANYTHING', 'ANYWHERE', 'ARE', 'AROUND', 'AS', 'ASKED', 'AT', 'AWAY', 'BACK', 'BE', 'BECAUSE', 'BECOME', 'BEEN', 'BEFORE', 'BEST', 'BETTER', 'BETWEEN', 'BIGGEST', 'BOTH', 'BRING', 'BUT', 'BY', 'CAME', 'CAN', 'CAN''T', 'CANNOT', 'CANT', 'CHANCE', 'COME', 'COMES', 'COULD', 'COULDN''T', 'DEFINITELY', 'DID', 'DIDN''T', 'DO', 'DOES', 'DOESN''T', 'DOING', 'DON''T', 'DONE', 'DURING', 'EACH', 'ELSE', 'ENOUGH', 'ENTIRE', 'ESPECIALLY', 'EVEN', 'EVER', 'EVERY', 'EVERYDAY', 'EVERYONE', 'EVERYTHING', 'FELT', 'FEW', 'FIRST', 'FOR', 'FROM', 'FRONT', 'GET', 'GETS', 'GETTING', 'GIVE', 'GIVEN', 'GIVES', 'GO', 'GOES', 'GOING', 'GOOD', 'GOT', 'GREAT', 'HAD', 'HAS', 'HASN''T', 'HAVE', 'HAVEN''T', 'HAVING', 'HE', 'HE''S', 'HELPED', 'HER', 'HER.', 'HERE', 'HERSELF', 'HERSELF.', 'HI', 'HIM', 'HIS', 'HOW', 'I', 'I''D', 'I''LL', 'I''M', 'I''VE', 'IF', 'IM', 'IN', 'INTO', 'IS', 'IT', 'IT.', 'IT''S', 'ITS', 'JUST', 'KEEP', 'KEEPS', 'KNOW', 'LAST', 'LET', 'LIKE', 'LOOKS', 'LOT', 'MADE', 'MAKE', 'MAKES', 'MAKING', 'MANY', 'MATTER', 'MAY', 'ME', 'ME.', 'MEANS', 'MORE', 'MORE.', 'MOST', 'MUCH', 'MY', 'MYSELF', 'NEARLY', 'NEED', 'NEEDS', 'NEVER', 'NEXT', 'NO', 'NOT', 'NOTHING', 'NOW', 'OF', 'ON', 'ONE', 'ONLY', 'OR', 'OTHER', 'OTHERS', 'OUR', 'OUT', 'OVER', 'OWN', 'PLEASE', 'PROBABLY', 'PUT', 'PUTS', 'REALLY', 'RECENTLY', 'SAID', 'SAME', 'SAW', 'SAY', 'SEE', 'SEEN', 'SHE', 'SHE''S', 'SHOULD', 'SIMPLE', 'SINCE', 'SO', 'SOME', 'SOMEONE', 'SOMETHING', 'SOMEWHERE', 'SPECIAL', 'STILL', 'SUCH', 'SURE', 'SURELY', 'TAKE', 'TAKES', 'TELL', 'TH', 'THAN', 'THAT', 'THAT''S', 'THE', 'THEIR', 'THEM', 'THEN', 'THERE', 'THESE', 'THEY', 'THING', 'THINGS', 'THINK', 'THINKING', 'THIS', 'THOSE', 'THOUGH', 'THOUGHT', 'THREE', 'THROUGH', 'TILL', 'TO', 'TOGETHER', 'TOLD', 'TOO', 'TOOK', 'TOWARDS', 'TRULY', 'TRYING', 'U', 'UNTIL', 'UP', 'UR', 'US', 'US.', 'USE', 'VERY', 'VIA', 'WANT', 'WANTED', 'WANTS', 'WAS', 'WAY', 'WE', 'WE''RE', 'WENT', 'WERE', 'WHAT', 'WHATEVER', 'WHEN', 'WHENEVER', 'WHERE', 'WHICH', 'WHILE', 'WHO', 'WHOM', 'WHY', 'WILL', 'WITH', 'WITHIN', 'WITHOUT', 'WOULD', 'YET', 'YOU', 'YOU.', 'YOU''D', 'YOU''RE', 'YOUR'"));
###############################################

-- Set Column List (needed to call future columns) --------------------------
SET @column_list  = (
  CONCAT(
    "SET @column_list = (SELECT CONCAT('a.`',GROUP_CONCAT(COLUMN_NAME SEPARATOR '`, a.`'),'`') FROM information_schema.columns WHERE TABLE_NAME = '",@input_dataset,"' AND COLUMN_NAME NOT LIKE '",@column2,"');"
   )
  );
PREPARE STMT FROM @column_list;
EXECUTE STMT;


SET @var2 = (CONCAT('CREATE TABLE final AS (select ',@column_list,',a.',@column,', CAST(NULL AS CHAR(255)) `New ',@column2,'` FROM ',@input_dataset,' a LIMIT 0);'));
PREPARE STMT FROM @var2;
EXECUTE STMT;
###############################################
IF(@common_word LIKE '%y%' AND @common_symbol LIKE '%y%') THEN
  SET @var = (CONCAT("CREATE TABLE main AS (SELECT ",@column_list,", REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(  REPLACE(  REPLACE(  REPLACE(  REPLACE( REPLACE(TRIM(a.",@column,"),'~',''),'`',''),'!',''),'@',''),'#',''),'£',''),'€',''),'$',''),'¢',''),'¥',''),'§',''),'%',''),'°',''),'^',''),'&',''),'*',''),'(',''),')',''),'-',''),'_',''),'+',''),'=',''),'{',''),'}',''),'[',''),']',''),'|',''),'","\\","\\',''),'/',''),':',''),';',''),'',''),'","\\","\'',''),'<',''),'>',''),',',''),'.',''),'?',''),'“',''),'”',''),'-',''),'–',''),'’',''),'\"','') as ",@column,",a.",@column," as `original` FROM ",@input_dataset," a);"));
  PREPARE STMT FROM @var;
  EXECUTE STMT;
    
    SET @var1 = (CONCAT('CREATE TABLE main2 AS (SELECT ',@column_list,' ,a.`original`,a.',@column,',  @row:=@row+1 `Row`, IFNULL(LENGTH(a.',@column,') - LENGTH(REPLACE(a.',@column,',\' \',\'\')),0) `Total` FROM main a, (SELECT @row:=0) b)'));
PREPARE STMT FROM @var1;
EXECUTE STMT;
  SET @counter = 0;
WHILE (@counter <= (SELECT MAX(row) FROM main2)) DO
  SET @total = (SELECT `Total` FROM main2 WHERE `row` = @counter);
  IF(@total = 0) THEN    
      SET @var3 = (CONCAT('INSERT INTO final (SELECT ',@column_list,',a.`original` as ',@column,', a.',@column,' AS `New ',@column2,'`  FROM main2 a  WHERE a.`row` = ',@counter,');'));
        PREPARE STMT FROM @var3;
      EXECUTE STMT;
    ELSE 
      SET @counter2 = 0;
        WHILE (@counter2 <= @total) DO
          SET @var4 = (CONCAT('INSERT INTO final (SELECT ',@column_list,',a.`original` as ',@column,', SUBSTRING_INDEX(SUBSTRING_INDEX(a.',@column,',\' \',',@counter2 ,'+1),\' \',-1) AS `New ',@column2,'`  FROM main2 a  WHERE a.`row` = ',@counter,');'));
          PREPARE STMT FROM @var4;
      EXECUTE STMT;
            SET @counter2 = @counter2 +1;
        END WHILE;
        
    END IF;
    
    
SET @counter = @counter + 1;
END WHILE;

SET @var9 =(CONCAT("DELETE FROM final WHERE `NEW ",@column2,"` IN (",@word_list,");"));
PREPARE STMT FROM @var9;
EXECUTE STMT;
########################################################
ELSEIF(@common_word LIKE '%n%' AND @common_symbol LIKE '%y%') THEN
  SET @var = (CONCAT("CREATE TABLE main AS (SELECT ",@column_list,", REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(  REPLACE(  REPLACE(  REPLACE(  REPLACE( REPLACE(TRIM(a.",@column,"),'~',''),'`',''),'!',''),'@',''),'#',''),'£',''),'€',''),'$',''),'¢',''),'¥',''),'§',''),'%',''),'°',''),'^',''),'&',''),'*',''),'(',''),')',''),'-',''),'_',''),'+',''),'=',''),'{',''),'}',''),'[',''),']',''),'|',''),'","\\","\\',''),'/',''),':',''),';',''),'',''),'","\\","\'',''),'<',''),'>',''),',',''),'.',''),'?',''),'“',''),'”',''),'-',''),'–',''),'’',''),'\"','') as ",@column,",a.",@column," as `original` FROM ",@input_dataset," a);"));
  PREPARE STMT FROM @var;
  EXECUTE STMT;
    
    SET @var1 = (CONCAT('CREATE TABLE main2 AS (SELECT ',@column_list,',a.`original`,a.',@column,',  @row:=@row+1 `Row`, IFNULL(LENGTH(a.',@column,') - LENGTH(REPLACE(a.',@column,',\' \',\'\')),0) `Total` FROM main a, (SELECT @row:=0) b)'));
PREPARE STMT FROM @var1;
EXECUTE STMT;
  SET @counter = 0;
WHILE (@counter <= (SELECT MAX(row) FROM main2)) DO
  SET @total = (SELECT `Total` FROM main2 WHERE `row` = @counter);
  IF(@total = 0) THEN    
      SET @var3 = (CONCAT('INSERT INTO final (SELECT ',@column_list,',a.`original` as ',@column,', a.',@column,' AS `New ',@column2,'`  FROM main2 a  WHERE a.`row` = ',@counter,');'));
        PREPARE STMT FROM @var3;
    EXECUTE STMT;
    ELSE 
      SET @counter2 = 0;
        WHILE (@counter2 <= @total) DO
          SET @var4 = (CONCAT('INSERT INTO final (SELECT ',@column_list,',a.`original` as ',@column,', SUBSTRING_INDEX(SUBSTRING_INDEX(a.',@column,',\' \',',@counter2 ,'+1),\' \',-1) AS `New ',@column2,'`  FROM main2 a  WHERE a.`row` = ',@counter,');'));
          PREPARE STMT FROM @var4;
      EXECUTE STMT;
            SET @counter2 = @counter2 +1;
        END WHILE;
        
    END IF;
    
    
SET @counter = @counter + 1;
END WHILE;
########################################################
ELSEIF(@common_word LIKE '%y%' AND @common_symbol LIKE '%n%') THEN
  SET @var = (CONCAT("CREATE TABLE main AS (SELECT ",@column_list,", a.",@column," as ",@column," FROM ",@input_dataset," a);"));
  PREPARE STMT FROM @var;
  EXECUTE STMT;
    
    SET @var1 = (CONCAT('CREATE TABLE main2 AS (SELECT ',@column_list,',a.',@column,',  @row:=@row+1 `Row`, IFNULL(LENGTH(a.',@column,') - LENGTH(REPLACE(a.',@column,',\' \',\'\')),0) `Total` FROM main a, (SELECT @row:=0) b)'));
PREPARE STMT FROM @var1;
EXECUTE STMT;
  SET @counter = 0;
WHILE (@counter <= (SELECT MAX(row) FROM main2)) DO
  SET @total = (SELECT `Total` FROM main2 WHERE `row` = @counter);
  IF(@total = 0) THEN    
      SET @var3 = (CONCAT('INSERT INTO final (SELECT ',@column_list,',a.',@column,', a.',@column,' AS `New ',@column2,'`  FROM main2 a  WHERE a.`row` = ',@counter,');'));
        PREPARE STMT FROM @var3;
    EXECUTE STMT;
    ELSE 
      SET @counter2 = 0;
        WHILE (@counter2 <= @total) DO
          SET @var4 = (CONCAT('INSERT INTO final (SELECT ',@column_list,',a.',@column,', SUBSTRING_INDEX(SUBSTRING_INDEX(a.',@column,',\' \',',@counter2 ,'+1),\' \',-1) AS `New ',@column2,'`  FROM main2 a  WHERE a.`row` = ',@counter,');'));
          PREPARE STMT FROM @var4;
      EXECUTE STMT;
            SET @counter2 = @counter2 +1;
        END WHILE;
        
    END IF;
    
    
SET @counter = @counter + 1;
END WHILE;
SET @var9 =(CONCAT("DELETE FROM final WHERE `NEW ",@column2,"` IN (",@word_list,");"));
PREPARE STMT FROM @var9;
EXECUTE STMT;
########################################################
ELSE 
  SET @var = (CONCAT("CREATE TABLE main AS (SELECT ",@column_list,", a.",@column," as ",@column," FROM ",@input_dataset," a);"));
  PREPARE STMT FROM @var;
  EXECUTE STMT;
    
    SET @var1 = (CONCAT('CREATE TABLE main2 AS (SELECT ',@column_list,',a.',@column,',  @row:=@row+1 `Row`, IFNULL(LENGTH(a.',@column,') - LENGTH(REPLACE(a.',@column,',\' \',\'\')),0) `Total` FROM main a, (SELECT @row:=0) b)'));
PREPARE STMT FROM @var1;
EXECUTE STMT;
  SET @counter = 0;
WHILE (@counter <= (SELECT MAX(row) FROM main2)) DO
  SET @total = (SELECT `Total` FROM main2 WHERE `row` = @counter);
  IF(@total = 0) THEN    
      SET @var3 = (CONCAT('INSERT INTO final (SELECT ',@column_list,',a.',@column,', a.',@column,' AS `New ',@column2,'`  FROM main2 a  WHERE a.`row` = ',@counter,');'));
        PREPARE STMT FROM @var3;
    EXECUTE STMT;
    ELSE 
      SET @counter2 = 0;
        WHILE (@counter2 <= @total) DO
          SET @var4 = (CONCAT('INSERT INTO final (SELECT ',@column_list,',a.',@column,', SUBSTRING_INDEX(SUBSTRING_INDEX(a.',@column,',\' \',',@counter2 ,'+1),\' \',-1) AS `New ',@column2,'`  FROM main2 a  WHERE a.`row` = ',@counter,');'));
          PREPARE STMT FROM @var4;
      EXECUTE STMT;
            SET @counter2 = @counter2 +1;
        END WHILE;
        
    END IF;
    
    
SET @counter = @counter + 1;
END WHILE;    
########################################################
END IF;



END;