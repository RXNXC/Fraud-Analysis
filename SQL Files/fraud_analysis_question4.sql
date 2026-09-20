/* Question 4 - Which merchants and transaction channels are most associated with fraud, and (merchants and channels vs fraud rate)
				what percentage of each merchant's total transaction volume is fraudulent?" (merchant_id, total txn, fraud txn and %fraud composition)
*/

/* Channels associated with fraud*/
WITH total_amt_per_channel AS (
	SELECT transaction_channel, ROUND(SUM(amount_ngn), 2) AS Total_amt
    FROM transactions
    GROUP BY transaction_channel
),
fraud_amt_per_channel AS(
	SELECT transaction_channel, ROUND(SUM(amount_ngn), 2) AS Fraud_amt
    FROM transactions
    WHERE is_fraud = 1
    GROUP BY transaction_channel
)
SELECT tc.transaction_channel, tc.total_amt, fc.Fraud_amt, 
		ROUND(100 * fc.Fraud_amt / tc.Total_amt, 2) AS Fraud_pct
FROM total_amt_per_channel tc
JOIN fraud_amt_per_channel fc 
	ON tc.transaction_channel = fc.transaction_channel
;

/*Merchants associated mostly with fraud*/
SELECT m.merchant_name, m.merchant_id, m.is_registered, 
		GROUP_CONCAT(DISTINCT t.account_id ORDER BY t.account_id SEPARATOR ', ') as merchant_accounts,
        GROUP_CONCAT(DISTINCT t.transaction_channel ORDER BY t.transaction_channel SEPARATOR ', ') as Channels_Used,
        count(DISTINCT t.account_id) AS No_of_accts, 
        ROUND((SELECT SUM(t.amount_ngn) FROM transactions t WHERE t.merchant_id = m.merchant_id),2) AS Total_amt,
        ROUND((SELECT SUM(t.amount_ngn) FROM transactions t WHERE t.merchant_id = m.merchant_id AND is_fraud = 1),2) AS Fraud_amt,
        ROUND((100 * (SELECT SUM(t.amount_ngn) FROM transactions t WHERE t.merchant_id = m.merchant_id AND is_fraud = 1) / 
				(SELECT SUM(t.amount_ngn) FROM transactions t WHERE t.merchant_id = m.merchant_id)), 2) AS Pct_Fraud_comp
FROM transactions t
JOIN merchants m
	ON t.merchant_id = m.merchant_id
JOIN accounts a
	ON t.account_id = a.account_id
WHERE t.merchant_id = m.merchant_id and t.is_fraud = 1
GROUP BY m.merchant_name, m.merchant_id, m.is_registered
ORDER BY No_of_accts DESC
;
