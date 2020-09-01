Answer the following questions

If we keep only records with unique timestamps, or where duplicate stamps all have identical sensor readings, how many unique timestamps are lost from the GPS dataset?
    a) when using satellite_time as the timestamp

		SELECT min(loss_rate) rm_dups_loss_rate_min, 
               max(loss_rate) rm_dups_loss_rate_max, 
               avg(loss_rate) rm_dups_loss_rate_avg,
			   min(loss_rate_ish) rm_conf_loss_rate_min, 
               max(loss_rate_ish) rm_conf_loss_rate_max, 
               avg(loss_rate_ish) rm_conf_loss_rate_avg FROM (
		SELECT user_id, seconds_clean, seconds_cleanish, seconds_all,
			trunc((seconds_all - seconds_clean)/seconds_all::decimal,3) as loss_rate,
			trunc((seconds_all - seconds_cleanish)/seconds_all::decimal,3) as loss_rate_ish
		FROM (
			SELECT user_id,
				COUNT(1) filter (where totrecs = 1) as seconds_clean,
				COUNT(1) filter (where totrecs = 1 or numconflicts = 1) as seconds_cleanish,
				COUNT(1) filter (where totrecs >=1) as seconds_all
			FROM (
				SELECT user_id, totrecs,numconflicts, to_char(satellite_time, 'YYYY-MM-DD HH24:MI:SS')
				FROM (
					-- USE: level_0.tmpssk_gps_conflicts
				    -- or use this unrolled version directly
					SELECT count(1) as numconflicts, sum(dupls) as totrecs,
						user_id, satellite_time,
						min(lat) as lat, min(lon) as lon -- min/max of identical values
					FROM
						(SELECT count(1) as dupls,
								user_id,
								satellite_time,
								trunc(lat::decimal,6) as lat,
								trunc(lon::decimal,6) as lon
						FROM level_0.tmpelemetrysskwgpscsv
						GROUP BY user_id, satellite_time, 
                                 trunc(lat::decimal,6), trunc(lon::decimal,6)
						ORDER BY user_id, satellite_time, 
                                 trunc(lat::decimal,6), trunc(lon::decimal,6)) as foo
					GROUP BY user_id, satellite_time
				) biz
			) bar
			GROUP BY user_id
		) baz ORDER BY loss_rate) 
        boop;

		Result: 
			Unchanged regardless of truncation
			rm_dups_loss_rate_min    | 0.000
			rm_dups_loss_rate_max    | 0.672
			rm_dups_loss_rate_avg    | 0.0839

			With GPS coords truncate to 4 decimals
			rm_conf_loss_rate_min    | 0.000
			rm_conf_loss_rate_max    | 0.009
			rm_conf_loss_rate_avg    | 0.0004

			With GPS coords truncate to 5 decimals
			rm_conf_loss_rate_min    | 0.000
			rm_conf_loss_rate_max    | 0.026
			rm_conf_loss_rate_avg    | 0.0018

			With GPS coords truncate to 6 decimals
			rm_conf_loss_rate_min    | 0.000
			rm_conf_loss_rate_max    | 0.045
			rm_conf_loss_rate_avg    | 0.0032

			With GPS coords untruncated
			rm_conf_loss_rate_min    | 0.000
			rm_conf_loss_rate_max    | 0.050
			rm_conf_loss_rate_avg    | 0.0037

		Conclusion: 
			Dropping all duplicates results in unacceptable losses for some users (up to 67%)
			Dropping conflicted readings and truncating to 4 gives virtually no loss (<0.04%)

    b) when using record_time as the timestamp

		SELECT min(loss_rate) rm_dups_loss_rate_min, 
               max(loss_rate) rm_dups_loss_rate_max, 
               avg(loss_rate) rm_dups_loss_rate_avg,
			   min(loss_rate_ish) rm_conf_loss_rate_min, 
               max(loss_rate_ish) rm_conf_loss_rate_max, 
               avg(loss_rate_ish) rm_conf_loss_rate_avg FROM (
		SELECT user_id, seconds_clean, seconds_cleanish, seconds_all,
			trunc((seconds_all - seconds_clean)/seconds_all::decimal,3) as loss_rate,
			trunc((seconds_all - seconds_cleanish)/seconds_all::decimal,3) as loss_rate_ish
		FROM (
			SELECT user_id,
				COUNT(1) filter (where totrecs = 1) as seconds_clean,
				COUNT(1) filter (where totrecs = 1 or numconflicts = 1) as seconds_cleanish,
				COUNT(1) filter (where totrecs >=1) as seconds_all
			FROM (
				SELECT user_id, totrecs,numconflicts, to_char(record_time, 'YYYY-MM-DD HH24:MI:SS')
				FROM (
					-- USE: level_0.tmpssk_gps_conflicts
				    -- or use this unrolled version directly
					SELECT count(1) as numconflicts, sum(dupls) as totrecs,
						user_id, record_time,
						min(lat) as lat, min(lon) as lon -- min/max of identical values
					FROM
						(SELECT count(1) as dupls,
								user_id,
								record_time,
								trunc(lat::decimal,4) as lat,
								trunc(lon::decimal,4) as lon
						FROM level_0.tmpelemetrysskwgpscsv
						GROUP BY user_id, record_time, trunc(lat::decimal,4), trunc(lon::decimal,4)
						ORDER BY user_id, record_time, trunc(lat::decimal,4), trunc(lon::decimal,4)) as foo
					GROUP BY user_id, record_time
				) biz
			) bar
			GROUP BY user_id
		) baz ORDER BY loss_rate) 
        boop;

		Result:
			rm_dups_loss_rate_min    | 0.000
			rm_dups_loss_rate_max    | 0.417
			rm_dups_loss_rate_avg    | 0.04666887417218543046

			rm_conf_loss_rate_min    | 0.000
			rm_conf_loss_rate_max    | 0.375
			rm_conf_loss_rate_avg    | 0.03090728476821192053

		Conclusion:
			Filtering based on record_time creates unacceptable levels of data loss
			for both duplicate filtering and conflict filtering

