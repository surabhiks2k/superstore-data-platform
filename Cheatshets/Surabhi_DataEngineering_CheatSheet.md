# 📘 Surabhi's Data Engineering Cheat Sheet
## Python | Pandas | OOP | PySpark — Complete Reference

---

# SECTION 1 — PYTHON FUNDAMENTALS

## 1.1 Functions
```python
# Basic function
def greet(name):
    return f"Hello {name}"

# Default arguments
def discount_risk(x, threshold=0.30):
    if x >= threshold: return "High Risk"
    return "Safe"

# *args — multiple positional arguments
def total(*args):
    return sum(args)
total(1, 2, 3)  # 6

# **kwargs — multiple keyword arguments
def show(**kwargs):
    for k, v in kwargs.items():
        print(f"{k}: {v}")
show(name="Surabhi", role="Data Engineer")
```

## 1.2 List Comprehensions
```python
# Basic
squares = [x**2 for x in range(5)]  # [0, 1, 4, 9, 16]

# With condition
evens = [x for x in range(10) if x % 2 == 0]

# Dict comprehension
scores = {name: score for name, score in zip(["a","b"], [90, 85])}
```

## 1.3 Lambda Functions
```python
double = lambda x: x * 2
double(5)  # 10

# Used with map/filter
nums = [1, 2, 3, 4, 5]
doubled = list(map(lambda x: x * 2, nums))
evens   = list(filter(lambda x: x % 2 == 0, nums))
```

## 1.4 Error Handling
```python
try:
    result = 10 / 0
except ZeroDivisionError as e:
    print(f"Error: {e}")
except Exception as e:
    print(f"Unexpected: {e}")
finally:
    print("Always runs")
```

## 1.5 File I/O
```python
import json, os

# Write JSON
os.makedirs("output", exist_ok=True)
with open("output/report.json", "w") as f:
    json.dump({"total": 100, "clean": 95}, f, indent=4)

# Read JSON
with open("output/report.json", "r") as f:
    data = json.load(f)
```

## 1.6 Logging
```python
import logging

logging.basicConfig(
    filename="logs/pipeline.log",
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s"
)

logging.info("Pipeline started")
logging.error("Something failed")
```

---

# SECTION 2 — OOP (Object Oriented Programming)

## 2.1 Class Basics
```python
class Pipeline:
    pipeline_count = 0          # class variable — shared across all instances

    def __init__(self, file_path):
        self.file_path = file_path  # instance variable — unique per object
        self.df = None
        Pipeline.pipeline_count += 1

    def load(self):
        print(f"Loading {self.file_path}")
        return self                  # enables method chaining

    def __str__(self):              # readable output — print(pipeline)
        return f"Pipeline: {self.file_path}"

    def __repr__(self):             # developer output — repr(pipeline)
        return f"Pipeline(file_path='{self.file_path}')"
```

## 2.2 Inheritance
```python
class DataPipeline(Pipeline):       # child inherits from Pipeline
    def __init__(self, file_path):
        super().__init__(file_path) # call parent __init__
        self.report = {}

    def validate(self):
        print("Validating...")
        return self

    def run(self):
        return self.load().validate()  # method chaining
```

## 2.3 Static & Class Methods
```python
class DataPipeline(Pipeline):

    @staticmethod
    def is_valid_file(filepath):    # no self or cls — pure utility
        return filepath.endswith(".csv")

    @classmethod
    def get_count(cls):             # accesses class-level data
        return cls.pipeline_count

    @classmethod
    def reset_count(cls):
        cls.pipeline_count = 0
        return cls.pipeline_count

# Usage — no object needed for staticmethod/classmethod
DataPipeline.is_valid_file("data.csv")   # True
DataPipeline.get_count()                  # 2
```

## 2.4 Method Chaining
```python
# Each method returns self — enables chaining
pipeline = DataPipeline("data/Superstore.csv")
pipeline.load().validate().enrich().generate_report().save_report()
```

## 2.5 Helper Functions (used with apply)
```python
def product_score(row):
    score = 0
    if row['Profit']   > 200:  score += 20
    if row['Sales']    > 1000: score += 30
    if row['Quantity'] > 5:    score += 25
    if row['Discount'] < 0.15: score += 25
    return score

def discount_risk(x):
    if x >= 0.30:   return 'High Risk'
    elif x >= 0.15: return 'Medium Risk'
    else:           return 'Safe'

def profit_category(row):
    if row['Sales'] == 0: return 'Unknown'
    margin = (row['Profit'] / row['Sales']) * 100
    if margin > 20:   return 'High Profit'
    elif margin >= 0: return 'Break Even'
    else:             return 'Loss'
```

---

# SECTION 3 — PANDAS

