SELECT
    SUM(f.revenue) as revenue,
    (ARRAY_AGG(m.title) FILTER (WHERE m.title IS NOT NULL))[1] AS title
FROM
    {{ ref('fct_revenues') }} AS f
LEFT JOIN {{ ref('dim_movies') }} AS m ON f.movie_key = m.movie_key
GROUP BY
    f.movie_key
ORDER BY
    revenue DESC;