What is the loss of temporal coverage if we drop GPS values to 5 decimals?
        Putting it another way: If we use less precise GPS coords, more records will
        test as duplicates which will cause more of them to be dropped or collapsed together.
        How many distinct timestamps remain if we do this?

		SELECT min(loss_rate) rm_dups_loss_rate_min, 
               max(loss_rate) rm_dups_loss_rate_max, 
               avg(loss_rate) rm_dups_loss_rate_avg,
			   min(loss_rate_ish) rm_conf_loss_rateish_min, 
               max(loss_rate_ish) rm_conf_loss_rateish_max, 
               avg(loss_rate_ish) rm_conf_loss_rateish_avg FROM (
		SELECT user_id, seconds_clean, seconds_cleanish, seconds_all,
			trunc((seconds_all - seconds_clean)/seconds_all::decimal,3) as loss_rate,
			trunc((seconds_all - seconds_cleanish)/seconds_all::decimal,3) as loss_rate_ish
		FROM (
			SELECT user_id,
				COUNT(1) filter (where totrecs = 1) as seconds_clean,
				COUNT(1) filter (where totrecs = 1 or numconflicts = 1) as seconds_cleanish,
				COUNT(1) filter (where totrecs >=1) as seconds_all
			FROM (
				SELECT user_id, totrecs,numconflicts, to_char(record_time, 'YYYY-MM-DD HH24:MI:SS')
				FROM (
					-- USE: level_0.tmpssk_gps_conflicts
				    -- or use this unrolled version directly
					SELECT count(1) as numconflicts, sum(dupls) as totrecs,
						user_id, record_time,
						min(lat) as lat, min(lon) as lon -- should be mins of identical values
					FROM
						(SELECT count(1) as dupls,
								user_id,
								record_time,
								min(trunc(lat::decimal,6)) as lat,
								min(trunc(lon::decimal,6)) as lon
						FROM level_0.tmpelemetrysskwgpscsv
						GROUP BY user_id, record_time, trunc(lat::decimal,6), trunc(lon::decimal,6)
						ORDER BY user_id, record_time, trunc(lat::decimal,6), trunc(lon::decimal,6)) as foo
					GROUP BY user_id, record_time
				) biz
			) bar
			GROUP BY user_id
		) baz ORDER BY loss_rate) 
        boop;

    Results:
        4 decimals of GPS accuracy
			rm_dups_loss_rate_min    | 0.000
			rm_dups_loss_rate_max    | 0.417
			rm_dups_loss_rate_avg    | 0.047
			rm_conf_loss_rateish_min | 0.000
			rm_conf_loss_rateish_max | 0.375
			rm_conf_loss_rateish_avg | 0.031

		5 decimals of GPS accuracy
			rm_dups_loss_rate_min    | 0.000
			rm_dups_loss_rate_max    | 0.417
			rm_dups_loss_rate_avg    | 0.047
			rm_conf_loss_rateish_min | 0.000
			rm_conf_loss_rateish_max | 0.384
			rm_conf_loss_rateish_avg | 0.036

		6 decimals of GPS accuracy
			rm_dups_loss_rate_min    | 0.000
			rm_dups_loss_rate_max    | 0.417
			rm_dups_loss_rate_avg    | 0.047
			rm_conf_loss_rateish_min | 0.000
			rm_conf_loss_rateish_max | 0.384
			rm_conf_loss_rateish_avg | 0.038

