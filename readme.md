# Analyzing Indonesia's Earthquake Data - *A Data Engineering Project*

## ⛰️ Background
Indonesia is known to be one of the most seismically active countries in the world due to its location on the Pacific Ring of Fire. Earthquakes, ranging from minor to catastrophic, occur frequently across the archipelago. Understanding the patterns, trends, and impacts of these earthquakes is crucial for disaster preparedness, mitigation, and response efforts.

## 🚩 Problem Statement
The objective of this project is to analyze earthquake data in Indonesia to gain insights into various aspects of seismic events. The analysis will focus on the following key areas:

1. **Geographical Distribution Analysis:** Explore the spatial distribution of earthquake disasters, considering filters such as time, magnitude, and depth, to identify high-risk areas and assess temporal trends in seismic activity.

2. **Categorical Data Distribution Analysis:** Investigate categorical characteristics of earthquakes, including earthquake categories based on magnitude, depth categories, and day periods, to understand the frequency and distribution of seismic events across different categories.

3. **Depth vs Magnitude Analysis:** Explore the relationship between earthquake depth and magnitude, identify trends and patterns over time, particularly focusing on how average magnitude varies with depth categories.

## 📑 Data Sources
The data for this analysis is sourced from Kaggle, accessible through the following link: [Indonesia Earthquake Data](https://www.kaggle.com/datasets/greegtitan/indonesia-earthquake-data).

The dataset belongs to the Badan Meteorologi, Klimatologi, dan Geofisika (BMKG) Indonesia, which translates to the Meteorology, Climatology, and Geophysical Agency in English. The original data is available on the BMKG's official website at [dataonline.bmkg.go.id/data_gempa_bumi](dataonline.bmkg.go.id/data_gempa_bumi).

**Temporal Coverage:**
- **Start Date:** November 1, 2008
- **End Date:** September 29, 2022

**Geospatial Coverage:** Indonesia

The dataset includes the following columns:
- **Date and Time:** Timestamp of the earthquake event
- **Latitude and Longitude:** Geolocation coordinates of the earthquake
- **Depth:** Depth of the earthquake hypocenter in kilometers
- **Magnitude:** Measurement of the earthquake's strength on the Richter scale

Sample of the first 5 rows:

| date       | time     | latitude | longitude | depth | magnitude |
|------------|----------|----------|-----------|-------|-----------|
| 2008-11-01 | 00:31:25 | -0.6     | 98.89553  | 20.0  | 2.99      |
| 2008-11-01 | 01:34:29 | -6.61    | 129.38722 | 30.1  | 5.51      |
| 2008-11-01 | 01:38:14 | -3.65    | 127.99068 | 5.0   | 3.54      |
| 2008-11-01 | 02:20:05 | -4.2     | 128.097   | 5.0   | 2.42      |
| 2008-11-01 | 02:32:18 | -4.09    | 128.20047 | 10.0  | 2.41      |

This CSV dataset has been uploaded to Google Drive, and the data source for this project will be sourced from there for extraction.


## 🛠️ Infrastructure
- **Cloud**: Google Cloud Platform
- **Infrastructure as Code (IaC)**: Terraform
- **Containerization**: Docker, Docker Compose
- **Batch Processing**: Python
- **Orchestration**: Airflow
- **Transformation**: dbt
- **Data Lake**: Google Cloud Storage (GCS)
- **Data Warehouse**: BigQuery
- **Data Visualization**: Looker Studio

<p align="center">
  <img src="img/infra-techs.png" width="600">
<p>


Airflow DAG View:
<p align="center">
  <img src="img/earthquake-dag.png" width="600">
<p>

dbt Lineage View:
<p align="center">
  <img src="img/dbt-lineage-graph.png" width="600">
<p>

#### Clustering and Partitioning in the Data Warehouse
```sql
# earthquake_partitioned.sql
{{ config(
    materialized = 'table',
    partition_by = {
        'field': 'date',
        'data_type': 'date',
        'granularity': 'year'
    },
    cluster_by = [
        'earthquake_category',
        'depth_category',
        'day_period'
    ]
)}}

SELECT *
FROM {{ ref('add_depth_category') }}
```
- Why Use `Year` for Partitioning?

  Partitioning the table by year based on the `date` column allows for efficient data retrieval when filtering by quarter year. This choice optimizes query performance by restricting the scan to only relevant partitions, reducing the amount of data that needs to be processed.

- Why Use `earthquake_category`, `depth_category`, and `day_period` for Clustering?

  Clustering the table based on the `earthquake_category`, `depth_category`, and `day_period` columns is advantageous because these columns are likely to be frequently used for aggregation operations. By clustering the data based on these columns, similar values within each cluster are physically stored together on disk. This arrangement can significantly improve the performance of aggregation queries, as the related data is co-located and can be efficiently accessed without the need for extensive data shuffling. Additionally, clustering on these columns can enhance the efficiency of certain types of joins and filtering operations that involve these attributes.


## 📊 Dashboard
Here is the link to the [dashboard](https://lookerstudio.google.com/reporting/38993308-4ed8-4351-9fb4-8379103a9db9).
<p align="center">
  <img src="img/page1.png" width="600">
<p>
<p align="center">
  <img src="img/page2.png" width="600">
<p>
<p align="center">
  <img src="img/page3.png" width="600">
<p>


## ♾️ How to reproduce this project?
### Create SSH Keys and Connecting [[source](https://cloud.google.com/compute/docs/connect/create-ssh-keys)]

```bash
# Creating an SSH file (just fill in the filename and username). Do this on your local computer (Gitbash)
cd ~/.ssh
ssh-keygen -t rsa -f ~/.ssh/gcp-capstone -C marli -b 2048
# After that, go to Compute Engine >> Settings >> Metadata, and enter your public key there.

# Connecting to the server (using a shortcut is, of course, more convenient)
ssh -i ~/.ssh/gcp marli@<external IP>
```


### Create a VM on GCP 
Create a VM on GCP with the following recommended VM Spec modifications (leave the rest as default)
- Machine type: `e2-standard-4 (4 vCPU, 16 GB Memory)`
- Boot Disk OS version: `Ubuntu 20.04 LTS`
- Boot Disk size: `30 GB`


### Upload a Service Account File via SFTP
```bash
# Use the SFTP command to connect to your server
sftp username@your_server_ip_or_hostname

# Create a directory for the Google Cloud service account file if it doesn't exist
mkdir -p .gc

# Navigate to the directory
cd .gc

# Upload your service account file
put <your-service-account.json>

# Rename the uploaded file
rename <your-service-account.json> service_account.json
```

### Docker, Docker Compose, and Terraform Installation
Please refer to [installation.md](installation.md) for detailed steps on how to install Docker, Docker Compose, and Terraform. After installation, use the following commands to verify that everything has been installed successfully:

```bash
gcloud --version
docker ps
docker run hello-world
which docker-compose
docker-compose version
terraform -version
```

This set of commands will check the versions and running status of the installed software, ensuring all components are correctly set up.


### Set up Terraform and Airflow
`git clone` this project.

#### Terraform
Terraform Setup:
```bash
cd earthquake-zoomcamp/terraform
nano `variables.tf` # update names
terraform init
terraform fmt
terraform apply
```

#### Airflow
1. Rename the environment file and configure variables:
```bash
cd earthquake-zoomcamp/airflow
mv .env.example .env
nano .env
```

2. Start Airflow:
```bash
export AIRFLOW_UID=1000 # If Airflow warns about needing definition
sudo chmod -R 777 <airflow_folder_path> # If Airflow has permissions to folder problem

docker-compose up airflow-init
docker-compose up -d 
```
- Login using **admin=*airflow*** and **passsword=*airflow***.
- Configuring Connection **Admin > Connections**. Then, trigger the dag.

Configuring GCP Connection at **Admin > Connections**:
<p align="center">
  <img src="img/gcp-connection-config.png" width="600">
<p>

DAGs View:
<p align="center">
  <img src="img/dags-view.png" width="600">
<p>


#### dbt
1. Navigate to **airflow/dags/dbt/zoomcamp_dbt/profiles.yml**. 
    - Update your BigQuery dataset name and GCP project name.

2. Navigate to **airflow/dags/dbt/zoomcamp_dbt/models/earthquacke_silver/src_zoomcamp.yml**.
    - Update your BigQuery dataset name.

❗ Use `sudo nano` or adjust permissions if there are issues with saving changes. ❗


## 💐 Special Mention
I express my gratitude to [DataTalks.Club](https://datatalks.club) for providing this Data Engineering course at no cost 🙏. For those interested in enhancing their skills in Data Engineering technologies, I recommend exploring their self-paced [course](https://github.com/DataTalksClub/data-engineering-zoomcamp). 😁👌
