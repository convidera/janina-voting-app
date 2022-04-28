CREATE DATABASE IF NOT EXISTS ProgrLangVote; 

CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED with caching_sha2_password BY 'password'
CREATE USER IF NOT EXISTS 'Programmer'@'%' IDENTIFIED with caching_sha2_password BY 'password';

GRANT ALL ON ProgrLangVote.* TO 'root'@'%';
GRANT ALL ON ProgrLangVote.* TO 'Programmer'@'%';