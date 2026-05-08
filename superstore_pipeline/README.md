# Superstore Pipeline — Upgraded ETL

Upgraded version of the v1 pipeline built on the
real Superstore retail dataset (9,994 rows).
Integrates Pandas for data processing and
adds enrichment, profiling and DQ reporting.

---

## What It Does

- Ingests Superstore CSV using pd.read_csv()
- Validates records against business rules
  - No negative sales
  - Discount cannot exceed 100%
  - Quantity must be positive
  - Customer name cannot be empty
- Splits into clean and rejected records
- Enriches clean data using apply()
  - Profit category — High Profit, Break Even, Loss
  - Discount risk — High Risk, Medium Risk, Safe
  - Product score — 0 to 100
- Generates GroupBy category summary
- Builds JSON DQ report with timestamp
- Saves clean and rejected CSV outputs
- Prints run summary with pass/fail status

---

## Files

- pipeline.py    → main pipeline orchestration
- dq_checks.py   → all validation and DQ logic
- logger.py      → centralised logging setup
- data/          → input CSV files

---

## How to Run

python pipeline.py

---

## Key Improvement Over V1

| Feature | V1 Pipeline | Superstore Pipeline |
|---|---|---|
| Data source | Text file | Real CSV — 9,994 rows |
| Parsing | Manual split | pd.read_csv() |
| Validation | Basic rules | Business rules + Pandas |
| Enrichment | None | apply() — 3 new columns |
| Summary | Basic count | GroupBy category report |
| Output | JSON + SQLite | CSV + JSON + SQL |
| Structure | Single file | Modular — 3 files |

---

## Tech Used

- Python 3
- Pandas
- SQLite3
- JSON
- Logging



