CREATE TABLE Investor_login (
    investor_id SERIAL PRIMARY KEY,
    phone_number TEXT,
    password VARCHAR(100)
);

CREATE TABLE Investor_info (
    investor_id INTEGER PRIMARY KEY,
    name TEXT,
    lastname TEXT,
    experience INTEGER,
    FOREIGN KEY (investor_id) REFERENCES Investor_login(investor_id)
);

CREATE TABLE Currency(
    currency_id SERIAL PRIMARY KEY,
    country TEXT
);

CREATE TABLE Currency_value(
    first_currency INTEGER,
    second_currency INTEGER,
    cost INTEGER,
    PRIMARY KEY (first_currency, second_currency),
    FOREIGN KEY (first_currency) REFERENCES Currency(currency_id),
    FOREIGN KEY (second_currency) REFERENCES Currency(currency_id)
);

CREATE TYPE OPERATION_TYPE AS ENUM('BUY', 'SALE');

CREATE TABLE Wallet(
    wallet_id SERIAL PRIMARY KEY,
    currency_id INTEGER,
    profitability FLOAT,
    FOREIGN KEY (currency_id) REFERENCES Currency(currency_id)
);

CREATE TABLE Investor_history(
    history_id SERIAL PRIMARY KEY,
    investor_id INTEGER,
    wallet_id INTEGER,
    paper_id INTEGER,
    operation OPERATION_TYPE,
    current_time_stamp TIMESTAMP,
    FOREIGN KEY (investor_id) REFERENCES Investor_login(investor_id),
    FOREIGN KEY (wallet_id) REFERENCES Wallet(wallet_id)
);

CREATE TABLE Investor_wallet(
    investor_id INTEGER,
    wallet_id INTEGER,
    PRIMARY KEY (investor_id, wallet_id),
    FOREIGN KEY (investor_id) REFERENCES Investor_login(investor_id),
    FOREIGN KEY (wallet_id) REFERENCES Wallet(wallet_id)
);

CREATE TABLE Wallet_security_paper(
    wallet_id INTEGER,
    paper_id INTEGER,
    PRIMARY KEY (wallet_id, paper_id),
    FOREIGN KEY (wallet_id) REFERENCES Wallet(wallet_id)
);

CREATE TABLE Stocks(
    paper_id INTEGER PRIMARY KEY,
    currency_id INTEGER,
    lot INTEGER,
    opening_price FLOAT,
    closing_price FLOAT,
    dividend_percent FLOAT,
    FOREIGN KEY (currency_id) REFERENCES Currency(currency_id)
);

CREATE TYPE ASSET AS ENUM('STOCK', 'BOND', 'COMMODITY', 'CURRENCY', 'INDEX');

CREATE TYPE CONTRACT_TYPE AS ENUM('BILLING', 'DELIVERY');

CREATE TYPE COUPON_TYPE AS ENUM('Plain Vanilla', 'Zero-Coupon', 'Deferred Coupon', 'Step-Up', 'Step Down', 'Floating Rate',
    'Inverse Floaters', 'Participatory', 'Income', 'Payment in Kind', 'Extendable', 'Extendable Reset', 'Perpetual', 'Convertible',
    'Foreign currency convertible', 'Exchangeable', 'Callable', 'Puttable', 'Treasury Strips', 'Yankee', 'Samurai');

CREATE TABLE Bonds(
    paper_id INTEGER PRIMARY KEY,
    repayment_date DATE,
    coupon_date DATE,
    coupon_type COUPON_TYPE,
    coupon_value FLOAT
);