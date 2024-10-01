WITH CTE AS(
SELECT
SPLIT_PART(transaction_code,'-',1) AS Bank
,MONTHNAME(DATE(transaction_date, 'DD/MM/YYYY HH:MI:SS')) AS Transaction_Month
,SUM(value) as total_value
,RANK() OVER (PARTITION BY Transaction_Month ORDER BY total_value DESC) AS Rnk
FROM pd2023_wk01
GROUP BY 1,2
)

,avg_rank AS(
SELECT
Bank
,AVG(Rnk) AS Avg_Rank
FROM CTE
GROUP BY Bank
)

, avg_value_per_rank AS (
SELECT
Rnk
, avg(total_value) AS avg_tran_per_rank
FROM CTE 
GROUP BY Rnk
)

SELECT CTE.*
, Avg_Rank AS "Avg Rank Per Bank"
, ROUND(avg_tran_per_rank,2) AS "Avg Transaction Value Per Rank"
FROM CTE
INNER JOIN avg_rank AS AR ON CTE.Bank = AR.Bank
INNER JOIN avg_value_per_rank AS AV ON CTE.Rnk = AV.Rnk
