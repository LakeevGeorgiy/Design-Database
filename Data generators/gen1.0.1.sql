INSERT INTO Futures(paper_id, underlying_asset, Contract_type, lot, guarantee_coverage, point_value)
SELECT DISTINCT
    GENERATE_SERIES,
    (SELECT unnest(enum_range(NULL::ASSET)) ORDER BY RANDOM() LIMIT 1),
    (SELECT unnest(enum_range(NULL::CONTRACT_TYPE)) ORDER BY RANDOM() LIMIT 1),
    FLOOR(RANDOM() * 100 + 1)::INTEGER,
    RANDOM() * 10000000 + 1,
    RANDOM() * 10000000 + 1
FROM GENERATE_SERIES(2 * :cnt + 1, 3 * :cnt);

