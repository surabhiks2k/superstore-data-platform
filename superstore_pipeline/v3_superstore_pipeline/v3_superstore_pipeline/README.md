# Superstore Data & Business Analysis Pipeline

An end-to-end Python data pipeline that loads, processes, enriches, and analyzes the Sample Superstore dataset, generating business insights on sales performance, profitability, discount impact, and category-level trends.

---

## Project Overview

This project simulates a real-world data pipeline that performs data ingestion, transformation, business rule processing, analytical reporting, and automated output generation using Python and pandas.

The pipeline follows an object-oriented design and is organized into separate modules for configuration, validation, enrichment, analytics, and orchestration.

---

## Features

### Data Ingestion

* Reads raw Superstore CSV data
* Standardizes column names
* Validates file format before processing

### Data Processing

* Applies configurable business rules
* Identifies invalid records
* Separates clean and rejected datasets

### Data Enrichment

Creates additional business-focused metrics:

* Product Score
* Discount Risk Classification
* Profit Category

### Business Analytics

#### Category Analysis

* Total Sales
* Total Profit
* Total Quantity
* Average Discount
* Profit Margin Percentage

#### Region Analysis

* Regional Sales Performance
* Regional Profitability
* Order Distribution
* Regional Sales Rankings

### Profit Margin Benchmarking

Compares actual category profit margins against predefined business targets and calculates performance gaps.

### Reporting

Generates:

* JSON summary report
* Clean records dataset
* Rejected records dataset
* Execution logs

---

## Project Structure

```text
v3_superstore_pipeline/
├── config.py          # Configuration, thresholds, business rules
├── helpers.py         # Utility and enrichment functions
├── validator.py       # Data validation logic
├── analyser.py        # Business analytics and aggregations
├── pipeline.py        # Pipeline orchestration
├── main.py            # Application entry point
├── data/
│   └── Sample - Superstore.csv
├── logs/
│   └── pipeline.log
└── output/
    ├── clean_record.csv
    ├── rejected_records.csv
    └── report_<date>.json
```

---

## Technologies Used

* Python
* Pandas
* Object-Oriented Programming (OOP)
* Logging
* JSON
* Data Processing
* Business Analytics

---

## How to Run

Install dependencies:

```bash
pip install pandas
```

Execute the pipeline:

```bash
python main.py
```

---

## Generated Outputs

### JSON Report

Produces a summarized business report including:

* Total records processed
* Duplicate record count
* Null value statistics
* Profit margin analysis
* Expected vs Actual margin comparison
* Clean and rejected record counts

### Clean Dataset

```text
output/clean_record.csv
```

### Rejected Dataset

```text
output/rejected_records.csv
```

### Execution Logs

```text
logs/pipeline.log
```

---

## Sample Results

Dataset Processed: **9,994 Records**

| Category        | Profit Margin % | Expected Margin % | Gap    | Status |
| --------------- | --------------- | ----------------- | ------ | ------ |
| Furniture       | 2.49            | 15.00             | -12.51 | Failed |
| Office Supplies | 17.04           | 20.00             | -2.96  | Failed |
| Technology      | 17.40           | 25.00             | -7.60  | Failed |

---

## Learning Outcomes

This project demonstrates:

* Python programming
* Pandas-based data processing
* Object-Oriented Design
* Data transformation workflows
* Business metric calculations
* Analytical reporting
* Structured project organization
* Logging and error handling

---
Tech Stack
Python · pandas · Object-Oriented Design · Logging · JSON
