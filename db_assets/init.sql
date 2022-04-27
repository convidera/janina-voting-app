CREATE DATABASE IF NOT EXISTS testingdb; 

--@<IP-address>, % is a wildcard meaning zero or more characters
CREATE USER 'testing'@'%' IDENTIFIED with caching_sha2_password BY 'password';

--testing.* - * grants access to all tables in testing database, database <database>.<table>, * would be access in database
GRANT ALL ON testingdb.* TO 'testing'@'%';