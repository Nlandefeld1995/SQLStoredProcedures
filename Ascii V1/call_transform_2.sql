#Remove Unwanted ASCII Characters V1
# *To see the change do a Select * from your_table after this transform.


CALL remove_uncommon_ascii('your_table', '`your_column`');

