---
-- Top zipcodes for crime
---
SELECT zipcode, count(*) crimes
FROM crime_fact
GROUP BY zipcode
ORDER BY crimes DESC
LIMIT 5;


---
-- Top crimes
---
SELECT charge, count(*) counts
FROM crime_fact
GROUP BY charge
ORDER BY counts DESC
LIMIT 5;


---
-- Top crimes in Sherman Oaks
---
SELECT charge, count(*) counts
FROM crime_fact
WHERE zipcode = '91403'
GROUP BY charge
ORDER BY counts DESC
LIMIT 5;



---
-- Top hours of day for crimes
---
SELECT HourOfDay, count(*) crimes
FROM crime_fact
LEFT JOIN datetime_dimension
ON crime_fact.ReportId = datetime_dimension.ReportId
GROUP BY HourOfDay
ORDER BY crimes DESC
LIMIT 5;
