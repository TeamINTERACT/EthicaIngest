-- THIS FILE IS DEFINITIVE
-- There is another version of this script in the Harmonizer
-- system, which uses this table to properly link
-- user records between Ethica and Treksoft. But since this
-- is where the linkage table is actually created, this version
-- remains authoritative.
CREATE TABLE portal_dev.ethica_assignments (
    ethica_id integer NOT NULL,
    study_id integer NOT NULL,
    interact_id bigint,
    ethica_email text,
    start_date timestamp with time zone,
    end_date timestamp with time zone,
    submitted_at_gap_start integer DEFAULT '-1'::integer,
    expired_at_gap_end integer DEFAULT 0,
    account_status text DEFAULT 'active'::text,
    low_notifications text DEFAULT 'active'::text,
    low_adherence text DEFAULT 'active'::text,
    relayed_to_treksoft boolean DEFAULT false,
    PRIMARY KEY (ethica_id, study_id)
);

COMMENT on COLUMN portal_dev.sensedoc_assignments.id IS
           'Simple row number index.';
COMMENT on COLUMN portal_dev.sensedoc_assignments.interact_id IS
           'Unique identifier of project participant.';
COMMENT on COLUMN portal_dev.sensedoc_assignments.sensedoc_serial IS
           'Unique identifier of a device assigned to participant.';
COMMENT on COLUMN portal_dev.sensedoc_assignments.city_id IS
           'The study city in which the user is enrolled.';
COMMENT on COLUMN portal_dev.sensedoc_assignments.wave_id IS
           'The data collection wave for which this assignment was made';
COMMENT on COLUMN portal_dev.sensedoc_assignments.started_wearing IS
           'The date this user received this device, with the understanding that good data will not begin until the following day.';
COMMENT on COLUMN portal_dev.sensedoc_assignments.stopped_wearing IS
           'The last date on which the user wore this device, which we assume extends until 3:00 the following morning.';

