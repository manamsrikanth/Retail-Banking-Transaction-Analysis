-- ============================================================
-- RETAIL BANKING TRANSACTION ANALYSIS
-- Database Setup - Sprint 2.1
-- ============================================================

-- 1. CREATE DATABASE
CREATE DATABASE Retail_Banking_DB;

USE Retail_Banking_DB;

-- ============================================================
-- 2. CUSTOMERS TABLE
-- ============================================================

CREATE TABLE Customers
(
    customer_id VARCHAR(20) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE,
    gender VARCHAR(20),
    city VARCHAR(50),
    state VARCHAR(30),
    customer_since DATE,
    kyc_status VARCHAR(20),
    segment VARCHAR(30),
    annual_income DECIMAL(12,2),
    credit_score INT,
    is_active VARCHAR(3)
);


-- ============================================================
-- 3. BRANCHES TABLE
-- ============================================================

CREATE TABLE Branches
(
    branch_id VARCHAR(10) PRIMARY KEY,
    branch_name VARCHAR(100) NOT NULL,
    city VARCHAR(50),
    state VARCHAR(30),
    region VARCHAR(30),
    opening_date DATE,
    employee_count INT
);


-- ============================================================
-- 4. ACCOUNTS TABLE
-- ============================================================

CREATE TABLE Accounts
(
    account_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20) NOT NULL,
    branch_id VARCHAR(10) NOT NULL,
    account_type VARCHAR(30),
    open_date DATE,
    close_date DATE,
    current_balance DECIMAL(15,2),
    interest_rate DECIMAL(5,2),
    overdraft_limit DECIMAL(12,2),
    status VARCHAR(20),

    CONSTRAINT FK_Account_Customer
        FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id),

    CONSTRAINT FK_Account_Branch
        FOREIGN KEY (branch_id)
        REFERENCES Branches(branch_id)
);


-- ============================================================
-- 5. LOANS TABLE
-- ============================================================

CREATE TABLE Loans
(
    loan_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20) NOT NULL,
    branch_id VARCHAR(10) NOT NULL,
    loan_type VARCHAR(30),
    original_amount DECIMAL(15,2),
    interest_rate DECIMAL(5,2),
    tenure_months INT,
    disbursement_date DATE,
    maturity_date DATE,
    emi_amount DECIMAL(12,2),
    outstanding_balance DECIMAL(15,2),
    loan_status VARCHAR(30),
    purpose VARCHAR(50),

    CONSTRAINT FK_Loan_Customer
        FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id),

    CONSTRAINT FK_Loan_Branch
        FOREIGN KEY (branch_id)
        REFERENCES Branches(branch_id)
);


-- ============================================================
-- 6. LOAN PAYMENTS TABLE
-- ============================================================

CREATE TABLE Loan_Payments
(
    payment_id VARCHAR(20) PRIMARY KEY,
    loan_id VARCHAR(20) NOT NULL,
    payment_date DATE,
    scheduled_amount DECIMAL(12,2),
    paid_amount DECIMAL(12,2),
    principal_paid DECIMAL(12,2),
    interest_paid DECIMAL(12,2),
    penalty DECIMAL(12,2),
    days_late INT,
    payment_method VARCHAR(30),
    status VARCHAR(20),

    CONSTRAINT FK_Payment_Loan
        FOREIGN KEY (loan_id)
        REFERENCES Loans(loan_id)
);


-- ============================================================
-- 7. CARDS TABLE
-- ============================================================

CREATE TABLE Cards
(
    card_id VARCHAR(20) PRIMARY KEY,
    account_id VARCHAR(20) NOT NULL,
    card_type VARCHAR(20),
    issue_date DATE,
    expiry_date DATE,
    credit_limit DECIMAL(12,2),
    outstanding_balance DECIMAL(12,2),
    reward_points INT,
    is_active VARCHAR(3),
    network VARCHAR(20),

    CONSTRAINT FK_Card_Account
        FOREIGN KEY (account_id)
        REFERENCES Accounts(account_id)
);


-- ============================================================
-- 8. TRANSACTIONS TABLE
-- ============================================================

