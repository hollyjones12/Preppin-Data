with CTE as (select quarter(Date(split_part(flight_details,'//',1), 'YYYY-MM-DD'))as Qtr
                    ,split_part(flight_details,'//',2) as flight_number
                    ,split_part(split_part(flight_details,'//',3),'-',1) as "FROM"
                    ,split_part(split_part(flight_details,'//',3),'-',2) as "TO"
                    ,split_part(flight_details,'//',4) as class
                    ,round(split_part(flight_details,'//',5),2) as price
                    ,iff(flow_card = 1, 'Yes','No') as flow_card
                    ,bags_checked
                    ,meal_type
            from PD2024_WK01
                    )

,min_price as (select
                Qtr
                ,flow_card
                ,class
                ,min(price) as min_price
                ,'Minimum' as Agg_unit
                from CTE
                group by Qtr, flow_card, class
                )

,med_price as (select
                Qtr
                ,flow_card
                ,class
                ,median(price) as med_price
                ,'Median' as Agg_unit
                from CTE
                group by Qtr, flow_card, class
                )

,max_price as (select Qtr
                    ,flow_card
                    ,class
                    ,max(price) as max_price
                    ,'Maximum' as Agg_unit
                    from CTE
                    group by Qtr, flow_card, class
                    )
,min_piv as (select *
            from min_price
            pivot (sum(min_price) for Class in ('Premium Economy', 'Economy', 'Business Class', 'First Class'))
            )
,med_piv as (select *
        from med_price as Med
        pivot (sum(med_price) for Class in ('Premium Economy', 'Economy', 'Business Class', 'First Class'))
            )
,max_piv as (select *
        from max_price as Med
        pivot (sum(max_price) for Class in ('Premium Economy', 'Economy', 'Business Class', 'First Class'))
            )
,Pivot_Union as (select * from min_piv
                union
                select * from med_piv
                union
                select * from max_piv
                )
select Flow_Card
,Qtr
,Round ("'First Class'",1) as Economy 
,Round ("'Business Class'",1) as Premium_Economy 
,Round ("'Premium Economy'",1) as Business_Class 
,Round ("'Economy'",1) as First_Class
,agg_unit as Aggregated_Unit
from Pivot_Union