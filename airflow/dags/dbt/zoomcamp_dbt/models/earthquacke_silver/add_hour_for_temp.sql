{{ config(materialized='ephemeral') }}

WITH add_hour_for_temp AS (
    SELECT
        *,
        EXTRACT(HOUR FROM time) AS hour,
    FROM
        {{ ref('concat_latitude_longitude') }}
)


SELECT *
FROM add_hour_for_temp