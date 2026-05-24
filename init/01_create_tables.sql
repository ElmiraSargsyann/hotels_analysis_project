-- =========================================
-- HOTEL ANALYSIS PROJECT
-- STEP 1: DATABASE + STAGING LAYER
-- =========================================

-- Create database for the project
-- (used to store all hotel analytics data)
CREATE DATABASE hotels;


-- Create schema for better organization
-- analytics schema separates project tables from system tables
CREATE SCHEMA analytics;

-- =========================================
-- STAGING TABLE: RAW HOTEL BOOKINGS
-- =========================================

-- This table stores raw data from CSV file without transformations
-- It is used as a source for building dimension and fact tables

CREATE TABLE analytics.hotel_bookings (    
    hotel TEXT,
    country VARCHAR(10),
    is_canceled INTEGER,
    lead_time INTEGER,
    
    arrival_date_year INTEGER,
    arrival_date_month VARCHAR(20),
    arrival_date_week_number INTEGER,
    arrival_date_day_of_month INTEGER,
    
    stays_in_weekend_nights INTEGER,
    stays_in_week_nights INTEGER,
    
    adults INTEGER,
    children NUMERIC(3,1),
    babies INTEGER,
    
    meal VARCHAR(20),
    market_segment VARCHAR(50),
    distribution_channel VARCHAR(50),
    
    reserved_room_type VARCHAR(5),
    booking_changes INTEGER,
    
    agent NUMERIC(10,2),
    customer_type VARCHAR(50),
    
    adr NUMERIC(10,2),
    
    reservation_status VARCHAR(20),
    reservation_status_date TIMESTAMP,
    
    name VARCHAR(100),
    email VARCHAR(100),
    phone_number VARCHAR(30)
);

-- Load raw data from CSV file into staging table
-- This is typical ETL step (Extract → Load)
COPY analytics.hotel_bookings
FROM '/docker-entrypoint-initdb.d/data/hotels_schema/hotel_booking.csv'
CSV HEADER; 

-- Quick check of loaded data
SELECT * 
FROM analytics.hotel_bookings
LIMIT 50