CREATE TABLE Transactions
(
    transaction_id VARCHAR(20) PRIMARY KEY,
    account_id VARCHAR(20) NOT NULL,
    transaction_date DATE,
    transaction_time TIME,
    transaction_type VARCHAR(30),
    amount DECIMAL(15,2),
    channel VARCHAR(30),
    description VARCHAR(50),
    balance_after DECIMAL(15,2),
    status VARCHAR(20),

    CONSTRAINT FK_Transaction_Account
        FOREIGN KEY (account_id)
        REFERENCES Accounts(account_id)
);


-- ============================================================
-- 9. VERIFY TABLES
-- ============================================================

SHOW TABLES;


-- ============================================================
-- 10. CHECK TABLE STRUCTURES
-- ============================================================

DESCRIBE Customers;
select*from customers;

DESCRIBE Branches;
select*from branches;

DESCRIBE Accounts;
select*from accounts;

DESCRIBE Loans;
select*from loans;

DESCRIBE Loan_Payments;
select*from loan_payments;

DESCRIBE Cards;
select*from cards;

DESCRIBE Transactions;
select*from transactions;

-- ============================================================
-- Sprint 3:Basic Analysis / Data Exploration
-- ============================================================
-- 1. Total number of customers
SELECT COUNT(*) AS total_customers
FROM customers;

-- ============================================================

-- 2. Total number of accounts
SELECT COUNT(*) AS total_accounts
FROM accounts;

--  ============================================================

-- 3. Different account types available
SELECT DISTINCT account_type
FROM accounts;

-- If we need count too

SELECT account_type, COUNT(*) AS total_accounts
FROM accounts
GROUP BY account_type;

-- ============================================================

-- 4. How many customers are currently active?
select distinct count(customer_id) from customers where is_active = 'Yes';

-- ============================================================

-- 5. Different transaction types available
SELECT DISTINCT transaction_type
FROM transactions;

 -- If we need Count:

SELECT
    transaction_type,
    COUNT(*) AS total_transactions
FROM transactions
GROUP BY transaction_type;

-- ============================================================

-- 6. Total amount of completed transactions
SELECT SUM(amount) AS total_completed_transaction_amount
FROM transactions
WHERE status = 'Completed';

-- ============================================================

-- 7. Different loan types available
SELECT DISTINCT loan_type
FROM loans;

-- If we need count:

SELECT
    loan_type,
    COUNT(*) AS total_loans
FROM loans
GROUP BY loan_type;

-- ============================================================

-- 8. Total number of loans
SELECT COUNT(*) AS total_loans
FROM loans;

-- ============================================================

-- 9. Different card types available
SELECT DISTINCT card_type
FROM cards;

-- If we need count:

SELECT
    card_type,
    COUNT(*) AS total_cards
FROM cards
GROUP BY card_type;

-- ============================================================

-- 10. Total outstanding loan balance
SELECT SUM(outstanding_balance) AS total_outstanding_loan_balance
FROM loans;

-- ============================================================
-- Sprint 4: Objective-Based Analysis
-- ============================================================

-- 4.1 Understand Customer Profile and Segmentation

-- Q1. How many customers belong to each customer segment?
-- Answer: This analysis shows the size of each customer segment and helps the bank understand which customer groups are more prominent.
SELECT
    segment,
    COUNT(*) AS total_customers
FROM customers
GROUP BY segment
ORDER BY total_customers DESC;

-- ============================================================

-- Q2. Which cities have the highest number of customers?
-- Answer: The city-wise comparison identifies areas where the bank has a stronger customer presence and helps in regional planning.
SELECT
    city,
    COUNT(*) AS total_customers
FROM customers
GROUP BY city
ORDER BY total_customers DESC;

-- ============================================================

-- Q3. How are customers distributed across different states?
-- Answer: State-wise analysis shows the bank’s customer reach across different regions and highlights areas with a larger customer base.
select*from customers;
SELECT
    state,
    COUNT(*) AS total_customers
FROM customers
GROUP BY state
ORDER BY total_customers DESC;

-- ============================================================

-- Q4. How do customers differ based on their income levels?
-- Answer: Grouping customers by income helps the bank understand their financial profile and identify suitable products for different customer groups.
SELECT
    segment,
    COUNT(*) AS total_customers,
    AVG(annual_income) AS average_income
