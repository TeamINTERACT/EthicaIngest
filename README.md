# EthicaIngest

Everything for ingesting Wave 1 Ethica linkage and telemetry info is embedded in the Jupyter Notebook.

Once the ingest is complete, create a PDF snapshot of the results by running:
    jupyter nbconvert Ingest-Ethica-Van-W1.ipynb --to pdf --output IngestReport-Ethica-Van-W1-20201007.pdf




Old Stuff
    Scripts and control files associated with ingesting Ethica data into the Interact data pipeline

    This file is a placeholder that will eventually describe the assumptions and decisions made in modernizing the ingest prototype into the production pipeline.

    The data validation and ingest process is a step-by-step procedure, broken down into the following modules:

        verify_ethica_linkage
        X Verify Ethica data files are ready to be ingested
            a) each ethica user has exactly one record in linkage csv
            b) each ethica user is a well-formed integer value
            c) each ethica user has corresponding interact_id in linkage csv
            d) each ethica user has ingestible telemetry files in archive 
            e) no ingestible telemetry files exist for unknown ethica users

            X) each ethica user has well-formed wear-dates in linkage csv
                Nope! Wear dates have no meaning for Ethica users

        verify_ethica_telemetry
        - Validate pairs of telemetry CSV files against linkage expectations
            - each file validates against checksum
            CURRENTLY NOT SURE THIS STEP IS NEEDED
            the linkage verify already validates these files in some degree
            should be able to add checksum test there rather than create
            an entirely separate step in the cycle

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


