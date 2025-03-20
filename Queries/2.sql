explain analyze select 
	paper_id,
	max(current_cost) - min(current_cost)
from security_paper
group by paper_id
order by max(current_cost) - min(current_cost) desc
limit 1;