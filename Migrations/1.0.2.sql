CREATE TABLE Security_paper(
    paper_id INTEGER,
    current_time_stamp TIMESTAMP,
    current_cost FLOAT,
    PRIMARY KEY (paper_id, current_time_stamp)
);