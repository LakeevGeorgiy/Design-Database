explain analyze with first_date_in_year as 
(
	select 
		date_trunc('year', current_time_stamp::date) as "current_year",
		st.paper_id,
		min(current_time_stamp) as "min_date"
	from stocks as st
	inner join security_paper as sp
	on st.paper_id = sp.paper_id
	group by date_trunc('year', current_time_stamp::date), st.paper_id
	order by date_trunc('year', current_time_stamp::date)
)

select 
	fd.current_year,
	fd.min_date,
	fd.paper_id,
	st.dividend_percent,
	sp.current_cost,
	st.dividend_percent * sp.current_cost as "dividend"
from first_date_in_year as fd
inner join security_paper as sp
on fd.paper_id = sp.paper_id and fd.min_date = sp.current_time_stamp
inner join stocks as st
on sp.paper_id = st.paper_id;