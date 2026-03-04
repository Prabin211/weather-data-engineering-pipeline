import requests
import os
from datetime import datetime
import pandas as pd
from dotenv import load_dotenv
from sqlalchemy import create_engine


# Load environment variables
load_dotenv()
API_KEY = os.getenv("OPENWEATHER_API_KEY")

URL = "https://api.openweathermap.org/data/2.5/weather"

# Cities to monitor
CITIES = ["Hyderabad", "Delhi", "Mumbai", "Bangalore"]


def fetch_weather(city):
    params = {
        "q": city,
        "appid": API_KEY,
        "units": "metric"
    }

    response = requests.get(URL, params=params)

    if response.status_code != 200:
        print(f"❌ Failed for {city}: {response.status_code}")
        return None

    data = response.json()

    record = {
        "city": city,
        "temperature": data["main"]["temp"],
        "humidity": data["main"]["humidity"],
        "weather_main": data["weather"][0]["main"],
        "api_timestamp": datetime.utcfromtimestamp(data["dt"]),
        "ingestion_time": datetime.utcnow()
    }

    return record


def main():
    all_records = []

    for city in CITIES:
        print(f"Fetching data for {city}...")
        rec = fetch_weather(city)
        if rec:
            all_records.append(rec)

    if not all_records:
        print("No data fetched.")
        return

    df = pd.DataFrame(all_records)
    DB_USER = "root"
    DB_PASSWORD = "Prabin%409365892137"
    DB_HOST = "localhost"
    DB_NAME = "weather_dw"

    engine = create_engine(
        f"mysql+pymysql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}/{DB_NAME}"
    )

    df.to_sql(
        name="staging_weather",
        con=engine,
        if_exists="append",
        index=False
    )

    print("✅ Data loaded into staging_weather table")

    # create raw folder if missing
    os.makedirs("data/raw", exist_ok=True)

    timestamp_str = datetime.utcnow().strftime("%Y%m%d_%H%M%S")
    raw_path = f"data/raw/weather_raw_{timestamp_str}.csv"

    df.to_csv(raw_path, index=False)

    print("✅ Raw data saved to:", raw_path)
    print(df.head())


if __name__ == "__main__":
    main()