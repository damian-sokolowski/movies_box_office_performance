{{
  config(
    materialized = 'incremental',
    unique_key = 'date_key'
  )
}}

WITH stg_movies AS (
    SELECT DISTINCT date FROM {{ ref('stg_movie_revenues') }}
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['date']) }} AS date_key,
    date,
    EXTRACT('year' FROM date) AS year,
    {{ dbt_date.date_part("year", "date") }} AS year2,
    {{ dbt_date.date_part("quarter", "date") }} AS quarter2,
    {{ dbt_date.date_part("week", "date") }} AS week2,
    EXTRACT('quarter' FROM date) AS quarter,
    {{ dbt_date.date_part("month", "date") }} AS month,
    EXTRACT('week' FROM date) AS week,
    {{ dbt_date.day_name("date") }} AS dow
FROM stg_movies
