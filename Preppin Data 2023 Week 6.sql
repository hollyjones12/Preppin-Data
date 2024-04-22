
with CTE as (
    select *
    from pd2023_wk06_dsb_customer_survey
    unpivot (ratings for Category in (mobile_app___ease_of_access
                    ,mobile_app___ease_of_use
                    ,mobile_app___navigation
                    ,mobile_app___likelihood_to_recommend
                    ,mobile_app___overall_rating
                    ,online_interface___ease_of_use
                    ,online_interface___ease_of_access
                    ,online_interface___navigation
                    ,online_interface___likelihood_to_recommend
                    ,online_interface___overall_rating))
    order by customer_id
    )
    , pre_pivot as (
        select 
        customer_id
        ,replace(split_part(Category,'__',1),'_',' ') as Application
        ,replace(split_part(Category,'__',2), '_',' ') as Category
        ,ratings
        from CTE
        )
    , pivoted as (
        select *
        from pre_pivot   
        pivot (sum(Ratings) for Application in ('MOBILE APP', 'ONLINE INTERFACE'))
        as P (Customer_id, Category, mobile_app, online_interface)
        where CATEGORY not ilike '%OVERALL%'
        )
    , avg_rating as (
        select
        customer_id
        ,avg(mobile_app) as avg_mobile
        ,avg(online_interface) as avg_online
        , avg_mobile - avg_online as online_mobile_diff
        from pivoted
        group by customer_id
        )
    , preference as (
        select *
        , (Case
        when online_mobile_diff >= 2 Then 'Mobile App Superfan'
        when online_mobile_diff >= 1 Then 'Mobile App Fan'   
        when online_mobile_diff <= -2 Then 'Online Interface Superfan'  
        when online_mobile_diff <= -1 Then 'Online Interface Fan'
        else 'Neutral'
        end) as Preference
        from avg_rating
        )
        
        select 
        preference
        ,round((count(*) / (select count(*) from preference))*100,1) as "Percent of Total"
        from preference
        group by Preference
        