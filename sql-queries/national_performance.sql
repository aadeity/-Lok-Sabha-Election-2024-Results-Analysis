-- 1. Top 5 parties by seats won
SELECT
    party_name,
    COUNT(*) AS seats_won
FROM election_result_2024
WHERE rankk = 1
GROUP BY party_name
ORDER BY seats_won DESC
FETCH FIRST 5 ROWS ONLY;

-- 2. Top 5 parties by vote share
SELECT
    party_name,
    SUM(total_votes) AS party_votes,
    ROUND(100.0 * SUM(total_votes) / SUM(SUM(total_votes)) OVER (), 2) AS vote_share_pct
FROM election_result_2024
GROUP BY party_name
ORDER BY party_votes DESC
FETCH FIRST 5 ROWS ONLY;

-- 3. Complete vote share by party
SELECT
    party_name,
    SUM(total_votes) AS party_votes,
    ROUND(100.0 * SUM(total_votes) / SUM(SUM(total_votes)) OVER (), 2) AS vote_share_pct
FROM election_result_2024
GROUP BY party_name
ORDER BY party_votes DESC;

-- 4. Parties contesting in more than 10 constituencies
SELECT
    party_name,
    COUNT(DISTINCT constituency_name) AS constituencies_contested
FROM election_result_2024
GROUP BY party_name
HAVING COUNT(DISTINCT constituency_name) > 10
ORDER BY constituencies_contested DESC;

-- 5. Geographic reach: Parties present in multiple states
SELECT
    party_name,
    COUNT(DISTINCT state_name) AS states_present,
    COUNT(DISTINCT constituency_name) AS total_constituencies
FROM election_result_2024
GROUP BY party_name
HAVING COUNT(DISTINCT state_name) >= 3
ORDER BY states_present DESC, total_constituencies DESC;