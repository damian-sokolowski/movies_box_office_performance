WITH movies AS (
    SELECT
        id,
        CASE WHEN date = 'N/A' THEN null ELSE cast(date AS date) END AS date,
        title,
        revenue,
        theaters,
        distributor
    FROM {{ source('movies_with_revenues', 'movies_with_revenues') }}
)

SELECT * FROM movies