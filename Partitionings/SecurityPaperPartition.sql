ALTER TABLE Security_paper RENAME to security_paper_old;

CREATE TABLE security_paper_master(
    paper_id INTEGER,
    current_time_stamp TIMESTAMP,
    current_cost FLOAT,
    PRIMARY KEY (paper_id, current_time_stamp)
) PARTITION BY RANGE (current_time_stamp);

create or replace view security_paper as select * from security_paper_master;

create or replace rule autoCall_createPartitionIfNotExists as on insert to security_paper
do instead 
(
    select createPartitionIfNotExists(NEW.current_time_stamp);
    insert into security_paper_master(paper_id, current_time_stamp, current_cost) values (NEW.paper_id, NEW.current_time_stamp, NEW.current_cost)
);

insert into security_paper(paper_id, current_time_stamp, current_cost) select * from security_paper_old;
drop table security_paper_old;