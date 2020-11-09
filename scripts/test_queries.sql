---
-- Top zipcodes for crime
---
SELECT zipcode, count(*) crimes
FROM crime_fact
GROUP BY zipcode
ORDER BY crimes DESC
LIMIT 5;


---
-- zipcodes with the least crime
---
SELECT zipcode, count(*) crimes
FROM crime_fact
GROUP BY zipcode
ORDER BY crimes ASC
LIMIT 5;


---
-- Top crimes
---
SELECT charge, count(*) counts
FROM crime_fact
GROUP BY charge
ORDER BY counts DESC
LIMIT 5;


SELECT charge, count(*) counts, description
FROM crime_fact
JOIN penal_codes
ON crime_fact.charge = penal_codes.code
GROUP BY charge, description
ORDER BY counts DESC
LIMIT 5;


---
-- Top crimes in the Hollywood, the highest crime district
---
SELECT charge, count(*) counts
FROM crime_fact
WHERE zipcode = '90028'
GROUP BY charge
ORDER BY counts DESC
LIMIT 5;


SELECT charge, count(*) counts, description
FROM crime_fact
JOIN penal_codes
ON crime_fact.charge = penal_codes.code
WHERE zipcode = '90028'
GROUP BY charge, description
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

SELECT charge, count(*) counts, description
FROM crime_fact
JOIN penal_codes
ON crime_fact.charge = penal_codes.code
WHERE zipcode = '91403'
GROUP BY charge, description
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
