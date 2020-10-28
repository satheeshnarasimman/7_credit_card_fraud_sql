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