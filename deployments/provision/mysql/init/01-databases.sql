CREATE DATABASE IF NOT EXISTS fire;
CREATE DATABASE IF NOT EXISTS fire_test;

GRANT ALL ON fire.* TO 'usr'@'%';
GRANT ALL ON fire_test.* TO 'usr'@'%';