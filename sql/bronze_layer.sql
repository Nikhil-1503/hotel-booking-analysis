-- Create DataBase
CREATE DATABASE HOTEL_DB;

-- Create File Format
CREATE OR REPLACE FILE FORMAT FF_RAW_CSV
TYPE = CSV
FIELD_DELIMITER = ','
FIELD_OPTIONALLY_ENCLOSED_BY = '"'
SKIP_HEADER = 1
NULL_IF = ('NULL', 'null', '');

-- Shows the properties/metadata of File Format 
DESC FILE FORMAT FF_RAW_CSV;

-- Get the DDL for File Format
SELECT GET_DDL('FILE FORMAT', 'FF_RAW_CSV');

-- Create Stage Table
CREATE OR REPLACE STAGE STG_RAW_HOTEL_BOOKING
FILE_FORMAT = FF_RAW_CSV;

-- Create Bronze Layer Table
CREATE OR REPLACE TABLE BRONZE_HOTEL_BOOKING (
    booking_id STRING,
    hotel_id STRING,
    hotel_city STRING,
    customer_id STRING,
    customer_name STRING,
    customer_email STRING,
    check_in_date STRING,
    check_out_date STRING,
    room_type STRING,
    num_guests STRING,
    total_amount STRING,
    currency STRING,
    booking_status STRING
);

-- Load data into Bronze Layer Table from Stage Table
COPY INTO BRONZE_HOTEL_BOOKING
FROM @STG_RAW_HOTEL_BOOKING
FILE_FORMAT = FF_RAW_CSV;

SELECT * FROM BRONZE_HOTEL_BOOKING;