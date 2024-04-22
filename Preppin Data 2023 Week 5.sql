with CTE as(
select 
split_part(transaction_code,'-',1) as Bank
,monthname(date(transaction_date, 'DD/MM/YYYY HH:MI:SS')) as Transaction_Month
,sum(value) as total_value
,rank() over (partition by Transaction_Month order by total_value DESC) as Rnk
from pd2023_wk01
group by 1,2
)

,avg_rank as(
select 
Bank
,avg(Rnk) as Avg_Rank
from CTE
group by Bank
)

, avg_value_per_rank as (
select 
Rnk
, avg(total_value) as avg_tran_per_rank
from CTE 
group by Rnk
)

select CTE.*
, Avg_Rank as "Avg Rank Per Bank"
, avg_tran_per_rank as "Avg Transaction Value Per Rank"
from CTE
inner join avg_rank as AR on CTE.Bank = AR.Bank
inner join avg_value_per_rank as AV on CTE.Rnk = AV.Rnk
