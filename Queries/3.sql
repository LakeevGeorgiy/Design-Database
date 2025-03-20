explain analyze select 
	inv_inf.investor_id,
	inv_h.paper_id
from investor_info as inv_inf
inner join investor_history as inv_h
on inv_inf.investor_id = inv_h.investor_id
where inv_inf.investor_id = 10000;