explain analyze select
	inv_inf.name,
	inv_inf.lastname,
	w.profitability,
	inv_wal.wallet_id
from investor_info as inv_inf
	inner join investor_wallet as inv_wal
	on inv_inf.investor_id = inv_wal.investor_id
	inner join wallet as w
	on inv_wal.wallet_id = w.wallet_id
order by w.profitability desc
limit 100;