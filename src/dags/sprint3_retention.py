import time
import requests
import json
import pandas as pd

from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.python_operator import PythonOperator, BranchPythonOperator
from airflow.providers.postgres.operators.postgres import PostgresOperator
from airflow.providers.postgres.hooks.postgres import PostgresHook
from airflow.hooks.http_hook import HttpHook

http_conn_id = HttpHook.get_connection('http_conn_id')
api_key = http_conn_id.extra_dejson.get('api_key')
base_url = http_conn_id.host

postgres_conn_id = 'postgresql_de'

args = {
    "owner": "student",
    'email': ['student@example.com'],
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 0
}

business_dt = '{{ ds }}'

with DAG(
        dag_id='customer_retention_mart',
        default_args=args,
        schedule_interval='0 0 * * 1',
        description='Provide second dag for sprint3',
        catchup=False,
        start_date=datetime.today() - timedelta(days=7)
) as update_retention_dag:
    
    delete_f_retention = PostgresOperator(
    task_id='delete_f_retention',
    postgres_conn_id=postgres_conn_id,
    sql="sql/mart.f_customer_retention_delete.sql",
    parameters={"date": {business_dt}}
    )

    update_f_retention = PostgresOperator(
    task_id='update_f_retention',
    postgres_conn_id=postgres_conn_id,
    sql="sql/mart.f_customer_retention.sql",
    parameters={"date": {business_dt}}
    )

    (
        delete_f_retention
        >> update_f_retention
    )