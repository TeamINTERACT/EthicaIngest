# EthicaIngest
Scripts and control files associated with ingesting Ethica data into the Interact data pipeline

This file is a placeholder that will eventually describe the assumptions and decisions made in modernizing the ingest prototype into the production pipeline.

The data validation and ingest process is a step-by-step procedure, broken down into the following steps:

    verify_ethica_linkage
    - Verify Ethica data files are ready to be ingested
        each ethica user has exactly one record in linkage csv
        each ethica user has corresponding interact_id in linkage csv
        each ethica user has well-formed wear-dates in linkage csv
        each ethica user has ingestible telemetry files in archive 
        all ingestible telemetry files validate against checksum
        no ingestible telemetry files exist for unknown ethica users

    create_ethica_assignments.sql
    - Create table psql portal_dev.ethica_assignments

    ingest_ethica_linkage
    - Ingest linkage csv into psql portal_dev.ethica_assignments
        - Verify row counts in ethica_assignments table against csv

    ingest_ethica_telemetry
    - Ingest each telemetry file for each ethica user
        - Verify row counts in telemetry tables against csvs

    verify_ethica_ingest
    - Verify ingest logs and produce post-mortem summary report
