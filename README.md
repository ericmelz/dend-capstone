# dend-capstone
Udacity Data Engineering Nano Degree capstone project

## Goal
The goal of this project is to provide a star schema for analyzing Los Angeles crime reports.
The analytics data is derived from two data sources:
* [Los Angeles crime reports](https://data.lacity.org/A-Safe-City/Arrest-Data-from-2010-to-2019/yru6-6re4) - 1.3M rows
* [Los Angeles Postal Codes](https://data.lacounty.gov/Geospatial/ZIP-Codes/65v5-jw9f) - 311 zipcode shape records (in `.shp` format)


## Data dictionary
### crime_fact - Fact table of arrest reports
| Column name | Type | Constraint | Description |
| --- | --- | --- | --- |
| ReportId | varchar | Primary Key | Id of the arrest report |
| Age | varchar | | Age of the offender |
| SexCode | varchar | | Gender of the offender M=Male, F=Female |
| Descent Code | varchar | | Ethnicity of the offender W=White, H=Hispanic, B=Black |
| Charge | varchar | | Penal code associated with the arrest |
| ZipCode | varchar | | Zip code of the arrest |

### datetime_dimension - Dimension table for date and time
| Column name | Type | Constraint | Description |
| --- | --- | --- | --- |
| ReportId | varchar | Primary Key | Id of the arrest report |
| Timestamp | timestamp |  | timestamp of the arrest |
| Year | integer |  | Year of the arrest |
| Month | integer |  | Year of the arrest |
| DayOfMonth | integer |  | Day of month  of the arrest |
| DayOfWeek | integer |  | Day of week of the arrest |
| WeekOfYear | integer |  | Week of year of the arrest |
| HourOfDay | integer |  | Hour of day of the arrest |

## 

## Example queries
### Top zipcodes for crime
```
SELECT zipcode, count(*) crimes
FROM crime_fact
GROUP BY zipcode
ORDER BY crimes DESC
LIMIT 5;

 zipcode | crimes
---------+--------
 90028   |  77526
 90291   |  59601
 90003   |  46616
 90013   |  38535
 90021   |  34204
```


### Top penal codes in Los Angeles (all zipcodes)


```
SELECT charge, count(*) counts, description
FROM crime_fact
JOIN penal_codes
ON crime_fact.charge = penal_codes.code
GROUP BY charge, description
ORDER BY counts DESC
LIMIT 5;

   charge   | counts |                        description                         
------------+--------+------------------------------------------------------------
 23152(A)VC |  98726 | driving under the influence of alchohol
 41.27CLAMC |  93842 | drinking alcohol in public
 273.5(A)PC |  46646 | domestic abuse
 11377(A)HS |  40931 | posession of methamphetamine
 11350(A)HS |  34221 | posession of a controlled substance without a prescription
```


### Top penal codes in Hollywood, (zipcode = 90028), the highest crime zipcode
```
SELECT charge, count(*) counts
FROM crime_fact
WHERE zipcode = '90028'
GROUP BY charge
ORDER BY counts DESC
LIMIT 5;

   charge   | counts |                    description                     
------------+--------+----------------------------------------------------
 41.27CLAMC |   9386 | drinking alcohol in public
 23152(A)VC |   4446 | driving under the influence of alchohol
 41.18DLAMC |   3954 | sitting or lying, or sleeping on a public sidewalk
 853.7PC    |   3646 | violation of a promise to appear in court
 25620(A)BP |   3442 | posession of an open alcohol container in public
```

<img style="float: right;" src="images/90028.png">


### Top penal codes in Sherman Oaks (zipcode = 91403), a typical suburb
```
SELECT charge, count(*) counts, description
FROM crime_fact
JOIN penal_codes
ON crime_fact.charge = penal_codes.code
WHERE zipcode = '91403'
GROUP BY charge, description
ORDER BY counts DESC
LIMIT 5;

   charge   | counts |                        description                         
------------+--------+------------------------------------------------------------
 23152(A)VC |   2144 | driving under the influence of alchohol
 25620BP    |    195 | posession of an open alcohol container in public
 273.5(A)PC |    153 | domestic abuse
 11377(A)HS |    147 | posession of methamphetamine
 11350(A)HS |    135 | posession of a controlled substance without a prescription
```

<img style="float: right;" src="images/90028.png">

<img style="float: right;" src="images/91403.png">

### Most popular hours of the day to commit crimes
```
SELECT HourOfDay, count(*) crimes
FROM crime_fact
LEFT JOIN datetime_dimension
ON crime_fact.ReportId = datetime_dimension.ReportId
GROUP BY HourOfDay
ORDER BY crimes DESC
LIMIT 5;

 hourofday | crimes
-----------+--------
        16 |  80313
        17 |  78055
        15 |  77676
        18 |  77063
        20 |  76563
```

## Pipeline
