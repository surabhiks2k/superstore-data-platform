# V1 — Basic Customer ETL Pipeline

This is the first version of the pipeline — built
using pure Python on a simple customer dataset.
No external libraries used except json, logging
and sqlite3.

---

## What It Does

- Reads raw customer data from a text file
- Validates each record against business rules
  - Age must be between 0 and 100
  - Name cannot be empty
  - Fields must match expected format
- Splits records into clean and rejected
- Logs every decision — valid and rejected
- Saves clean data as JSON
- Loads clean records into SQLite database
- Generates a DQ report with rejection rate
- Prints pipeline run summary

---

## Files

- v1_customer_pipeline.py  → main pipeline script
- pipeline.ipynb           → notebook version
- data/customers.txt       → raw input data

## Why This Exists

This v1 pipeline was the starting point.
It shows the core ETL logic in its simplest form
before being upgraded to the Superstore pipeline
with Pandas integration and real dataset.

---

## What I Learnt Building This

- File handling with open() and with statement
- try/except for row level error handling
- Logging — info and error levels
- JSON output using json.dump()
- SQLite database operations
- Structuring a pipeline with main()

---

## How to Run

python v1_customer_pipeline.py

---

## Pipeline Run Summary

2026-05-07 23:19:17,823 - INFO - Transformation process started
2026-05-07 23:19:17,823 - INFO - Valid record: 1
2026-05-07 23:19:17,823 - ERROR - Rejected: 2,Alice,abc,UK | Reason: invalid literal for int() with base 10: 'abc'
2026-05-07 23:19:17,823 - INFO - Valid record: 3
2026-05-07 23:19:17,823 - ERROR - Rejected: 4,,30,USA | Reason: Invalid record
2026-05-07 23:19:17,823 - ERROR - Rejected: 5,Sam,120,Canada | Reason: Invalid record
2026-05-07 23:19:17,823 - INFO - Valid record: 6
2026-05-07 23:19:17,823 - INFO - DQ report saved - 50.0% rejection rate

# Cleaned.Json

[
    {
        "id": "1",
        "name": "John",
        "age": 25,
        "country": "USA"
    },
    {
        "id": "3",
        "name": "Bob",
        "age": 45,
        "country": "India"
    },
    {
        "id": "6",
        "name": "Mike",
        "age": 35,
        "country": "USA"
    }
]

# DQ_report.json

{
    "total_records": 6,
    "clean_record_count": 3,
    "rejected_record_count": 3,
    "rejection_rate%": 50.0
}