FROM customers
GROUP BY segment
ORDER BY total_customers DESC;

-- ============================================================

-- Q5. How are customers distributed based on credit score?
-- Answer: Credit-score analysis helps the bank understand the overall credit profile of its customers and supports better lending decisions.
SELECT
   segment,avg(credit_score) as average_credit_score
FROM customers
GROUP BY segment
ORDER BY average_credit_score DESC;
select*from customers;

-- ============================================================

-- Q6. How many customers are currently active with the bank?
-- Answer: This shows the size of the active customer base and gives an indication of ongoing customer engagement.
SELECT
    COUNT(DISTINCT customer_id) AS active_customers
FROM accounts
WHERE status = 'Active';

-- ============================================================

-- Q7. What is the distribution of customers based on KYC status?
-- Answer: KYC analysis helps identify customers with completed or pending verification and highlights areas requiring follow-up.
SELECT
    kyc_status,
    COUNT(*) AS total_customers
FROM customers
GROUP BY kyc_status
ORDER BY total_customers DESC;

-- ============================================================

-- Q8. How long have customers been associated with the bank?
-- Answer: Customer tenure analysis helps distinguish new customers from long-term customers and provides an understanding of customer retention.    
    SELECT
    customer_id,
    customer_since,
    TIMESTAMPDIFF(YEAR, customer_since, CURDATE()) AS years_with_bank
FROM customers;

-- ============================================================

-- Q9. How do customer income and credit scores vary across different locations?
-- Answer: Combining demographic and financial information helps identify differences in customer profiles across locations.
SELECT
    city,
    COUNT(*) AS total_customers,
    AVG(annual_income) AS average_income,
    AVG(credit_score) AS average_credit_score
FROM customers
GROUP BY city
ORDER BY total_customers DESC;

-- ============================================================

-- Q10. What are the major characteristics of the bank’s customer base?
-- Answer: The analysis provides an overall view of customer demographics, financial profiles, activity levels, KYC status, and tenure, helping the bank understand its customer base more effectively.
SELECT
    state,
    COUNT(*) AS total_customers,
    AVG(annual_income) AS average_income,
    AVG(credit_score) AS average_credit_score
FROM customers
GROUP BY state
ORDER BY average_income DESC, average_credit_score DESC;

-- ============================================================
-- 4.2 Understand Account Usage and Branch Activity
-- ============================================================
-- Q1. How are accounts distributed across different account types?
SELECT
    account_type,
    COUNT(*) AS total_accounts
FROM accounts
GROUP BY account_type
ORDER BY total_accounts DESC;

-- ============================================================

-- Q2. How many accounts does each customer hold?
SELECT
    customer_id,
    COUNT(account_id) AS total_accounts
FROM accounts
GROUP BY customer_id
ORDER BY total_accounts DESC;

-- ============================================================

-- Q3. What is the average account balance for each account type?
SELECT
    account_type,
    AVG(current_balance) AS average_balance
FROM accounts
GROUP BY account_type
ORDER BY average_balance DESC;

-- ============================================================

-- Q4. Which account types have the highest and lowest average balances?
SELECT
    account_type,
    AVG(current_balance) AS average_balance
FROM accounts
GROUP BY account_type
ORDER BY average_balance DESC;

-- ============================================================

-- Q5. How does account activity differ across branches?
SELECT
    branch_id,
    COUNT(account_id) AS total_accounts
FROM accounts
GROUP BY branch_id
ORDER BY total_accounts DESC;

-- ============================================================

-- Q6. Which branches have the highest average account balance?
SELECT
    branch_id,
    AVG(current_balance) AS average_balance
FROM accounts
GROUP BY branch_id
ORDER BY average_balance DESC;

-- ============================================================

-- Q7. How do interest rates vary across different account types?
SELECT
    account_type,
    AVG(interest_rate) AS average_interest_rate,
    MAX(interest_rate) AS maximum_interest_rate,
    MIN(interest_rate) AS minimum_interest_rate
FROM accounts
GROUP BY account_type
ORDER BY average_interest_rate DESC;

-- ============================================================

