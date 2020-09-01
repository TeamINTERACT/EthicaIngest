Executive Summary 
------------------
    The data in Ethica telemetry files is unexpectedly chaotic.

    There are significantly too many records in each file.

    Both timestamping mechanisms seem conflicted and unreliable.

    These issues were found in both Saskatoon and Victoria W1 datasets, for both accelerometry and GPS data, but for the purposes of this discussion, all numbers cited below are taken from the case of Saskatoon's GPS data.

Issue #0: Redundant Timestamps
------------------------------
It has already been well discussed that both the record_time and satellite_time fields act as timestamps of the observations. This report was originally intended to be an analysis of the two data fields to try to ascertain which was the more reliable source of time information, but other issues have come to light that need to be resolved before this question can be answered.


Issue #1: Too Much Data
-----------------------
The data files we receive from Ethica are in CSV format, with one timestamped data sample per line for each user in the study.

The GPS data file contains 29M samples. This is supposed to mean that we have 29M unique observations of our participant cohort, with each sample recording a particular user in a particular location at a particular point in time. However, when we count the number of unique pairings of userid and timestamp, we get only 8M, and this is true regardless of which timestamp field we use. 

This suggests that there is a lot of redundancy in the files, with 3 or 4 times as many records as there should be.

With SenseDoc data, the ingest process filtered out occasional timestamp collisions to ensure that the ToP process would have well-ordered timeseries data to work with. So if the Ethica ingest is to do the same, we'll need to get a better understanding of what that redundancy looks like. If all the redundant records are clustered in a few focused periods of time where the capture tech became 'glitchy', then we can just drop records from those confused periods. But if the conflicted captures are diffused more generally throughout the data, we'll have to devise a more sophisticated filtration scheme.

Redundancy Clusters
-------------------
So what does the redudancy look like?

Of the 8M unique user/time values in the file, 6M are collision-free.

Within the 2M conflicted timestamps, some collide in groups of only 2 records, while other conflict groups are as large as 1900 records. 

There are again two possibilities: if this is a simple case of "output stuttering", in which the same observation is being written to the file multiple times, then we can simply ignore the redundant records. On the other hand, if the conflicted samples have DISTINCT sensor values, then we'll have to devise a more elaborate solution.

Collision Variability
---------------------
This time, instead of looking at records that share just user and timestamp values, I'm counting the records that share userid, timestamp, lat, and lon values.

Unfortunately, it is not a simple case of stuttering. The conflict groups contain as many as 100 distinct sensor readings for the same timestamp.

And I should be clear on that last point. We are not talking about 100 different samples within a given second. We're seeing as many as 100 different sensor values being mapped to identical timestamps, down to the millisecond.

Status
------
So at this point, I've reached an impasse and need some input from the team on how to proceed. 

1. Are there better diagnostics we can run to help illuminate the nature of the redundancy?
2. Is there a simple razor we can apply for ToP ingest and leave deeper analysis for later?
