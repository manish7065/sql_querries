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

-- Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade. Sort the list starting from the earliest birth_date.


SELECT
  first_name,
  last_name,
  birth_date
FROM patients
WHERE
  YEAR(birth_date) BETWEEN 1970 AND 1979
ORDER BY birth_date ASC;


SELECT
  first_name,
  last_name,
  birth_date
FROM patients
WHERE
  birth_date >= '1970-01-01'
  AND birth_date < '1980-01-01'
ORDER BY birth_date ASC

-- We want to display each patient's full name in a single column. Their last_name in all upper letters must appear first, then first_name in all lower case letters. Separate the last_name and first_name with a comma. Order the list by the first_name in decending order
-- EX: SMITH,jane

SELECT
  CONCAT(UPPER(last_name), ',', LOWER(first_name)) AS new_name_format
FROM patients
ORDER BY first_name DESC;

SELECT
  UPPER(last_name) || ',' || LOWER(first_name) AS new_name_format
FROM patients
ORDER BY first_name DESC;

-- Show the province_id(s), sum of height; where the total sum of its patient's height is greater than or equal to 7,000.

SELECT
  province_id,
  SUM(height) AS sum_height
FROM patients
GROUP BY province_id
HAVING sum_height >= 7000

select * from 
(select province_id, SUM(height) as sum_height FROM 
patients group by province_id) where sum_height >= 7000;

-- Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni'

-- self:
select (max(weight)-min(weight)) as weight_delta from(
select weight from patients
where last_name like 'Maroni')

SELECT
  (MAX(weight) - MIN(weight)) AS weight_delta
FROM patients
WHERE last_name = 'Maroni';

-- Show all of the days of the month (1-31) and how many admission_dates occurred on that day. Sort by the day with most admissions to least admissions.
-- self:
select day(admission_date)as day_, count(admission_date)as total_admit from admissions
group by day_
order by total_admit desc

SELECT
  DAY(admission_date) AS day_number,
  COUNT(*) AS number_of_admissions
FROM admissions
GROUP BY day_number
ORDER BY number_of_admissions DESC

-- Show all columns for patient_id 542's most recent admission_date.

-- self:
select * from admissions
where patient_id=542
order BY admission_date desc limit 1

SELECT *
FROM admissions
WHERE patient_id = 542
GROUP BY patient_id
HAVING
  admission_date = MAX(admission_date);

SELECT *
FROM admissions
WHERE
  patient_id = '542'
  AND admission_date = (
    SELECT MAX(admission_date)
    FROM admissions
    WHERE patient_id = '542'
  )



-- Show patient_id, attending_doctor_id, and diagnosis for admissions that match one of the two criteria:
-- 1. patient_id is an odd number and attending_doctor_id is either 1, 5, or 19.
-- 2. attending_doctor_id contains a 2 and the length of patient_id is 3 characters.

-- self:
select patient_id,attending_doctor_id,diagnosis from admissions
where
	(cast(patient_id as int) % 2 != 0 and attending_doctor_id in (1,5,19))
    or
    ((attending_doctor_id like "%2" or attending_doctor_id like "2%") and
     len(patient_id)=3)


SELECT
  patient_id,
  attending_doctor_id,
  diagnosis
FROM admissions
WHERE
  (
    attending_doctor_id IN (1, 5, 19)
    AND patient_id % 2 != 0
  )
  OR 
  (
    attending_doctor_id LIKE '%2%'
    AND len(patient_id) = 3
  )


-- Show first_name, last_name, and the total number of admissions attended for each doctor.
-- Every admission has been attended by a doctor.

-- self:


select d.first_name,d.last_name, count(a.attending_doctor_id) from doctors d 
join admissions a on a.attending_doctor_id=d.doctor_id
group by d.doctor_id


SELECT
  first_name,
  last_name,
  count(*) as admissions_total
from admissions a
  join doctors ph on ph.doctor_id = a.attending_doctor_id
group by attending_doctor_id

SELECT
  first_name,
  last_name,
  count(*)
from
  doctors p,
  admissions a
where
  a.attending_doctor_id = p.doctor_id
group by p.doctor_id;

