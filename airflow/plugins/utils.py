import pandas as pd

def read_csv_from_google_drive(url):    
    # Modified link pointing directly to the CSV file, allowing successful reading
    url = 'https://drive.google.com/uc?id=' + url.split('/')[-2] 

    # Read CSV using pandas
    df = pd.read_csv(url)
    return df
