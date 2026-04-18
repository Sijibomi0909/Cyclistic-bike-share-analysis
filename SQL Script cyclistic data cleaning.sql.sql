-- ============================================================
-- CYCLISTIC CASE STUDY - DATA CLEANING & PREPARATION
-- Analyst: Oluwasijibomi Oderinde
-- Date: 16/04/2026
-- Tool: DB Browser for SQLite (SQLite)
-- Time Period: April 2025 - March 2026
-- ============================================================

-- ------------------------------------------------------------
-- STEP 1: Create and populate the combined raw table
-- ------------------------------------------------------------

-- Import the first file manually via File > Import > Table from CSV
-- Table name: tripdata_combined
-- After that, run the following commands to append remaining months

-- IMPORTANT: Update the file paths below to match YOUR computer!
-- Use forward slashes (/) in the path.

.import "C:/Users/Lenovo/Desktop/Cyclistic_Capstone/01_Raw_Data/202504-divvy-tripdata.csv" tripdata_combined --csv --skip 1
.import "C:/Users/Lenovo/Desktop/Cyclistic_Capstone/01_Raw_Data/202505-divvy-tripdata.csv" tripdata_combined --csv --skip 1
.import "C:/Users/Lenovo/Desktop/Cyclistic_Capstone/01_Raw_Data/202506-divvy-tripdata.csv" tripdata_combined --csv --skip 1
.import "C:/Users/Lenovo/Desktop/Cyclistic_Capstone/01_Raw_Data/202507-divvy-tripdata.csv" tripdata_combined --csv --skip 1
.import "C:/Users/Lenovo/Desktop/Cyclistic_Capstone/01_Raw_Data/202508-divvy-tripdata.csv" tripdata_combined --csv --skip 1
.import "C:/Users/Lenovo/Desktop/Cyclistic_Capstone/01_Raw_Data/202509-divvy-tripdata.csv" tripdata_combined --csv --skip 1
.import "C:/Users/Lenovo/Desktop/Cyclistic_Capstone/01_Raw_Data/202510-divvy-tripdata.csv" tripdata_combined --csv --skip 1
.import "C:/Users/Lenovo/Desktop/Cyclistic_Capstone/01_Raw_Data/202511-divvy-tripdata.csv" tripdata_combined --csv --skip 1
.import "C:/Users/Lenovo/Desktop/Cyclistic_Capstone/01_Raw_Data/202512-divvy-tripdata.csv" tripdata_combined --csv --skip 1
.import "C:/Users/Lenovo/Desktop/Cyclistic_Capstone/01_Raw_Data/202601-divvy-tripdata.csv" tripdata_combined --csv --skip 1
.import "C:/Users/Lenovo/Desktop/Cyclistic_Capstone/01_Raw_Data/202602-divvy-tripdata.csv" tripdata_combined --csv --skip 1
.import "C:/Users/Lenovo/Desktop/Cyclistic_Capstone/01_Raw_Data/202603-divvy-tripdata.csv" tripdata_combined --csv --skip 1

-- ------------------------------------------------------------
-- STEP 2: Create cleaned table with engineered features
-- ------------------------------------------------------------

DROP TABLE IF EXISTS tripdata_cleaned;

CREATE TABLE tripdata_cleaned AS
SELECT
  -- Original columns
  ride_id,
  rideable_type,
  started_at,
  ended_at,
  start_station_name,
  end_station_name,
  member_casual,
  
  -- NEW: Ride length in minutes (rounded to 2 decimal places)
  ROUND((JULIANDAY(ended_at) - JULIANDAY(started_at)) * 1440, 2) AS ride_length_mins,
  
  -- NEW: Day of week (text format for readability)
  CASE CAST(STRFTIME('%w', started_at) AS INTEGER)
    WHEN 0 THEN 'Sunday'
    WHEN 1 THEN 'Monday'
    WHEN 2 THEN 'Tuesday'
    WHEN 3 THEN 'Wednesday'
    WHEN 4 THEN 'Thursday'
    WHEN 5 THEN 'Friday'
    WHEN 6 THEN 'Saturday'
  END AS day_of_week,
  
  -- NEW: Numeric day of week (0=Sun, 6=Sat) for sorting
  CAST(STRFTIME('%w', started_at) AS INTEGER) AS day_of_week_num,
  
  -- NEW: Month number (1-12)
  CAST(STRFTIME('%m', started_at) AS INTEGER) AS month_num,
  
  -- NEW: Hour of day (0-23)
  CAST(STRFTIME('%H', started_at) AS INTEGER) AS start_hour,
  
  -- NEW: Year
  CAST(STRFTIME('%Y', started_at) AS INTEGER) AS year

FROM tripdata_combined
WHERE
  -- Data quality filters
  ride_id IS NOT NULL AND ride_id != ''
  AND started_at IS NOT NULL
  AND ended_at IS NOT NULL
  AND JULIANDAY(ended_at) > JULIANDAY(started_at)
  AND (JULIANDAY(ended_at) - JULIANDAY(started_at)) * 1440 >= 1      -- minimum 1 minute
  AND (JULIANDAY(ended_at) - JULIANDAY(started_at)) * 1440 <= 1440   -- maximum 24 hours
  AND start_station_name IS NOT NULL AND start_station_name != ''
  AND end_station_name IS NOT NULL AND end_station_name != '';

-- ------------------------------------------------------------
-- STEP 3: Verify row count (should be ~3.7 million)
-- ------------------------------------------------------------
SELECT COUNT(*) AS total_cleaned_rows FROM tripdata_cleaned;

-- ------------------------------------------------------------
-- STEP 4: Export cleaned data to CSV
-- (Use File > Export > Table(s) as CSV file...)
-- Save as: 02_Prepared_Data/cyclistic_clean_12months.csv
-- ------------------------------------------------------------