-- Q8. How many accounts are active and closed?
SELECT
    status,
    COUNT(account_id) AS total_accounts
FROM accounts
GROUP BY status
ORDER BY total_accounts DESC;

-- ============================================================

-- Q9. What is the average balance of active and closed accounts?
SELECT
    status,
    AVG(current_balance) AS average_balance
FROM accounts
GROUP BY status
ORDER BY average_balance DESC;

-- ============================================================

-- Q10. Which branches have the highest number of active accounts?
SELECT
    branch_id,
    COUNT(account_id) AS active_accounts
FROM accounts
WHERE status = 'Active'
GROUP BY branch_id
ORDER BY active_accounts DESC;

-- ============================================================

-- Q11. Which account type has the highest total balance?
SELECT
    account_type,
    SUM(current_balance) AS total_balance
FROM accounts
GROUP BY account_type
ORDER BY total_balance DESC;

-- ============================================================

-- Q12. Which customers have more than one account?
SELECT
    customer_id,
    COUNT(account_id) AS total_accounts
FROM accounts
GROUP BY customer_id
HAVING COUNT(account_id) > 1
ORDER BY total_accounts DESC;

-- ============================================================
-- 4.3 Analyze Transaction Patterns
-- ============================================================
-- 1. What are the most common transaction types?
SELECT
    transaction_type,
    COUNT(*) AS total_transactions
FROM transactions
GROUP BY transaction_type
ORDER BY total_transactions DESC;

-- ============================================================

-- 2. How do transactions vary across different channels?
SELECT
    channel,
    COUNT(*) AS total_transactions
FROM transactions
GROUP BY channel
ORDER BY total_transactions DESC;

-- ============================================================

-- 3. What is the total transaction amount for each transaction type?
SELECT
    transaction_type,
    SUM(amount) AS total_transaction_amount
FROM transactions
GROUP BY transaction_type
ORDER BY total_transaction_amount DESC;

-- ============================================================

-- 4. What are the average, maximum, and minimum transaction amounts for each transaction type?
SELECT
    transaction_type,
    AVG(amount) AS average_amount,
    MAX(amount) AS maximum_amount,
    MIN(amount) AS minimum_amount
FROM transactions
GROUP BY transaction_type
ORDER BY average_amount DESC;

-- ============================================================

-- 5. Which transaction descriptions occur most frequently?
SELECT
    description,
    COUNT(*) AS total_transactions
FROM transactions
GROUP BY description
ORDER BY total_transactions DESC;

-- ============================================================

-- 6. How does transaction activity change over time?
SELECT
    YEAR(transaction_date) AS transaction_year,
    MONTH(transaction_date) AS transaction_month,
    COUNT(*) AS total_transactions,
    SUM(amount) AS total_transaction_amount
FROM transactions
GROUP BY
    YEAR(transaction_date),
    MONTH(transaction_date)
ORDER BY transaction_year, transaction_month;

-- ============================================================

-- 7. Which accounts have the highest transaction activity?
SELECT
    account_id,
    COUNT(transaction_id) AS total_transactions,
    SUM(amount) AS total_transaction_amount
FROM transactions
GROUP BY account_id
ORDER BY total_transactions DESC;

-- ============================================================

-- 8. Which transaction channels generate the highest transaction amounts?
SELECT
    channel,
    COUNT(*) AS total_transactions,
    SUM(amount) AS total_transaction_amount,
    AVG(amount) AS average_transaction_amount
FROM transactions
GROUP BY channel
ORDER BY total_transaction_amount DESC;

-- ============================================================

-- 9. What is the transaction status distribution?
SELECT
    status,
    COUNT(*) AS total_transactions,
    SUM(amount) AS total_transaction_amount
FROM transactions
GROUP BY status
ORDER BY total_transactions DESC;

-- ============================================================

-- 10. How does transaction activity vary across customers?
SELECT
    a.customer_id,
    COUNT(t.transaction_id) AS total_transactions,
    SUM(t.amount) AS total_transaction_amount,
    AVG(t.amount) AS average_transaction_amount
FROM accounts a
JOIN transactions t
    ON a.account_id = t.account_id
GROUP BY a.customer_id
ORDER BY total_transactions DESC;

-- ============================================================

