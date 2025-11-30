-- National efficiency: Votes per seat won
WITH party_performance AS (
    SELECT
        party_name,
        SUM(total_votes) AS total_votes,
        COUNT(*) FILTER (WHERE rankk = 1) AS seats_won
    FROM election_result_2024
    GROUP BY party_name
)
SELECT
    party_name,
    total_votes,
    seats_won,
    CASE 
        WHEN seats_won > 0 THEN ROUND(total_votes::numeric / seats_won, 0)
        ELSE NULL
    END AS votes_per_seat,
    ROUND(100.0 * seats_won / NULLIF(SUM(seats_won) OVER (), 0), 2) AS seat_share_pct
FROM party_performance
WHERE seats_won > 0
ORDER BY votes_per_seat ASC;

