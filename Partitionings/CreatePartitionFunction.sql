-- create function createPartitionIfNotExists(current_time_stamp TIMESTAMP) returns void
-- as $body$

-- declare yearStart date := date_trunc('year', current_time_stamp::date);
-- declare yearEnd date := yearStart + INTERVAL '1 year';
-- declare tableName text := 'Security_paper_' || to_char(yearStart, 'YYYY');

-- begin
--     if to_regclass(tableName) is NULL then
--         execute format('create table %I partition of Security_paper_master for values from (%L) to (%L)', tableName, yearStart, yearEnd);
--     end if;
-- end; 
-- $body$ language plpgsql;

create function createPartitionIfNotExists(current_time_stamp TIMESTAMP) returns void
as $body$
declare monthStart date := date_trunc('year', current_time_stamp::date);
    declare monthEndExclusive date := monthStart + interval '1 year';
    -- We infer the name of the table from the date that it should contain
    -- E.g. a date in June 2005 should be int the table mytable_200506:
    declare tableName text := 'security_paper_' || to_char(current_time_stamp::date, 'YYYY');
begin
    -- Check if the table we need for the supplied date exists.
    -- If it does not exist...:
    if to_regclass(tableName) is null then
        -- Generate a new table that acts as a partition for mytable:
        execute format('create table %I partition of security_paper_master for values from (%L) to (%L)', tableName, monthStart, monthEndExclusive);
        -- Unfortunatelly Postgres forces us to define index for each table individually:
        --execute format('create unique index on %I (current_time_stamp, key2)', tableName);
    end if;
end;
$body$ language plpgsql;