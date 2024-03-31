{{ config(materialized='ephemeral') }}

WITH concat_latitude_longitude AS (
    SELECT 
        *,
        CONCAT(latitude, ',', longitude) AS coordinat
    FROM
        {{ source('silver', 'gcs_external') }}
)

SELECT *
FROM concat_latitude_longitude