## 3.1 Read & Inspect
```python
import pandas as pd

df = pd.read_csv("data/Sample - Superstore.csv", encoding="latin1")
df.shape          # (9994, 21)
df.dtypes         # column types
df.isnull().sum() # null counts
df.duplicated().sum()  # duplicate count
df.head(5)
df.describe()
```

## 3.2 Column Operations
```python
df.columns = df.columns.str.strip()          # remove spaces
df['Sales'] = df['Sales'].astype(float)       # cast type
df['Profit_Margin'] = df['Profit'] / df['Sales'] * 100
```

## 3.3 Filter & Select
```python
df[df['Sales'] > 1000]
df[(df['Category'] == 'Furniture') & (df['Profit'] < 0)]
df[['Category', 'Sales', 'Profit']]
```

## 3.4 GroupBy & Aggregation
```python
summary = df.groupby('Category').agg(
    total_sales   = ('Sales',    'sum'),
    total_profit  = ('Profit',   'sum'),
    avg_discount  = ('Discount', 'mean'),
    total_orders  = ('Order ID', 'count')
).reset_index()

summary['Profit_Margin_pct'] = summary['total_profit'] / summary['total_sales'] * 100
```

## 3.5 Apply — Custom Functions
```python
df['Product_Score']   = df.apply(product_score, axis=1)
df['Profit_Category'] = df.apply(profit_category, axis=1)
df['Discount_Risk']   = df['Discount'].apply(discount_risk)
```

## 3.6 Merge (Join)
```python
targets = pd.DataFrame({
    'Category':        ['Furniture', 'Office Supplies', 'Technology'],
    'expected_margin': [15.0, 20.0, 25.0]
})

merged = pd.merge(summary, targets, on='Category', how='left')
merged['GAP']    = merged['Profit_Margin_pct'] - merged['expected_margin']
merged['status'] = merged['GAP'].apply(lambda x: 'Passed' if x > 0 else 'Failed')
```

## 3.7 Save Output
```python
import json
from datetime import datetime

df.to_csv("output/clean_record.csv", index=False)

report = {
    'total_records':   len(df),
    'clean_records':   len(clean),
    'rejected_records': len(rejected)
}
with open(f"output/report_{datetime.now().strftime('%Y-%m-%d')}.json", "w") as f:
    json.dump(report, f, indent=4)
```

---

# SECTION 4 — PYSPARK

## 4.1 SparkSession Setup
```python
import os
os.environ["SPARK_LOCAL_IP"] = "127.0.0.1"
os.environ["JAVA_HOME"]      = "/opt/homebrew/opt/openjdk@17"

from pyspark.sql import SparkSession

spark = (
    SparkSession.builder
    .appName("Superstore")
    .config("spark.driver.host",        "127.0.0.1")
    .config("spark.driver.bindAddress", "127.0.0.1")
    .getOrCreate()
)
spark.sparkContext.setLogLevel("ERROR")
```

## 4.2 Read CSV
```python
# With inferSchema
df = (
    spark.read
    .option("header",    True)
    .option("inferSchema", True)
    .option("quote",     '"')
    .option("escape",    '"')
    .option("multiLine", True)
    .csv("Sample - Superstore.csv")
)

# With explicit schema (recommended for production)
from pyspark.sql.types import (
    StructType, StructField,
    StringType, DoubleType, IntegerType
)

schema = StructType([
    StructField("Order ID",      StringType(),  True),
    StructField("Category",      StringType(),  True),
    StructField("Sales",         DoubleType(),  True),
    StructField("Quantity",      IntegerType(), True),
    StructField("Discount",      DoubleType(),  True),
    StructField("Profit",        DoubleType(),  True),
    StructField("Region",        StringType(),  True),
    StructField("Product Name",  StringType(),  True),
])

df = (
    spark.read
    .option("header", True)
    .schema(schema)
    .csv("Sample - Superstore.csv")
)

df.printSchema()
df.count()
df.show(5)
```

## 4.3 Cast Columns
```python
from pyspark.sql.functions import col

df = df \
    .withColumn("Sales",    col("Sales").cast("double")) \
    .withColumn("Profit",   col("Profit").cast("double")) \
    .withColumn("Discount", col("Discount").cast("double")) \
    .withColumn("Quantity", col("Quantity").cast("integer"))
```

## 4.4 Select & Filter
```python
# Select columns
df.select("Category", "Sales", "Profit").show(5)

# Filter — single condition
df.filter(col("Sales") > 500).show(5)

# Filter — multiple conditions
df.filter(
    (col("Category") == "Furniture") & (col("Profit") < 0)
).show(5)
```

