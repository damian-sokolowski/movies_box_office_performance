WITH stg_movie_revenues AS (
    SELECT * FROM {{ ref('stg_movie_revenues') }}
    WHERE title IS NOT NULL
),
stg_omdb_movies AS (
    SELECT * FROM {{ ref('stg_omdb_movies') }}
)
SELECT
    {{ dbt_utils.generate_surrogate_key(['r.title', 'o.released']) }} AS movie_key,
    {{ dbt_utils.generate_surrogate_key(['r.date']) }} AS date_key,
    r.revenue,
    r.theaters,
    r.distributor
FROM stg_movie_revenues AS r
LEFT JOIN stg_omdb_movies AS o ON r.title = o.title