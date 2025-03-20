INSERT INTO Investor_login(phone_number, password)
SELECT
    CONCAT('(+',FLOOR(RANDOM()*1000),')',FLOOR(RANDOM()*1000000000)),
    SUBSTR(MD5(RANDOM()::text), 0, 100)
FROM GENERATE_SERIES(1, :'cnt');

INSERT INTO Investor_info(investor_id, name, lastname, experience)
SELECT
    GENERATE_SERIES,
    MD5(RANDOM()::TEXT),
    MD5(RANDOM()::TEXT),
    FLOOR(RANDOM() * 75 + 0)::INTEGER
FROM GENERATE_SERIES(1, :'cnt');

INSERT INTO Currency(country)
SELECT 
    (array['RUSSIA', 'BELARUS', 'UK', 'USA', 'FRANCE', 'ITALY', 'GEOGRIA', 'UZBEKISTAN', 'SPAIN'])[floor(random() * 9 + 1)]
FROM GENERATE_SERIES(1, 50);

INSERT INTO Currency_value(first_currency, second_currency, cost)
SELECT DISTINCT
    FLOOR(RANDOM() * 50 + 1)::INTEGER,
    FLOOR(RANDOM() * 50 + 1)::INTEGER,
    FLOOR(RANDOM())
FROM GENERATE_SERIES(1, :'cnt');

INSERT INTO Wallet(currency_id, profitability)
SELECT DISTINCT
    FLOOR(RANDOM() * 50 + 1)::INTEGER,
    RANDOM()::FLOAT
FROM GENERATE_SERIES(1, :'cnt');

INSERT INTO Investor_history(investor_id, wallet_id, paper_id, operation, current_time_stamp)
SELECT DISTINCT
    FLOOR(RANDOM() * :'cnt' + 1)::INTEGER,
    FLOOR(RANDOM() * :'cnt' + 1)::INTEGER,
    FLOOR(RANDOM() * :'cnt' + 1)::INTEGER,
    (SELECT unnest(enum_range(NULL::OPERATION_TYPE)) ORDER BY RANDOM() LIMIT 1),
    DATE (TIMESTAMP '2020-01-01' + 
        RANDOM() * (CURRENT_TIMESTAMP - (CURRENT_TIMESTAMP - INTERVAL '5 years')))
    + TIME '10:00:00' 
    + RANDOM() * INTERVAL '8 hours'
FROM GENERATE_SERIES(1, :'cnt');

INSERT INTO Investor_wallet(investor_id, wallet_id)
SELECT DISTINCT
    FLOOR(RANDOM() * :'cnt' + 1)::INTEGER,
    FLOOR(RANDOM() * :'cnt' + 1)::INTEGER
FROM GENERATE_SERIES(1, :'cnt');

INSERT INTO Wallet_security_paper(wallet_id, paper_id)
SELECT DISTINCT
    FLOOR(RANDOM() * :'cnt' + 1)::INTEGER,
    GENERATE_SERIES
FROM GENERATE_SERIES(1, 3 * :cnt);

INSERT INTO Stocks(paper_id, currency_id, lot, opening_price, closing_price, dividend_percent)
SELECT DISTINCT
    GENERATE_SERIES,
    FLOOR(RANDOM() * 50 + 1)::INTEGER,
    FLOOR(RANDOM() * 100 + 1)::INTEGER,
    RANDOM() * 100000 + 1,
    RANDOM() * 100000 + 1,
    FLOOR(RANDOM() * 100 + 1)::INTEGER
FROM GENERATE_SERIES(1, :'cnt');

INSERT INTO Bonds(paper_id, repayment_date, coupon_date, coupon_type, coupon_value)
SELECT DISTINCT
    GENERATE_SERIES,
    (SELECT '2023-01-01 00:00:00'::timestamp + ('2023-12-31 23:59:59'::timestamp - '2023-01-01 00:00:00'::timestamp) * RANDOM() AS random_timestamp),
    (SELECT * FROM GENERATE_SERIES('2024-04-05', '2030-12-31', INTERVAL '1 day') LIMIT 1),
    (SELECT unnest(enum_range(NULL::COUPON_TYPE)) ORDER BY RANDOM() LIMIT 1),
    RANDOM() * 100000 + 1
FROM GENERATE_SERIES(1 * :cnt + 1, 2 * :cnt);