-- For each doctor, display their id, full name, and the first and last admission date they attended.
-- self:
select d.doctor_id,concat(d.first_name," " , d.last_name) as full_name,
MIN(a.admission_date) as first_date , max(a.admission_date) as last_date
from doctors d 
join admissions a on a.attending_doctor_id=d.doctor_id
group by d.doctor_id


select
  doctor_id,
  first_name || ' ' || last_name as full_name,
  min(admission_date) as first_admission_date,
  max(admission_date) as last_admission_date
from admissions a
  join doctors ph on a.attending_doctor_id = ph.doctor_id
group by doctor_id;

-- Display the total amount of patients for each province. Order by descending.

select pr.province_name, p.cnt from province_names pr
join (
select province_id ,count(*) as cnt from patients
group by province_id
 ) p 
on p.province_id = pr.province_id
order by cnt desc

-- For every admission, display the patient's full name, their admission diagnosis, and their doctor's full name who diagnosed their problem.
select 
concat(p.first_name," ", p.last_name) as patients,
a.diagnosis,
concat(d.first_name," ", d.last_name) as doctors
from patients p 
join admissions a on a.patient_id=p.patient_id
join doctors d on d.doctor_id=a.attending_doctor_id

SELECT
  CONCAT(patients.first_name, ' ', patients.last_name) as patient_name,
  diagnosis,
  CONCAT(doctors.first_name,' ',doctors.last_name) as doctor_name
FROM patients
  JOIN admissions ON admissions.patient_id = patients.patient_id
  JOIN doctors ON doctors.doctor_id = admissions.attending_doctor_id;

  Show first name, last name and role of every person that is either patient or doctor.
The roles are either "Patient" or "Doctor"



-- Show patient_id, first_name, last_name from patients whose does not have any records in the admissions table. (Their patient_id does not exist in any admissions.patient_id rows.)

select
  patient_id,
  first_name,
  last_name
from patients
where patient_id not in (
    select patient_id
    from admissions
  )

SELECT 
  p.patient_id,
  first_name,
  last_name
FROM patients p 
LEFT JOIN admissions ON admissions.patient_id = p.patient_id
WHERE admissions.patient_id is NULL

-- Show patient_id, first_name, last_name, and attending doctor's specialty.
-- Show only the patients who has a diagnosis as 'Epilepsy' and the doctor's first name is 'Lisa'

-- Check patients, admissions, and doctors tables for required information.

SELECT 
  p.patient_id,
  p.first_name,
  p.last_name,
  d.specialty
FROM patients p 
JOIN admissions a ON a.patient_id = p.patient_id
JOIN doctors d ON a.attending_doctor_id = d.doctor_id
WHERE a.diagnosis = 'Epilepsy' and d.first_name = 'Lisa'

SELECT
  p.patient_id,
  p.first_name AS patient_first_name,
  p.last_name AS patient_last_name,
  ph.specialty AS attending_doctor_specialty
FROM patients p
  JOIN admissions a ON a.patient_id = p.patient_id
  JOIN doctors ph ON ph.doctor_id = a.attending_doctor_id
WHERE
  ph.first_name = 'Lisa' and
  a.diagnosis = 'Epilepsy'

SELECT
  pa.patient_id,
  pa.first_name,
  pa.last_name,
  ph1.specialty
FROM patients AS pa
  JOIN (
    SELECT *
    FROM admissions AS a
      JOIN doctors AS ph ON a.attending_doctor_id = ph.doctor_id
  ) AS ph1 USING (patient_id)
WHERE
  ph1.diagnosis = 'Epilepsy'
  AND ph1.first_name = 'Lisa'


--   All patients who have gone through admissions, can see their medical documents on our site. Those patients are given a temporary password after their first admission. Show the patient_id and temp_password.

-- The password must be the following, in order:
-- 1. patient_id
-- 2. the numerical length of patient's last_name
-- 3. year of patient's birth_date

SELECT
  DISTINCT P.patient_id,
  CONCAT(
    P.patient_id,
    LEN(last_name),
    YEAR(birth_date)
  ) AS temp_password
FROM patients P
  JOIN admissions A ON A.patient_id = P.patient_id


select
  distinct p.patient_id,
  p.patient_id || floor(len(last_name)) || floor(year(birth_date)) as temp_password
from patients p
  join admissions a on p.patient_id = a.patient_id

  