-- 11. How does transaction activity affect account balances?
SELECT
    account_id,
    COUNT(transaction_id) AS total_transactions,
    SUM(amount) AS total_transaction_amount,
    MAX(balance_after) AS highest_balance,
    MIN(balance_after) AS lowest_balance
FROM transactions
GROUP BY account_id
ORDER BY total_transaction_amount DESC;

-- ============================================================

-- 12. Which customers have the highest total transaction value?
SELECT
    a.customer_id,
    SUM(t.amount) AS total_transaction_amount
FROM accounts a
JOIN transactions t
    ON a.account_id = t.account_id
GROUP BY a.customer_id
ORDER BY total_transaction_amount DESC
LIMIT 10;

-- ============================================================
-- 4.4 Evaluate Loan Performance and Repayment Behaviour
-- ============================================================

-- 1. How are loans distributed across different loan types?
SELECT
    loan_type,
    COUNT(*) AS total_loans
FROM loans
GROUP BY loan_type
ORDER BY total_loans DESC;

-- ============================================================

-- 2. What are the most common purposes for which customers take loans?
SELECT
    purpose,
    COUNT(*) AS total_loans
FROM loans
GROUP BY purpose
ORDER BY total_loans DESC;

-- ============================================================

-- 3. What is the average, maximum, and minimum loan amount for each loan type?
SELECT
    loan_type,
    AVG(original_amount) AS average_loan_amount,
    MAX(original_amount) AS maximum_loan_amount,
    MIN(original_amount) AS minimum_loan_amount
FROM loans
GROUP BY loan_type
ORDER BY average_loan_amount DESC;

-- ============================================================

-- 4. What is the total outstanding balance for each loan type?
SELECT
    loan_type,
    SUM(outstanding_balance) AS total_outstanding_balance
FROM loans
GROUP BY loan_type
ORDER BY total_outstanding_balance DESC;

-- ============================================================

-- 5. How are loans distributed based on their current status?
SELECT
    loan_status,
    COUNT(*) AS total_loans
FROM loans
GROUP BY loan_status
ORDER BY total_loans DESC;

-- ============================================================

-- 6. Which loan types have the highest interest rates?
SELECT
    loan_type,
    AVG(interest_rate) AS average_interest_rate,
    MAX(interest_rate) AS maximum_interest_rate,
    MIN(interest_rate) AS minimum_interest_rate
FROM loans
GROUP BY loan_type
ORDER BY average_interest_rate DESC;

-- ============================================================

-- 7. Which branches have the highest loan activity?
SELECT
    branch_id,
    COUNT(loan_id) AS total_loans,
    SUM(original_amount) AS total_loan_amount
FROM loans
GROUP BY branch_id
ORDER BY total_loan_amount DESC;

-- ============================================================

-- 8. Which loan types have the highest outstanding balance?
SELECT
    loan_type,
    SUM(outstanding_balance) AS total_outstanding_balance
FROM loans
GROUP BY loan_type
ORDER BY total_outstanding_balance DESC;

-- ============================================================

-- 9. What is the average EMI amount for each loan type?
SELECT
    loan_type,
    AVG(emi_amount) AS average_emi_amount
FROM loans
GROUP BY loan_type
ORDER BY average_emi_amount DESC;

-- ============================================================

-- 10. Which loans are currently close to their maturity date?
SELECT
    loan_id,
    loan_type,
    maturity_date,
    outstanding_balance
FROM loans
WHERE maturity_date <= DATE_ADD(CURDATE(), INTERVAL 6 MONTH)
ORDER BY maturity_date;

-- ============================================================

-- 11. Which branches have the highest outstanding loan balance?
SELECT
    branch_id,
    COUNT(loan_id) AS total_loans,
    SUM(outstanding_balance) AS total_outstanding_balance
FROM loans
GROUP BY branch_id
ORDER BY total_outstanding_balance DESC;

-- ============================================================

-- 12. Which loan types have the highest average outstanding balance?
SELECT
    loan_type,
    AVG(outstanding_balance) AS average_outstanding_balance
FROM loans
GROUP BY loan_type
ORDER BY average_outstanding_balance DESC;

