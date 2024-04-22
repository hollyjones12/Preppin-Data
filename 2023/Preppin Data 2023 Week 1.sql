select 
    split_part(transaction_code,'-',1) as Bank
    ,sum(value) as total_value
from pd2023_wk01
group by Bank



select 
    split_part(transaction_code,'-',1) as Bank
    ,iff(online_or_in_person = '1', 'Online', 'In Person') as "Online or InPerson"
    ,dayname(to_date(transaction_date,'DD/MM/YYYY HH:mi:ss')) as "Day of Week"
    , sum(value) as "Total Value"
from pd2023_wk01
group by 1,2,3


select 
    split_part(transaction_code,'-',1) as Bank
    , customer_code
    , sum(value) as "Total Value"
from pd2023_wk01
group by Bank, CUSTOMER_CODE
