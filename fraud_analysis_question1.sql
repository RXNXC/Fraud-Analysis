/* 	QUESTION 1 
	- Which account types, risk profiles and transaction channels have the highest fraud rates.
    - What share of total transaction value do fraudulent transactions represent.
*/

/* Columns needed account_type, risk_profile, fraud_rate(calculated on the fly)....*/

/* Steps: 1. Join transactions on accounts using account_id.*/
SELECT *
FROM accounts a
	JOIN transactions t
	ON a.account_id = t.account_id
;

/* 2. Check if there's any account_id in accounts but not in transactions and vice versa.*/
SELECT 
	a.account_id as accts_id, 
	t.account_id as txns_id
FROM accounts a
	JOIN transactions t
	ON a.account_id = t.account_id
WHERE t.account_id NOT IN (
	SELECT a.account_id
    FROM accounts) 
OR a.account_id NOT IN (
	SELECT t.account_id
    FROM transactions)
;

/* 3. Calculate fraud rate then check which account_types, risk_profiles and transaction_channels have the highest rates.
	Fraud rate = 100 * fraud_txns_count/total_txn_count	
*/
SELECT account_type,
	ROUND(100 * SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END)/COUNT(*), 2) AS fraud_rate
FROM accounts a
	JOIN transactions t
	ON a.account_id = t.account_id
GROUP BY account_type
ORDER BY fraud_rate DESC
;

SELECT risk_profile,
	ROUND(100 * SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END)/COUNT(*), 2) AS fraud_rate
FROM accounts a
	JOIN transactions t
	ON a.account_id = t.account_id
GROUP BY risk_profile
ORDER BY fraud_rate DESC
;

SELECT transaction_channel,
	ROUND(100 * SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END)/COUNT(*), 2) AS fraud_rate
FROM accounts a
	JOIN transactions t
	ON a.account_id = t.account_id
GROUP BY transaction_channel
ORDER BY fraud_rate DESC
;

/* Calculating the total transaction value as well as fraud_txns_val and finding its share value, then segment by acct_type, channel, flag_reason.*/
#total amount transacted.
SELECT ROUND(SUM(amount_ngn), 2) AS Total_txns_val
FROM transactions
;

#total value of fraud trasactions.
SELECT ROUND(SUM(amount_ngn), 2) AS Fraud_txns_val
FROM transactions
WHERE is_fraud = 1;

/* Fraud_txn_val percentage of total transactions.*/
SELECT 
    ROUND((100 * ((SELECT ROUND(SUM(amount_ngn), 2) AS Fraud_txns_val
			FROM transactions
			WHERE is_fraud = 1)) / 
	ROUND(SUM(amount_ngn), 2)), 2) AS Fraud_txns_val_pct
FROM transactions
;

/*Segmetation.*/
#By account type
SELECT account_type,
	ROUND((100 * ((SELECT ROUND(SUM(amount_ngn), 2) AS Fraud_txns_val
			FROM transactions
			WHERE is_fraud = 1)) / 
	ROUND(SUM(amount_ngn), 2)), 2) AS Fraud_txns_val_pct
FROM accounts a
	JOIN transactions t
	ON a.account_id = t.account_id
GROUP BY account_type
;

#By Channel
SELECT transaction_channel, 
	CONCAT(ROUND((100 * ((SELECT ROUND(SUM(amount_ngn), 2)
			FROM transactions
			WHERE is_fraud = 1)) / 
	ROUND(SUM(amount_ngn), 2)), 2), '%') AS Fraud_txns_vol_pct
FROM accounts a
	JOIN transactions t
	ON a.account_id = t.account_id
GROUP BY transaction_channel
ORDER BY Fraud_txns_vol_pct DESC
;