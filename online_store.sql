CREATE DATABASE IF NOT EXISTS online_store;
CREATE ROLE rd_group, rd_wrt_group;
GRANT SELECT ON online_store.* TO rd_group;
GRANT SELECT, INSERT, UPDATE, DELETE ON online_store.* TO rd_wrt_group;
CREATE USER rifky@localhost IDENTIFIED BY 'pass103';
CREATE USER wendy@localhost IDENTIFIED BY 'pass103';
CREATE USER miriam@localhost IDENTIFIED BY 'pass103';
GRANT rd_group, rd_wrt_group TO rifky@localhost, wendy@localhost;
GRANT rd_group TO miriam@localhost;
SHOW GRANTS FOR wendy@localhost USING rd_wrt_group;
CREATE USER devora@localhost IDENTIFIED BY 'pass103';
GRANT ALL privileges ON online_store.* TO devora@localhost;
SET DEFAULT ROLE ALL TO wendy@localhost, rifky@localhost;
SET DEFAULT ROLE ALL TO miriam@localhost;

USE online_store;
CREATE TABLE IF NOT EXISTS customer(
customer_id MEDIUMINT NOT NULL AUTO_INCREMENT,
last_name varchar(50) NOT NULL, 
first_name varchar(50) NOT NULL,
street varchar(75) NOT NULL,
floor DECIMAL (10,1) SIGNED,
neighborhood_id  MEDIUMINT NOT NULL,
delivery_note VARCHAR(250),
email VARCHAR(200),
CONSTRAINT pk_customer_id PRIMARY KEY(customer_id)
);
CREATE TABLE IF NOT EXISTS neighborhood(
neighborhood_id  MEDIUMINT NOT NULL AUTO_INCREMENT,
neighborhood VARCHAR (100) NOT NULL,
delivery_cost TINYINT NOT NULL,
CONSTRAINT pk_neighborhood_id PRIMARY KEY(neighborhood_id )
);
ALTER TABLE customer ADD CONSTRAINT fk_neighborhood_id
FOREIGN KEY (neighborhood_id) REFERENCES neighborhood(neighborhood_id);
CREATE TABLE IF NOT EXISTS phone(
phone_id MEDIUMINT NOT NULL AUTO_INCREMENT,
customer_id MEDIUMINT NOT NULL,
phone_number VARCHAR (20),
CONSTRAINT pk_phone_id PRIMARY KEY(phone_id),
CONSTRAINT fk_cusotmer_id FOREIGN KEY(customer_id) REFERENCES customer(customer_id)
);
CREATE TABLE IF NOT EXISTS orders(
order_id MEDIUMINT NOT NULL AUTO_INCREMENT,
customer_id MEDIUMINT NOT NULL,
order_total_price DECIMAL(10, 2),
billing_id MEDIUMINT NOT NULL,
time_order TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
CONSTRAINT pk_order_id PRIMARY KEY(order_id),
CONSTRAINT fko_cusotmer_id FOREIGN KEY(customer_id) REFERENCES customer(customer_id)
);
CREATE TABLE IF NOT EXISTS billing(
billing_id MEDIUMINT NOT NULL AUTO_INCREMENT,
billing_type ENUM ('paypal', 'cc'),
cc_num BIGINT,
cc_name VARCHAR(50),
cc_exp DATE,
cc_cvc MEDIUMINT, 
cc_type ENUM ('visa', 'mc', 'amex', 'diner', 'isracard'),
paypal_email VARCHAR(200),
address VARCHAR(75),
city VARCHAR(50),
state VARCHAR(75),
country VARCHAR(75),
postal_code VARCHAR(75),
CONSTRAINT pk_billing_id PRIMARY KEY(billing_id)
);
ALTER TABLE orders ADD CONSTRAINT fko_billing_id
FOREIGN KEY (billing_id) REFERENCES billing(billing_id);

CREATE TABLE IF NOT EXISTS order_item(
order_item_id MEDIUMINT NOT NULL AUTO_INCREMENT,
order_id MEDIUMINT NOT NULL,
product_id MEDIUMINT NOT NULL,
quantity_ordered TINYINT NOT NULL DEFAULT 0,
product_total_price DECIMAL(10, 2) NOT NULL,
CONSTRAINT pk_order_item_id PRIMARY KEY(order_item_id),
CONSTRAINT fkoi_order_id FOREIGN KEY(order_id) REFERENCES orders(order_id)
);
CREATE TABLE IF NOT EXISTS product(
product_id MEDIUMINT NOT NULL AUTO_INCREMENT,
product_name VARCHAR(100) NOT NULL,
cost DECIMAL (10,2) NOT NULL,
size VARCHAR(20) NOT NULL,
color VARCHAR(20) NOT NULL,
sale_price DECIMAL (10, 2) DEFAULT 0,
quantity_inventory MEDIUMINT UNSIGNED DEFAULT 0,
CONSTRAINT pk_product_id PRIMARY KEY(product_id)
);

ALTER TABLE order_item ADD CONSTRAINT fkoi_product_id
FOREIGN KEY (product_id) REFERENCES product(product_id);




