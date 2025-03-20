INSERT INTO Security_paper(paper_id, current_time_stamp, current_cost)
SELECT 
    RANDOM() * (3 * :cnt) + 1,
    DATE (TIMESTAMP '2020-01-01' + 
        RANDOM() * (CURRENT_TIMESTAMP - (CURRENT_TIMESTAMP - INTERVAL '5 YEARS')))
    + TIME '10:00:00' 
    + RANDOM() * INTERVAL '8 hours',
    RANDOM() * 10000000 + 1
FROM GENERATE_SERIES(1, 3 * :cnt);