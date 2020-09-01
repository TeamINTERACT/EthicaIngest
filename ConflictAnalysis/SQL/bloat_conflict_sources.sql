-- create a view table to show blocks of redundant samples 
-- including the sources of the duplicated signals
-- with counter of how many blocks collide at identical timestamps 
--SELECT numconflicts, totrecs, user_id, satellite_time FROM

CREATE VIEW level_0.tmpssk_gps_conflicts_w_sources AS
    SELECT count(1) as numconflicts, sum(dupls) as totrecs,
           user_id, satellite_time,
           min(lat) as lat, min(lon) as lon, -- min/max of identical values
           provider
    FROM
        (SELECT count(1) as dupls, 
                user_id,
                satellite_time, 
                trunc(lat::decimal,4) as lat, 
                trunc(lon::decimal,4) as lon,
                provider
        FROM level_0.tmpelemetrysskwgpscsv
        GROUP BY user_id, satellite_time, trunc(lat::decimal,4), trunc(lon::decimal,4), provider
        ORDER BY user_id, satellite_time, trunc(lat::decimal,4), trunc(lon::decimal,4), provider) as foo
    GROUP BY user_id, satellite_time, provider;