## 4.5 GroupBy & Aggregation
```python
import pyspark.sql.functions as F

category_summary = df.groupBy("Category").agg(
    F.round(F.sum("Sales"),   2).alias("Total_Sales"),
    F.round(F.sum("Profit"),  2).alias("Total_Profit"),
    F.round(F.avg("Discount"),4).alias("Avg_Discount"),
    F.count("Order ID")         .alias("Total_Orders")
).withColumn(
    "Profit_Margin_Pct",
    F.round((col("Total_Profit") / col("Total_Sales")) * 100, 2)
)

category_summary.show()
```

## 4.6 withColumn & when (CASE WHEN)
```python
from pyspark.sql.functions import when

# Discount Risk
df = df.withColumn(
    "Discount_Risk",
    when(col("Discount") >= 0.30, "High Risk")
    .when(col("Discount") >= 0.15, "Medium Risk")
    .otherwise("Safe")
)

# Profit Category
df = df.withColumn(
    "Profit_Category",
    when(col("Sales") == 0, "Unknown")
    .when((col("Profit") / col("Sales") * 100) > 20,  "High Profit")
    .when((col("Profit") / col("Sales") * 100) >= 0,  "Break Even")
    .otherwise("Loss")
)
```

## 4.7 Window Functions
```python
from pyspark.sql.window import Window
from pyspark.sql.functions import rank, dense_rank, sum as spark_sum, avg

# Rank by profit within each category
window_rank = Window.partitionBy("Category").orderBy(col("Profit").desc())

df.withColumn("profit_rank", rank().over(window_rank)) \
  .filter(col("profit_rank") <= 3) \
  .select("Category", "Product Name", "Profit", "profit_rank") \
  .show(10)

# Running total of sales by region
window_running = (
    Window.partitionBy("Region")
    .orderBy("Order Date")
    .rowsBetween(Window.unboundedPreceding, Window.currentRow)
)

df.withColumn("Running_Sales", spark_sum("Sales").over(window_running)) \
  .select("Region", "Order Date", "Sales", "Running_Sales") \
  .show(10)

# Partition-level average without collapsing rows
window_avg = Window.partitionBy("Category")
df.withColumn("Avg_Category_Sales", avg("Sales").over(window_avg)) \
  .select("Category", "Sales", "Avg_Category_Sales") \
  .show(10)
```

## 4.8 Spark SQL
```python
# Register temp view
df.createOrReplaceTempView("superstore")

# Query with pure SQL
spark.sql("""
    SELECT
        Category,
        ROUND(SUM(Sales), 2)               AS total_sales,
        ROUND(SUM(Profit), 2)              AS total_profit,
        ROUND(SUM(Profit)/SUM(Sales)*100, 2) AS profit_margin_pct,
        CASE
            WHEN AVG(Discount) >= 0.30 THEN 'High Risk'
            WHEN AVG(Discount) >= 0.15 THEN 'Medium Risk'
            ELSE 'Safe'
        END AS risk_flag
    FROM superstore
    GROUP BY Category
    ORDER BY profit_margin_pct DESC
""").show()
```

## 4.9 Joins
```python
from pyspark.sql import Row
from pyspark.sql.functions import broadcast

# Create reference/dimension table
targets = spark.createDataFrame([
    Row(Category="Furniture",       expected_margin=15.0),
    Row(Category="Office Supplies", expected_margin=20.0),
    Row(Category="Technology",      expected_margin=25.0),
])

# Join types
category_summary.join(targets, on="Category", how="inner").show()  # inner
category_summary.join(targets, on="Category", how="left").show()   # left
category_summary.join(targets, on="Category", how="right").show()  # right
category_summary.join(targets, on="Category", how="outer").show()  # full outer

# Broadcast join — use when one table is small
result = (
    category_summary
    .join(broadcast(targets), on="Category", how="left")
    .withColumn("GAP",    col("Profit_Margin_Pct") - col("expected_margin"))
    .withColumn("Status", when(col("GAP") > 0, "Passed").otherwise("Failed"))
)
result.show()
```

## 4.10 UDFs — User Defined Functions
```python
from pyspark.sql.functions import udf
from pyspark.sql.types import StringType, IntegerType

# Regular UDF — slower, use when native functions can't do it
def discount_risk_udf_fn(x):
    if x is None: return "Unknown"   # always null-guard UDFs
    if x >= 0.30: return "High Risk"
    elif x >= 0.15: return "Medium Risk"
    else: return "Safe"

discount_risk_udf = udf(discount_risk_udf_fn, StringType())
df = df.withColumn("Discount_Risk", discount_risk_udf(col("Discount")))

# Pandas UDF — faster (batch processing via Apache Arrow)
from pyspark.sql.functions import pandas_udf
import pandas as pd

@pandas_udf(StringType())
def discount_risk_pandas(discount: pd.Series) -> pd.Series:
    def classify(x):
        if x >= 0.30: return "High Risk"
        elif x >= 0.15: return "Medium Risk"
        else: return "Safe"
    return discount.apply(classify)

df = df.withColumn("Discount_Risk_Fast", discount_risk_pandas(col("Discount")))

# KEY RULE: prefer native when() over UDF when possible — UDFs break JVM optimization
```

