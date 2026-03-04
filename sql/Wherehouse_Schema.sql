CREATE DATABASE weather_dw;
USE weather_dw;
CREATE TABLE IF NOT EXISTS staging_weather (
    id INT AUTO_INCREMENT PRIMARY KEY,
    city VARCHAR(50),
    temperature FLOAT,
    humidity INT,
    weather_main VARCHAR(50),
    api_timestamp DATETIME,
    ingestion_time DATETIME
);
SHOW TABLES;
SELECT * FROM staging_weather;
USE weather_dw;
CREATE TABLE IF NOT EXISTS dim_city (
    city_id INT AUTO_INCREMENT PRIMARY KEY,
    city_name VARCHAR(50) UNIQUE
);

CREATE TABLE IF NOT EXISTS dim_datetime (
    datetime_id INT AUTO_INCREMENT PRIMARY KEY,
    full_datetime DATETIME,
    date DATE,
    hour INT,
    day INT,
    month INT,
    year INT
);

CREATE TABLE IF NOT EXISTS fact_weather (
    fact_id INT AUTO_INCREMENT PRIMARY KEY,
    city_id INT,
    datetime_id INT,
    temperature FLOAT,
    humidity INT,
    weather_main VARCHAR(50),
    ingestion_time DATETIME,
    FOREIGN KEY (city_id) REFERENCES dim_city(city_id),
    FOREIGN KEY (datetime_id) REFERENCES dim_datetime(datetime_id)
);

INSERT IGNORE INTO dim_city (city_name)
SELECT DISTINCT city
FROM staging_weather;

SELECT * FROM dim_city;

INSERT INTO dim_datetime (full_datetime, date, hour, day, month, year)
SELECT DISTINCT
    api_timestamp,
    DATE(api_timestamp),
    HOUR(api_timestamp),
    DAY(api_timestamp),
    MONTH(api_timestamp),
    YEAR(api_timestamp)
FROM staging_weather;

SELECT * FROM dim_datetime;

INSERT INTO fact_weather (
    city_id,
    datetime_id,
    temperature,
    humidity,
    weather_main,
    ingestion_time
)
SELECT
    c.city_id,
    d.datetime_id,
    s.temperature,
    s.humidity,
    s.weather_main,
    s.ingestion_time
FROM staging_weather s
JOIN dim_city c
    ON s.city = c.city_name
JOIN dim_datetime d
    ON s.api_timestamp = d.full_datetime;
    
SELECT * FROM fact_weather;
SELECT COUNT(*) FROM fact_weather;

SHOW CREATE TABLE dim_city;
SHOW CREATE TABLE dim_datetime;
SHOW CREATE TABLE fact_weather;
SHOW CREATE TABLE staging_weather;