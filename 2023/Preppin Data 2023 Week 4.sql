with CTE as(
    select * 
    ,'PD2023_WK04_JANUARY' as tablename 
    from PD2023_WK04_JANUARY 
    Union
    select * 
    ,'PD2023_WK04_FEBRUARY' as tablename 
    from PD2023_WK04_FEBRUARY 
    Union
    select * 
    ,'PD2023_WK04_MARCH' as tablename
    from PD2023_WK04_MARCH 
    Union
    select * 
    ,'PD2023_WK04_APRIL' as tablename 
    from PD2023_WK04_APRIL 
    Union all
    select * 
    ,'PD2023_WK04_MAY' as tablename 
    from PD2023_WK04_MAY 
    Union all
    select * 
    ,'PD2023_WK04_JUNE' as tablename 
    from PD2023_WK04_JUNE 
    Union all
    select *
    ,'PD2023_WK04_JULY' as tablename 
    from PD2023_WK04_JULY 
    Union all
    select * 
    ,'PD2023_WK04_AUGUST' as tablename 
    from PD2023_WK04_AUGUST
    Union all
    select *
    ,'PD2023_WK04_SEPTEMBER' as tablename 
    from PD2023_WK04_SEPTEMBER
    Union all
    select *
    ,'PD2023_WK04_OCTOBER' as tablename 
    from PD2023_WK04_OCTOBER 
    Union all
    select * 
    ,'PD2023_WK04_NOVEMBER' as tablename 
    from PD2023_WK04_NOVEMBER
    Union all
    select *
    ,'PD2023_WK04_DECEMBER' as tablename 
    from PD2023_WK04_DECEMBER
 )
 
,unpivoted_table as (
select
id
,date_from_parts(2023,date_part('month', date(split_part(tablename,'_',3),'MMMM')),joining_day) as joining_date
,demographic
,value
from CTE
)

,pivoted_table as (
select
id
,joining_date
,ethnicity
,account_type
,date_of_birth::date as date_of_birth
,row_number() over(partition by id order by joining_date ASC) as row_num
from unpivoted_table
pivot (Max(value) for demographic in ('Ethnicity', 'Account Type', 'Date of Birth')) as P 
(id
,joining_date
,ethnicity
,account_type
,date_of_birth
))

select
joining_date
,account_type
,date_of_birth
,ethnicity
from pivoted_table
where row_num = 1