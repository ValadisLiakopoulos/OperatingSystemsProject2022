CREATE DATABASE travel_agency;

USE travel_agency;

CREATE TABLE branch
(branch_code INT(11) NOT NULL AUTO_INCREMENT,
branch_street VARCHAR(30) NOT NULL,
branch_num INT(4) NOT NULL,
branch_city VARCHAR(30) NOT NULL,
PRIMARY KEY(branch_code));

CREATE TABLE phones
(phones_br_code INT(11) NOT NULL,
phones_number CHAR(10) NOT NULL,
PRIMARY KEY(phones_br_code),
CONSTRAINT BRANCHPHONES 
FOREIGN KEY(phones_br_code) REFERENCES branch(branch_code));

CREATE TABLE worker
(worker_AT CHAR(10) NOT NULL, 
worker_name VARCHAR(20) DEFAULT 'unknown' NOT NULL,
worker_lname VARCHAR(20) DEFAULT 'unknown' NOT NULL,
worker_salary FLOAT(7,2) NOT NULL, 
worker_br_code INT(11) NOT NULL, 
PRIMARY KEY(worker_AT),
CONSTRAINT WORKERBRANCH
FOREIGN KEY(worker_br_code) REFERENCES branch(branch_code));

CREATE TABLE admin
(admin_AT CHAR(10) NOT NULL,
admin_type ENUM('LOGISTICS','ADMINISTRATIVE','ACCOUNTING'),
admin_diploma VARCHAR(200) NOT NULL,
PRIMARY KEY(admin_A),
CONSTRAINT ADMINWORKER 
FOREIGN KEY(admin_AT) REFERENCES worker(worker_AT));

CREATE TABLE driver
(driver_AT CHAR(10) NOT NULL,
driver_licence ENUM('A','B','C','D') NOT NULL,
driver_route ENUM('LOCAL','ABROAD') NOT NULL,
driver_experience TINYINT(4) NOT NULL,
PRIMARY KEY(driver_AT),
CONSTRAINT DRIVERWORKER 
FOREIGN KEY(driver_AT) REFERENCES worker(worker_AT));

CREATE TABLE guide
(guide_AT CHAR(10) NOT NULL,
guide_cv TEXT,
PRIMARY KEY(guide_AT),
CONSTRAINT GUIDEWORKER 
FOREIGN KEY(guide_AT) REFERENCES worker(worker_AT));

CREATE TABLE languages
(lng_guide_AT CHAR(10) NOT NULL,
lng_languages VARCHAR(30) NOT NULL,
PRIMARY KEY(lng_guide_AT),
CONSTRAINT GUIDELNGS 
FOREIGN KEY(lng_guide_AT) REFERENCES guide(guide_AT));

test
