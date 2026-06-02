import pandas as pd
import json
import logging
from datetime import datetime
import os

logging.basicConfig(
    level  = logging.INFO,
    format = '%(asctime)s - %(levelname)s - %(message)s'
)

# ── helper functions ──────────────────────────────────────────

def product_score(row):
    score = 0
    if row['Sales']    > 1000: score += 30
    if row['Quantity'] > 5:    score += 20
    if row['Discount'] < 0.15: score += 25
    if row['Profit']   > 200:  score += 25
    return score

def discount_risk(x):
    if x > 0.30:    return 'High Risk'
    elif x >= 0.15: return 'Medium Risk'
    else:           return 'Safe'

def profit_category(row):
    if row['Sales'] == 0: return 'Unknown'
    margin = (row['Profit'] / row['Sales']) * 100
    if margin > 20:   return 'High Profit'
    elif margin >= 0: return 'Acceptable'
    else:             return 'Loss'


# ── base class ────────────────────────────────────────────────

class Pipeline:
    """Base class — common attributes and methods
       shared across all pipeline types"""

    pipeline_count = 0             # class variable — shared

    def __init__(self, file_path):
        self.file_path = file_path  # instance variable — unique
        self.df        = None
        Pipeline.pipeline_count += 1

    def load_file(self):
        self.df = pd.read_csv(
            self.file_path, encoding='latin1'
        )
        logging.info(f"Loaded {len(self.df):,} rows")
        return self

    def shape(self):
        return self.df.shape

    def info(self):
        print(f"File             : {self.file_path}")
        print(f"Pipelines created: {Pipeline.pipeline_count}")

    def __str__(self):
        rows = len(self.df) if self.df is not None else 0
        return (f"Pipeline | "
                f"file: {self.file_path} | "
                f"rows: {rows:,}")

    def __repr__(self):
        return f"Pipeline(file_path='{self.file_path}')"


# ── child class ───────────────────────────────────────────────

class DataPipeline(Pipeline):
    """Child class — inherits from Pipeline
       adds DQ validation, enrichment and reporting"""

    def __init__(self, file_path):
        super().__init__(file_path)  # call parent __init__
        self.report = {}

    # @staticmethod — utility, no self or cls needed
    @staticmethod
    def is_valid_file(file_path):
        """Check file is CSV before loading"""
        return file_path.endswith('.csv')

    @staticmethod
    def clean_column_names(df):
        """Remove leading/trailing spaces from column names"""
        df.columns = df.columns.str.strip()
        return df

    # @classmethod — access class variable
    @classmethod
    def get_pipeline_count(cls):
        """Return total pipelines created"""
        return cls.pipeline_count

    @classmethod
    def reset_count(cls):
        """Reset pipeline counter to zero"""
        cls.pipeline_count = 0      # assign first
        return cls.pipeline_count   # then return

    def validation(self):
        required = ['Sales', 'Discount', 'Profit', 'Quantity']
        missing  = [col for col in required
                    if col not in self.df.columns]
        if missing:
            raise ValueError(f"Missing columns: {missing}")
        logging.info("All required columns present")
        return self

    def enrich(self):
        self.df['Profit_Category'] = self.df.apply(
            profit_category, axis=1)
        self.df['Product_Score']   = self.df.apply(
            product_score, axis=1)
        self.df['Discount_Risk']   = self.df['Discount'].apply(
            discount_risk)
        logging.info("Enrichment complete")
        return self

    def generate_report(self):
        self.report = {
            'total_records': len(self.df),
            'null_count'   : self.df.isnull().sum().to_dict(),
            'duplicate'    : int(self.df.duplicated().sum())
        }
        logging.info("Report generated")
        return self

    def save_report(self):
        os.makedirs('output', exist_ok=True)
        today    = datetime.now().strftime('%Y-%m-%d')
        filename = f"output/report_{today}.json"
        with open(filename, 'w') as f:
            json.dump(self.report, f, indent=4)
        logging.info(f"Report saved: {filename}")
        return self

    def run(self):
        logging.info(f"Pipeline started: {self.file_path}")
        try:
            return (self
                    .load_file()
                    .validation()
                    .enrich()
                    .generate_report()
                    .save_report())
        except Exception as e:
            logging.error(f"Pipeline failed: {e}")
            return None


# ── run and demonstrate the OOP concepts ─────────────────────

# Basic usage
pipeline1 = DataPipeline("data/Sample - Superstore.csv")
pipeline1.run()

# Instance methods
print(pipeline1.report)           # DQ report dict
print(pipeline1.shape())          # (9994, 21+)
print(pipeline1.info())           # file + count

# __str__ and __repr__
print(pipeline1)                  #  readable
print(repr(pipeline1))            # developer repr

# staticmethod — no object needed
print(DataPipeline.is_valid_file("file.csv"))    # True
print(DataPipeline.is_valid_file("file.xlsx"))   # False

# clean column names — pass df
pipeline1.df = DataPipeline.clean_column_names(pipeline1.df)

# classmethod — track pipeline count
print(DataPipeline.get_pipeline_count())  # 1

# Create second pipeline — count goes up
pipeline2 = DataPipeline("data/Sample - Superstore.csv")
print(DataPipeline.get_pipeline_count())  # 2

# Prove class vs instance variable
print(pipeline1.file_path)        # data/Sample - Superstore.csv
print(pipeline2.file_path)        # data/Sample - Superstore.csv
print(DataPipeline.pipeline_count) # 2 — shared

# Reset count
DataPipeline.reset_count()
print(DataPipeline.get_pipeline_count())  # 0
