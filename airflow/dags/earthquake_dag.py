from airflow import DAG
from airflow.decorators import task
from airflow.operators.bash_operator import BashOperator
from airflow.providers.google.cloud.transfers.gcs_to_bigquery import GCSToBigQueryOperator
import gcsfs

from datetime import datetime
import os

from utils import read_csv_from_google_drive


# Google Drive preview page URL
url = 'https://drive.google.com/file/d/1Cp2sG0T7r5F-iwmJfjfioPhBB2UMSe7W/view?usp=drive_url' 

# For GCS and Bigquery
BUCKET_NAME = 'Your Bucket Name'
DATASET_NAME = 'Your Dataset Name'
TABLE_NAME = 'external_earthquake'
schema_fields = [
    {"name": "date", "type": "DATE"},
    {"name": "time", "type": "TIME"},
    {"name": "latitude", "type": "FLOAT"},
    {"name": "longitude", "type": "FLOAT"},
    {"name": "depth", "type": "FLOAT"},
    {"name": "magnitude", "type": "FLOAT"}
]

# For dbt
CURRENT_DIR = os.getcwd()
DBT_DIR = CURRENT_DIR + '/dags/dbt/zoomcamp_dbt'


with DAG(
    'earthquake_dag.py',
    start_date=datetime(2024, 3, 11),
    schedule='@once',
    catchup=False
) as dag:

    @task()
    def get_data_and_load_pq_to_gcs():
        df = read_csv_from_google_drive(url)

        # Set GCS File System
        service_account_key_file = '/tmp/<service-account-filename>'
        fs = gcsfs.GCSFileSystem(token=service_account_key_file)

        # Write data
        destination = f'gs://{BUCKET_NAME}/earthquake.parquet'
        with fs.open(destination, mode='wb') as f:
            df.to_parquet(f)

        # Log
        print('Parquet data has been loaded to GCS.')


    GCS_to_BQ = GCSToBigQueryOperator(
        task_id="gcs_to_bigquery",
        bucket=BUCKET_NAME,
        source_objects=['earthquake.parquet'],
        source_format='PARQUET',
        destination_project_dataset_table=f"{DATASET_NAME}.{TABLE_NAME}",
        write_disposition="WRITE_TRUNCATE",
        external_table=True,
        schema_fields=schema_fields,
        gcp_conn_id='google_cloud_default'
    )

    
    dbt_build = BashOperator(
        task_id="dbt_build",
        bash_command=f"cd {DBT_DIR} && dbt build --profiles-dir . --models earthquacke_silver",
        dag=dag
    )

    get_data_and_load_pq_to_gcs() >> GCS_to_BQ >> dbt_build
