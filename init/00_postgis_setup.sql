-- =========================================
-- HOTEL ANALYSIS PROJECT
-- STAGE 0: POSTGIS & GEOSPATIAL SETUP
-- =========================================

-- Enable PostGIS extension
-- This allows working with spatial data (maps, geometry, countries)
-- Used for country boundaries and geographic analysis
DROP EXTENSION IF EXISTS postgis CASCADE;
CREATE EXTENSION postgis;

-- Check PostGIS version (verification step)
SELECT PostGIS_Version();

-- =========================================
-- GEOSPATIAL STAGING TABLE
-- =========================================

-- This table stores world country geometries
-- Data source: GeoJSON file
-- Used for geographic enrichment of hotel bookings (country mapping, visualization)
CREATE TABLE analytics._stg_world_countries (
    country_name TEXT NOT NULL,
    country_code TEXT NOT NULL,
    geom geometry(MULTIPOLYGON, 4326) NOT NULL
);

-- Load GeoJSON data into staging table
-- Converts raw geometry into PostGIS format
INSERT INTO analytics._stg_world_countries (country_name, country_code, geom)
SELECT
    feature->'properties'->>'name' AS country_name,
    feature->>'id' AS country_code,
    ST_SetSRID(
        ST_Multi(
            ST_CollectionExtract(
                ST_Force2D(
                    ST_MakeValid(
                        ST_GeomFromGeoJSON(feature->>'geometry')
                    )
                ),
            3)
        ),
        4326
    ) AS geom
FROM (
    SELECT jsonb_array_elements(data->'features') AS feature
    FROM (
		SELECT pg_read_file('/docker-entrypoint-initdb.d/data/hotels_schema/countries.geo.json')::jsonb AS data
    ) f
) sub;

-- Validation query
SELECT 
    * 
FROM analytics._stg_world_countries