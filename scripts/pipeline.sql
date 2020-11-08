---
-- Flags
---
\timing


---
-- First time setup of fact and dimension tables
---
CREATE TABLE IF NOT EXISTS crime_fact (
  ReportId varchar PRIMARY KEY,
  Age integer NOT NULL,
  SexCode varchar NOT NULL,
  DescentCode varchar NOT NULL,
  ArrestTypeCode varchar NOT NULL,
  Charge varchar NOT NULL,
  zipcode varchar NOT NULL
);

CREATE TABLE IF NOT EXISTS datetime_dimension (
  ReportId varchar PRIMARY KEY,
  Timestamp timestamp NOT NULL,
  Year integer NOT NULL,
  Month integer NOT NULL,
  DayOfMonth integer NOT NULL,
  DayOfWeek integer NOT NULL,
  WeekOfYear integer NOT NULL,
  HourOfDay integer NOT NULL
);


---
-- Read latest batch of data into a table where all columns are strings
---
DROP TABLE crime_staging_untyped;

CREATE TABLE crime_staging_untyped (
  ReportID varchar,
  ReportType varchar,
  ArrestDate varchar,
  ArrestTime varchar,
  AreaId varchar,
  AreaName varchar,
  ReportingDistrict varchar,
  Age varchar,
  SexCode varchar,
  DescentCode varchar,
  ChargeGroupCode varchar,
  ChargeGroupDescription varchar,
  ArrestTypeCode varchar,
  Charge varchar,
  ChargeDescription varchar,
  DispositionDescription varchar,
  Address varchar,
  CrossStreet varchar,
  Lat varchar,
  Lon varchar,
  Location varchar,
  BookingDate varchar,
  BookingTime varchar,
  BookingLocation varchar,
  BookingLocationCode varchar
);


COPY crime_staging_untyped FROM :'arrest_csv_file' USING DELIMITERS ',' CSV HEADER;


-- Cleaning rules
-- Change time=2400 to 0000
UPDATE crime_staging_untyped set arrestTime='0000' where arrestTime='2400';

-- Remove rows containing nulls
DELETE FROM crime_staging_untyped
WHERE ReportId IS NULL
OR ArrestDate IS NULL
OR ArrestTime IS NULL
OR Age IS NULL
OR DescentCode IS NULL
OR Charge IS NULL;


-- Compute new RecordIds 
DROP TABLE IF EXISTS new_records;
CREATE TABLE new_records AS (select reportid from crime_staging_untyped except select reportid from crime_fact);


---
-- Strongly type fields, add geom
---
DROP TABLE IF EXISTS crime_staging_typed;

CREATE TABLE crime_staging_typed (
  ReportID varchar,
  ArrestTimestamp timestamp,
  Age integer,
  SexCode varchar,
  DescentCode varchar,
  ArrestTypeCode varchar,
  Charge varchar,
  geom GEOGRAPHY(POINT,4326)
);

INSERT INTO crime_staging_typed (
  SELECT
    ReportId,
    TO_TIMESTAMP(ArrestDate || ArrestTime , 'MM/DD/YYYYHH24MI') ArrestTimestamp,
    Age::integer,
    SexCode,
    DescentCode,
    ArrestTypeCode,
    Charge,
    Location::geography geom
  FROM crime_staging_untyped
  WHERE reportId IN (SELECT reportId FROM new_records)
);

DROP INDEX IF EXISTS crime_staging_typed_gix;
CREATE INDEX crime_staging_typed_gix ON crime_staging_typed USING GIST ( geom );


---
--  Compute zipcodes by joining with zipcodes table geometrically.
--  This can create duplicates if there are multiple zips per report incident.
---
CREATE TABLE IF NOT EXISTS crime_staging_with_zips (
  ReportId varchar NOT NULL,
  Age integer NOT NULL,
  SexCode varchar NOT NULL,
  DescentCode varchar NOT NULL,
  ArrestTypeCode varchar NOT NULL,
  Charge varchar NOT NULL,
  ZipCode varchar NOT NULL
);

DELETE FROM crime_staging_with_zips;

INSERT INTO crime_staging_with_zips (
  SELECT
    ReportId,
    Age,
    SexCode,
    DescentCode,
    ArrestTypeCode,
    Charge,
    zip_codes.zipcode
  FROM zip_codes
  JOIN crime_staging_typed
  ON ST_Intersects(zip_codes.geom, crime_staging_typed.geom));

DROP INDEX IF EXISTS crime_staging_with_zips_idx;
CREATE INDEX crime_staging_with_zips_idx ON crime_staging_typed_with_zips (ReportId);

---
-- Remove duplicates, keeping zipcodes with lowest number
---

DELETE FROM crime_staging_with_zips a
USING crime_staging_with_zips b
WHERE a.ZipCode < b.ZipCode
AND a.ReportId = b.ReportId;


---
-- Update the fact table, inserting new records.
---
INSERT INTO crime_fact (
  SELECT
    ReportId,
    Age,
    SexCode,
    DescentCode,
    ArrestTypeCode,
    Charge,
    Zipcode
  FROM crime_staging_with_zips);


---
-- Update the dimension table
---
INSERT INTO datetime_dimension (
  SELECT
    ReportId,
    ArrestTimestamp,
    extract(year from ArrestTimestamp),
    extract(month from ArrestTimestamp),
    extract(day from ArrestTimestamp),
    extract(dow from ArrestTimestamp),
    extract(week from ArrestTimestamp),
    extract(hour from ArrestTimestamp)
  FROM crime_staging_typed
);

-- TODO (maybe) clean charges, or categorize them, add charge_description table (602WIC288PC -> Child endangermenet)


