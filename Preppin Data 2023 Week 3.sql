with CTE as(
    select     
    iff (online_or_in_person ='1', 'Online', 'In-Person') as Online_In_Person
    , date_part('quarter',date(transaction_date, 'DD/MM/YYYY HH:MI:SS')) as quarter
    , sum(value) as total_value
    from pd2023_wk01
where split_part(transaction_code,'-',1) = 'DSB'
group by online_or_in_person, quarter
)
select 
    online_or_in_person
    ,replace(t.quarter, 'Q','') as Quarter
    ,Target
    ,v.total_value as "Total Value"
    , v.total_value - target as "Variance From Target"
from pd2023_wk03_targets t
    unpivot (target
        for quarter in (Q1,Q2,Q3,Q4))
inner join cte as v on t.online_or_in_person = v.online_in_person
and replace(t.quarter, 'Q','') = v.quarter
