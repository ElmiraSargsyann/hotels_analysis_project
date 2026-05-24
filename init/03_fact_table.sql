-- =========================================
-- HOTEL ANALYSIS PROJECT
-- STAGE 3: FACT TABLE (BOOKINGS)
-- =========================================

-- Fact table contains measurable business events
-- Each row = one hotel booking transaction

CREATE TABLE analytics.bookings (
    booking_id SERIAL PRIMARY KEY,

    -- Foreign keys to dimension tables
    hotel_id INTEGER REFERENCES analytics.hotel(hotel_id),
    country_id INTEGER REFERENCES analytics.country(country_id),
    meal_id INTEGER REFERENCES analytics.meals(meal_id),
    segment_id INTEGER REFERENCES analytics.market_segments(segment_id),
    channel_id INTEGER REFERENCES analytics.distribution_channels(channel_id),
    room_type_id INTEGER REFERENCES analytics.room_types(room_type_id),
    customer_type_id INTEGER REFERENCES analytics.customer_types(customer_type_id),
    agent_id INTEGER REFERENCES analytics.agents(agent_id),
    customer_id INTEGER REFERENCES analytics.customers(customer_id),

    -- Business metrics
    is_canceled BOOLEAN,
    lead_time INTEGER,
    arrival_date DATE,
    stays_in_week_nights INTEGER,
    stays_in_weekend_nights INTEGER,
    adults INTEGER,
    children INTEGER,
    babies INTEGER,
    booking_changes INTEGER,
    adr NUMERIC(10,2),
    reservation_status VARCHAR(30),
    reservation_status_date DATE
);

-- Populate fact table by joining all dimensions
-- This is the TRANSFORM + LOAD step of ETL
INSERT INTO analytics.bookings (
    hotel_id,
    country_id,
    meal_id,
    segment_id,
    channel_id,
    room_type_id,
    customer_type_id,
    agent_id,
    customer_id,
    is_canceled,
    lead_time,
    arrival_date,
    stays_in_week_nights,
    stays_in_weekend_nights,
    adults,
    children,
    babies,
    booking_changes,
    adr,
    reservation_status,
    reservation_status_date
)
SELECT
    h.hotel_id,
    c.country_id,
    m.meal_id,
    ms.segment_id,
    dc.channel_id,
    rt.room_type_id,
    ct.customer_type_id,
    a.agent_id,
    cu.customer_id,

    -- Convert integer flag into boolean
    CASE hb.is_canceled
    	WHEN 0 THEN FALSE
    	WHEN 1 THEN TRUE
    END AS is_canceled,

    hb.lead_time,

    -- Build proper DATE from separate fields
    MAKE_DATE(
        hb.arrival_date_year,
        CASE TRIM(hb.arrival_date_month)
            WHEN 'January' THEN 1
            WHEN 'February' THEN 2
            WHEN 'March' THEN 3
            WHEN 'April' THEN 4
            WHEN 'May' THEN 5
            WHEN 'June' THEN 6
            WHEN 'July' THEN 7
            WHEN 'August' THEN 8
            WHEN 'September' THEN 9
            WHEN 'October' THEN 10
            WHEN 'November' THEN 11
            WHEN 'December' THEN 12
        END,
        hb.arrival_date_day_of_month
    ) AS arrival_date,
    
    hb.stays_in_week_nights,
    hb.stays_in_weekend_nights,
    hb.adults,
    hb.children,
    hb.babies,
    hb.booking_changes,
    hb.adr,
    hb.reservation_status,
    hb.reservation_status_date
FROM analytics.hotel_bookings hb
LEFT JOIN analytics.hotel h ON SPLIT_PART(TRIM(hb.hotel), '-', 1) = h.hotel_type
LEFT JOIN analytics.country c ON TRIM(hb.country) = c.country_code
LEFT JOIN analytics.meals m ON TRIM(hb.meal) = m.meal_type
LEFT JOIN analytics.market_segments ms ON TRIM(hb.market_segment) = ms.segment_name
LEFT JOIN analytics.distribution_channels dc ON TRIM(hb.distribution_channel) = dc.channel_name
LEFT JOIN analytics.room_types rt ON TRIM(hb.reserved_room_type) = rt.room_type
LEFT JOIN analytics.customer_types ct ON TRIM(hb.customer_type) = ct.customer_type
LEFT JOIN analytics.agents a ON hb.agent = a.agent_code
LEFT JOIN analytics.customers cu ON LOWER(TRIM(hb.email)) = cu.customer_email;