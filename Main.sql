CREATE TABLE clinical_center (
   id INTEGER NOT NULL AUTO_INCREMENT,
   name VARCHAR(45) NOT NULL,
   address VARCHAR(45),
   tel INTEGER,
   certificate ENUM('yes', 'no') NOT NULL DEFAULT 'no',
   PRIMARY KEY (id)
);

CREATE TABLE labratory (
  id INTEGER NOT NULL AUTO_INCREMENT,
  name VARCHAR(45) NOT NULL,
  address VARCHAR(45),
  tel INTEGER,
  certificate ENUM('yes', 'no') NOT NULL DEFAULT 'no',
  PRIMARY KEY (id)
);

CREATE TABLE doctor (
  id INTEGER NOT NULL AUTO_INCREMENT,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  clinical_center_id INTEGER NOT NULL,
  education VARCHAR(45),
  job_experience INTEGER,
  PRIMARY KEY (id),
  FOREIGN KEY (clinical_center_id) REFERENCES clinical_center(id)
);

CREATE TABLE clinical_monitor (
  id INTEGER NOT NULL AUTO_INCREMENT,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  clinical_center_id INTEGER NOT NULL,
  education VARCHAR(45),
  job_experience INTEGER,
  PRIMARY KEY (id),
  FOREIGN KEY (clinical_center_id) REFERENCES clinical_center(id)
);

CREATE TABLE comments_monitor (
  id INTEGER NOT NULL AUTO_INCREMENT,
  monitor_id INTEGER NOT NULL,
  date_of_comment TIMESTAMP NOT NULL,
  comment MEDIUMTEXT NOT NULL,
  fixed ENUM('yes', 'no') NOT NULL DEFAULT 'no',
  PRIMARY KEY (id),
  FOREIGN KEY (monitor_id) REFERENCES clinical_monitor(id)
);

CREATE TABLE patient (
   id INTEGER NOT NULL AUTO_INCREMENT,
   first_name VARCHAR(45) NOT NULL,
   last_name VARCHAR(45) NOT NULL,
   age INTEGER NOT NULL CHECK(age >= 18),
   birthday DATE,
   race VARCHAR(45),
   sex ENUM('m', 'f', '?') NOT NULL DEFAULT '?',
   doctor_id INTEGER NOT NULL,
   PRIMARY KEY (id),
   FOREIGN KEY (doctor_id) REFERENCES doctor(id)
);

CREATE TABLE serology_blood (
  id INTEGER NOT NULL AUTO_INCREMENT,
  patient_id INTEGER NOT NULL,
  labratory_id INTEGER NOT NULL,
  HIV ENUM('neg', 'pos') NOT NULL DEFAULT 'neg',
  syphilis ENUM('neg', 'pos') NOT NULL DEFAULT 'neg',
  hep_B ENUM('neg', 'pos') NOT NULL DEFAULT 'neg',
  hep_C ENUM('neg', 'pos') NOT NULL DEFAULT 'neg',
  PRIMARY KEY (id),
  FOREIGN KEY (patient_id) REFERENCES patient(id),
  FOREIGN KEY (labratory_id) REFERENCES labratory(id)
);

CREATE TABLE blood_analysis (
  id INTEGER NOT NULL AUTO_INCREMENT,
  patient_id INTEGER NOT NULL,
  labratory_id INTEGER NOT NULL,
  glucose DOUBLE NOT NULL,
  HDL DOUBLE,
  LDL DOUBLE,
  general_protein INTEGER,
  HGB DOUBLE NOT NULL,
  HCT DOUBLE,
  PRIMARY KEY (id),
  FOREIGN KEY (patient_id) REFERENCES patient(id),
  FOREIGN KEY (labratory_id) REFERENCES labratory(id)
);

CREATE TABLE general_urine_analysis (
  id INTEGER NOT NULL AUTO_INCREMENT,
  patient_id INTEGER NOT NULL,
  labratory_id INTEGER NOT NULL,
  PRO ENUM('yes', 'no', '?') NOT NULL DEFAULT '?',
  KET ENUM('yes', 'no', '?') NOT NULL DEFAULT '?',
  BLD INTEGER NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (patient_id) REFERENCES patient(id),
  FOREIGN KEY (labratory_id) REFERENCES labratory(id)
);

CREATE TABLE vital_functions (
  id INTEGER NOT NULL AUTO_INCREMENT,
  patient_id INTEGER NOT NULL,
  heart_rate INTEGER NOT NULL,
  temp DOUBLE,
  pressure_sys INTEGER,
  pressure_dias INTEGER,
  respiratory_rate INTEGER NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (patient_id) REFERENCES patient(id)
);

