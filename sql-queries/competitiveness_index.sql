-- 1. State-wise competitiveness based on winning margins
WITH winner AS (
    SELECT *
    FROM election_result_2024
    WHERE rankk = 1
),
runner_up AS (
    SELECT *
    FROM election_result_2024
    WHERE rankk = 2
),
margins AS (
    SELECT
        w.state_name,
        w.constituency_name,
        w.candidate_name AS winner_name,
        w.party_name AS winner_party,
        r.candidate_name AS runner_up_name,
        r.party_name AS runner_up_party,
        w.total_votes AS winner_votes,
        r.total_votes AS runner_up_votes,
        (w.total_votes - r.total_votes) AS absolute_margin,
        ROUND(100.0 * (w.total_votes - r.total_votes) / w.total_votes, 2) AS winning_margin_pct
    FROM winner w
    JOIN runner_up r ON w.constituency_name = r.constituency_name
)
SELECT
    state_name,
    COUNT(*) AS total_constituencies,
    ROUND(AVG(winning_margin_pct), 2) AS avg_winning_margin_pct,
    ROUND(MIN(winning_margin_pct), 2) AS min_margin_pct,
    ROUND(MAX(winning_margin_pct), 2) AS max_margin_pct,
    CASE 
        WHEN AVG(winning_margin_pct) < 15 THEN 'Highly Competitive'
        WHEN AVG(winning_margin_pct) < 30 THEN 'Moderately Competitive'
        ELSE 'Low Competition'
    END AS competitiveness_category
FROM margins
GROUP BY state_name
ORDER BY avg_winning_margin_pct;

-- 2. Top 20 closest races
WITH winner AS (
    SELECT *
    FROM election_result_2024
    WHERE rankk = 1
),
runner_up AS (
    SELECT *
    FROM election_result_2024
    WHERE rankk = 2
)
SELECT
    w.state_name,
    w.constituency_name,
    w.candidate_name AS winner,
    w.party_name AS winner_party,
    r.candidate_name AS runner_up,
    r.party_name AS runner_up_party,
    (w.total_votes - r.total_votes) AS margin,
    ROUND(100.0 * (w.total_votes - r.total_votes) / w.total_votes, 2) AS margin_pct
FROM winner w
JOIN runner_up r ON w.constituency_name = r.constituency_name
ORDER BY margin
LIMIT 20;

-- 3. Strongholds: Wins with 60%+ vote share
SELECT
    state_name,
    constituency_name,
    candidate_name,
    party_name,
    total_votes,
    ROUND(100.0 * total_votes / SUM(total_votes) OVER (PARTITION BY constituency_name), 2) AS vote_share_pct
FROM election_result_2024
WHERE rankk = 1
HAVING ROUND(100.0 * total_votes / SUM(total_votes) OVER (PARTITION BY constituency_name), 2) >= 60
ORDER BY vote_share_pct DESC;