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
