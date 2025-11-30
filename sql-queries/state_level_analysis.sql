-- 1. State-wise seats won 
SELECT
    state_name,
    COUNT(*) AS seats_won
FROM election_result_2024
WHERE rankk = 1
GROUP BY state_name
ORDER BY seats_won DESC;

-- 2. Party & state-wise seat count
SELECT
    state_name,
    party_name,
    COUNT(*) AS seats_won
FROM election_result_2024
WHERE rankk = 1
GROUP BY state_name, party_name
ORDER BY state_name, seats_won DESC;

-- 3. Vote share by party within each state
SELECT
    state_name,
    party_name,
    SUM(total_votes) AS party_votes,
    ROUND(100.0 * SUM(total_votes) / 
        SUM(SUM(total_votes)) OVER (PARTITION BY state_name), 2) AS state_vote_share_pct
FROM election_result_2024
GROUP BY state_name, party_name
ORDER BY state_name, state_vote_share_pct DESC;

-- 4. Seat share by party within each state
SELECT
    state_name,
    party_name,
    COUNT(*) AS seats_won,
    ROUND(100.0 * COUNT(*) / 
        SUM(COUNT(*)) OVER (PARTITION BY state_name), 2) AS state_seat_share_pct
FROM election_result_2024
WHERE rankk = 1
GROUP BY state_name, party_name
ORDER BY state_name, state_seat_share_pct DESC;

-- 5. BJP performance breakdown by state
SELECT 
    state_name, 
    COUNT(*) AS seats_won,
    SUM(total_votes) AS total_votes,
    ROUND(AVG(CASE WHEN rankk = 1 THEN 100.0 * total_votes / 
        SUM(total_votes) OVER (PARTITION BY constituency_name) END), 2) AS avg_vote_share_in_wins
FROM election_result_2024
WHERE party_name = 'Bharatiya Janata Party'
GROUP BY state_name
ORDER BY seats_won DESC;