## 4.11 Null Handling
```python
import pyspark.sql.functions as F

# Check nulls per column
df.select([
    F.count(F.when(F.col(c).isNull(), c)).alias(c)
    for c in df.columns
]).show()

# dropna
df.dropna()                              # drop if ANY null
df.dropna(how="all")                     # drop if ALL null
df.dropna(subset=["Sales", "Profit"])    # drop if these cols null
df.dropna(thresh=3)                      # keep if at least 3 non-null

# fillna
df.fillna({
    "Sales":    0.0,
    "Profit":   0.0,
    "Discount": 0.0,
    "Quantity": 0,
    "Category": "Unknown"
})

# isNull / isNotNull filter
df.filter(col("Sales").isNull()).show()
df.filter(col("Sales").isNotNull()).show()
df.filter(col("Sales").isNotNull() & col("Category").isNotNull()).show()
```

## 4.12 Schema Enforcement
```python
from pyspark.sql.types import StructType, StructField, StringType, DoubleType, IntegerType

schema = StructType([
    StructField("Row ID",       IntegerType(), True),
    StructField("Order ID",     StringType(),  True),
    StructField("Order Date",   StringType(),  True),
    StructField("Category",     StringType(),  True),
    StructField("Sub-Category", StringType(),  True),
    StructField("Product Name", StringType(),  True),
    StructField("Sales",        DoubleType(),  True),
    StructField("Quantity",     IntegerType(), True),
    StructField("Discount",     DoubleType(),  True),
    StructField("Profit",       DoubleType(),  True),
    StructField("Region",       StringType(),  True),
])

df = (
    spark.read
    .option("header", True)
    .schema(schema)
    .csv("Sample - Superstore.csv")
)

# Interview point: "I define schemas explicitly — faster (no double scan),
# deterministic, avoids type-inference bugs in production."
```

## 4.13 Repartition vs Coalesce
```python
# Check current partitions
print(df.rdd.getNumPartitions())

# repartition — increases OR decreases, causes full shuffle
df.repartition(4)
df.repartition(4, "Category")   # partition by column — good before joins

# coalesce — only reduces, NO shuffle, faster
df.coalesce(2)
df.coalesce(1)                  # single file for CSV write

# RULE:
# Reduce partitions  → coalesce  (no shuffle, cheaper)
# Increase partitions → repartition (full shuffle)
# Before a join      → repartition(n, join_column)
# Write single CSV   → coalesce(1)
```

## 4.14 Write Output
```python
import os
os.makedirs("output", exist_ok=True)

# Write Parquet (standard for data lakes)
df.write.mode("overwrite").parquet("output/superstore_parquet")

# Write CSV — coalesce(1) for single file
df.coalesce(1) \
  .write.mode("overwrite") \
  .option("header", True) \
  .csv("output/superstore_csv")

# Read back — MUST specify header=True on read too
spark.read.parquet("output/superstore_parquet").show(5)
spark.read.option("header", True).csv("output/superstore_csv").show(5)

# Write modes
# "overwrite" — replace existing
# "append"    — add to existing
# "ignore"    — skip if exists
# "error"     — fail if exists (default)
```

---

# SECTION 5 — QUICK REFERENCE TABLES

## 5.1 Pandas vs PySpark Equivalents
| Operation | Pandas | PySpark |
|---|---|---|
| Read CSV | `pd.read_csv()` | `spark.read.csv()` |
| Filter rows | `df[df['col'] > x]` | `df.filter(col('col') > x)` |
| Select columns | `df[['a','b']]` | `df.select('a','b')` |
| Add column | `df['new'] = ...` | `df.withColumn('new', ...)` |
| GroupBy | `df.groupby().agg()` | `df.groupBy().agg()` |
| Apply function | `df.apply(fn, axis=1)` | `df.withColumn(udf(fn)(col))` |
| CASE WHEN | `np.where() / apply` | `when().otherwise()` |
| Join | `pd.merge()` | `df.join()` |
| Null check | `df.isnull()` | `col.isNull()` |
| Fill nulls | `df.fillna()` | `df.fillna()` |
| Drop nulls | `df.dropna()` | `df.dropna()` |
| Write CSV | `df.to_csv()` | `df.write.csv()` |
| Write Parquet | `df.to_parquet()` | `df.write.parquet()` |
| Row count | `len(df)` | `df.count()` |
| Schema | `df.dtypes` | `df.printSchema()` |

