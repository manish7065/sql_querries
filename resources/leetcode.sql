-- Show unique birth years from patients and order them by ascending.

SELECT YEAR(birth_date) as birth_year FROM patient 
ORDER BY birth_year 

SELECT YEAR(birth_date) as birth_year FROM patients
GROUP BY(birth_year)

-- Show unique first names from the patients table which only occurs once in the list.
-- For example, if two or more people are named 'John' in the first_name column then don't include their name in the output list. If only 1 person is named 'Leo' then include them in the output.

SELECT  first_name from patients 
group by first_name having count(first_name)=1

SELECT first_name
FROM (
    SELECT
      first_name,
      count(first_name) AS occurrencies
    FROM patients
    GROUP BY first_name
  )
WHERE occurrencies = 1


-- Show patient_id and first_name from patients where their first_name start and ends with 's' and is at least 6 characters long.

SELECT
  patient_id,
  first_name
FROM patients
WHERE first_name LIKE 's____%s';

SELECT
  patient_id,
  first_name
FROM patients
WHERE
  first_name LIKE 's%s'
  AND len(first_name) >= 6;



  SELECT
  patient_id,
  first_name,
  last_name
FROM patients
WHERE patient_id IN (
    SELECT patient_id
    FROM admissions
    WHERE diagnosis = 'Dementia'
  );

--   Show patient_id, first_name, last_name from patients whos diagnosis is 'Dementia'.

-- Primary diagnosis is stored in the admissions table.

SELECT patient_id, first_name, last_name FROM patients
WHERE patient_id IN(
SELECT patient_id FROM admissions WHERE diagnosis = 'Dementia')

SELECT
  patients.patient_id,
  first_name,
  last_name
FROM patients
  JOIN admissions ON admissions.patient_id = patients.patient_id
WHERE diagnosis = 'Dementia';

-- Display every patient's first_name.
-- Order the list by the length of each name and then by alphabetically.
SELECT first_name
FROM patients
order by
  len(first_name),
  first_name;




--   Show the total amount of male patients and the total amount of female patients in the patients table.
-- Display the two results in the same row.

SELECT 
  (SELECT count(*) FROM patients WHERE gender='M') AS male_count, 
  (SELECT count(*) FROM patients WHERE gender='F') AS female_count;

SELECT
sum(case when gender='M' then 1 else 0 end)as male,
sum(case when gender='F' then 1 else 0 end)as female
from patients;

SELECT 
  SUM(Gender = 'M') as male_count, 
  SUM(Gender = 'F') AS female_count
FROM patients


-- Show first and last name, allergies from patients which have allergies to either 'Penicillin' or 'Morphine'. Show results ordered ascending by allergies then by first_name then by last_name.

SELECT
  first_name,
  last_name,
  allergies
FROM patients
WHERE
  allergies IN ('Penicillin', 'Morphine')
ORDER BY
  allergies,
  first_name,
  last_name;


SELECT
  first_name,
  last_name,
  allergies
FROM
  patients
WHERE
  allergies = 'Penicillin'
  OR allergies = 'Morphine'
ORDER BY
  allergies ASC,
  first_name ASC,
  last_name ASC;

  
-- Show patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis.
SELECT
  patient_id,
  diagnosis
FROM admissions
GROUP BY
  patient_id,
  diagnosis
HAVING COUNT(*) > 1;

-- Show the city and the total number of patients in the city.
-- Order from most to least patients and then by city name ascending.

SELECT
  city,
  COUNT(*) AS num_patients
FROM patients
GROUP BY city
ORDER BY num_patients DESC, city asc;

-- Show first name, last name and role of every person that is either patient or doctor.
-- The roles are either "Patient" or "Doctor"

SELECT first_name, last_name, 'Patient' AS role
FROM patients
UNION ALL
SELECT first_name, last_name, 'Doctor' AS role
FROM doctors;



-- Show all allergies ordered by popularity. Remove NULL values from query.

SELECT
  allergies,
  COUNT(*) AS total_diagnosis
FROM patients
WHERE
  allergies IS NOT NULL
GROUP BY allergies
ORDER BY total_diagnosis DESC

SELECT
  allergies,
  count(*)
FROM patients
WHERE allergies NOT NULL
GROUP BY allergies
ORDER BY count(*) DESC

-- Show all of the patients grouped into weight groups.
-- Show the total amount of patients in each weight group.
-- Order the list by the weight group decending.

-- For example, if they weight 100 to 109 they are placed in the 100 weight group, 110-119 = 110 weight group, etc.

-- self soln

select
  floor(weight / 10) * 10 as weight_group,
  count(*)
from patients
group by weight_group
order by weight_group desc;

-- suggested:
select
  floor(weight / 10) * 10 as weight_group,
  count(*)
from patients
group by weight_group
order by weight_group desc;

SELECT
  TRUNCATE(weight, -1) AS weight_group,
  count(*)
FROM patients
GROUP BY weight_group
ORDER BY weight_group DESC;


-- Show patient_id, weight, height, isObese from the patients table.
-- Display isObese as a boolean 0 or 1.
-- Obese is defined as weight(kg)/(height(m)2) >= 30.
-- weight is in units kg.
-- height is in units cm.

select
  patient_id,
  weight,
  height,
  case
    when (weight / ((height / 100.0) * (height / 100.0))) >= 30 then 1
    else 0
  end as isObese
from patients

SELECT
  patient_id,
  weight,
  height,
  weight / power(CAST(height AS float) / 100, 2) >= 30 AS obese
FROM patients