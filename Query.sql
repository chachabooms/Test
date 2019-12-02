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
SELECT first_name, last_name, PRO
FROM patient
INNER JOIN general_urine_analysis
ON patient.id = general_urine_analysis.patient_id;

-- вывод данных(рост, вес и имт)
SELECT first_name, last_name, weight, height, BMI
FROM patient
INNER JOIN anthropometric_data
ON patient.id = anthropometric_data.patient_id;

-- комментарии монитора
SELECT first_name, last_name, comment, fixed, date_of_comment
FROM clinical_monitor
INNER JOIN comments_monitor
ON clinical_monitor.id = comments_monitor.monitor_id;

-- попытка добавления пациента младше 18 лет и результат должен быть неудачным (работает для MariaDB и MySQL с 8.0.16)
INSERT INTO patient (first_name, last_name, age, birthday, race, sex, doctor_id)
VALUES ('Petor', 'Ivanov', 10, '1993-02-03', 'evro', 'm', 1);

-- выбор тех пациентов, у которых гемоглобин попал в норму, а так же что за лаборатория делала анализ
SELECT first_name, last_name, HGB, labratory.name as lab
FROM patient
INNER JOIN blood_analysis
ON patient.id = blood_analysis.patient_id
INNER JOIN labratory
ON labratory.id = blood_analysis.labratory_id
WHERE HGB >= 130 AND HGB <= 170;

-- выбор тех пациентов, у которых гемоглобин не попал в норму, а так же что за лаборатория делала анализ и ее документы
SELECT first_name, last_name, HGB, labratory.name as lab, certificate 
FROM patient
INNER JOIN blood_analysis
ON patient.id = blood_analysis.patient_id
INNER JOIN labratory
ON labratory.id = blood_analysis.labratory_id
WHERE HGB < 130 OR HGB > 170;

-- проверка белка в мочи при диабете
SELECT DISTINCT first_name, last_name, glucose, PRO
FROM (SELECT first_name, last_name, patient.id, PRO FROM patient INNER JOIN general_urine_analysis ON patient.id = general_urine_analysis.patient_id WHERE PRO = "yes") as t
INNER JOIN blood_analysis
ON t.id = blood_analysis.patient_id
WHERE glucose >= 7;

-- проверим какой результат на сифилис у пациентов, с гемоглобином не входящим в норму
SELECT DISTINCT first_name, last_name, HGB, syphilis
FROM (SELECT first_name, last_name, patient.id, syphilis FROM patient INNER JOIN serology_blood ON patient.id = serology_blood.patient_id) as t
INNER JOIN blood_analysis
ON t.id = blood_analysis.patient_id
WHERE HGB < 130 OR HGB > 170;

-- проверим наличие кетонов в мочи при диабете (проверяем кетоацидоз)
SELECT DISTINCT first_name, last_name, glucose, KET
FROM (SELECT first_name, last_name, patient.id, KET FROM patient INNER JOIN general_urine_analysis ON patient.id = general_urine_analysis.patient_id WHERE KET = "yes") as t
INNER JOIN blood_analysis
ON t.id = blood_analysis.patient_id
WHERE glucose >= 7;

-- выберим тех пациентов, у которых температура выше средней (расчет среднего из всей выборки пациентов)
SELECT first_name, last_name, temp
FROM patient
INNER JOIN vital_functions
ON patient.id = vital_functions.patient_id
WHERE temp > (SELECT AVG(temp) FROM vital_functions);

-- анализ мочи у пациентов, имеющих отклонения в мочеполовой системе 
SELECT first_name, last_name, KET, PRO, BLD, urinary_sys
FROM (SELECT first_name, last_name, patient.id, urinary_sys FROM patient INNER JOIN physical_exam ON patient.id = physical_exam.patient_id WHERE urinary_sys = "deviation") as t
INNER JOIN general_urine_analysis
ON t.id = general_urine_analysis.patient_id;

-- смотрим анализ липопротеина низкой плотности у пациентов, имеющих отклонения в сердечно-сосудистой системе
SELECT first_name, last_name, LDL
FROM (SELECT first_name, last_name, patient.id, cardiovascular_sys FROM patient INNER JOIN physical_exam ON patient.id = physical_exam.patient_id WHERE cardiovascular_sys = "deviation") as t
INNER JOIN blood_analysis
ON t.id = blood_analysis.patient_id;

-- смотрим чдд у пациентов, имеющих отклонения в дыхательной системе
SELECT first_name, last_name, respiratory_rate
FROM (SELECT first_name, last_name, patient.id, respiratory_sys FROM patient INNER JOIN physical_exam ON patient.id = physical_exam.patient_id WHERE respiratory_sys = "deviation") as t
INNER JOIN vital_functions
ON t.id = vital_functions.patient_id;