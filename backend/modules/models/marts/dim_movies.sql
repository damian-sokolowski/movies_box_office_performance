WITH stg_movie_revenues AS (
    SELECT DISTINCT ON (title)
        title,
        distributor
    FROM {{ ref('stg_movie_revenues') }}
    WHERE title IS NOT NULL
),
stg_omdb_movies AS (
    SELECT * FROM {{ ref('stg_omdb_movies') }}
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['r.title', 'o.released']) }} AS movie_key,
    r.title,
    r.distributor,
    o.year,
    o.rated,
    o.released AS release,
    o.runtime,
    o.genres,
    o.directors,
    o.writers,
    o.actors,
    o.plot,
    o.type,
    o.boxoffice
FROM stg_movie_revenues AS r
LEFT JOIN stg_omdb_movies AS o ON r.title = o.title