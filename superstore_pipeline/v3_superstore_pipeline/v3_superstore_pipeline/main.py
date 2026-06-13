import logging
from config import input_path
from pipeline import DataPipeline
if __name__ == "__main__":
     pipeline = DataPipeline(input_path)
     logging.info("the pipeline has strated")
     pipeline.run()
     print(pipeline)
    
    
    
        