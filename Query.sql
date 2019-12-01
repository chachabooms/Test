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
SELECT first_name, last_name, weight, height, BMI
FROM patient
INNER JOIN anthropometric_data
ON patient.id = anthropometric_data.patient_id;

-- комментарии монитора
SELECT first_name, last_name, comment, fixed, date_of_comment
FROM clinical_monitor
INNER JOIN comments_monitor
ON clinical_monitor.id = comments_monitor.monitor_id

-- попытка добавления пациента младше 18 и результат должен быть неудачным (работает для MariaDB и MySQL с 8.0.16)
INSERT INTO patient (first_name, last_name, age, birthday, race, sex, doctor_id)
VALUES ('Petor', 'Ivanov', 10, '1993-02-03', 'evro', 'm', 1);

-- выбор тех пациентов, у которых гемоглабин попал в норму
SELECT first_name, last_name, HGB
FROM patient
INNER JOIN blood_analysis
ON patient.id = blood_analysis.patient_id
INNER JOIN labratory
ON labratory.id = blood_analysis.labratory_id
WHERE hgb >= 130 AND hgb <= 170

-- выбор тех пациентов, у которых гемоглабин не попал в норму, а так же что за лабратория делала анализ и ее документы
SELECT first_name, last_name, HGB, labratory.name as lab, certificate 
FROM patient
INNER JOIN blood_analysis
ON patient.id = blood_analysis.patient_id
INNER JOIN labratory
ON labratory.id = blood_analysis.labratory_id
WHERE HGB < 130 OR HGB > 170

-- проверка белка в мочи при диабете
SELECT DISTINCT first_name, last_name, glucose, PRO
FROM (SELECT first_name, last_name, patient.id, PRO FROM patient INNER JOIN general_urine_analysis ON patient.id = general_urine_analysis.patient_id WHERE PRO = "yes") as t
INNER JOIN blood_analysis
ON t.id = blood_analysis.patient_id
WHERE glucose >= 7

-- прверим какой результат на сифилис у пациентов, с гемоглабином не входящим в норму
SELECT DISTINCT first_name, last_name, HGB, syphilis
FROM (SELECT first_name, last_name, patient.id, syphilis FROM patient INNER JOIN serology_blood ON patient.id = serology_blood.patient_id) as t
INNER JOIN blood_analysis
ON t.id = blood_analysis.patient_id
WHERE HGB < 130 OR HGB > 170

