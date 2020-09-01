SET SCHEMA 'level_0';

CREATE TABLE IF NOT EXISTS eth_accel
(
    iid BIGINT NOT NULL,   -- interact_id
    ts TIMESTAMP WITH TIME ZONE NOT NULL, -- participant's UTC time, to millisec 
    x DOUBLE PRECISION NOT NULL,
    y DOUBLE PRECISION NOT NULL,
    z DOUBLE PRECISION NOT NULL,
    PRIMARY KEY(iid,ts)
);
COMMENT ON TABLE eth_accel IS 'Contains all the valid accelerometer records extracted from the Ethica devices. Granularity about 50ms';

CREATE TABLE IF NOT EXISTS eth_gps
(
    iid BIGINT NOT NULL,  -- interact_id
    ts TIMESTAMP WITH TIME ZONE NOT NULL, -- participant's UTC time, to millisec
    lat DOUBLE PRECISION NOT NULL,
    lon DOUBLE PRECISION NOT NULL,
    speed DOUBLE PRECISION DEFAULT 'NaN',
    course DOUBLE PRECISION DEFAULT 'NaN',
    alt DOUBLE PRECISION DEFAULT 'NaN',
    accu DOUBLE PRECISION DEFAULT 'NaN',
    provider TEXT DEFAULT '',
    PRIMARY KEY(iid,ts)
);
COMMENT ON TABLE eth_gps IS 'Contains all the valid GPS records extracted from the Ethica devices. Granularity about 1s';

