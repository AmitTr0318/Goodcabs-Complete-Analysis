SELECT 
    dim_city.city_name AS cityname, 
    COUNT(fact_trips.trip_id) AS total_trips, 
    ROUND(AVG(fact_trips.fare_amount / fact_trips.distance_travelled_km), 2) AS avg_fare_per_km,
    ROUND(SUM(fact_trips.fare_amount) / COUNT(fact_trips.trip_id), 2) AS avg_fare_per_trip,
    ROUND(COUNT(fact_trips.trip_id) / (SELECT COUNT(trip_id) FROM fact_trips) * 100, 2) AS perc_contribution_to_total_trips
FROM 
    fact_trips
INNER JOIN 
    dim_city ON fact_trips.city_id = dim_city.city_id
GROUP BY 
    dim_city.city_name;






-- select (select distinct city_name as city from fact_trips
-- inner join dim_city
-- on fact_trips.city_id = dim_city.city_id), 
-- count(trip_id) as total_trips, (fare_amount/distance_travelled_km) as avg_fare_per_km, 
-- (avg_fare_per_km/total_trips) as avg_fare_per_trip from fact_trips
-- group by city_id