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
PRIMARY KEY(phones_br_code,phones_number),
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
PRIMARY KEY(admin_AT),
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

CREATE TABLE trip
(tr_id INT(11) NOT NULL AUTO_INCREMENT,
 tr_departure DATETIME NOT NULL,
 tr_return DATETIME NOT NULL,
 tr_maxseats TINYINT(4) NOT NULL,
 tr_cost FLOAT(7,2) UNSIGNED NOT NULL,
 tr_br_code INT(11) NOT NULL,
 tr_gui_AT CHAR(10) NOT NULL,
 tr_drv_AT CHAR(10) NOT NULL,
 PRIMARY KEY(tr_id),
 CONSTRAINT BRANCHTRIP
 FOREIGN KEY(tr_br_code) REFERENCES branch(branch_code),
 CONSTRAINT GUIDETRIP
 FOREIGN KEY(tr_gui_AT) REFERENCES guide(guide_AT),
 CONSTRAINT DRIVERTRIP
 FOREIGN KEY(tr_drv_AT) REFERENCES driver(driver_AT)
 ON DELETE CASCADE ON UPDATE CASCADE);

CREATE TABLE event
(ev_tr_id INT(11) NOT NULL,
 ev_start DATETIME NOT NULL,
 ev_end DATETIME NOT NULL,
 ev_descr TEXT NOT NULL,
 PRIMARY KEY(ev_tr_id),
 CONSTRAINT TRIPEVENT
 FOREIGN KEY(ev_tr_id) REFERENCES trip(tr_id)
 ON DELETE CASCADE ON UPDATE CASCADE);

CREATE TABLE manages
(mng_adm_AT CHAR(10) NOT NULL,
 mng_br_code INT(11) NOT NULL,
 PRIMARY KEY(mng_adm_AT,mng_br_code),
 CONSTRAINT ADMINMANAGES
 FOREIGN KEY(mng_adm_AT) REFERENCES admin(admin_AT),
 CONSTRAINT MANAGESBRANCH
 FOREIGN KEY(mng_br_code) REFERENCES branch(branch_code)
 ON DELETE CASCADE ON UPDATE CASCADE);
 
 CREATE TABLE reservation
 (res_tr_id INT(11) UNSIGNED NOT NULL,
  res_seatnum TINYINT(4) UNSIGNED NOT NULL,
  res_name VARCHAR(20) DEFAULT 'unknown' NOT NULL,
  res_lname VARCHAR(20) DEFAULT 'unknown' NOT NULL,
  res_isadult ENUM('ADULT','MINOR'),
  
  PRIMARY KEY(res_seatnum),
  CONSTRAINT TRIPRESERVED
  FOREIGN KEY(res_tr_id) REFERENCES trip(tr_id)
  ON DELETE CASCADE ON UPDATE CASCADE);
  
  CREATE TABLE destination
  (dst_id INT(11) NOT NULL AUTO_INCREMENT,
   dst_name VARCHAR(50) NOT NULL,
   dst_descr  TEXT NOT NULL,
   dst_rtype ENUM('LOCAL','ABROAD'),
   dst_language VARCHAR(30) NOT NULL,
   dst_location INT(11) NOT NULL,
   PRIMARY KEY(dst_id),
   CONSTRAINT DESTININSIDEREFERENCE
   FOREIGN KEY(dst_id) REFERENCES destination(dst_location)
   ON DELETE CASCADE ON UPDATE CASCADE);
   
   
   
 
 
