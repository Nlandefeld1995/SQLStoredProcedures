#Remove Unwanted ASCII Characters V1
#DO NOT ALTER OR CHANGE THIS TRANSFORM

CREATE PROCEDURE remove_uncommon_ascii(IN `input` char(255), IN `column` char(255))
BEGIN
SET @in = `input`;
SET @col = `column`;

SET @counter = 1;
WHILE ((@counter <= 31 OR @counter >= 127) AND @counter <= 300) DO
  SET @var = (SELECT CONCAT("update ",@in," set ",@col," = replace(",@col,", CHAR(",@counter,"), '');") query);
  PREPARE STMT FROM @var;
  EXECUTE STMT;

  IF(@counter = 31) THEN 
    SET @counter = 127;
  ELSE
    SET @counter = @counter +1;
  END IF;

END WHILE;


SET @var2 = (SELECT CONCAT("update ",@in," set ",@col," = TRIM(",@col,");") query);
  PREPARE STMT FROM @var2;
  EXECUTE STMT;

END;