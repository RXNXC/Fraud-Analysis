/* __Data Cleaning Process__
1. Check for duplicates.
2. Standardising the data.
3. Handling NULL values.
4. Removing any inconsequential column(s)
*/

/* 1. Checking for Duplicates.*/
SELECT *
FROM
	(SELECT *, 
		ROW_NUMBER() OVER(PARTITION BY transaction_id, account_id, transaction_date, 
		amount_ngn, merchant_id, merchant_name, merchant_category, transaction_channel, 
		transaction_location, account_home_city, is_fraud, fraud_flag_reason) as r_num
	FROM transactions) AS Duplicates
WHERE r_num > 1
;

/* 2. Standardising the data in each table.*/
/* Removing whitespaces: accounts table.*/
UPDATE accounts
SET 
account_id = TRIM(account_id),
city = TRIM(city),
account_type = TRIM(account_type),
risk_profile = TRIM(risk_profile)
;

/* Removing whitspaces: merchants table.*/
UPDATE merchants
SET
merchant_id = TRIM(merchant_id),
merchant_name = TRIM(merchant_name),
merchant_category = TRIM(merchant_category),
country = TRIM(country)
;

/* Removing whitspaces: transactions table.*/
UPDATE transactions
SET
transaction_id = TRIM(transaction_id),
account_id = TRIM(account_id),
merchant_id = TRIM(merchant_id),
merchant_name = TRIM(merchant_name),
merchant_category = TRIM(merchant_category),
transaction_channel = TRIM(transaction_channel),
transaction_location = TRIM(transaction_location),
account_home_city = TRIM(account_home_city),
fraud_flag_reason = TRIM(fraud_flag_reason)
;

/*Formatting date column form text to date format*/
/*Checking the number of times each date occurs*/
SELECT transaction_date, COUNT(*) as occurences
FROM transactions
GROUP BY transaction_date
HAVING COUNT(*) = 1
ORDER BY transaction_date
;

/*Adding a datetime column*/
ALTER TABLE transactions
ADD COLUMN txn_date DATETIME;

/*Adding datetime to the new date column*/
UPDATE transactions
SET txn_date = STR_TO_DATE(transaction_date, '%Y-%m-%d %H:%i:%s');

/*Checking for dates that failed*/
SELECT transaction_id, txn_date
FROM transactions
WHERE txn_date IS NULL
;

/*Removing the initial datetime column*/
ALTER TABLE transactions
DROP COLUMN transaction_date;

/*Renaming the newly created datetime column to the initial one*/
ALTER TABLE transactions
RENAME COLUMN txn_date TO transaction_date;

/* 3. Checking Nulls values and handling them(if any)*/
/*accounts table*/
SELECT 
	SUM(CASE WHEN account_id IS NULL THEN 1 ELSE 0 END) as null_id,
    SUM(CASE WHEN age IS NULL THEN 1 ELSE 0 END) as null_age,
    SUM(CASE WHEN city IS NULL THEN 1 ELSE 0 END) as null_city,
    SUM(CASE WHEN account_type IS NULL THEN 1 ELSE 0 END) as null_acc_type,
    SUM(CASE WHEN avg_monthly_balance IS NULL THEN 1 ELSE 0 END) as null_bal,
    SUM(CASE WHEN risk_profile IS NULL THEN 1 ELSE 0 END) as null_risk_profile
FROM accounts
;

/*merchants table*/
SELECT 
	SUM(CASE WHEN merchant_id IS NULL THEN 1 ELSE 0 END) as null_id,
    SUM(CASE WHEN merchant_name IS NULL THEN 1 ELSE 0 END) as null_name,
    SUM(CASE WHEN merchant_category IS NULL THEN 1 ELSE 0 END) as null_category,
    SUM(CASE WHEN is_registered IS NULL THEN 1 ELSE 0 END) as null_register,
    SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) as null_country
FROM merchants
;

/*transactions table*/
SELECT 
	SUM(CASE WHEN transaction_id IS NULL THEN 1 ELSE 0 END) as null_id,
    SUM(CASE WHEN account_id IS NULL THEN 1 ELSE 0 END) as null_acc_id,
    SUM(CASE WHEN merchant_id IS NULL THEN 1 ELSE 0 END) as null_merch_id,
    SUM(CASE WHEN merchant_name IS NULL THEN 1 ELSE 0 END) as null_name,
    SUM(CASE WHEN merchant_category IS NULL THEN 1 ELSE 0 END) as null_category,
    SUM(CASE WHEN transaction_channel IS NULL THEN 1 ELSE 0 END) as null_channel,
    SUM(CASE WHEN transaction_location IS NULL THEN 1 ELSE 0 END) as null_location,
    SUM(CASE WHEN account_home_city IS NULL THEN 1 ELSE 0 END) as null_home,
    SUM(CASE WHEN is_fraud IS NULL THEN 1 ELSE 0 END) as null_fraud,
    SUM(CASE WHEN fraud_flag_reason IS NULL THEN 1 ELSE 0 END) as null_reason,
    SUM(CASE WHEN transaction_date IS NULL THEN 1 ELSE 0 END) as null_date
FROM transactions
;