CREATE TABLE anthropometric_data (
  id INTEGER NOT NULL AUTO_INCREMENT,
  weight DOUBLE NOT NULL DEFAULT 0,
  height DOUBLE NOT NULL DEFAULT 0,
  BMI DECIMAl(10,2) NOT NULL DEFAULT 0,
  patient_id INTEGER NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (patient_id) REFERENCES patient(id)
);

CREATE TABLE physical_exam (
  id INTEGER NOT NULL AUTO_INCREMENT,
  patient_id INTEGER NOT NULL,
  cardiovascular_sys ENUM('norm', 'deviation', '?') NOT NULL DEFAULT '?',
  respiratory_sys ENUM('norm', 'deviation', '?') NOT NULL DEFAULT '?',
  digestive_sys ENUM('norm', 'deviation', '?') NOT NULL DEFAULT '?',
  endocrine_sys ENUM('norm', 'deviation', '?') NOT NULL DEFAULT '?',
  urinary_sys ENUM('norm', 'deviation', '?') NOT NULL DEFAULT '?',
  comment MEDIUMTEXT,
  PRIMARY KEY (id),
  FOREIGN KEY (patient_id) REFERENCES patient(id)
);

INSERT INTO clinical_center (name, address, certificate)
VALUES ('Klen', 'Laplandiya', 'yes');

INSERT INTO labratory (name, address, certificate)
VALUES ('VolnaLab', 'Laplandiya', 'yes'),
       ('KlenLab', 'Laplandiya', 'yes'),
       ('EvroLab', 'Evrolandiya' ,'no');

INSERT INTO doctor (clinical_center_id, first_name, last_name, education, job_experience)
VALUES (1, 'Fedor', 'Sidorov', 'GUMO', 10);

INSERT INTO clinical_monitor (clinical_center_id, first_name, last_name, education, job_experience)
VALUES (1, 'Irina', 'Petrova', 'GUMO', 7);

INSERT INTO comments_monitor (monitor_id, comment)
VALUES (1, 'incorrect a value of the temp');

INSERT INTO patient (first_name, last_name, age, birthday, race, sex, doctor_id)
VALUES ('Ivan', 'Ivanov', 26, '1993-02-03', 'evro', 'm', 1),
       ('Ksenya', 'Galkina', 18, '2001-01-05', 'afro', 'f', 1),
       ('Petr', 'Petrov', 19, '2000-04-05', 'evro', 'm', 1);

INSERT INTO blood_analysis (patient_id, labratory_id, glucose, HDL, LDL, general_protein, HGB, HCT)
VALUES (1, 2, 6.8, 2.1, 5.9, 34, 130, 0.40),
       (1, 2, 4.8, 2.2, 4.9, 41, 155, 0.39),
       (2, 1, 9.9, 2.4, 1.3, 68, 165, 0.42),
       (3, 2, 3.5, 2.7, 1.8, 70, 188, 0.32);

INSERT INTO general_urine_analysis(patient_id, labratory_id, PRO, KET, BLD)
VALUES (2, 1, 'yes', 'no', 1),
       (2, 1, 'no', 'no', 3),
       (3, 2, 'no', 'no', 2),
       (1, 2, 'no', 'no', 5),
       (2, 2, 'no', 'yes', 4);      

INSERT INTO serology_blood(patient_id, labratory_id, HIV, syphilis, hep_B, hep_C)
VALUES (1, 1, 'neg', 'neg', 'neg', 'neg'),
       (1, 1, 'neg', 'neg', 'neg', 'neg'),
       (2, 1, 'neg', 'neg', 'neg', 'neg'),
       (3, 1, 'neg', 'neg', 'neg', 'neg'),
       (3, 3, 'neg', 'neg', 'neg', 'neg');

INSERT INTO vital_functions(patient_id, heart_rate, temp, pressure_sys, pressure_dias, respiratory_rate)
VALUES (1, 70, 36.6, 120, 70, 16),
       (2, 80, 36.8, 130, 60, 17),
       (3, 90, 41 , 120, 80, 27);

INSERT INTO physical_exam (patient_id, cardiovascular_sys, respiratory_sys, digestive_sys, endocrine_sys, urinary_sys)
VALUES (1, 'deviation', 'norm', 'norm', 'norm', 'norm'),
       (2, 'norm', 'norm', 'norm', 'norm', 'deviation'),
       (3, 'norm', 'deviation', 'norm', 'norm', 'norm');       

INSERT INTO anthropometric_data(patient_id, weight, height)
VALUES(1, 56, 1.56),
      (2, 65, 1.76),
      (3, 87, 1.89);
      
-- расчет индекса имт
UPDATE anthropometric_data
SET BMI = weight/(height*height)
WHERE weight <> 0 AND height <> 0;
