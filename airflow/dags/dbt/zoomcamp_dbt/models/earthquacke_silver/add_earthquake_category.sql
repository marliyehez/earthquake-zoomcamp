{{ config(materialized='ephemeral') }}

WITH add_earthquake_category AS (
    SELECT 
        *,
        CASE 
            WHEN magnitude < 3 THEN 'Micro'
            WHEN magnitude < 4 THEN 'Minor'
            WHEN magnitude < 5 THEN 'Light'
            WHEN magnitude < 6 THEN 'Moderate'
            WHEN magnitude < 7 THEN 'Strong'
            WHEN magnitude < 8 THEN 'Major'
            ELSE 'Great'
        END AS earthquake_category
    FROM
        {{ ref('convert_hour_to_day_period') }}
)

SELECT *
FROM add_earthquake_category