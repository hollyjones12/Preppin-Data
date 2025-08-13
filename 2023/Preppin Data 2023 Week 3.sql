with base_transactions as(

    select
        iff(online_or_in_person = 1, 'Online', 'In-Person') as online_in_person,
        quarter(date(transaction_date:: varchar,'dd/mm/yyyy HH:mi:ss')) as quarter,
        sum(value) as value
    from PD2023_WK01
    where startswith(transaction_code,'DSB')
    group by online_or_in_person, quarter

),

target_pivot as (

    select *,
    from PD2023_WK03_TARGETS
    unpivot (target for target_quarter IN (Q1, Q2, Q3, Q4)),
    order by online_or_in_person
),

targets as (

    select 
        online_or_in_person as online_in_person,
        right(target_quarter, 1) as quarter,
        target    
    from target_pivot
    
),

quarterly_trans as (

    select 
        base_transactions.*,
        targets.target,
    from base_transactions
    inner join targets
        on targets.online_in_person = base_transactions.online_in_person
        and targets.quarter = base_transactions.quarter

)

Select *,
(VALUE - TARGET) as variance_of_target
from quarterly_trans