Can a similar strategy be used for filtering ACCEL data if we truncate sensors to 3 decimals

To what degree do the conflict groups correspond to different signal providers?
    a) when using satellite_time as the timestamp
    b) when using record_time as the timestamp

If we retain only records with unique timestamps, or where duplicate stamps all have identical sensor readings, how many unique timestamps are lost from the ACCEL dataset?

	Filtering out dups vs conflicts, based on record_time

		SELECT min(loss_rate) rm_dups_loss_rate_min, 
               max(loss_rate) rm_dups_loss_rate_max, 
               avg(loss_rate) rm_dups_loss_rate_avg,
			   min(loss_rate_ish) rm_conf_loss_rateish_min, 
               max(loss_rate_ish) rm_conf_loss_rateish_max, 
               avg(loss_rate_ish) rm_conf_loss_rateish_avg FROM (
		SELECT user_id, seconds_clean, seconds_cleanish, seconds_all,
			trunc((seconds_all - seconds_clean)/seconds_all::decimal,3) as loss_rate,
			trunc((seconds_all - seconds_cleanish)/seconds_all::decimal,3) as loss_rate_ish
		FROM (
			SELECT user_id,
				COUNT(1) filter (where totrecs = 1) as seconds_clean,
				COUNT(1) filter (where totrecs = 1 or numconflicts = 1) as seconds_cleanish,
				COUNT(1) filter (where totrecs >=1) as seconds_all
			FROM (
				SELECT user_id, totrecs,numconflicts, to_char(record_time, 'YYYY-MM-DD HH24:MI:SS')
				FROM (
					-- add defining sensor values to each
                    -- counted duplication class
					SELECT count(1) as numconflicts, sum(dupls) as totrecs,
						user_id, record_time,
						min(x_axis) as x_axis, -- min of identical values
						min(y_axis) as y_axis, -- min of identical values
						min(z_axis) as z_axis  -- min of identical values
					FROM (
						-- group raw samples 
                        -- by timestamp and sensor values
						SELECT count(1) as dupls,
								user_id,
								record_time,
								x_axis, y_axis, z_axis
						FROM level_0.tmpelemetrysskwaccelcsv
						GROUP BY user_id, record_time, x_axis, y_axis, z_axis
						ORDER BY user_id, record_time, x_axis, y_axis, z_axis) as foo
					GROUP BY user_id, record_time
				) biz
			) bar
			GROUP BY user_id
		) baz ORDER BY loss_rate) 
        boop;

		Results:
			rm_dups_loss_rate_min    | 0.000
			rm_dups_loss_rate_max    | 0.531
			rm_dups_loss_rate_avg    | 0.04002631578947368421

			rm_conf_loss_rate_min    | 0.000
			rm_conf_loss_rate_max    | 0.530
			rm_conf_loss_rate_avg    | 0.03728947368421052632

		Conclusion:
			Like GPS, conflict filtering based on record_time has undesirable max loss rates
			but again, filtering out conflicts seems preferable to filtering duplicates

