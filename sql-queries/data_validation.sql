-- 1.total record count
SELECT COUNT(*) AS total_records FROM election_result_2024;

-- 2.
SELECT * FROM election_result_2024 LIMIT 5;

-- 3. missing candidate names
SELECT COUNT(*) AS null_candidate
FROM election_result_2024
WHERE candidate_name IS NULL OR candidate_name = '';

-- 4.missing EVM votes
SELECT COUNT(*) AS null_evm_votes
FROM election_result_2024
WHERE evm_votes IS NULL;

-- 5. missing total votes
SELECT COUNT(*) AS null_total_votes
FROM election_result_2024
WHERE total_votes IS NULL;

-- 6. Unique constituencies
SELECT COUNT(DISTINCT constituency_name) AS total_constituencies
FROM election_result_2024;

-- 7. Unique parties
SELECT COUNT(DISTINCT party_name) AS total_parties
FROM election_result_2024;