explain analyze select distinct 
	inv_inf.name, 
	inv_inf.lastname
from investor_info as inv_inf
inner join investor_history as inv_h
on inv_inf.investor_id = inv_h.investor_id
where date_trunc('month', inv_h.current_time_stamp::date) = date_trunc('month', current_date);