## 5.2 Join Types
| Type | Keeps |
|---|---|
| `inner` | Only matching rows from both |
| `left` | All left + matched right |
| `right` | All right + matched left |
| `outer` | All rows from both |
| `broadcast` | Optimized join — small table sent to all executors |

## 5.3 Window Function Patterns
| Pattern | Code |
|---|---|
| Rank within group | `rank().over(Window.partitionBy('col').orderBy('col'))` |
| Running total | `sum('col').over(Window.partitionBy('col').orderBy('col').rowsBetween(unboundedPreceding, currentRow))` |
| Partition average | `avg('col').over(Window.partitionBy('col'))` |

## 5.4 UDF vs Native Functions
| | Native (`when`, `col`) | Regular UDF | Pandas UDF |
|---|---|---|---|
| Speed | Fastest | Slowest | Fast |
| Runs in | JVM | Python | Python (Arrow batch) |
| Use when | Always prefer | Custom logic only | Custom logic, performance needed |
| Null safe | Yes | Must add `if x is None` | Handle in pandas |

## 5.5 Repartition vs Coalesce
| | `repartition` | `coalesce` |
|---|---|---|
| Direction | Increase or decrease | Decrease only |
| Shuffle | Yes (full) | No |
| Speed | Slower | Faster |
| Use for | Increasing partitions, join optimization | Reducing partitions, single file write |

---

# SECTION 6 — PIPELINE PATTERNS

## 6.1 v3 Pandas Pipeline Structure
```
config.py       → business rules, thresholds, logging
helpers.py      → product_score, discount_risk, profit_category, validate_records
validator.py    → DataValidator class (nulls, duplicates, column checks, clean/rejected split)
analyser.py     → DataAnalyser class (category_summary, region_summary, enrich, margin_vs_expected)
pipeline.py     → DataPipeline class (load, validate, run_analysis, generate_report, save_report)
main.py         → entry point
```

## 6.2 v5 PySpark Pipeline Structure (planned)
```
config.py           → paths, thresholds, business rules
schema.py           → StructType schema definitions
transformations.py  → UDFs, withColumn enrichment logic
analyser.py         → groupBy, window functions, broadcast joins
pipeline.py         → SparkSession, orchestrates everything
main.py             → entry point
```

## 6.3 Key Production Patterns
```python
# Always use os.makedirs before writing
os.makedirs("output", exist_ok=True)
os.makedirs("logs",   exist_ok=True)

# Always null-guard UDFs
def my_udf(x):
    if x is None: return "Unknown"
    # rest of logic

# Always specify header on BOTH read and write in Spark
df.write.option("header", True).csv("output/")
spark.read.option("header", True).csv("output/")

# Use coalesce(1) for single CSV file output
df.coalesce(1).write.mode("overwrite").option("header", True).csv("output/")

# Prefer native Spark functions over UDFs
# when() > regular UDF > pandas UDF (for custom logic)
```

---

# SECTION 7 — SQL

## 7.1 Basics
```sql
-- SELECT with filter and sort
SELECT Category, Sales, Profit
FROM superstore
WHERE Sales > 500
  AND Category = 'Furniture'
ORDER BY Sales DESC
LIMIT 10;

-- DISTINCT
SELECT DISTINCT Region FROM superstore;

-- Aliases
SELECT Category, SUM(Sales) AS total_sales
FROM superstore
GROUP BY Category;
```

## 7.2 Aggregations
```sql
-- GROUP BY with HAVING
SELECT
    Category,
    ROUND(SUM(Sales), 2)               AS total_sales,
    ROUND(SUM(Profit), 2)              AS total_profit,
    ROUND(AVG(Discount), 4)            AS avg_discount,
    COUNT(Order_ID)                    AS total_orders,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2) AS profit_margin_pct
FROM superstore
GROUP BY Category
HAVING SUM(Sales) > 500000
ORDER BY profit_margin_pct DESC;

-- WHERE vs HAVING
-- WHERE  → filters BEFORE aggregation (filters rows)
-- HAVING → filters AFTER aggregation (filters groups)
```

## 7.3 Joins
```sql
-- INNER JOIN
SELECT s.Category, s.Sales, t.expected_margin
FROM superstore s
INNER JOIN targets t ON s.Category = t.Category;

-- LEFT JOIN — all rows from left, nulls where no match
SELECT s.Category, s.Sales, t.expected_margin
FROM superstore s
LEFT JOIN targets t ON s.Category = t.Category;

-- SELF JOIN — joining a table to itself
SELECT a.Order_ID, a.Product_Name, b.Product_Name AS related
FROM superstore a
JOIN superstore b ON a.Order_ID = b.Order_ID
WHERE a.Product_Name != b.Product_Name;
```