-- ============================================================
-- 4.5 Understand Card Usage and Product Engagement
-- ============================================================

-- 1. How are cards distributed across different card types?
SELECT
    card_type,
    COUNT(*) AS total_cards
FROM cards
GROUP BY card_type
ORDER BY total_cards DESC;

-- ============================================================

-- 2. How are cards distributed across different networks?
SELECT
    network,
    COUNT(*) AS total_cards
FROM cards
GROUP BY network
ORDER BY total_cards DESC;

-- ============================================================

-- 3. How many cards are active and inactive?
SELECT
    is_active,
    COUNT(*) AS total_cards
FROM cards
GROUP BY is_active
ORDER BY total_cards DESC;

-- ============================================================

-- 4. What is the average credit limit for each card type?
SELECT
    card_type,
    AVG(credit_limit) AS average_credit_limit,
    MAX(credit_limit) AS maximum_credit_limit,
    MIN(credit_limit) AS minimum_credit_limit
FROM cards
GROUP BY card_type
ORDER BY average_credit_limit DESC;

-- ============================================================

-- 5. What is the outstanding balance for each card type?
SELECT
    card_type,
    SUM(outstanding_balance) AS total_outstanding_balance,
    AVG(outstanding_balance) AS average_outstanding_balance
FROM cards
GROUP BY card_type
ORDER BY total_outstanding_balance DESC;

-- ============================================================

-- 6. Which card types provide the highest average reward points?
SELECT
    card_type,
    AVG(reward_points) AS average_reward_points,
    MAX(reward_points) AS maximum_reward_points
FROM cards
GROUP BY card_type
ORDER BY average_reward_points DESC;

-- ============================================================

-- 7. How many cards does each account have?
SELECT
    account_id,
    COUNT(card_id) AS total_cards
FROM cards
GROUP BY account_id
ORDER BY total_cards DESC;

-- ============================================================

-- 8. Which accounts have multiple cards?
SELECT
    account_id,
    COUNT(card_id) AS total_cards
FROM cards
GROUP BY account_id
HAVING COUNT(card_id) > 1
ORDER BY total_cards DESC;

-- ============================================================

-- 9. Which customers use multiple banking products?
SELECT
    c.customer_id,
    COUNT(DISTINCT a.account_id) AS total_accounts,
    COUNT(DISTINCT ca.card_id) AS total_cards,
    COUNT(DISTINCT l.loan_id) AS total_loans
FROM customers c
LEFT JOIN accounts a
    ON c.customer_id = a.customer_id
LEFT JOIN cards ca
    ON a.account_id = ca.account_id
LEFT JOIN loans l
    ON c.customer_id = l.customer_id
GROUP BY c.customer_id
HAVING total_accounts > 1
    OR total_cards > 1
    OR total_loans > 1
ORDER BY total_accounts DESC, total_cards DESC, total_loans DESC;

-- ============================================================

-- 10. How does card usage vary across different account types?
SELECT
    a.account_type,
    COUNT(c.card_id) AS total_cards
FROM accounts a
JOIN cards c
    ON a.account_id = c.account_id
GROUP BY a.account_type
ORDER BY total_cards DESC;

-- ============================================================

-- 11. How many customers have both cards and loans?
SELECT
    COUNT(DISTINCT c.customer_id) AS customers_with_cards_and_loans
FROM customers c
JOIN accounts a
    ON c.customer_id = a.customer_id
JOIN cards ca
    ON a.account_id = ca.account_id
JOIN loans l
    ON c.customer_id = l.customer_id;
    
-- ============================================================
    
-- 12. Which customers have cards, accounts, and loans?
SELECT
    c.customer_id,
    COUNT(DISTINCT a.account_id) AS total_accounts,
    COUNT(DISTINCT ca.card_id) AS total_cards,
    COUNT(DISTINCT l.loan_id) AS total_loans
FROM customers c
JOIN accounts a
    ON c.customer_id = a.customer_id
JOIN cards ca
    ON a.account_id = ca.account_id
JOIN loans l
    ON c.customer_id = l.customer_id
GROUP BY c.customer_id
ORDER BY total_cards DESC, total_loans DESC;

-- ============================================================
-- ========================THE END=============================
-- ============================================================