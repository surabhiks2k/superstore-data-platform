# OOP Data  Pipeline (V2)

## Overview

This project demonstrates how Object-Oriented Programming (OOP) concepts can be applied to build reusable and maintainable data engineering pipelines.

Using the Superstore dataset, the pipeline performs data validation, business-rule enrichment, data quality analysis, and automated reporting while showcasing core OOP principles commonly used in enterprise software development.

---

## Project Objectives

* Build a reusable data pipeline using OOP principles
* Apply data quality validation checks
* Implement business-rule-based transformations
* Generate automated Data Quality (DQ) reports
* Demonstrate inheritance, static methods, class methods, and method chaining
* Improve code maintainability and scalability

---

## Dataset

Sample Superstore Dataset

Key Columns Used:

* Sales
* Profit
* Discount
* Quantity

---

## Pipeline Workflow

CSV File

↓

Load Data

↓

Column Validation

↓

Business Rule Enrichment

↓

Data Quality Analysis

↓

DQ Report Generation

↓

JSON Report Output

---

## Features

### Data Validation

Validates required columns exist before processing:

* Sales
* Profit
* Discount
* Quantity

Raises exceptions for missing columns.

---

### Profit Classification

Calculates profitability category based on profit margin.

Categories:

* High Profit
* Break Even
* Loss

---

### Discount Risk Analysis

Classifies discount levels into:

* High Risk
* Medium Risk
* Safe

---

### Product Scoring

Assigns scores using business rules based on:

* Sales
* Quantity
* Discount
* Profit

---

### Data Quality Reporting

Generates:

* Total Records
* Null Counts
* Duplicate Counts

Outputs report as JSON.

Example:

```json
{
  "total_records": 9994,
  "null_count": {},
  "duplicate": 17
}
```

---

## OOP Concepts Demonstrated

### Classes and Objects

Reusable pipeline implementation using:

* Pipeline
* DataPipeline

---

### Inheritance

DataPipeline inherits from Pipeline.

Benefits:

* Code Reusability
* Reduced Duplication
* Cleaner Design

---

### Class Variables

Shared variable:

```python
pipeline_count
```

Tracks number of pipeline objects created.

---

### Instance Variables

Unique to each pipeline instance:

```python
file_path
df
report
```

---

### Static Methods

Utility methods that do not depend on object state.

Examples:

```python
is_valid_file()
clean_column_names()
```

---

### Class Methods

Operate on class-level data.

Examples:

```python
get_pipeline_count()
reset_count()
```

---

### Method Chaining

Pipeline execution uses fluent chaining:

```python
pipeline.run()

.load_file()
.validation()
.enrich()
.generate_report()
.save_report()
```

---

### Magic Methods

Implemented:

```python
__str__()
__repr__()
```

Provides readable object representation.

---

## Project Structure

```text
v2_oops_pipeline/

├── data/
│   └── Sample - Superstore.csv
│
├── output/
│   └── report_YYYY-MM-DD.json
│
├── logs/
│
├── superstore_pipeline_v2.py
│
└── README.md
```

---

## Technologies Used

* Python
* Pandas
* JSON
* Logging
* OOP
* Data Quality Validation

---

## Sample Execution

```python
pipeline = DataPipeline(
    "data/Sample - Superstore.csv"
)

pipeline.run()
```

Output:

```python
Loaded 9,994 rows
Validation Complete
Enrichment Complete
Report Generated
Report Saved
```

---

## Skills Demonstrated

### Data Engineering

* ETL Development
* Data Validation
* Data Quality Frameworks
* Reporting Automation

### Python

* OOP Design
* Inheritance
* Static Methods
* Class Methods
* Method Chaining
* Exception Handling

### Analytics

* Business Rule Implementation
* Data Profiling
* Data Quality Metrics

---

## Future Enhancements

* Configuration-driven pipelines
* Advanced DQ checks
* Data profiling reports
* SQL analytics integration
* PySpark implementation
* Workflow orchestration

---

## Author

Surabhi K S

Senior Data Quality Engineer

Building practical Data Engineering projects using Python, SQL, Pandas, Data Quality Frameworks, and ETL design principles.

