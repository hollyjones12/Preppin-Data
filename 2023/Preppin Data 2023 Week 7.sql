with account_holders as (
        select 
        account_holder_id
        ,name
        ,date_of_birth
        ,('0'||contact_number) as contact_number
        ,first_line_of_address
        from pd2023_wk07_account_holders AH
)
,account_info as(
        select 
        account_number
        ,account_type
        ,trim(value) as Account_holder_id
        ,Balance_Date
        ,Balance
        from pd2023_wk07_account_information,
        lateral split_to_table(account_holder_id,',')
)
,filtered_tbl as (
    select 
    TP.TRANSACTION_ID
    ,TP.ACCOUNT_TO
    ,TD.TRANSACTION_DATE
    ,TD.VALUE
    ,AI.Account_Number
    ,AI.Account_Type
    ,AI.Balance_Date
    ,AI.Balance
    ,AH.name
    ,AH.Date_of_Birth
    ,AH.contact_number
    ,AH.First_Line_of_Address
    ,TD.CANCELLED_ as Cancelled
    from account_info AI
    inner join account_holders AH on AH.account_holder_id = AI.account_holder_id
    inner join pd2023_wk07_transaction_path TP on AI.account_number = TP.account_from
    inner join pd2023_wk07_transaction_detail TD on TP.transaction_id = TD.transaction_id
    Where Cancelled = 'N'
    AND value > 1000
    AND ACCOUNT_TYPE not like '%Platinum%'
)
select 
TRANSACTION_ID
,ACCOUNT_TO
,TRANSACTION_DATE
,VALUE
,Account_Number
,Account_Type
,Balance_Date
,Balance
,name
,Date_of_Birth
,contact_number
,first_Line_of_Address
from filtered_tbl