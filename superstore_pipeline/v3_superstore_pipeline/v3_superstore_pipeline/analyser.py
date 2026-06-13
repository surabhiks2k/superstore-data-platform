import pandas as pd
import logging

from config import expected_margin
from helpers import (
    product_scores,
    discount_risk,
    profit_category
)

class DataAnalyser:

    def __init__(self,df):
        self.df=df.copy()
        self.summary = {}
        

    def category_summary(self):
        self.summary['category'] = self.df.groupby('Category').agg(
        total_sales = ('Sales', 'sum'),
        total_profit = ('Profit', 'sum'),
        total_discount = ('Discount', 'sum'),
        total_quantity= ('Quantity', 'sum'),
        total_order= ('Order ID', 'count'),
        avg_discount = ('Discount', 'mean')).reset_index()
        self.summary['category']['Profit_Margin_perc']= self.summary['category']['total_profit']/self.summary['category']['total_sales'] *100
        self.summary['category']['Risk_Flag'] = self.summary['category']['avg_discount'].apply(lambda x :'High Risk' if x >0.35 else 'Medium Risk' if x>0 else'Safe') 
        return self

    
    def region_summary(self):
       
        self.summary['region'] = self.df.groupby('Region').agg(
        total_sales=('Sales', 'sum'),
        total_profit=('Profit', 'sum'),
        total_orders=('Order ID', 'count'),
        total_discount=('Discount', 'sum'),
        avg_sales=('Sales', 'mean'))
        return self
        
        
        
    def enrich(self):
        
        self.df['Product_score'] =self.df.apply(product_scores , axis=1)
        self.df['Discount_risk']=self.df['Discount'].apply(discount_risk)
        self.df['Profit_Category']=self.df.apply(profit_category , axis=1)
        logging.info("All the 3 columns i.e, profit categorry , product_score, discount_risk added")
        return self   


    def margin_vs_expected(self):
        expected = pd.DataFrame({
            'expected_margin_perc': list(expected_margin.values()),
                           'Category':list(expected_margin.keys())
        })
        self.summary['margin_check']=pd.merge(
            self.summary['category'][['Category' , 'Profit_Margin_perc']],   expected , on='Category' , how ='left')
        self.summary['margin_check']['GAP']= self.summary['margin_check']['Profit_Margin_perc'] - self.summary['margin_check']['expected_margin_perc']
        self.summary['margin_check']['status']= (self.summary['margin_check']['GAP'].apply(lambda x: 'passed' if x>0 else 'Failed'))
        return self

    