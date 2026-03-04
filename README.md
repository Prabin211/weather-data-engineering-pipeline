# Weather Data Engineering Pipeline

## Project Overview
This project builds an end-to-end data pipeline that collects real-time weather data from the OpenWeather API, stores it in a MySQL data warehouse using a star schema, and visualizes insights using Power BI.

## Architecture
OpenWeather API → Python ETL → MySQL Data Warehouse → Power BI Dashboard

## Technologies Used
- Python
- Pandas
- Requests
- MySQL
- SQLAlchemy
- Power BI

## Data Pipeline Steps
1. Extract weather data from OpenWeather API
2. Store raw API responses as CSV
3. Load data into MySQL staging table
4. Transform data into star schema (dimension and fact tables)
5. Build interactive dashboard in Power BI

## Dashboard Features
- Average temperature by city
- Average humidity by city
- Weather condition distribution
- City filtering

## Folder Structure
api-weather-warehouse/
│
├── etl/
│   ├── ingest_api.py
│   └── test_api.py
│
├── sql/
│   └── warehouse_schema.sql
│
├── powerbi/
│   └── weather_dashboard.pbix
│
├── data/
│   └── raw/
│       └── weather_raw_*.csv
│
├── requirements.txt
└── README.md
