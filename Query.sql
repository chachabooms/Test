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

-- вывод имени пациента с анализом мочи(белок)
SELECT patient.first_name as name, general_urine_analysis.PRO as pro
FROM patient
INNER JOIN general_urine_analysis
ON patient.id = general_urine_analysis.patient_id

-- вывод данных(рост, вес и имт)
SELECT * 
FROM anthropometric_data;

-- комментарии монитора
SELECT * 
FROM comments_monitor;

-- попытка добавления пациента младше 18 (работает для MariaDB и MySQL 8.0.16)
INSERT INTO patient (first_name, last_name, age, birthday, race, sex, doctor_id)
VALUES ('Petor', 'Ivanov', 10, '1993-02-03', 'evro', 'm', 1);