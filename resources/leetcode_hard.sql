
-- You Got The Query Correct
-- View All Questions
-- Next Question

-- Hard
-- Each admission costs $50 for patients without insurance, and $10 for patients with insurance. All patients with an even patient_id have insurance.

-- Give each patient a 'Yes' if they have insurance, and a 'No' if they don't have insurance. Add up the admission_total cost for each has_insurance group.


-- self:
select 
case
when (patient_id%2 = 0) then 'Yes' else	'No'
end
as has_insurance,
sum(
  case when patient_id%2 = 0 then 10 else 50 end
  ) as total_collection
from admissions
group by has_insurance 

SELECT 
CASE WHEN patient_id % 2 = 0 Then 
    'Yes'
ELSE 
    'No' 
END as has_insurance,
SUM(CASE WHEN patient_id % 2 = 0 Then 
    10
ELSE 
    50 
END) as cost_after_insurance
FROM admissions 
GROUP BY has_insurance;


--
select 'No' as has_insurance, count(*) * 50 as cost
from admissions where patient_id % 2 = 1 group by has_insurance
union
select 'Yes' as has_insurance, count(*) * 10 as cost
from admissions where patient_id % 2 = 0 group by has_insurance

