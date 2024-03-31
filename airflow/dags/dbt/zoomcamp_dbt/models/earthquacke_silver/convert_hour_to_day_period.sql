{{ config(materialized='ephemeral') }}

WITH convert_hour_to_day_period AS (
    SELECT
        date,
        time,
        coordinat,
        depth,
        magnitude,
        CASE
            WHEN hour < 3 THEN 'Night'
            WHEN hour < 6 THEN 'Dawn'
            WHEN hour < 12 THEN 'Morning'
            WHEN hour < 18 THEN 'Afternoon'
            ELSE 'Evening'
        END AS day_period
    FROM
        {{ ref('add_hour_for_temp') }}
)

SELECT *
FROM convert_hour_to_day_period