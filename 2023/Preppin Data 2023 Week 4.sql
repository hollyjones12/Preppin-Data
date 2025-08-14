with CTE as (

    Select *, 'Pd2023_wk04_january' as table_name from PD2023_WK04_JANUARY
    UNION ALL
    Select *, 'Pd2023_wk04_february' as table_name from PD2023_WK04_FEBRUARY
    UNION ALL
    Select *, 'Pd2023_wk04_march' as table_name from PD2023_WK04_MARCH
    UNION ALL
    Select *, 'Pd2023_wk04_april' as table_name from PD2023_WK04_APRIL
    UNION ALL
    Select *, 'Pd2023_wk04_may' as table_name from PD2023_WK04_MAY
    UNION ALL
    Select *, 'Pd2023_wk04_june' as table_name from PD2023_WK04_JUNE
    UNION ALL
    Select *, 'Pd2023_wk04_july' as table_name from PD2023_WK04_JULY
    UNION ALL
    Select *, 'Pd2023_wk04_august' as table_name from PD2023_WK04_AUGUST
    UNION ALL
    Select *, 'Pd2023_wk04_september' as table_name from PD2023_WK04_SEPTEMBER
    UNION ALL
    Select *, 'Pd2023_wk04_october' as table_name from PD2023_WK04_OCTOBER
    UNION ALL
    Select *, 'Pd2023_wk04_november' as table_name from PD2023_WK04_NOVEMBER
    UNION ALL
    Select *, 'Pd2023_wk04_december' as table_name from PD2023_WK04_DECEMBER

),

pre_pivot as (

    select id,
        date_from_parts(2023,date_part('month',date(split_part(table_name,'_',3),'MMMM')),joining_day) as join_date,
        demographic,
        value,
    from CTE
),

table_pivot as (

    select id,
           join_date,
           ethnicity,
           account_type, 
           date_of_birth:: date as date_of_birth,
           row_number() over(partition by id order by join_date ASC) as rn
    from pre_pivot
    pivot(max(value) for demographic IN ('Ethnicity', 'Account Type', 'Date of Birth')) as P
     (id, 
      join_date,
      ethnicity,
      account_type,
      date_of_birth)
     )

      
select
    id,
    join_date,
    account_type,
    date_of_birth,
    ethnicity
from table_pivot
where rn = 1
