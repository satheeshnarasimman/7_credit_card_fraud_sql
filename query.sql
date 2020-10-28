-- View all the tables
SELECT *
FROM card_holder;

SELECT *
FROM credit_card;

SELECT *
FROM merchant_category;

SELECT *
FROM merchant;

SELECT *
FROM transaction;

--------------------------------------------------------------
-- Perform a left join to merge the data 
SELECT *
FROM card_holder as ch
LEFT JOIN credit_card as cc
    ON ch.ch_id= cc.ch_id
LEFT JOIN transaction as txn
    ON cc.card= txn.card
LEFT JOIN merchant as mer
    ON txn.id_merchant= mer.id_merchant
LEFT JOIN merchant_category as mc
    ON mer.mc_id= mc.mc_id;

----------------------------------------------------------
-- Grouping the transactions for each customer
CREATE VIEW customer_grouping AS
SELECT ch.ch_id, txn.id_merchant, SUM(amount)
FROM card_holder as ch
LEFT JOIN credit_card as cc
    ON ch.ch_id= cc.ch_id
LEFT JOIN transaction as txn
    ON cc.card= txn.card
LEFT JOIN merchant as mer
    ON txn.id_merchant= mer.id_merchant
LEFT JOIN merchant_category as mc
    on mer.mc_id= mc.mc_id
GROUP BY ch.ch_id, txn.id_merchant
ORDER BY SUM (amount) DESC;

SELECT *
FROM customer_grouping;

-------------------------------------------------------------
-- Select the 100 highest transactions that occured between 7 AM- 9 AM
CREATE VIEW seven_nine_txn100 AS
SELECT ch.ch_id, txn.amount, date_trunc ('hour', date) AS seven_nine 
FROM card_holder as ch
LEFT JOIN credit_card as cc
    ON ch.ch_id= cc.ch_id
LEFT JOIN transaction as txn
    ON cc.card= txn.card
LEFT JOIN merchant as mer
    ON txn.id_merchant= mer.id_merchant
LEFT JOIN merchant_category as mc
    on mer.mc_id= mc.mc_id
WHERE date between '2018-01-01 07:00:00- 09:00:00' AND '2018-12-31 07:00:00- 09:00:00'
GROUP BY ch.ch_id, txn.amount, date_trunc ('hour', date)
ORDER BY txn.amount DESC
LIMIT 100; 

----------------------------------------------------
-- Count the transactions less than $2 per cardholder
CREATE VIEW low_txn_cust AS
SELECT ch.ch_id AS card_holder_id, COUNT(txn.amount) as low_txn
FROM card_holder as ch
LEFT JOIN credit_card as cc
    ON ch.ch_id= cc.ch_id
LEFT JOIN transaction as txn
    ON cc.card= txn.card
LEFT JOIN merchant as mer
    ON txn.id_merchant= mer.id_merchant
LEFT JOIN merchant_category as mc
    on mer.mc_id= mc.mc_id
WHERE txn.amount< 2.00
GROUP BY ch.ch_id
ORDER BY COUNT(txn.amount) DESC;

SELECT *
FROM low_txn_cust;

----------------------------------------------------
-- Top 5 merchants prone to being hacked
CREATE VIEW low_txn_merc AS
SELECT mer.id_merchant AS merchant_id, COUNT(txn.amount) as low_txn, mer.mer_name
FROM card_holder as ch
LEFT JOIN credit_card as cc
    ON ch.ch_id= cc.ch_id
LEFT JOIN transaction as txn
    ON cc.card= txn.card
LEFT JOIN merchant as mer
    ON txn.id_merchant= mer.id_merchant
LEFT JOIN merchant_category as mc
    on mer.mc_id= mc.mc_id
WHERE txn.amount< 2.00
GROUP BY mer.id_merchant
ORDER BY COUNT(txn.amount) DESC
LIMIT 5;

SELECT *
FROM low_txn_merc;

------------------------------------------------------------
-- Fraudulent transactions for card holder id's 2 and 18
CREATE VIEW fraud_218 AS
SELECT ch.ch_id as holder_id, txn.amount as fraud_txn, txn.date as txn_date
FROM card_holder as ch
LEFT JOIN credit_card as cc
    ON ch.ch_id= cc.ch_id
LEFT JOIN transaction as txn
    ON cc.card= txn.card
LEFT JOIN merchant as mer
    ON txn.id_merchant= mer.id_merchant
LEFT JOIN merchant_category as mc
    ON mer.mc_id= mc.mc_id
WHERE ch.ch_id= 2 OR ch.ch_id= 18
GROUP BY ch.ch_id, txn.date, txn.amount
ORDER BY txn.amount DESC;

-- Querying the view to find fraud txn for 2 and 18
SELECT *
FROM fraud_218;

SELECT *
FROM fraud_218
WHERE holder_id= 2;

SELECT *
FROM fraud_218
WHERE holder_id= 18;

------------------------------------------------
-- Transactions in the first-half of 2018 for customer id 25
CREATE VIEW fraud_25 AS
SELECT ch.ch_id as holder_id, txn.amount as fraud_txn, txn.date as txn_date
FROM card_holder as ch
LEFT JOIN credit_card as cc
    ON ch.ch_id= cc.ch_id
LEFT JOIN transaction as txn
    ON cc.card= txn.card
LEFT JOIN merchant as mer
    ON txn.id_merchant= mer.id_merchant
LEFT JOIN merchant_category as mc
    ON mer.mc_id= mc.mc_id
WHERE ch.ch_id= 25
GROUP BY ch.ch_id, txn.date, txn.amount
ORDER BY txn.amount DESC;

-- Querying the view by month and the first half of 2018
SELECT *, date_part ('month', txn_date) AS numeric_month
FROM fraud_25
WHERE txn_date BETWEEN '2018-01-01' AND '2018-06-30';;

-- Might not be necessary
-- January 2018
SELECT *
FROM fraud_25
WHERE txn_date BETWEEN '2018-01-01' AND '2018-01-31';

-- February 2018
SELECT *
FROM fraud_25
WHERE txn_date BETWEEN '2018-02-01' AND '2018-02-28';

-- March 2018
SELECT *
FROM fraud_25
WHERE txn_date BETWEEN '2018-03-01' AND '2018-03-31';

-- April 2018
SELECT *
FROM fraud_25
WHERE txn_date BETWEEN '2018-04-01' AND '2018-04-30';

-- May 2018
SELECT *
FROM fraud_25
WHERE txn_date BETWEEN '2018-05-01' AND '2018-05-31';

-- June 2018
SELECT *
FROM fraud_25
WHERE txn_date BETWEEN '2018-06-01' AND '2018-06-30';
