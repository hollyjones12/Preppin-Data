-- Table 1: Output for Card Holders

select
Date(split_part(flight_details,'//',1), 'YYYY-MM-DD') as Date
,split_part(flight_details,'//',2) as flight_number
,split_part(split_part(flight_details,'//',3),'-',1) as "FROM"
,split_part(split_part(flight_details,'//',3),'-',2) as "TO"
,split_part(flight_details,'//',4) as class
,round(split_part(flight_details,'//',5),2) as price
,iff(flow_card = 1, 'Yes','No') as Flow_Card
,bags_checked
,meal_type
from PD2024_WK01
Where Flow_Card = 1

--Table 2: Table for non-card holders

select
Date(split_part(flight_details,'//',1), 'YYYY-MM-DD') as Date
,split_part(flight_details,'//',2) as flight_number
,split_part(split_part(flight_details,'//',3),'-',1) as "FROM"
,split_part(split_part(flight_details,'//',3),'-',2) as "TO"
,split_part(flight_details,'//',4) as class
,round(split_part(flight_details,'//',5),2) as price
,iff(flow_card = 1, 'Yes','No') as Flow_Card
,bags_checked
,meal_type
from PD2024_WK01
Where Flow_Card = 0