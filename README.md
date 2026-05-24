# 🏨 Hotel Bookings Analytics Project

## 📌 Overview

This project is a complete SQL-based data warehouse and analytics solution built on hotel booking data.

The goal of the project is to simulate a real-world analytics pipeline used in hospitality business intelligence systems.

It includes:
- Data ingestion (CSV → staging table)
- Data modeling (star schema design)
- ETL transformations
- Business analytics queries
- Geospatial enrichment using PostGIS

---

## 🎯 Business Problem

Hotel companies need to understand:

- Which countries generate the most bookings
- How customers behave across seasons
- What drives cancellations
- Which channels bring the most revenue
- Which room and meal types are most popular

This project answers these questions using structured SQL analytics.

---

## 🧱 Data Architecture

The project follows a **modern data warehouse approach**:
RAW DATA (CSV)
↓
STAGING LAYER
↓
DIMENSION TABLES
↓
FACT TABLE (BOOKINGS)
↓
ANALYTICS QUERIES

---

## 🗂️ Data Model

### 📥 Staging Layer
- `hotel_bookings`
- `_stg_world_countries` (GeoJSON data with PostGIS)

### 📊 Dimension Tables
- `country`
- `hotel`
- `meals`
- `market_segments`
- `distribution_channels`
- `room_types`
- `customer_types`
- `agents`
- `customers`

### ⭐ Fact Table
- `bookings`

Each booking represents a single hotel reservation enriched with all related dimensions.

---

## ⚙️ ETL Process

### 1. Extract
Raw data is loaded from CSV files into staging tables.

### 2. Transform
Data is cleaned and transformed:
- Standardizing text fields
- Converting date components into proper DATE format
- Mapping categorical values into dimension keys
- Converting cancellation flags into boolean values

### 3. Load
Final structured data is loaded into:
- Dimension tables
- Fact table

This allows efficient analytical querying.

---

## 🌍 Geospatial Analysis (PostGIS)

The project includes geospatial enrichment using PostGIS:

- World countries are loaded from GeoJSON
- Geometry is stored in `MULTIPOLYGON (4326)` format
- Enables future mapping and geographic analysis

---

## 📊 Key Business Insights

### 🌎 Top booking countries
Identifies countries with the highest demand for hotels.

### 📅 Seasonality trends
Analyzes booking distribution by month and year.

### 🛏️ Room preferences
Determines most popular room types among customers.

### 🍽️ Meal preferences
Shows which meal plans are most frequently selected.

### 📡 Distribution channels
Analyzes how customers book (direct vs agents).

### 💰 Revenue analysis
Estimates total revenue based on ADR and stay duration.

### ❌ Cancellation rate
Measures cancellation behavior by hotel type.

---

## 📈 Example Analytics Questions

- Which countries generate the highest number of bookings?
- What is the most popular month for hotel reservations?
- Which hotel type has the highest cancellation rate?
- What is the average daily rate (ADR) by country?
- Are customers mostly repeat or first-time guests?
- Which distribution channels bring the most bookings?

---

## 🛠️ Technologies Used

- PostgreSQL
- SQL (Advanced queries, joins, window functions)
- PostGIS (Geospatial data processing)
- CSV data ingestion
- Data warehouse modeling (Star schema)

---

## 🧠 Skills Demonstrated

- Data modeling (Star schema design)
- ETL pipeline development
- Data cleaning and transformation
- Business analytics using SQL
- Geospatial data processing
- KPI design and reporting logic

---

## 🚀 Project Structure
init/
├── 00_postgis_setup.sql
├── 01_create_tables.sql
├── 02_dimensions.sql
├── 03_fact_table.sql
├── 04_analytics_queries.sql

data/
├── hotel_booking.csv
├── countries.geo.json

---

## 📌 Key Takeaway

This project demonstrates how raw operational data can be transformed into a structured analytics system capable of answering real business questions.

It simulates a production-style data warehouse pipeline used in analytics engineering.

---

## 👩‍💻 Author

Built as a data analytics portfolio project focusing on SQL, data modeling, and business intelligence.