-- 1. Average parties per constituency by state
WITH parties_per_const AS (
    SELECT
        state_name,
        constituency_name,
        COUNT(DISTINCT party_name) AS parties_contesting
    FROM election_result_2024
    GROUP BY state_name, constituency_name
)
SELECT
    state_name,
    ROUND(AVG(parties_contesting), 1) AS avg_parties_per_constituency,
    MIN(parties_contesting) AS min_parties,
    MAX(parties_contesting) AS max_parties
FROM parties_per_const
GROUP BY state_name
ORDER BY avg_parties_per_constituency DESC;

-- 2. Total unique parties per state
SELECT
    state_name,
    COUNT(DISTINCT party_name) AS unique_parties_in_state
FROM election_result_2024
GROUP BY state_name
ORDER BY unique_parties_in_state DESC;

-- 3. High-stress constituencies (many candidates, close margins)
WITH parties_per_const AS (
    SELECT
        constituency_name,
        COUNT(DISTINCT party_name) AS total_parties
    FROM election_result_2024
    GROUP BY constituency_name
),
winner AS (
    SELECT * FROM election_result_2024 WHERE rankk = 1
),
runner_up AS (
    SELECT * FROM election_result_2024 WHERE rankk = 2
),
margins AS (
    SELECT
        w.constituency_name,
        ROUND(100.0 * (w.total_votes - r.total_votes) / w.total_votes, 2) AS margin_pct
    FROM winner w
    JOIN runner_up r ON w.constituency_name = r.constituency_name
)
SELECT
    p.constituency_name,
    p.total_parties,
    m.margin_pct
FROM parties_per_const p
JOIN margins m ON p.constituency_name = m.constituency_name
WHERE p.total_parties >= 30 OR m.margin_pct < 5
ORDER BY p.total_parties DESC, m.margin_pct ASC
LIMIT 25;