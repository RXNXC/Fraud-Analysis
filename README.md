# Fraud-Analysis
Analysed a synthetic banking dataset of 6,270 transactions across 120 accounts and 15 merchants to investigate fraud patterns and answer four business questions on customer risk, fraud typology, repeat offences, and merchant exposure.

# Fraud Detection SQL Analysis

A end-to-end SQL analysis project simulating the workflow of a fraud analyst at a Nigerian commercial bank. Built on a synthetic dataset of 6,270 transactions across 120 customer accounts and 15 merchants, covering the full 2024 calendar year.

## Project Overview

The project investigates fraudulent transaction patterns across a Nigerian banking dataset and answers four core business questions:

1. Which account types and risk profiles carry the highest fraud rates?
2. Which fraud patterns are most prevalent and most costly?
3. Which accounts are repeat fraud targets, and are their credentials compromised?
4. Which merchants and channels are most exposed to fraud?

Dataset
Three tables form the analytical foundation:

| File | Rows | Description |
|---|---|---|
| `transactions.csv` | 6,270 | Every card, transfer, and ATM transaction |
| `accounts.csv` | 120 | Customer account profiles and risk labels |
| `merchants.csv` | 15 | Merchant reference data |

Six fraud patterns are embedded at a realistic 1.37% fraud rate:
- Geographic anomaly
- Round-amount structuring
- Velocity spike
- Odd-hour large transaction
- Unknown/unregistered vendor
- Foreign/cross-border transaction

Structure
├── datasets/
│ ├── transactions.csv
│ ├── accounts.csv
│ └── merchants.csv
├── fraud_analysis.sql # Data cleaning
├── fraud_analysis_question1.sql # Fraud rate by segment and channel
├── fraud_analysis_question2.sql # Fraud pattern breakdown
├── fraud_analysis_question3.sql # Repeat offender accounts
├── fraud_analysis_question4.sql # Merchant and channel exposure
└── documentation/
└── Fraud_Analysis_Documentation.pdf

Tools
- Database: MySQL
- Analysis: Window functions, CTEs, GROUP_CONCAT, correlated subqueries
- Domain: Financial services — fraud detection

Key Findings
- Current accounts and high-risk profiles carry the highest fraud rates, but medium-risk accounts generate the most total fraud cases by volume.
- Geographic anomaly is the most frequent fraud pattern; round-amount structuring produces the highest average transaction value per incident.
- Several repeat-offender accounts held Low or Medium risk labels at the time of the fraud, revealing a gap in the bank's existing risk scoring model.
- Unregistered merchants record fraud compositions approaching 100% — nearly every transaction through them is fraudulent.

Recommendations
- Require OTP for round-amount transfers above ₦200,000
- Block unregistered merchants; activate geo-velocity rules
- Freeze repeat-offender accounts, force re-KYC, recalibrate risk scoring model
