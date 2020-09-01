-- The idea is to look at collision groups and see whether the 
-- groups with different sensor values correspond to different
-- signal source providers

-- To do this, I've created the tmpssk_gps_conflicts_w_source
-- view, that reports conflict groups, including signal sources
-- in the GROUP BY clause.

-- I can now count the records in that table and then compare to
-- the number of records when I group by sensor but not by
-- source. If the numbers are the same, then the conflict groups
-- correspond to different signal sources.

--SELECT count(1) from level_0.tmpssk_gps_conflicts_w_sources;
-- SELECT count(1) FROM (
--     SELECT count(1) FROM level_0.tmpssk_gps_conflicts_w_sources
--     GROUP BY user_id, satellite_time, lat, lon, provider
-- ) bar;

-- SELECT count(1) FROM (
--     SELECT count(1) FROM level_0.tmpssk_gps_conflicts_w_sources
--     GROUP BY user_id, satellite_time, lat, lon
-- ) bar;

-- This will select all the fields from records with multiple
-- conflict groups so we can examine the provider and see how
-- it behaves across multiple conflict groups
SELECT * FROM level_0.tmpssk_gps_conflicts_w_sources
WHERE user_id, satellite_time, lat, lon 
    IN (
        -- this finds all cases where a given sample has multiple
        -- conflict groups
        SELECT * FROM (
                SELECT count(1) as num, user_id, satellite_time, lat, lon
                FROM level_0.tmpssk_gps_conflicts_w_sources
                GROUP BY user_id, satellite_time, lat, lon) bar
            WHERE num > 1) zip;
