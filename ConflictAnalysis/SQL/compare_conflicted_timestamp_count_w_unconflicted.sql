\pset pager off
\f ','
\a
\o 'foo_bar.csv'
SELECT user_id, seconds_clean, seconds_cleanish, seconds_conflicted, 
       trunc(100*(seconds_conflicted - seconds_clean)/seconds_conflicted::decimal,3) as percent_loss,
       trunc(100*(seconds_conflicted - seconds_cleanish)/seconds_conflicted::decimal,3) as percent_loss_ish
FROM (
    SELECT user_id, 
        COUNT(1) filter (where totrecs = 1) as seconds_clean,
        COUNT(1) filter (where totrecs = 1 or numconflicts = 1) as seconds_cleanish,
        COUNT(1) filter (where totrecs >=1) as seconds_conflicted
    FROM (
        SELECT user_id, totrecs,numconflicts, to_char(satellite_time, 'YYYY-MM-DD HH24:MI:SS')
        FROM level_0.tmpssk_gps_conflicts  
        --WHERE user_id > 5450 and user_id < 6000
        --AND totrecs = 1
        ) bar
    GROUP BY user_id
) baz ORDER BY percent_loss;
\q
