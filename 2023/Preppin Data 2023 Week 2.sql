select transaction_id
    ,concat('GB', check_digits,SWIFT_CODE,replace(sort_code,'-',''),account_number) as IBAN
from pd2023_wk02_transactions t
inner join pd2023_wk02_swift_codes s on s.bank = t.bank