To what degree do the GPS record_time and satellite_time fields correspond?
    a) before filtration
		-- Find basic stats about time mismatches
		SELECT min(diff_ms), max(diff_ms), avg(diff_ms),
			   percentile_cont(0.25) within group (order by diff_ms asc) as p25,
			   percentile_cont(0.5) within group (order by diff_ms asc) as p50,
			   percentile_cont(0.75) within group (order by diff_ms asc) as p75
		FROM (
			-- convert timestamp to consistent ms basis relative to epoch
			SELECT user_id, record_time, satellite_time,
				ABS(EXTRACT(EPOCH from record_time AT TIME ZONE 'UTC') - 
					EXTRACT(EPOCH from satellite_time AT TIME ZONE 'UTC')) as diff_ms  
			--FROM tmpelemetrysskwgpscsv 
			FROM tmpvicwgpscsv 
			--LIMIT 20
		) foo;

    Result: avg discrepancy is 3-5 hrs
        SSK
        min | 0
        max | 413854.562000036 = 4.78 days
        avg | 17483.4328274943 = 4.85 hrs
        p25 | 6.86400008201599 = 6.86 sec
        p50 | 6244.03549993038 = 1.73 hrs
        p75 | 25560.8147498965 = 7.10 hrs

        VIC
        min | 0
        max | 18645117.6159999  = 215 days
        avg | 10706.773918101   = 2.9 hrs
        p25 | 0.594000101089478 = 0.6 sec
        p50 | 1244.46050000191  = 21  min
        p75 | 14953.5802500844  = 4.2 hrs


    b) after filtration by satellite_time
		-- Find basic stats about time mismatches based on filtered satellite_time
		SELECT min(diff_ms), max(diff_ms), avg(diff_ms),
			   percentile_cont(0.25) within group (order by diff_ms asc) as p25,
			   percentile_cont(0.5) within group (order by diff_ms asc) as p50,
			   percentile_cont(0.75) within group (order by diff_ms asc) as p75
		FROM (
			-- convert timestamps to consistent ms basis relative to epoch
            -- and take the absolute difference
			SELECT user_id, record_time, satellite_time,
				ABS(EXTRACT(EPOCH from record_time AT TIME ZONE 'UTC') - 
					EXTRACT(EPOCH from satellite_time AT TIME ZONE 'UTC')) as diff_ms  
			FROM (
				SELECT user_id, totrecs, numconflicts, 
					   satellite_time, record_time
				FROM (
                    -- reduce duplication groups into single, counted records
					SELECT count(1) as numconflicts, sum(dupls) as totrecs,
						user_id, satellite_time, record_time,
						min(lat) as lat, min(lon) as lon -- min/max of identical values
					FROM
						(SELECT count(1) as dupls,
								user_id,
								satellite_time,
								record_time,
								trunc(lat::decimal,4) as lat,
								trunc(lon::decimal,4) as lon
						--FROM level_0.tmpelemetrysskwgpscsv
						FROM level_0.tmpvicwgpscsv
						GROUP BY user_id, satellite_time, record_time, 
                                 trunc(lat::decimal,4), 
                                 trunc(lon::decimal,4)
						ORDER BY user_id, satellite_time, trunc(lat::decimal,4), trunc(lon::decimal,4)) as foo
					GROUP BY user_id, satellite_time, record_time
				) biz
			    WHERE totrecs = 1 OR numconflicts = 1
			) blap
			--LIMIT 20
		) foo;

    Result: avg discrepancy is 3-5 hrs
        SSK
        min | 0
        max | 413854.562000036 = 4.78 days
        avg | 18451.5697243268 = 5.12 hrs
        p25 | 40.1029999256134 = 40.1 sec
        p50 | 7600.84799993038 = 2.11 hrs
        p75 | 26992.8110001087 = 7.48 hrs

        VIC
        min | 0
        max | 18645117.6159999  = 215 days
        avg | 10689.7966948969  = 2.9 hrs
        p25 | 0.593000173568726 = 0.6 sec
        p50 | 1229.96399998665  = 20  min
        p75 | 14840.4769999981  = 4.1 hrs

    c) after filtration by record_time

    But what is the test?
        a) sum of squared absolute difference, per sample, in ms
        b) same, but taken as difference from average difference for that user, which becomes a measure of how stable the difference is between signals for that user

