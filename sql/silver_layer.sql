-- Use existing database
USE DATABASE HOTEL_DB;

-- Create Silver Layer Table with Datatypes
CREATE OR REPLACE TABLE SILVER_HOTEL_BOOKING (
    booking_id VARCHAR,
    hotel_id VARCHAR,
    hotel_city VARCHAR,
    customer_id VARCHAR,
    customer_name VARCHAR,
    customer_email VARCHAR,
    check_in_date DATE,
    check_out_date DATE,
    room_type VARCHAR,
    num_guests INTEGER,
    total_amount FLOAT,
    currency VARCHAR,
    booking_status VARCHAR
);

-- Check for invalid email format
SELECT *
FROM BRONZE_HOTEL_BOOKING
where customer_email is null or 
(customer_email not like '%@%.%');

-- Check for invalid guest number
SELECT *
FROM BRONZE_HOTEL_BOOKING
where NUM_GUESTS < 0;

-- Check for invalid check in/check out date
SELECT check_in_date, check_out_date
FROM BRONZE_HOTEL_BOOKING
WHERE TRY_TO_DATE(check_out_date) < TRY_TO_DATE(check_in_date);

-- Check for invalid booking status
SELECT distinct booking_status
from BRONZE_HOTEL_BOOKING;

-- SELECT *
-- from BRONZE_HOTEL_BOOKING
-- where TOTAL_AMOUNT < 0 and booking_status = 'Confirmed';

-- Copy data into Silver Layer Table from Bronze Layer Table
INSERT INTO SILVER_HOTEL_BOOKING
SELECT 
booking_id,
hotel_id,
initcap(trim(hotel_city)) as hotel_city,
customer_id,
initcap(trim(customer_name)) as customer_name,
case when customer_email like '%@%.%' then lower(customer_email) else null end as customer_email,
try_to_date(nullif(check_in_date, '')) as check_in_date,
try_to_date(nullif(check_out_date, '')) as check_out_date,
room_type,
num_guests,
total_amount,
currency,
case when lower(booking_status) in ('confirmeeed', 'confirmed') then 'Confirmed' else booking_status end as booking_status
from bronze_hotel_booking
where 
check_in_date < check_out_date and 
TRY_TO_DATE(check_in_date) IS NOT NULL AND 
TRY_TO_DATE(check_out_date) IS NOT NULL;

SELECT * FROM SILVER_HOTEL_BOOKING;

