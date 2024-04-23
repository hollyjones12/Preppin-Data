with CTE as (
    select *,1 as file from pd2023_wk08_01
    union all
    select *,2 as file from pd2023_wk08_02
    union all
    select *,3 as file from pd2023_wk08_03
    union all
    select *,4 as file from pd2023_wk08_04
    union all
    select *,5 as file from pd2023_wk08_05
    union all
    select *,6 as file from pd2023_wk08_06
    union all
    select *,7 as file from pd2023_wk08_07
    union all
    select *,8 as file from pd2023_wk08_08
    union all
    select *,9 as file from pd2023_wk08_09
    union all
    select *,10 as file from pd2023_wk08_10
    union all
    select *,11 as file from pd2023_wk08_11
    union all
    select *,12 as file from pd2023_wk08_12
)
    , categories as(
    select *
    ,date_from_parts('2023',file,1) as File_Date
    ,Case
    when
    ((substr(market_cap,2,length(market_cap)-2))::float *
    (case
    when right(market_cap,1)='B' then 100000000
    when right(market_cap,1)='M' then 1000000 
    end))<100000000 then 'Small'
    when
    ((substr(market_cap,2,length(market_cap)-2))::float *
    (case
    when right(market_cap,1)='B' then 100000000
    when right(market_cap,1)='M' then 1000000 
    end))<1000000000 then 'Medium'
    when
    ((substr(market_cap,2,length(market_cap)-2))::float *
    (case
    when right(market_cap,1)='B' then 100000000
    when right(market_cap,1)='M' then 1000000 
    end))<100000000000 then 'Large'
    else 'Huge'
    end as market_cap_cat
    ,case
    when (substr(purchase_price,2,length(purchase_price)))::float <25000 then 'Low'
    when (substr(purchase_price,2,length(purchase_price)))::float <50000 then 'Medium'
    when (substr(purchase_price,2,length(purchase_price)))::float <75000 then 'High'
    when (substr(purchase_price,2,length(purchase_price)))::float <100000 then 'Low'
    end as price_cat
    from CTE
    where market_cap <> 'n/a'
    )
    ,ranked as (
    select *
    ,RANK()OVER(partition by file_date, market_cap_cat, price_cat order by
    (substr(purchase_price,2,length(purchase_price)))::float DESC) as rnk
    from categories
    )
    select
    market_cap_cat
    ,price_cat
    ,file_date
    ,ticker
    ,sector
    ,market
    ,stock_name
    ,market_cap
    ,purchase_price
    ,rnk as Rank
    from ranked
    where rnk <= 5
