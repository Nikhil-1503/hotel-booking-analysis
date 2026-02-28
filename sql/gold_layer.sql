-- Use existing databse
USE DATABASE HOTEL_DB;

DESC TABLE SILVER_HOTEL_BOOKING;

-- Create table for Daily Revenue
CREATE OR REPLACE TABLE GOLD_DAILY_REVENUE AS
SELECT 
    CHECK_IN_DATE, COUNT(*) AS TOTAL_BOOKINGS, 
    SUM(TOTAL_AMOUNT) AS TOTAL_REVENUE 
FROM SILVER_HOTEL_BOOKING
GROUP BY CHECK_IN_DATE
ORDER BY CHECK_IN_DATE;

SELECT * FROM GOLD_DAILY_REVENUE;

-- Create table for Revenue by city
CREATE OR REPLACE TABLE GOLD_REVENUE_BY_CITY AS
SELECT
    hotel_city,
    SUM(total_amount) AS total_revenue,
    COUNT(*) AS total_bookings
FROM SILVER_HOTEL_BOOKING
GROUP BY hotel_city
ORDER BY TOTAL_REVENUE DESC;

SELECT * FROM GOLD_REVENUE_BY_CITY;

-- Create table for Revenue per month
CREATE OR REPLACE TABLE GOLD_MONTHLY_REVENUE AS 
SELECT 
    DATE_TRUNC('month', CHECK_IN_DATE) AS BOOKING_MONTH,
    TO_CHAR(DATE_TRUNC('month', CHECK_IN_DATE), 'MON-YY') AS MONTH_NAME,
    SUM(TOTAL_AMOUNT) AS MONTHLY_REVENUE
FROM SILVER_HOTEL_BOOKING
GROUP BY DATE_TRUNC('month', CHECK_IN_DATE)
ORDER BY DATE_TRUNC('month', CHECK_IN_DATE);

SELECT * FROM GOLD_MONTHLY_REVENUE;

-- Create table for Avg stay
CREATE OR REPLACE TABLE GOLD_AVG_STAY AS
SELECT
    hotel_city,
    ROUND(AVG(DATEDIFF('day', check_in_date, check_out_date)),0) AS avg_stay_days
FROM SILVER_HOTEL_BOOKING
WHERE BOOKING_STATUS = 'Confirmed'
GROUP BY hotel_city
ORDER BY avg_stay_days desc;

SELECT * FROM GOLD_AVG_STAY;

-- Create table for Cancellation Rate
CREATE OR REPLACE TABLE GOLD_CANCELLATION_RATE AS
SELECT
    hotel_city,
    ROUND(COUNT(CASE WHEN booking_status <> 'Confirmed' THEN 1 END) * 100.0
        / COUNT(*),2) AS cancellation_rate
FROM SILVER_HOTEL_BOOKING
GROUP BY hotel_city;

SELECT * FROM GOLD_CANCELLATION_RATE;

-- Create table for Repeat customers
CREATE OR REPLACE TABLE GOLD_REPEAT_CUSTOMERS AS
SELECT
    customer_id,
    customer_name,
    COUNT(*) AS booking_count,
    SUM(total_amount) AS lifetime_value
FROM SILVER_HOTEL_BOOKING
WHERE booking_status = 'Confirmed'
GROUP BY customer_id, customer_name;

select * from gold_repeat_customers;

-- Create Gold Layer Table
CREATE TABLE GOLD_HOTEL_BOOKING AS
SELECT
    booking_id,
    hotel_id,
    hotel_city,
    customer_id,
    customer_name,
    customer_email,
    check_in_date,
    check_out_date,
    room_type,
    num_guests,
    total_amount,
    currency,
    booking_status
FROM SILVER_HOTEL_BOOKING;