/* 	QUESTION 3: Focuses on Fraudulent Accounts and Transactions
	- Which accounts have had more than one fraudulent transactions, what channels did they use and
    - How does their fraud activity compare to their average legitimate transaction amount?
*/
/*repeat offenders, average legitimate transaction amounts, channels used - accounts with more than 1 fraud transactions, 
the channels they use and comparing their average legit transactions to their average fraud transaction amount */

WITH fraud_count AS (
	SELECT account_id, COUNT(*) as Total_fraud_txns
    FROM transactions
    WHERE is_fraud = 1
    GROUP BY account_id
),
repeat_offenders AS (
	SELECT account_id, Total_fraud_txns
    FROM fraud_count
    WHERE Total_fraud_txns > 1
),
avg_legit_txn_amt AS (
	SELECT t.account_id, 
			ROUND(avg(t.amount_ngn), 2) as avg_legit_amt
	FROM transactions t
    JOIN repeat_offenders ro
		ON t.account_id = ro.account_id
	WHERE is_fraud = 0
    GROUP BY account_id
),
channels_used AS (
	SELECT t.account_id, 
			GROUP_CONCAT(DISTINCT t.transaction_channel ORDER BY t.transaction_channel SEPARATOR ', ') AS channels
    FROM transactions t
    JOIN repeat_offenders ro
		ON t.account_id = ro.account_id
	WHERE is_fraud = 1
    GROUP BY account_id
)
SELECT ro.account_id, a.account_type, a.risk_profile, ro.Total_fraud_txns, cu.channels, al.avg_legit_amt,
		ROUND((SELECT AVG(amount_ngn) FROM transactions t WHERE t.account_id = ro.account_id and is_fraud = 1), 2) AS avg_fraud_txn_amt,
        ROUND((SELECT AVG(amount_ngn) FROM transactions t WHERE t.account_id = ro.account_id and is_fraud = 1) / 
			NULLIF(al.avg_legit_amt, 0), 2) AS Fraud_to_legit_ratio
FROM repeat_offenders ro
JOIN accounts a
	ON ro.account_id = a.account_id
JOIN avg_legit_txn_amt al
	ON ro.account_id = al.account_id
JOIN channels_used cu 
	ON ro.account_id = cu.account_id
ORDER BY Total_fraud_txns
;