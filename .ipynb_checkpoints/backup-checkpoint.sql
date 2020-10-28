-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/Eo2MG1
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


CREATE TABLE "card_holder" (
    "id" INT   NOT NULL,
    "name" VARCHAR(255)   NOT NULL,
    CONSTRAINT "pk_card_holder" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "credit_card" (
    "card" VARCHAR(20)   NOT NULL,
    "id_card_holder" INT   NOT NULL,
    CONSTRAINT "pk_credit_card" PRIMARY KEY (
        "card"
     )
);

CREATE TABLE "merchant_category" (
    "id" INT   NOT NULL,
    "name" VARCHAR(100)   NOT NULL,
    CONSTRAINT "pk_merchant_category" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "merchant" (
    "id" INT   NOT NULL,
    "name" VARCHAR(255)   NOT NULL,
    "id_merchant_category" INT   NOT NULL,
    CONSTRAINT "pk_merchant" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "transaction" (
    "id" INT   NOT NULL,
    "date" TIMESTAMP   NOT NULL,
    "amount" FLOAT   NOT NULL,
    "card" VARCHAR(20)   NOT NULL,
    "id_merchant" INT   NOT NULL,
    CONSTRAINT "pk_transaction" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "card_holder"
RENAME COLUMN "id" TO "ch_id";

ALTER TABLE "card_holder"
RENAME COLUMN "name" TO "ch_name";

ALTER TABLE "credit_card" 
RENAME COLUMN "id_card_holder" TO "ch_id";

ALTER TABLE "credit_card" 
ADD CONSTRAINT "fk_credit_card_id_card_holder" FOREIGN KEY("ch_id")
REFERENCES "card_holder" ("ch_id");

ALTER TABLE "merchant_category"
RENAME COLUMN "id" TO "mc_id";

ALTER TABLE "merchant_category"
RENAME COLUMN "name" TO "mer_cat_name";

ALTER TABLE "merchant" 
RENAME COLUMN "name" TO "mer_name";

ALTER TABLE "merchant" 
RENAME COLUMN "id" TO "id_merchant";

ALTER TABLE "merchant"
RENAME COLUMN "id_merchant_category" TO "mc_id";

ALTER TABLE "merchant"
ADD CONSTRAINT "fk_merchant_id_merchant_category" FOREIGN KEY("mc_id")
REFERENCES "merchant_category" ("mc_id");

ALTER TABLE "transaction"
RENAME COLUMN "id" to "txn_id";

ALTER TABLE "transaction" 
ADD CONSTRAINT "fk_transaction_card" FOREIGN KEY("card")
REFERENCES "credit_card" ("card");

ALTER TABLE "transaction" 
ADD CONSTRAINT "fk_transaction_id_merchant" FOREIGN KEY("id_merchant")
REFERENCES "merchant" ("id_merchant");

----------------------------------------------------------
-- Grouping the transactions for each customer. Select the name and merchants name
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

-- Money spent by each customer
CREATE VIEW customer_money AS
SELECT ch.ch_id, txn.amount
FROM card_holder as ch
LEFT JOIN credit_card as cc
    ON ch.ch_id= cc.ch_id
LEFT JOIN transaction as txn
    ON cc.card= txn.card
LEFT JOIN merchant as mer
    ON txn.id_merchant= mer.id_merchant
LEFT JOIN merchant_category as mc
    on mer.mc_id= mc.mc_id
GROUP BY ch.ch_id, txn.amount
ORDER BY ch.ch_id, txn.amount;

SELECT *
FROM customer_money;
-------------------------------------------------------------
-- Select the 100 highest transactions that occured between 7 AM- 9 AM
CREATE VIEW seven_nine AS
SELECT ch.ch_id, txn.amount, date_part ('hour', "date") AS seven_nine 
FROM card_holder as ch
LEFT JOIN credit_card as cc
    ON ch.ch_id= cc.ch_id
LEFT JOIN transaction as txn
    ON cc.card= txn.card
LEFT JOIN merchant as mer
    ON txn.id_merchant= mer.id_merchant
LEFT JOIN merchant_category as mc
    on mer.mc_id= mc.mc_id
WHERE date_part ('hour', "date") >=7 AND date_part ('hour', "date") <=9
GROUP BY ch.ch_id, txn.amount, date_part ('hour', "date")
ORDER BY txn.amount DESC
LIMIT 100;

SELECT *
FROM seven_nine;

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
GROUP BY mer.id_merchant, mer.mer_name
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

SELECT *
FROM fraud_25;

-- Querying the view by month and the first half of 2018
SELECT *, date_part ('month', txn_date) AS numeric_month
FROM fraud_25
WHERE txn_date BETWEEN '2018-01-01' AND '2018-06-30';