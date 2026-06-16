import os
from datetime import datetime
import logging 
from config import input_path
import pandas as pd
import json
import logging
from validator import DataValidator
from analyser import DataAnalyser

class DataPipeline:
    def __init__(self , filepath):
        self.filepath=filepath
        self.df = None
    
    @staticmethod
    def is_file_valid(filepath):
        return DataValidator.file_extension_check(filepath)
        

    def load(self):
        try:
            if not self.is_file_valid(self.filepath):
                raise ValueError ("Invalid file Path")
            self.df=pd.read_csv(self.filepath , encoding ='latin1')
            validator = DataValidator(self.df)
            validator.check_column_space_issue()
            self.df=validator.df
            logging.info(f"loaded file of records {self.df.shape} , rows :{len(self.df)} ,columns {len(self.df.columns)}")

        except FileNotFoundError:
            logging.error(f"File was not found {self.filepath}")

        return self 
    
    def validate(self):
        self.validator = DataValidator(self.df)
        (self.validator.check_column_space_issue()
        .check_nulls()
        .check_duplicates()
        .check_column_names()
        .clean_rejected_records_check())
        return self
        
    def run_analysis(self):
        self.analyse = DataAnalyser(self.validator.clean)
        (self.analyse.category_summary()
         .region_summary()
         .enrich()
         .margin_vs_expected())
        return self
        
    

    def generate_report(self):
        self.report = {
            'total_records':len(self.df),
            'duplicate_records':self.validator.duplicated_count,
            'null values': self.validator.df.isnull().sum().to_dict(),
            'category_summary_profit_margin_perc' : dict(zip(
                self.analyse.summary['category']['Category'],
                self.analyse.summary['category']['Profit_Margin_perc'])),
            'Expcted_vs_Actual_merged_GAP': dict(zip(
                self.analyse.summary['margin_check']['Category'],
                self.analyse.summary['margin_check']['GAP'])),
            'Expcted_vs_Actual_merged_status': dict(zip(
                self.analyse.summary['margin_check']['Category'],
                self.analyse.summary['margin_check']['status'])),
            'clean_record':len(self.validator.clean),
            'Rejected_record': len(self.validator.rejected)}
        return self
        
    def save_report(self):
        os.makedirs("output", exist_ok=True)
        today = datetime.now().strftime('%Y-%m-%d')
        filename = f"output/report_{today}.json"
        with open(filename , "w") as f:
            json.dump(self.report , f , indent=4)
        self.validator.clean.to_csv("output/clean_record.csv" , index=False)
        if self.validator.rejected:
            pd.DataFrame(
                [r['record'] 
                 for r in self.validator.rejected]
            ).to_csv(
                "output/rejected_records.csv" ,
                index=False)
        return self 

    def run(self):
        logging.info("started the pipeline execution")
        try:
            return self.load().validate().run_analysis().generate_report().save_report()
        except Exception as e:
            logging.error(f"execution has failed due to {e}")

    
            
        
    