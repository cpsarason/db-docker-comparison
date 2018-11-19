/*CREATE extension postgis;*/


DROP TABLE ais;

CREATE TABLE ais (
    mmsi varchar,
    basedatetime timestamp,
    lat double precision,
    lon double precision,
    sog double precision,
    cog double precision,
    heading double precision,
    vesselname varchar,
    imo varchar,
    callsign varchar,
    vesseltype varchar,
    vesselstatus varchar,
    vessellength double precision,
    vesselwidth double precision,
    draft double precision, 
    cargo varchar
);


/* import AIS data from text files */

\copy ais FROM 'ais_2017_01_zone10_test.csv' WITH (FORMAT csv);

/* add geospatial column */

SELECT AddGeometryColumn ('ais','geom',4326,'POINT',2);
UPDATE ais set geom=st_SetSrid(st_MakePoint(lon, lat), 4326);

/* create indices */

ALTER TABLE ais ADD COLUMN id BIGSERIAL PRIMARY KEY;
CREATE INDEX ais_gix ON ais USING GIST (geom);
CREATE INDEX mmsi_ix ON AIS (mmsi);