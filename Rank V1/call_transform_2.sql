#Rank/row count V1 
#If multiple columns are needed comma seperate them. 
#If no partition is needed enter '' as value. IE: "'columns_to_order_by','');"

CALL global_rank('table_name','column(s)_to_order_by','column(s)_to_partition_by');