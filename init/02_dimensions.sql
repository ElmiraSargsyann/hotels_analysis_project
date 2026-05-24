-- =========================================
-- HOTEL ANALYSIS PROJECT
-- STAGE 2: DIMENSION TABLES
-- =========================================

-- Dimension tables are used to normalize data
-- They reduce redundancy and improve analytics performance

-- =========================================
-- COUNTRY DIMENSION
-- =========================================

CREATE TABLE analytics.country (
	country_id SERIAL PRIMARY KEY,
	country_code VARCHAR(10) UNIQUE NOT NULL,
	country_name VARCHAR(100),
	geom geometry(MULTIPOLYGON, 4326)
);

-- Populate country dimension from staging + geo data
-- Links booking country codes to real world geography
INSERT INTO analytics.country(country_code, country_name, geom)
SELECT
    hb.country_code,
    s.country_name,
    s.geom
FROM (
    SELECT DISTINCT TRIM(country) AS country_code
    FROM analytics.hotel_bookings
    WHERE country IS NOT NULL
) hb
LEFT JOIN analytics._stg_world_countries s
    ON hb.country_code = s.country_code;

-- =========================================
-- HOTEL DIMENSION
-- =========================================

-- Stores unique hotel types (Resort / City Hotel)
CREATE TABLE analytics.hotel (
	hotel_id SERIAL PRIMARY KEY,
	hotel_type VARCHAR(50) UNIQUE NOT NULL
);

INSERT INTO analytics.hotel(hotel_type)
SELECT DISTINCT
	SPLIT_PART(hotel, '-', 1)
FROM analytics.hotel_bookings
WHERE hotel IS NOT NULL;

-- =========================================
-- MEAL DIMENSION
-- =========================================

CREATE TABLE analytics.meals (
	meal_id SERIAL PRIMARY KEY,
	meal_type VARCHAR(50) UNIQUE NOT NULL
);

INSERT INTO analytics.meals (meal_type)
SELECT DISTINCT
	TRIM(meal)
FROM analytics.hotel_bookings
WHERE meal IS NOT NULL;

-- =========================================
-- MARKET SEGMENT DIMENSION
-- =========================================

CREATE TABLE analytics.market_segments(
	segment_id SERIAL PRIMARY KEY,
	segment_name VARCHAR(100) UNIQUE NOT NULL
);

INSERT INTO analytics.market_segments (segment_name)
SELECT DISTINCT
	TRIM(market_segment)
FROM analytics.hotel_bookings
WHERE market_segment IS NOT NULL;

-- =========================================
-- DISTRIBUTION CHANNEL DIMENSION
-- =========================================

CREATE TABLE  analytics.distribution_channels (
	channel_id SERIAL PRIMARY KEY,
	channel_name VARCHAR(100) UNIQUE NOT NULL
);

INSERT INTO analytics.distribution_channels (channel_name)
SELECT DISTINCT
	TRIM(distribution_channel)
FROM analytics.hotel_bookings
WHERE distribution_channel IS NOT NULL;

-- =========================================
-- ROOM TYPE DIMENSION
-- =========================================


CREATE TABLE analytics.room_types (
	room_type_id SERIAL PRIMARY KEY,
	room_type VARCHAR(10) UNIQUE NOT NULL
);

INSERT INTO analytics.room_types (room_type)
SELECT DISTINCT 
	TRIM(reserved_room_type)
FROM analytics.hotel_bookings
WHERE reserved_room_type IS NOT NULL;

-- =========================================
-- CUSTOMER TYPE DIMENSION
-- =========================================

CREATE TABLE analytics.customer_types (
	customer_type_id SERIAL PRIMARY KEY,
	customer_type VARCHAR(50) UNIQUE NOT NULL
);

INSERT INTO analytics.customer_types (customer_type)
SELECT DISTINCT
	TRIM(customer_type)
FROM analytics.hotel_bookings
WHERE customer_type IS NOT NULL;

-- =========================================
-- AGENT DIMENSION
-- =========================================


CREATE TABLE analytics.agents (
	agent_id SERIAL PRIMARY KEY,
	agent_code INTEGER UNIQUE
);

INSERT INTO analytics.agents (agent_code)
SELECT DISTINCT
	agent
FROM analytics.hotel_bookings
WHERE agent IS NOT NULL;

-- =========================================
-- CUSTOMERS DIMENSION
-- =========================================

CREATE TABLE analytics.customers (
	customer_id SERIAL PRIMARY KEY,
	customer_name VARCHAR(150),
	customer_email VARCHAR(150),
	phone_number VARCHAR(30),
	UNIQUE (customer_name, customer_email, phone_number)
);

-- Clean and normalize customer data
-- Standardize format (capitalization, lowercase, phone cleanup)
INSERT INTO analytics.customers (customer_name, customer_email, phone_number)
SELECT DISTINCT
	INITCAP(name),
	LOWER(email),
	REPLACE(TRIM(phone_number), '-', '')
FROM analytics.hotel_bookings
WHERE name IS NOT NULL
	AND email IS NOT NULL
	AND phone_number IS NOT NULL;