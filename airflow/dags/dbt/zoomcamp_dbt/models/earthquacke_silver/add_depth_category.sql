{{ config(materialized='ephemeral') }}

WITH add_depth_category AS (
    SELECT
        *,
        CASE
            WHEN depth < 71 THEN 'Shallow'
            WHEN depth < 301 THEN 'Intermediate'
            ELSE 'Deep'
        END AS depth_category
    FROM
        {{ ref('add_earthquake_category') }}
)

SELECT *
FROM add_depth_category