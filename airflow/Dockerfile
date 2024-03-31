FROM apache/airflow:latest-python3.11    

USER root

RUN apt-get update && \
    apt-get -y install git && \
    apt-get clean

USER airflow

RUN pip install 'apache-airflow[google]'

COPY <service_account_filepath> /tmp/<service_account_filename>.json
COPY requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt
