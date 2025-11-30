
DROP TABLE IF EXISTS election_result_2024;

CREATE TABLE election_result_2024 (
    election_year INTEGER,
    state_name VARCHAR(100),
    constituency_name VARCHAR(200),
    constituency_type VARCHAR(50),
    party_name VARCHAR(200),
    candidate_name VARCHAR(200),
    evm_votes INTEGER,
    postal_votes INTEGER,
    total_votes INTEGER,
    rankk INTEGER,
    units VARCHAR(200)
);

