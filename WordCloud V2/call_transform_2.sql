#Word Cloud V2
#Example: CALL word_cloud('sample_word_cloud_nolan', '`Sentence`' , 'y','y' );
CALL string_split('your_data_table', '`your_column`' , 'exclude common words (y/n)','exclude common symbols (y/n)' );

