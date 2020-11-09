# dend-capstone
Udacity Data Engineering Nano Degree capstone project

## Goal
The goal of this project is to provide a star schema for analyzing los angeles crime reports.
The analytics data is derived from two data sources:
* [Los Angeles crime reports](https://data.lacity.org/A-Safe-City/Arrest-Data-from-2010-to-2019/yru6-6re4) - 1.3M rows
* [Los Angeles Postal Codes](https://leginfo.legislature.ca.gov/faces/codes.xhtml) - 311 zipcode shape records (in `.shp` format)

## Schema


## Data dictionary

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
Note the following Penal code descriptions:
| Code | Description |
| --- | --- |
| 23152 | DUI |


```
SELECT charge, count(*) counts
FROM crime_fact
GROUP BY charge
ORDER BY counts DESC
LIMIT 5;

   charge   | counts
------------+--------
 23152(A)VC |  98726
 41.27CLAMC |  93842
 273.5(A)PC |  46646
 11377(A)HS |  40931
 11350(A)HS |  34221
```


### Top penal codes in Sherman Oaks (zipcode = 91403)
```
SELECT charge, count(*) counts
FROM crime_fact
WHERE zipcode = '91403'
GROUP BY charge
ORDER BY counts DESC
LIMIT 5;

   charge   | counts
------------+--------
 23152(A)VC |   2144
 25620BP    |    195
 273.5(A)PC |    153
 11377(A)HS |    147
 11350(A)HS |    135
```


### Most popular hour of day to commit crime
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
