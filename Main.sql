CREATE TABLE clinical_center (
   id INTEGER NOT NULL AUTO_INCREMENT,
   name VARCHAR(45) NOT NULL,
   address VARCHAR(45),
   tel INTEGER,
   certificate ENUM('да', 'нет') NOT NULL DEFAULT 'нет',
   PRIMARY KEY (id)
);

CREATE TABLE labratory (
  id INTEGER NOT NULL AUTO_INCREMENT,
  name VARCHAR(45) NOT NULL,
  address VARCHAR(45),
  tel INTEGER,
  certificate ENUM('да', 'нет') NOT NULL DEFAULT 'нет',
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
  fixed ENUM('да', 'нет') NOT NULL DEFAULT 'нет',
  PRIMARY KEY (id),
  FOREIGN KEY (monitor_id) REFERENCES clinical_monitor(id)
);

CREATE TABLE patient (
   id INTEGER NOT NULL AUTO_INCREMENT,
   first_name VARCHAR(45) NOT NULL,
   last_name VARCHAR(45) NOT NULL,
   age INTEGER NOT NULL,
   birthday DATE,
   race VARCHAR(45),
   sex ENUM('м', 'ж', '?') NOT NULL DEFAULT '?',
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
  PRO ENUM('есть', 'нет', '?') NOT NULL DEFAULT '?',
  KET ENUM('есть', 'нет', '?') NOT NULL DEFAULT '?',
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
  BMI INTEGER NOT NULL DEFAULT 0,
  patient_id INTEGER NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (patient_id) REFERENCES patient(id)
);

CREATE TABLE physical_exam (
  id INTEGER NOT NULL AUTO_INCREMENT,
  patient_id INTEGER NOT NULL,
  cardiovascular_sys ENUM('есть', 'отклонения', '?') NOT NULL DEFAULT '?',
  respiratory_sys ENUM('есть', 'отклонения', '?') NOT NULL DEFAULT '?',
  digestive_sys ENUM('есть', 'отклонения', '?') NOT NULL DEFAULT '?',
  endocrine_sys ENUM('есть', 'отклонения', '?') NOT NULL DEFAULT '?',
  urinary_sys ENUM('есть', 'отклонения', '?') NOT NULL DEFAULT '?',
  comment MEDIUMTEXT,
  PRIMARY KEY (id),
  FOREIGN KEY (patient_id) REFERENCES patient(id)
);

INSERT INTO clinical_center (name, address, certificate)
VALUES ('Клен', 'лапландия', 'да');

INSERT INTO labratory (name, address, certificate)
VALUES ('Волна', 'лапландия', 'да'),
       ('Лаб при Клен', 'лапландия', 'да'),
       ('Евролаборатория', 'евроландия' ,'нет');

INSERT INTO doctor (clinical_center_id, first_name, last_name, education, job_experience)
VALUES (1, 'Федор', 'Сидоров', 'ГУМО', 10);

INSERT INTO clinical_monitor (clinical_center_id, first_name, last_name, education, job_experience)
VALUES (1, 'Ирина', 'Петрова', 'ГУМО', 7);

INSERT INTO comments_monitor (monitor_id, comment)
VALUES (1, 'неправильно введено значение температуры');

INSERT INTO patient (first_name, last_name, age, birthday, race, sex, doctor_id)
VALUES ('Иван', 'Иванов', 26, '1993-02-03', 'евро', 'м', 1),
       ('Ксения', 'Галкина', 18, '2001-01-05', 'афро', 'ж', 1),
       ('Петр', 'Петров', 19, '2000-04-05', 'евро', 'м', 1);

INSERT INTO blood_analysis (patient_id, labratory_id, glucose, HDL, LDL, general_protein, HGB, HCT)
VALUES (1, 2, 6.8, 2.1, 1.9, 34, 130, 0.40),
       (1, 2, 4.8, 2.2, 2.5, 41, 155, 0.39),
       (2, 1, 9.9, 2.4, 1.3, 68, 165, 0.42),
       (3, 2, 3.5, 2.7, 1.8, 70, 188, 0.32);

INSERT INTO general_urine_analysis(patient_id, labratory_id, PRO, KET, BLD)
VALUES (2, 1, 'есть', 'нет', 1),
       (2, 1, 'нет', 'нет', 3),
       (3, 2, 'нет', 'нет', 2),
       (1, 2, 'нет', 'нет', 5);      

INSERT INTO serology_blood(patient_id, labratory_id, HIV, syphilis, hep_B, hep_C)
VALUES (1, 1, 'neg', 'neg', 'neg', 'neg'),
       (1, 1, 'neg', 'neg', 'neg', 'neg'),
       (2, 1, 'neg', 'neg', 'neg', 'neg'),
       (3, 1, 'neg', 'neg', 'neg', 'neg'),
       (3, 3, 'neg', 'neg', 'neg', 'neg');

-- запрос сколько каждая лаборатория сделала анализов крови по возрастанию
SELECT labratory.name as lab, COUNT(blood_analysis.labratory_id) as item
FROM labratory
INNER JOIN blood_analysis
ON labratory.id = blood_analysis.labratory_id
GROUP BY lab
ORDER BY item;

-- запрос сколько каждая лабортория сделала анализов по убыванию
SELECT name, COUNT(item) as num FROM (
SELECT labratory.name as name, blood_analysis.labratory_id as item
FROM labratory
INNER JOIN blood_analysis
ON labratory.id = blood_analysis.labratory_id
UNION ALL
SELECT labratory.name as name, general_urine_analysis.labratory_id as item
FROM labratory
INNER JOIN general_urine_analysis
ON labratory.id = general_urine_analysis.labratory_id
UNION ALL
SELECT labratory.name as name, serology_blood.labratory_id as item
FROM labratory
INNER JOIN serology_blood
ON labratory.id = serology_blood.labratory_id) as t
GROUP BY name
ORDER BY num DESC;

-- комментарии монитора
SELECT * 
FROM comments_monitor;