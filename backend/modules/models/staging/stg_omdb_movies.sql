WITH movies AS (
    SELECT
        title,
        year,
        rated,
        CASE WHEN released = 'N/A' THEN null ELSE cast(released AS date) END AS released,
        runtime,
        string_to_array(genre, ', ') AS genres,
        string_to_array(director, ', ') AS directors,
        string_to_array(writer, ', ') AS writers,
        string_to_array(actors, ', ') AS actors,
        plot,
        string_to_array(language, ', ') AS languages,
        string_to_array(country, ', ') AS countries,
        awards,
        poster,
        metascore,
        imdbrating,
        imdbvotes,
        imdbid,
        type,
        dvd,
        boxoffice,
        production,
        website
    FROM {{ source('omdb', 'omdb_movies') }}
)

SELECT * FROM movies