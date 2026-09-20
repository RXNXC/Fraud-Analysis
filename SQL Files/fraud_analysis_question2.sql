/* 	QUESTION 2: Focuses on Fraudulent Transactions
	- Which fraud types are most prevalent
    - What is the average transaction by fraud type
*/

#Transaction Count by Fraud Type
SELECT 
	fraud_flag_reason, 
    COUNT(*) AS Fraud_count,
    CONCAT(ROUND(COUNT(*) / SUM(COUNT(*)) OVER() * 100, 2), '%') AS pct_of_all_fraud,
    ROUND(SUM(amount_ngn), 2) AS total_transacted,
    ROUND(AVG(amount_ngn), 2) AS avg_amt_per_txn,
    ROUND(MAX(amount_ngn), 2) AS maximum_amt_per_fraud_type,
    ROUND(MIN(amount_ngn), 2) AS minimum_amt_per_fraud_type
FROM Transactions
WHERE is_fraud = 1
GROUP BY fraud_flag_reason
ORDER BY Fraud_count DESC
;