How reliable is the DC timing signal contained in the battery table?
    This table is also somewhat noisy. Not all signals are near the 5-min interval target
				
		For this table, a GOOD signal is one whose prev or next neighbor is at an interval between 4:30 and 5:30.
				NumGood  KeepRate (signal stamps)
		mean     4238.5   87.2
		std      2828.2   23.2
		min         0.0    0.0
		25%      1472.0   93.1  <--
		50%      4584.0   97.1
		75%      6668.0   98.1
		max      8577.0   99.8

    Identify duty cycle periods
        Created a filter to extract only signals occurring in 5-min increments (duty_cycle_filter)
        Results:
            Average retention: 93.6% of signal stamps

    Determine min threshold number of good DCs to keep users (count_min_dutycycles)
        MinThreshold,NumUsersKept,KeepPercent (users)
        0,153,100.0
        500,132,86.3
        1000,122,79.7
        1500,115,75.2  <--
        2000,109,71.2
        2500,104,68.0
        3000,99,64.7
        3500,92,60.1
        4000,86,56.2
        4500,80,52.3
        5000,74,48.4
        5500,67,43.8
        6000,57,37.3
        6500,47,30.7
        7000,35,22.9
        7500,24,15.7
        8000,17,11.1
        8500,1,0.7


	Are most battery stamps aligned the 5-minute clock?
		Show a histogram of battery timestamps by clock minute. (After adding 30s)

    Result:
        Indeed, the multiples of 5 minutes are the most common stamp times in the data.

        See Outputs/offset-min-hist-all.png for histograms
        Produced with script: duty_cycle_clock_adherence

        But GPS histogram does not have same shape
        See Outputs/min-hist-gbsbatx5.png for comparative histograms
        (Which shows battery hist overlaid on histogram of GPS minutes (w duplicates removed) 



To what degree do capture periods of ACCEL and GPS data correspond w each other and to BATTERY?

    Compare start times of DC periods between ACCEL and GPS, per user
    May also be useful to compare times to signals in battery table (need more info)

    Produced minutes-of-hour histogram for 5 GPS tables
        See Outputs/min-hist-GPSx5.png
    Found that they DO NOT spike on the 5-minute lines
        Could there be mismatch between BATTERY and GPS timestamps?
    PRODUCE THAT AGAIN, but overlay battery hist and GPS hist for each user
        (All duplicate timestamps in GPS and Battery collapsed into singletons)
        See: Outputs/min-hist-gpsbatx5.png


Identify users with insufficent duty cycles, either by looking at gps or battery

    FOR ACCEL DATA: timestamps mark starts of duty cycles

    GPS DUTY CYCLE IS EITHER SYNCED, OR DELAYED
        Examine data to see which is true - does GPS DC ever drift from Accel? 
        For a given user 
            make a list of all DC start times
            For each sample 
                report the offset from most recent DC start

        This will give us a stream of DC-relative offsets, which SHOULD range from 0-60s
        Anything other than that will tell us something about possible DC drift.

    FOR BATTERY:
        see analysis above re battery duty cycles

CURRENT: Working on script: duty_cycle_map
    Now have a histogram of battery signal delays
        It shows plenty of 5-minute signals, but lots of noise beyond those
    Filter battery signals, keeping only those that mark either start or end of a 5-min interval
        We'll call those the 'clean' signals
    Now create filter of GPS/Accel telemetry samples
        Drop all samples that are timestamped later than 1 minute after most recent battery signal

    How many users have at least 4000 DC signals in the raw battery table?
        93 of 153 (for saskatoon)
        83 if we consider only the 'clean' signals

        114 if we change the threshold to 2000
        105 (if we still consider clean only)
        
    
    How much data do we lose if we take each battery record as the start of a DC and keep only telemetry in the 1-min window following those stamps?

        SELECT * 
        FROM gps
        WHERE user_id = uid
            AND record_time IN (
                SELECT * 
                FROM battery
                WHERE user_id = uid
                ) dcstamps;
            

How do our filtration schemes improve if we exclude users with low participation rates?
