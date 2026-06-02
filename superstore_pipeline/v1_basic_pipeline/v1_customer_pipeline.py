"""
Customer Data Pipeline (v1)

This project demonstrates:
Basic ETL pipeline built in pure Python
ingestion, transformation, validation,
JSON output and SQLite load

- File-based ingestion
- Data validation and transformation
- Data quality reporting
- JSON and SQLite data loading

Author: Surabhi
"""

#-----------------------------------------------
# Step 1 — Ingestion
# -----------------------------------------------
"""
Reads raw customer data from a text file.

Input  : File path (customers.txt)
Output : List of raw records (lines)

Each line is expected in CSV format:
user_id,name,age,country
"""
def ingestion(file_path):
    with open(file_path, "r") as file:
        lines = file.readlines()
        return lines


# -----------------------------------------------
# Step 2 — Transformation & Validation
# -----------------------------------------------
"""
Applies data validation rules and separates data into:
- Clean records (valid)
- Rejected records (invalid)

Validation rules:
- Name should not be empty
- Age should be between 0 and 100
Returns:
clean    → list of valid records (dict format)
rejected → list of invalid raw records
"""

import logging
import datetime

logging.basicConfig(
    filename="logs/pipeline.log",
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)

def transformation(file):
    logging.info("Transformation process started")

    clean = []
    rejected = []

    for line in file:
        try:
            user_id, name, age, country = line.strip().split(",")
            age = int(age)

            if not name or age > 100 or age < 0:
                raise ValueError("Invalid record")

            clean.append({
                "id": user_id,
                "name": name,
                "age": age,
                "country": country
            })

            logging.info(f"Valid record: {user_id}")

        except Exception as e:
            rejected.append(line.strip())
            logging.error(f"Rejected: {line.strip()} | Reason: {e}")

    return clean, rejected


# -----------------------------------------------
# Step 3 — Data Quality Report
# -----------------------------------------------
"""
Generates a simple DQ (Data Quality) report.

Metrics:
- Total records
- Clean records
- Rejected records
- Rejection rate (%)

Output:
- Saves report as JSON file (DQ_report.json)
"""

import json

def dq_report(clean, rejected):
    total = len(clean) + len(rejected)

    report = {
        "total_records": total,
        "clean_record_count": len(clean),
        "rejected_record_count": len(rejected),
        "rejection_rate%": round(len(rejected) / total * 100, 2)
        # "generated_at": str(datetime.datetime.now())
    }

    with open("output/DQ_report.json", "w") as f:
        json.dump(report, f, indent=4)

    logging.info(f"DQ report saved - {report['rejection_rate%']}% rejection rate")

    return report


# -----------------------------------------------
# Step 4 — Load to JSON
# -----------------------------------------------
"""
Stores clean records into a JSON file.

Output file:
- cleaned.json
"""

def load_json(clean_data):
    with open("output/cleaned.json", "w") as file:
        json.dump(clean_data, file, indent=4)


# -----------------------------------------------
# Step 5 — Load to SQLite Database
# -----------------------------------------------
"""
Loads clean data into SQLite database.

Table:
- customers(id, name, age, country)

Uses parameterized queries to avoid SQL issues.
"""

import sqlite3

def load_sql(clean_data):
    conn = sqlite3.connect("customer.db")
    cur = conn.cursor()

    cur.execute("""
        CREATE TABLE IF NOT EXISTS customers(
            id TEXT,
            name TEXT,
            age INTEGER,
            country TEXT
        )
    """)

    for row in clean_data:
        cur.execute(
            "INSERT INTO customers VALUES (?, ?, ?, ?)",
            (row["id"], row["name"], row["age"], row["country"])
        )

    conn.commit()
    conn.close()


# -----------------------------------------------
# Step 6 — Table Validation
# -----------------------------------------------
"""
Validates data load by:
- Counting total records
- Printing inserted rows
"""

def table_validation():
    conn = sqlite3.connect("customer.db")
    cur = conn.cursor()

    cur.execute("SELECT COUNT(*) FROM customers")
    print("Total Records:", cur.fetchone()[0])

    cur.execute("SELECT * FROM customers")
    rows = cur.fetchall()

    for row in rows:
        print(row)

    conn.close()
    print("Records have been successfully added")


# -----------------------------------------------
# MAIN — Pipeline Execution
# -----------------------------------------------
"""
Executes the full pipeline:
1. Ingestion
2. Transformation & validation
3. DQ report generation
4. JSON load
5. SQL load
6. Validation
"""

def main():
    data = ingestion("data/customers.txt")

    clean, rejected = transformation(data)

    dq_report(clean, rejected)

    load_json(clean)

    load_sql(clean)

    table_validation()

    print("Pipeline completed")
    print("Valid records:", len(clean))
    print("Invalid records:", len(rejected))


if __name__ == "__main__":
    main()
