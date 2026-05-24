-- =========================================
-- HOTEL ANALYSIS PROJECT
-- STAGE 4: BUSINESS ANALYTICS QUERIES
-- =========================================

-- These queries are used for insights and reporting

-- Top 5 countries by number of bookings
SELECT
	c.country_name,
	COUNT(b.booking_id) AS total_bookings
FROM analytics.bookings b
JOIN analytics.country c ON b.country_id = c.country_id
GROUP BY c.country_name
ORDER BY total_bookings DESC
LIMIT 5;

-- Monthly booking trends (seasonality analysis)
SELECT EXTRACT(YEAR FROM arrival_date) AS year,
       EXTRACT(MONTH FROM arrival_date) AS month,
       COUNT(*) AS bookings_count
FROM analytics.bookings
GROUP BY year, month
ORDER BY bookings_count DESC;

-- Most popular room type
SELECT
	rt.room_type,
	COUNT(*) AS bookings_count
FROM analytics.bookings	b
JOIN analytics.room_types rt ON b.room_type_id = rt.room_type_id
GROUP BY rt.room_type
ORDER BY bookings_count DESC
LIMIT 1;

-- Preferred meal type
SELECT
	m.meal_type,
	COUNT(*) AS bookings_count
FROM analytics.bookings b
JOIN analytics.meals m ON b.meal_id = m.meal_id
GROUP BY m.meal_type
ORDER BY bookings_count DESC
LIMIT 1;

-- Booking distribution by channel (direct vs agents)
SELECT
	dc.channel_name,
	COUNT(*) AS bookings_count
FROM analytics.bookings b
JOIN analytics.distribution_channels dc ON b.channel_id = dc.channel_id
GROUP BY dc.channel_name
ORDER BY bookings_count DESC;

-- Average Daily Rate (ADR) analysis
-- Average room rate (ADR) by hotel type and country
SELECT
	h.hotel_type,
	c.country_name,
	AVG(adr) AS avg_adr
FROM analytics.bookings b
JOIN analytics.hotel h ON b.hotel_id = h.hotel_id
JOIN analytics.country c ON b.country_id = c.country_id
GROUP BY h.hotel_type, c.country_name
ORDER BY avg_adr DESC
LIMIT 5;

-- Revenue estimation by country
SELECT
	c.country_name,
	SUM(adr * (stays_in_week_nights + stays_in_weekend_nights)) AS total_revenue
FROM analytics.bookings b
JOIN analytics.country c ON b.country_id = c.country_id
GROUP BY c.country_name
ORDER BY total_revenue DESC
LIMIT 5;

-- Guest segmentation (new vs repeat)
SELECT 
    guest_type,
    COUNT(*) AS number_of_guests,
    AVG(avg_adr) AS avg_adr
FROM (
    SELECT 
        customer_id,
        AVG(adr) AS avg_adr,
        CASE 
            WHEN COUNT(*) = 1 THEN 'New Guest'
            ELSE 'Repeat Guest'
        END AS guest_type
    FROM analytics.bookings
    GROUP BY customer_id
) sub
GROUP BY guest_type;

-- Cancellation rate by hotel type
SELECT
	h.hotel_type,
	COUNT(*) FILTER (WHERE is_canceled) * 100.0 / COUNT(*) AS cancel_rate
FROM analytics.bookings b
JOIN analytics.hotel h ON b.hotel_id = h.hotel_id
GROUP BY h.hotel_type
ORDER BY cancel_rate DESC;