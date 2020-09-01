\pset pager off
\pset numericlocale 

SELECT 'ssk-accel';
SELECT count(1) as distinct_record_usertimestamps FROM
    (SELECT count(1) from level_0.tmpelemetrysskwaccelcsv GROUP BY user_id, record_time) as foo;
SELECT min(num_recs) min_distinctsamples_per_record_time, 
       to_char(avg(num_recs),'99D9') avg_distinctsamples_per_record_time, 
       max(num_recs) max_distinctsamples_per_record_time FROM
    (SELECT count(1) as num_recs FROM level_0.tmpelemetrysskwaccelcsv GROUP BY user_id, record_time, lat, lon) as bar;

SELECT 'ssk-gps';
SELECT count(1) as distinct_satellite_usertimestamps FROM
    (SELECT count(1) from level_0.tmpelemetrysskwgpscsv GROUP BY user_id, satellite_time) as foo;
SELECT count(1) as distinct_record_usertimestamps FROM
    (SELECT count(1) from level_0.tmpelemetrysskwgpscsv GROUP BY user_id, record_time) as foo;
SELECT min(num_recs) min_distinctsamples_per_satellite_time, 
       to_char(avg(num_recs),'99D9') avg_distinctsamples_per_satellite_time, 
       max(num_recs) max_distinctsamples_per_satellite_time FROM
    (SELECT count(1) as num_recs FROM level_0.tmpelemetrysskwgpscsv GROUP BY user_id, satellite_time, lat, lon) as bar;
SELECT min(num_recs) min_distinctsamples_per_record_time, 
       to_char(avg(num_recs),'99D9') avg_distinctsamples_per_record_time, 
       max(num_recs) max_distinctsamples_per_record_time FROM
    (SELECT count(1) as num_recs FROM level_0.tmpelemetrysskwgpscsv GROUP BY user_id, record_time, lat, lon) as bar;

SELECT 'vic-accel';
SELECT count(1) as distinct_record_usertimestamps FROM
    (SELECT count(1) from level_0.tmpvicwaccelcsv GROUP BY user_id, record_time) as foo;
SELECT min(num_recs) min_distinctsamples_per_record_time, 
       to_char(avg(num_recs),'99D9') avg_distinctsamples_per_record_time, 
       max(num_recs) max_distinctsamples_per_record_time FROM
    (SELECT count(1) as num_recs FROM level_0.tmpvicwaccelcsv GROUP BY user_id, record_time, lat, lon) as bar;

SELECT 'vic-gps';
SELECT count(1) as distinct_satellite_usertimestamps FROM
    (SELECT count(1) from level_0.tmpvicwgpscsv GROUP BY user_id, satellite_time) as foo;
SELECT count(1) as distinct_record_usertimestamps FROM
    (SELECT count(1) from level_0.tmpvicwgpscsv GROUP BY user_id, record_time) as foo;
SELECT min(num_recs) min_distinctsamples_per_satellite_time, 
       to_char(avg(num_recs),'99D9') avg_distinctsamples_per_satellite_time, 
       max(num_recs) max_distinctsamples_per_satellite_time FROM
    (SELECT count(1) as num_recs FROM level_0.tmpvicwgpscsv GROUP BY user_id, satellite_time, lat, lon) as bar;
SELECT min(num_recs) min_distinctsamples_per_record_time, 
       to_char(avg(num_recs),'99D9') avg_distinctsamples_per_record_time, 
       max(num_recs) max_distinctsamples_per_record_time FROM
    (SELECT count(1) as num_recs FROM level_0.tmpvicwgpscsv GROUP BY user_id, record_time, lat, lon) as bar;
