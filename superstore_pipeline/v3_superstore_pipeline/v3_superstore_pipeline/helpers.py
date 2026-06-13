from config import Score_rules , RULES
    
def product_scores(row):
    score = 0
    if row['Profit']>Score_rules['profit_threshold']:
        score= score+20
    if row['Sales']>Score_rules['sales_threshold']:
        score = score+30
    if row['Quantity']>Score_rules['quantity_threshold']:
        score = score+25
    if row['Discount']<Score_rules['discount_threshold']:
        score = score+25
    return score 

def profit_category(row):
    if row['Sales']==0: 
        return 'Unknown'
    margin = (row['Profit']/row['Sales']
        )*100
    
    if margin> 20 : 
        return 'High Profit'
            
    elif margin>=0 : 
        return 'Break Even'
            
    else: return 'Loss'
        
def discount_risk(x):
    if x >=0.30: return 'High Risk'
    elif x>=0.15: return 'Medium Risk'
    else: return 'Safe'

    
def validate_records(row):
    if row['Sales'] < RULES['min_sale']:
        raise ValueError(
            f"The Sale is negative {row['Sales']}" )
    if row['Quantity'] < RULES['min_quantity']:
        raise ValueError(f"The quantity is less than the minimum quantity {row['Quantity']}") 
    if row['Discount'] > RULES['max_discount']:
        raise ValueError(f"The discoun has exceeded {row['Discount']}")       
    return True
    