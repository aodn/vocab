

-- Usage psql -h 127.0.0.1 -U meteo -f build.sql


-- we don't want to do the dropping and creation of the database usually.
-- because then we get logged out.



-- select admin.drop_objects_in_schema( 'contr_vocab_db' );

drop schema if exists contr_vocab_db cascade; 
create schema contr_vocab_db ; 



\i docs_seb/Vocab_db_table_creation_10092014.sql; 

\i docs_seb/test_seb_vocab_v6.txt; 