## 7.4 Subqueries
```sql
-- Subquery in WHERE
SELECT Category, Sales
FROM superstore
WHERE Sales > (SELECT AVG(Sales) FROM superstore);

-- Subquery in FROM (inline view)
SELECT category_stats.Category, category_stats.avg_sales
FROM (
    SELECT Category, AVG(Sales) AS avg_sales
    FROM superstore
    GROUP BY Category
) AS category_stats
WHERE category_stats.avg_sales > 200;

-- Correlated subquery
SELECT s1.Category, s1.Sales
FROM superstore s1
WHERE s1.Sales > (
    SELECT AVG(s2.Sales)
    FROM superstore s2
    WHERE s2.Category = s1.Category  -- references outer query
);
```

## 7.5 CTEs (Common Table Expressions)
```sql
-- Basic CTE
WITH category_summary AS (
    SELECT
        Category,
        ROUND(SUM(Sales), 2)   AS total_sales,
        ROUND(SUM(Profit), 2)  AS total_profit,
        ROUND(SUM(Profit)/SUM(Sales)*100, 2) AS profit_margin_pct
    FROM superstore
    GROUP BY Category
),
targets AS (
    SELECT 'Furniture'       AS Category, 15.0 AS expected_margin
    UNION ALL
    SELECT 'Office Supplies' AS Category, 20.0 AS expected_margin
    UNION ALL
    SELECT 'Technology'      AS Category, 25.0 AS expected_margin
)
SELECT
    c.Category,
    c.profit_margin_pct,
    t.expected_margin,
    ROUND(c.profit_margin_pct - t.expected_margin, 2) AS GAP,
    CASE WHEN c.profit_margin_pct > t.expected_margin
         THEN 'Passed' ELSE 'Failed' END AS status
FROM category_summary c
LEFT JOIN targets t ON c.Category = t.Category;
```

## 7.6 Window Functions in SQL
```sql
-- ROW_NUMBER — unique rank, no ties
SELECT
    Category,
    Product_Name,
    Sales,
    ROW_NUMBER() OVER (PARTITION BY Category ORDER BY Sales DESC) AS row_num
FROM superstore;

-- RANK — ties get same rank, next rank skips (1,1,3)
SELECT
    Category,
    Sales,
    RANK() OVER (PARTITION BY Category ORDER BY Sales DESC) AS rnk
FROM superstore;

-- DENSE_RANK — ties get same rank, next rank does NOT skip (1,1,2)
SELECT
    Category,
    Sales,
    DENSE_RANK() OVER (PARTITION BY Category ORDER BY Sales DESC) AS dense_rnk
FROM superstore;

-- Top 3 products by profit per category
SELECT * FROM (
    SELECT
        Category,
        Product_Name,
        Profit,
        RANK() OVER (PARTITION BY Category ORDER BY Profit DESC) AS rnk
    FROM superstore
) ranked
WHERE rnk <= 3;

-- LAG — previous row value
SELECT
    Order_Date,
    Sales,
    LAG(Sales, 1) OVER (PARTITION BY Category ORDER BY Order_Date) AS prev_sales,
    Sales - LAG(Sales, 1) OVER (PARTITION BY Category ORDER BY Order_Date) AS sales_change
FROM superstore;

-- LEAD — next row value
SELECT
    Order_Date,
    Sales,
    LEAD(Sales, 1) OVER (PARTITION BY Category ORDER BY Order_Date) AS next_sales
FROM superstore;

-- Running total
SELECT
    Region,
    Order_Date,
    Sales,
    SUM(Sales) OVER (
        PARTITION BY Region
        ORDER BY Order_Date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM superstore;

-- Partition-level average (without collapsing rows)
SELECT
    Category,
    Sales,
    AVG(Sales) OVER (PARTITION BY Category) AS avg_category_sales
FROM superstore;
```

## 7.7 CASE WHEN
```sql
SELECT
    Category,
    Sales,
    Discount,
    CASE
        WHEN Discount >= 0.30 THEN 'High Risk'
        WHEN Discount >= 0.15 THEN 'Medium Risk'
        ELSE 'Safe'
    END AS Discount_Risk,
    CASE
        WHEN Sales > 1000 AND Profit > 200 THEN 'Star'
        WHEN Sales > 500  THEN 'Good'
        ELSE 'Low'
    END AS Performance
FROM superstore;
```

## 7.8 NULL Handling in SQL
```sql
-- Check for nulls
SELECT COUNT(*) FROM superstore WHERE Sales IS NULL;

-- COALESCE — return first non-null value
SELECT COALESCE(Sales, 0) AS sales FROM superstore;

-- NULLIF — return null if values are equal
SELECT NULLIF(Sales, 0) FROM superstore;  -- returns NULL if Sales = 0

-- IS NULL / IS NOT NULL
SELECT * FROM superstore WHERE Category IS NOT NULL;
```

