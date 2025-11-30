-- 1. Total votes across all constituencies
SELECT SUM(total_votes) AS total_votes
FROM election_result_2024;

-- 2. Total EVM votes and percentage
SELECT
    SUM(evm_votes) AS total_evm_votes,
    ROUND(100.0 * SUM(evm_votes) / SUM(total_votes), 2) AS evm_vote_percent
FROM election_result_2024;

-- 3. Total postal votes and percentage
SELECT
    SUM(postal_votes) AS total_postal_votes,
    ROUND(100.0 * SUM(postal_votes) / SUM(total_votes), 2) AS postal_vote_percent
FROM election_result_2024;

-- 4. NOTA votes analysis
SELECT
    SUM(evm_votes + postal_votes) AS nota_votes,
    ROUND(100.0 * SUM(evm_votes + postal_votes) / 
        (SELECT SUM(total_votes) FROM election_result_2024), 2) AS nota_percent
FROM election_result_2024
WHERE party_name = 'NOTA';

-- 5. State-wise constituency distribution
SELECT 
    state_name, 
    COUNT(DISTINCT constituency_name) AS total_constituencies
FROM election_result_2024
GROUP BY state_name
ORDER BY total_constituencies DESC;

-- 6. State-wise party participation
SELECT 
    state_name, 
    COUNT(DISTINCT party_name) AS total_parties
FROM election_result_2024
GROUP BY state_name
ORDER BY total_parties DESC;

-- 7. Constituency-wise party count 
SELECT 
    state_name, 
    constituency_name,
    COUNT(DISTINCT party_name) AS total_parties
FROM election_result_2024
GROUP BY state_name, constituency_name
ORDER BY total_parties DESC
LIMIT 20;

-- 8. Party-wise candidate count
SELECT 
    party_name, 
    COUNT(DISTINCT candidate_name) AS total_candidates
FROM election_result_2024
GROUP BY party_name
ORDER BY total_candidates DESC
LIMIT 15;