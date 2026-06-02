Why I Built This

As part of my journey from Data Quality Engineering
towards Data Engineering, I wanted to strengthen my
hands-on skills in Python, SQL, Pandas, ETL design,
and reusable pipeline development.

# Superstore Data Platform

## Overview

This repository documents my hands-on journey from Data Quality Engineering toward Data Engineering through a series of progressively advanced data pipeline projects.

The objective is not only to process data but also to demonstrate software engineering principles, data quality frameworks, ETL design patterns, business rule implementation, reporting, and reusable pipeline architecture.

Each version builds on the previous one and introduces new concepts commonly used in enterprise data platforms.

---

# Project Evolution

## Version 1 – Customer Data Pipeline

A foundational ETL pipeline built using core Python.

### Features

* File-based ingestion
* Data validation
* Data transformation
* Rejected record handling
* Data Quality reporting
* JSON output generation
* SQLite database loading
* Logging and exception handling

### Concepts Demonstrated

* Functions
* File Handling
* Lists and Dictionaries
* Exception Handling
* Logging
* JSON Processing
* SQLite Integration
* ETL Fundamentals

### Pipeline Flow

Input File

↓

Validation & Transformation

↓

Clean / Rejected Records

↓

DQ Report

↓

JSON Output

↓

SQLite Load

↓

Load Validation

---

## Version 2 – OOP Data Quality Pipeline

An object-oriented implementation of a reusable data quality framework using the Superstore dataset.

### Features

* CSV ingestion using Pandas
* Data validation
* Business rule enrichment
* Product scoring
* Discount risk analysis
* Profitability classification
* Data Quality reporting
* Automated JSON report generation

### Business Rules

#### Product Score

Based on:

* Sales
* Quantity
* Discount
* Profit

#### Profit Category

* High Profit
* Break Even
* Loss

#### Discount Risk

* High Risk
* Medium Risk
* Safe

### OOP Concepts Demonstrated

#### Classes and Objects

Reusable pipeline architecture.

#### Inheritance

DataPipeline inherits from Pipeline.

#### Class Variables

Tracking total pipelines created.

#### Instance Variables

Pipeline-specific state.

#### Static Methods

Reusable utility functions.

#### Class Methods

Pipeline management and tracking.

#### Method Chaining

load → validate → enrich → report → save

#### Magic Methods

* **str**()
* **repr**()

### Data Quality Metrics

* Total Records
* Null Count
* Duplicate Count

---

## Version 3 – Enterprise Data Platform (In Progress)

The next phase extends the framework toward production-style data engineering patterns.

### Planned Features

* Configuration Driven Pipelines
* Modular Architecture
* Data Quality Framework
* Advanced Validation Rules
* Data Profiling
* SQL Analytics Layer
* Reporting Framework
* Pipeline Monitoring
* Reusable Components
* End-to-End ETL Workflow

### Technologies

* Python
* Pandas
* SQL
* JSON
* Logging
* OOP
* Git
* GitHub


---

# SQL Analytics Repository

The repository also contains SQL practice organized by topic.

### Topics Covered

* Joins
* Aggregations
* CASE WHEN
* CTEs
* Window Functions
* Ranking Functions
* Business Analytics
* Growth Analysis

---

# Skills Demonstrated

### Data Engineering

* ETL Development
* Data Validation
* Data Quality Frameworks
* Reporting
* Data Processing

### Programming

* Python
* Pandas
* OOP
* JSON
* Logging

### Analytics

* SQL
* Business Rules
* Data Profiling
* KPI Analysis

### Software Engineering

* Reusable Design
* Exception Handling
* Modular Development
* Version Control

---

# Why This Repository

As part of my transition toward Data Engineering, I wanted to move beyond theory and build practical projects that demonstrate real-world concepts used in enterprise data platforms.

This repository captures that journey—from a basic ETL pipeline to a reusable object-oriented framework and eventually toward large-scale data engineering workflows.