## 7.9 String Functions
```sql
SELECT
    UPPER(Category)          AS upper_cat,
    LOWER(Category)          AS lower_cat,
    TRIM(Category)           AS trimmed,
    LENGTH(Product_Name)     AS name_length,
    SUBSTRING(Order_ID, 1,4) AS order_prefix,
    CONCAT(Category, ' - ', Region) AS cat_region
FROM superstore;
```

## 7.10 Date Functions
```sql
-- Common date operations (syntax varies by DB)
SELECT
    Order_Date,
    YEAR(Order_Date)  AS order_year,
    MONTH(Order_Date) AS order_month,
    DATEDIFF(Ship_Date, Order_Date) AS days_to_ship
FROM superstore;
```

---

# SECTION 8 — SPARK INTERNALS (Interview Critical)

## 8.1 Lazy Evaluation
```
Spark does NOT execute transformations immediately.
It builds a DAG (execution plan) and only runs when an ACTION is called.

Transformations (lazy) — build the plan:
  select(), filter(), groupBy(), withColumn(), join(), orderBy()

Actions (trigger execution):
  show(), count(), collect(), write(), take(), first()

WHY lazy evaluation?
→ Spark can optimize the full plan before running
→ Avoids unnecessary computation
→ Chains multiple transformations efficiently
```

```python
# Nothing runs here — just builds the plan
df_filtered = df.filter(col("Sales") > 500)
df_grouped  = df_filtered.groupBy("Category").agg(F.sum("Sales"))

# Execution happens HERE when action is called
df_grouped.show()   # ← triggers the full plan
```

## 8.2 DAG — Directed Acyclic Graph
```
DAG = Spark's execution plan — a graph of all transformations
      from source data to final output.

Stages → groups of transformations that can run without shuffling
Tasks  → individual units of work within a stage (one per partition)

Narrow transformation  → no shuffle needed (filter, select, withColumn)
                         data stays on same partition
Wide transformation    → shuffle required (groupBy, join, orderBy)
                         data moves across partitions — EXPENSIVE

Interview point:
"I minimize wide transformations where possible — groupBy and joins
cause shuffles which are the most expensive operations in Spark.
I use broadcast joins for small tables to avoid shuffles entirely."
```

## 8.3 Transformations vs Actions
```python
# TRANSFORMATIONS — lazy, return a new DataFrame
df.select()
df.filter()
df.withColumn()
df.groupBy()
df.join()
df.orderBy()
df.repartition()
df.coalesce()
df.dropna()
df.fillna()

# ACTIONS — trigger execution, return result
df.show()       # print to console
df.count()      # return row count
df.collect()    # return all rows as Python list — careful on large data
df.take(n)      # return first n rows as list
df.first()      # return first row
df.write        # write to storage
```

## 8.4 Shuffle & Partitions
```
Shuffle = moving data across the network between executors
        = most expensive operation in Spark

Caused by: groupBy, join, orderBy, repartition, distinct

How to minimize shuffle:
→ Use broadcast join for small tables
→ Repartition by join key BEFORE joining large tables
→ Avoid orderBy unless necessary
→ Use coalesce instead of repartition when reducing partitions

spark.sql.shuffle.partitions = 200 (default)
For small datasets, reduce this:
spark.conf.set("spark.sql.shuffle.partitions", "10")
```

## 8.5 Caching & Persistence
```python
# cache() — stores in memory (default)
df.cache()

# persist() — more control over storage level
from pyspark import StorageLevel
df.persist(StorageLevel.MEMORY_AND_DISK)  # memory first, spills to disk

# When to cache:
# → DataFrame used multiple times in the same pipeline
# → After expensive transformations (joins, groupBy)
# → Iterative algorithms

# Always unpersist when done
df.unpersist()

# Check if cached
print(df.is_cached)
```

## 8.6 Broadcast Join Internals
```
Regular join:   both DataFrames shuffled across network → expensive
Broadcast join: small table copied to every executor → no shuffle

When Spark auto-broadcasts:
→ Table smaller than spark.sql.autoBroadcastJoinThreshold (default 10MB)

Force broadcast manually:
from pyspark.sql.functions import broadcast
df.join(broadcast(small_df), on="key", how="left")

Rule of thumb: broadcast any table under 100MB
```

## 8.7 Spark UI — What to Look For
```
Access: http://localhost:4040 while Spark is running

Key tabs:
→ Jobs      — overall job status, duration
→ Stages    — which stages are slow, how many tasks
→ SQL       — visual DAG of your query plan
→ Storage   — what's cached and how much memory used
→ Executors — memory usage, GC time, failed tasks

Red flags to look for:
→ Stage taking much longer than others → data skew
→ High GC time → not enough memory, too many objects
→ Spill to disk → increase executor memory
→ Many failed tasks → OOM or data issues
→ One task taking 10x longer than others → skewed partition
```

