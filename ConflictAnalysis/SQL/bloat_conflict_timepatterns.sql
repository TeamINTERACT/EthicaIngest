-- create a view table to show blocks of redundant samples 
-- with counter of how many blocks collide at identical timestamps 
--SELECT numconflicts, totrecs, user_id, satellite_time FROM

--DROP VIEW IF EXISTS  level_0.tmpssk_gps_conflicts; 
CREATE VIEW level_0.tmpssk_gps_conflicts AS
    SELECT count(1) as numconflicts, sum(dupls) as totrecs,
           user_id, satellite_time,
           min(lat) as lat, min(lon) as lon -- min/max of identical values
    FROM
        (SELECT count(1) as dupls, 
                user_id,
                satellite_time, 
                trunc(lat::decimal,4) as lat, 
                trunc(lon::decimal,4) as lon
        FROM level_0.tmpelemetrysskwgpscsv
        GROUP BY user_id, satellite_time, trunc(lat::decimal,4), trunc(lon::decimal,4)
        ORDER BY user_id, satellite_time, trunc(lat::decimal,4), trunc(lon::decimal,4)) as foo
    GROUP BY user_id, satellite_time;
