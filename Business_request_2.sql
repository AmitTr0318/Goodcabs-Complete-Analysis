WITH target_trips AS (
    SELECT 
        dim_city.city_name,
        MONTHNAME(targets_db.monthly_target_trips.month) AS month_name,
        SUM(targets_db.monthly_target_trips.total_target_trips) AS target_trips
    FROM 
        targets_db.monthly_target_trips
    INNER JOIN 
        dim_city ON targets_db.monthly_target_trips.city_id = dim_city.city_id
    GROUP BY 
        dim_city.city_name, month_name
),

actual_trips AS (
    SELECT 
        dim_city.city_name,
        MONTHNAME(fact_trips.date) AS month_name,
        COUNT(fact_trips.trip_id) AS actual_trips
    FROM 
        fact_trips
    INNER JOIN 
        dim_city ON fact_trips.city_id = dim_city.city_id
    GROUP BY 
        dim_city.city_name, month_name
)

SELECT 
    target_trips.city_name,
    target_trips.month_name,
    target_trips.target_trips,
    actual_trips.actual_trips,
    case
    when actual_trips.actual_trips>=target_trips.target_trips then "Above target"
    else "Below Target"
    end as performance_status,
    round((100*abs(target_trips.target_trips - actual_trips.actual_trips)/target_trips.target_trips),2) as perc_diff
FROM 
    target_trips
LEFT JOIN 
    actual_trips ON target_trips.city_name = actual_trips.city_name
                 AND target_trips.month_name = actual_trips.month_name;
