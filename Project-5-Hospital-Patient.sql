-- Create Patients table
CREATE TABLE Patients (
    patient_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    dob DATE NOT NULL,
    gender CHAR(1) CHECK (gender IN ('M', 'F')),
    address VARCHAR(100)
);

-- Create Visits table
CREATE TABLE Visits (
    visit_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT,
    visit_date DATE NOT NULL,
    reason VARCHAR(255),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

-- Create Treatments table
CREATE TABLE Treatments (
    treatment_id INT PRIMARY KEY AUTO_INCREMENT,
    visit_id INT,
    treatment_type VARCHAR(100) NOT NULL,
    cost DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (visit_id) REFERENCES Visits(visit_id)
);

-- Insert sample data into Patients table
INSERT INTO Patients (first_name, last_name, dob, gender, address) VALUES
('John', 'Doe', '1980-05-15', 'M', '123 Main St'),
('Jane', 'Smith', '1990-07-22', 'F', '456 Oak St'),
('Alice', 'Johnson', '1975-02-28', 'F', '789 Pine St'),
('Bob', 'Brown', '1985-12-03', 'M', '321 Maple St'),
('Carol', 'Davis', '2000-11-11', 'F', '654 Elm St');

-- Insert sample data into Visits table
INSERT INTO Visits (patient_id, visit_date, reason) VALUES
(1, '2023-01-10', 'Flu'),
(1, '2023-03-12', 'Checkup'),
(2, '2023-02-15', 'Allergy'),
(3, '2023-05-20', 'Physical Therapy'),
(4, '2023-06-18', 'Vaccination'),
(5, '2023-07-25', 'Dermatology'),
(1, '2023-08-05', 'Dental Checkup'),
(2, '2023-09-12', 'Flu'),
(3, '2023-10-30', 'Follow-up'),
(4, '2023-11-20', 'Surgery Consultation');

-- Insert sample data into Treatments table
INSERT INTO Treatments (visit_id, treatment_type, cost) VALUES
(1, 'Medication', 50.00),
(2, 'Blood Test', 100.00),
(2, 'X-ray', 200.00),
(3, 'Allergy Test', 150.00),
(4, 'Physical Therapy Session', 300.00),
(5, 'Vaccination', 80.00),
(6, 'Skin Treatment', 200.00),
(7, 'Teeth Cleaning', 120.00),
(8, 'Flu Medication', 60.00),
(9, 'Follow-up Consultation', 100.00),
(10, 'Surgery Preparation', 500.00);


SELECT COUNT(*) AS total_patients
FROM Patients;

SELECT AVG(DATEDIFF(CURDATE(), dob)/365) AS average_age 
FROM Patients;

SELECT gender, COUNT(*)
FROM patients
GROUP BY gender;

SELECT COUNT(visit_id)
FROM visits;

SELECT SUM(cost) AS total_cost
FROM Treatments;

SELECT AVG(cost) AS avg_cost
FROM treatments;

SELECT patient_id, COUNT(visit_id) AS total_visits
FROM visits
GROUP BY patient_id;

SELECT patient_id, COUNT(visit_id) AS total_visits 
FROM visits 
GROUP BY patient_id
ORDER BY total_visits DESC
LIMIT 5;

SELECT treatment_type, COUNT(treatment_id) AS treat
FROM treatments 
GROUP BY treatment_type;

-- 10
SELECT treatment_type, SUM(cost) AS total_cost 
FROM treatments 
GROUP BY treatment_type;

SELECT p.patient_id, p.first_name, SUM(t.cost) AS total_cost
FROM patients AS p
LEFT JOIN visits AS v 
ON v.patient_id = p.patient_id
LEFT JOIN treatments AS t 
ON t.visit_id = v.visit_id
GROUP BY p.patient_id, p.first_name
HAVING SUM(t.cost) > 1000
;

-- 12
WITH cte1 AS 
(
SELECT p.patient_id, COUNT(v.visit_id) AS total_visits
FROM Patients AS p
LEFT JOIN visits AS v
ON v.patient_id = p.patient_id 
GROUP BY p.patient_id 
HAVING COUNT(v.visit_id) > 5
)
SELECT *
FROM cte1;



-- The next 2 queries are same but one is being done by 2 joins along with as a CTE 
WITH PatientTreatments AS (
    SELECT p.patient_id, p.first_name, p.last_name, COUNT(t.treatment_id) AS total_treatments, SUM(t.cost) AS total_cost
    FROM Patients p
    JOIN Visits v ON p.patient_id = v.patient_id
    JOIN Treatments t ON v.visit_id = t.visit_id
    GROUP BY p.patient_id, p.first_name, p.last_name
)
SELECT * FROM PatientTreatments;


SELECT v.patient_id, COUNT(t.treatment_id) AS total_treatments, SUM(t.Cost) AS total_cost
FROM visits AS v
LEFT JOIN treatments AS t
ON t.visit_id = v.visit_id 
GROUP BY v.patient_id;

-- 14
SELECT p.patient_id, p.first_name, p.last_name, t.treatment_id, t.cost,
	SUM(t.cost) OVER (PARTITION BY p.patient_id ORDER BY t.treatment_id) AS running_total_cost

FROM patients AS p
JOIN Visits AS v
ON p.patient_id = v.patient_id
JOIN treatments AS t
ON t.visit_id = v.visit_id;

SELECT p.patient_id, p.first_name, p.last_name, SUM(t.cost) AS total_cost,
       RANK() OVER (ORDER BY SUM(t.cost) DESC) AS patient_rank
FROM Patients p
JOIN Visits v ON p.patient_id = v.patient_id
JOIN Treatments t ON v.visit_id = t.visit_id
GROUP BY p.patient_id, p.first_name, p.last_name;
;



-- 16
SELECT visit_id, COUNT(treatment_id) AS total_treatments
FROM treatments
GROUP BY visit_id;


SELECT AVG(count_treatment) AS avg_treatments
FROM  
(SELECT visit_id, COUNT(*) AS count_treatment 
FROM treatments
GROUP BY visit_id) AS subq1;

SELECT visit_id, SUM(cost)
FROM treatments 
GROUP BY visit_id;

SELECT *
FROM patients AS p
WHERE NOT EXISTS
(
SELECT 1 
FROM VISITS v
WHERE v.patient_id = p.patient_id);


-- 20
SELECT *
FROM PATIENTS p
WHERE NOT EXISTS 
(
SELECT 1 
FROM Treatments AS t 
JOIN Visits AS V ON t.visit_id = v.visit_id
WHERE v.visit_id = p.patient_id); 


SELECT *
FROM Visits AS V 
WHERE NOT EXISTS 
(
SELECT 1 
FROM Treatments AS T 
WHERE t.visit_id = v.visit_id);



-- 22
SELECT reason, COUNT(*) AS total_visits 
FROM visits
GROUP BY reason
ORDER BY COUNT(visit_id) DESC
LIMIT 3;


SELECT MONTH(visit_date) AS monthh, COUNT(*) AS visit_count
FROM visits 
WHERE YEAR(visit_date) = '2023'
GROUP BY MONTH(visit_date)
ORDER BY MONTH(visit_date) ASC;

-- Quarterly treatment cost for the year 2023
SELECT QUARTER(visit_date) AS quarterr, SUM(t.cost) AS total_cost
FROM visits AS v
JOIN treatments AS t 
ON v.visit_id = t.visit_id
WHERE YEAR(visit_date) = '2023'
GROUP BY QUARTER(visit_date);

SELECT p.patient_id, p.first_name, p.last_name, YEAR(v.visit_date) AS yearly, SUM(t.cost) AS total_csot
FROM patients AS p
JOIN visits AS v 
ON p.patient_id = v.patient_id
JOIN treatments AS t 
ON v.visit_id = t.visit_id 
WHERE YEAR(visit_date) = '2023'
GROUP BY p.patient_id, p.first_name, p.last_name, YEAR(visit_date);



-- 26 Patients who have visited in the last 10 months from the current date(15-07-2024)
SELECT DISTINCT p.*
FROM patients AS p
JOIN visits AS v ON p.patient_id = v.patient_id 
WHERE v.visit_date >= DATE_SUB(CURDATE(), INTERVAL 10 MONTH);


SELECT DISTINCT p.*
FROM Patients p
JOIN Visits v ON p.patient_id = v.patient_id
JOIN Treatments t ON v.visit_id = t.visit_id
WHERE t.treatment_date >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH);

