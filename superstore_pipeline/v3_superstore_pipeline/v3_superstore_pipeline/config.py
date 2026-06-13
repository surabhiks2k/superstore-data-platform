import os
import logging

input_path = 'Data/Sample_Superstore.csv'
output_path = 'output'

REQUIRED_COLUMNS = [
    'Sales', 'Profit', 'Discount',
    'Quantity', 'Category', 'Sub-Category',
    'Region', 'Customer Name', 'Order ID',
    'Product Name', 'Order Date'
]

RULES = { 'min_sale' :0 , 
          'max_discount' : 1.0,
          'min_quantity' : 1,
          'high_discount':0.30,
          'medium_discount':0.15
        }

expected_margin = { 'Furniture' : 15.0,
                    'Office Supplies' : 20.0,
                    'Technology' : 25.0
    
}

Score_rules = {
    'sales_threshold':1000,
    'quantity_threshold':5,
    'discount_threshold':0.15,
    'profit_threshold':200
}


LOG_FORMAT = '%(asctime)s - %(levelname)s - %(message)s'
LOG_LEVEL  = 'INFO'
os.makedirs('logs', exist_ok=True)
logging.basicConfig(
    filename='logs/pipeline.log',
    level=logging.INFO,
    format=LOG_FORMAT
)