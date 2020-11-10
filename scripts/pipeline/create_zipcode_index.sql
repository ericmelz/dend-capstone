-- Create a spatial index on the zipcode table
CREATE INDEX zipcodes_gix ON zip_codes USING GIST ( geom );