-- 28 Top 5 most expensive treatments
SELECT treatment_type, cost
FROM treatments 
ORDER BY cost DESC 
LIMIT 5;

SELECT visit_id, treatment_type, SUM(cost) AS most_exp
FROM treatments 
GROUP BY visit_id, treatment_type
ORDER BY SUM(cost) DESC
LIMIT 1;


-- 30
SELECT p.first_name, p.last_name, AVG(t.cost) AS avg_cost
FROM patients AS p
JOIN visits AS v
ON p.patient_id = v.patient_id
JOIN treatments AS t 
ON v.visit_id = t.visit_id 
GROUP BY p.first_name, p.last_name;

SELECT AVG(cost) AS median_cost
FROM (
    SELECT cost
    FROM Treatments
    ORDER BY cost
    LIMIT 2 - (SELECT COUNT(*) FROM Treatments) % 2
    OFFSET (SELECT (COUNT(*) - 1) / 2 FROM Treatments)
) sub;


SELECT 
    STDDEV(cost) AS STD_DEV, 
    VAR_POP(cost) AS VAR_, 
    MIN(cost) AS MIN_cost, 
    MAX(cost) AS MAX_cost 
FROM treatments;

-- 35
SELECT 
CASE 
	WHEN DATEDIFF(CURDATE(), dob) / 365 < 18 THEN 'Under 18'
    WHEN DATEDIFF(CURDATE(), dob) / 365 BETWEEN 18 AND 34 THEN '18-34'
    WHEN DATEDIFF(CURDATE(), dob) / 365 BETWEEN 35 AND 49 THEN '35-49'
    WHEN DATEDIFF(CURDATE(), dob) / 365 BETWEEN 50 AND 64 THEN '50-64'
    ELSE '65 AND OVER'
    END AS age_group, 
	COUNT(*) AS total_count
FROM patients
GROUP BY age_group
ORDER BY age_group;



SELECT p.patient_id, p.first_name, p.last_name
FROM Patients p
JOIN Visits v ON p.patient_id = v.patient_id
WHERE YEAR(v.visit_date) = YEAR(CURDATE())
GROUP BY p.patient_id, p.first_name, p.last_name
HAVING COUNT(DISTINCT MONTH(v.visit_date)) = 12;

SELECT DAYNAME(visit_date) AS day_of_week, cOUNT(*) AS visit_count
FROM visits
GROUP BY dayname(visit_date)
ORDER BY COUNT(*) DESC;

SELECT DAYNAME(visit_date) AS day_of_week, COUNT(*) AS visit_count
FROM Visits
GROUP BY DAYNAME(visit_date)
ORDER BY visit_count DESC
LIMIT 1;




















    







 



















    
    
    




