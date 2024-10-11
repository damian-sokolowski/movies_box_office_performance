SELECT
    f.revenue,
    f.distributor,
    d.date,
    m.title
FROM
    {{ ref('fct_revenues') }} AS f
JOIN {{ ref('dim_date') }} AS d ON f.date_key = d.date_key
JOIN {{ ref('dim_movies') }} AS m ON f.movie_key = m.movie_key;