---

# SECTION 9 — INTERVIEW Q&A

## 9.1 PySpark Interview Questions

**Q: What is lazy evaluation in Spark?**
A: Spark doesn't execute transformations immediately — it builds a DAG (execution plan) and only runs when an action like `show()`, `count()`, or `write()` is called. This allows Spark to optimize the full plan before execution.

**Q: What's the difference between transformation and action?**
A: Transformations (filter, select, groupBy, join) are lazy — they build the plan. Actions (show, count, collect, write) trigger actual execution.

**Q: What's the difference between repartition and coalesce?**
A: `repartition` can increase or decrease partitions and causes a full shuffle. `coalesce` only decreases partitions with no shuffle — it's faster for reducing. Use `coalesce` when reducing, `repartition` when increasing or redistributing by a key.

**Q: When would you use a UDF vs native Spark functions?**
A: Always prefer native Spark functions (when, col, F.sum etc.) — they run inside the JVM and are fully optimized. Use UDFs only when native functions can't express the logic. For UDFs, prefer Pandas UDFs over regular UDFs since they use Apache Arrow for batch processing and are significantly faster.

**Q: What is a broadcast join and when would you use it?**
A: A broadcast join copies a small DataFrame to every executor, avoiding a shuffle of the large DataFrame. Use it when one side of the join is small (under ~100MB). It's the most effective way to optimize join performance in Spark.

**Q: What causes a shuffle in Spark?**
A: Wide transformations — groupBy, join, orderBy, distinct, repartition. Shuffles move data across the network between executors and are the most expensive operations. Minimize them by using broadcast joins, pre-partitioning by join key, and avoiding unnecessary orderBy.

**Q: What is a DAG in Spark?**
A: Directed Acyclic Graph — Spark's execution plan. It represents all transformations from source to output as a graph of stages and tasks. Spark uses the DAG to optimize execution before running.

**Q: What's the difference between cache() and persist()?**
A: `cache()` stores the DataFrame in memory only. `persist()` gives more control — you can specify storage level (memory only, memory + disk, disk only). Use `cache()` for DataFrames used multiple times in the same pipeline.

**Q: Why define schema explicitly instead of using inferSchema?**
A: Three reasons — faster (no double file scan), deterministic (no type-inference surprises), and safer in production (avoids runtime failures from mis-inferred types like Sales being read as string).

**Q: What is data skew and how do you handle it?**
A: Data skew is when some partitions have significantly more data than others — causing one task to take much longer. Signs: one task takes 10x longer in Spark UI. Solutions: salting the join key, repartitioning by a more even key, or using broadcast join to avoid the skewed join entirely.

---

## 9.2 Python/OOP Interview Questions

**Q: What's the difference between @staticmethod and @classmethod?**
A: `@staticmethod` is a utility method that doesn't need access to the class or instance — no `self` or `cls`. `@classmethod` receives the class (`cls`) as the first argument — useful for factory methods or accessing/modifying class-level variables.

**Q: What is method chaining?**
A: Each method returns `self`, allowing multiple methods to be called in sequence: `pipeline.load().validate().enrich().save()`. Makes code more readable and fluent.

**Q: What's the difference between `__str__` and `__repr__`?**
A: `__str__` is for human-readable output — called by `print()`. `__repr__` is for developer/debugging output — called by `repr()` and in the REPL. `__repr__` should ideally return something that can recreate the object.

**Q: What is inheritance in OOP?**
A: A child class inherits attributes and methods from a parent class. Use `super().__init__()` to call the parent's constructor. The child can override or extend parent methods.

---

## 9.3 SQL Interview Questions

**Q: What's the difference between WHERE and HAVING?**
A: WHERE filters rows before aggregation. HAVING filters groups after aggregation. You can't use aggregate functions in WHERE.

**Q: What's the difference between RANK, DENSE_RANK, and ROW_NUMBER?**
A: ROW_NUMBER — always unique (1,2,3,4). RANK — ties get same rank, next rank skips (1,1,3). DENSE_RANK — ties get same rank, next rank does NOT skip (1,1,2).

**Q: What is a CTE and when would you use it?**
A: Common Table Expression — a named temporary result set defined with `WITH`. Use it to break complex queries into readable steps, avoid repeating subqueries, or build multi-step logic cleanly.

**Q: What's the difference between UNION and UNION ALL?**
A: UNION removes duplicates (slower). UNION ALL keeps all rows including duplicates (faster). Always use UNION ALL unless you specifically need deduplication.

**Q: What is a correlated subquery?**
A: A subquery that references a column from the outer query — runs once per row of the outer query. Usually slower than joins but sometimes the most readable way to express certain conditions.

---

*Last updated: June 2026 | github.com/surabhiks2k/superstore-data-platform*
