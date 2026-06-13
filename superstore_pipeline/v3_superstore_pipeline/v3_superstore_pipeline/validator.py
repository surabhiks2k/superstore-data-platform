import pandas as pd
import logging

from config import REQUIRED_COLUMNS
from helpers import validate_records

class DataValidator:

    def __init__(self,df):
        self.df=df
    
    def check_column_space_issue(self):
        self.df.columns=self.df.columns.str.strip()
        return self
    
    def check_nulls(self):
        self.null_counts=self.df.isnull().sum()
        logging.info(f"Nulls:{int(self.null_counts.sum())}")
        return self

    def check_duplicates(self):
        self.duplicated_count=int(self.df.duplicated().sum())
        logging.info(f"The duplicated count{self.duplicated_count}")
        return self
    
    def check_column_names(self):
        missing = [col for col in REQUIRED_COLUMNS if col not in self.df.columns]
        if missing :
            raise ValueError(f"The key was not found {missing}")
        logging.info("All the records were loaded")
        return self 
        
    @staticmethod
    def file_extension_check(filepath):
        return filepath.endswith(".csv")
        

    def clean_rejected_records_check(self):
        clean= []
        rejected=[]
        for _ , row in self.df.iterrows():
            try: 
                validate_records(row)
                clean.append(row)
            except Exception as e: 
                rejected.append({"record": row.to_dict() , "message":str(e)})
                logging.error(f"Rejected:{e}")
            self.rejected= rejected
            logging.info(f"rejected:{len(rejected):,} | clean:{len(clean):,}")
            self.clean=pd.DataFrame(clean)
        return self
                
    