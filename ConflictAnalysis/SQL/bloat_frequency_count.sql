\pset pager off
\pset numericlocale 

SELECT 'level_0.tmpelemetrysskwgpscsv';

SELECT count(1) as duple_occurrences, dupls 
FROM (
    SELECT count(1) as dupls, user_id, satellite_time, lat, lon
    FROM level_0.tmpelemetrysskwgpscsv
    GROUP BY user_id, satellite_time, lat, lon
    ORDER BY user_id, satellite_time, lat, lon) as foo
GROUP BY dupls
ORDER BY dupls;
