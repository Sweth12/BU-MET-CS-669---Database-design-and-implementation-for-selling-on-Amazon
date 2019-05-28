-- ASPECT 1: 
-- Table creations:

CREATE TABLE new_product(
product_id DECIMAL(10) NOT NULL PRIMARY KEY,
product_name VARCHAR(30),
product_category VARCHAR(40),
product_description VARCHAR(200),
price DECIMAL(12,2)
);

CREATE TABLE seller(
seller_id DECIMAL(10) NOT NULL PRIMARY KEY,
seller_name VARCHAR(30)
);

CREATE TABLE prod_seller_inventory(
inv_id DECIMAL(10) NOT NULL PRIMARY KEY,
product_id DECIMAL(10),
seller_id DECIMAL(10),
prod_count DECIMAL(10),
prod_condition VARCHAR(10),
FOREIGN KEY (product_id) REFERENCES new_product,
FOREIGN KEY (seller_id) REFERENCES seller
);

-- Stored Procedure:

create or replace PROCEDURE add_products_new(
product_id_arg IN DECIMAL,
product_name_arg IN VARCHAR,
product_category_arg IN VARCHAR,
product_description_arg IN VARCHAR,
price_arg IN DECIMAL,
inv_id_arg IN DECIMAL,
seller_id_arg IN DECIMAL,
seller_name_arg IN VARCHAR,
prod_count_arg IN DECIMAL,
prod_condition_arg IN VARCHAR)
AS
BEGIN
INSERT INTO new_product (product_id,product_name,product_category,product_description,price)
VALUES (product_id_arg,product_name_arg,product_category_arg,product_description_arg,price_arg);
INSERT INTO seller(seller_id,seller_name)
VALUES(seller_id_arg,seller_name_arg);
INSERT INTO prod_seller_inventory(inv_id,product_id,seller_id,prod_count,prod_condition)
VALUES(inv_id_arg,product_id_arg,seller_id_arg,prod_count_arg,prod_condition_arg);
END;

-- Trigger:

create or replace TRIGGER PRODUCT_CHECKING 
BEFORE INSERT ON new_product 
FOR EACH ROW
DECLARE 
decx new_product.product_description%TYPE;
BEGIN
FOR i IN (SELECT product_description INTO decx FROM new_product WHERE product_description=:new.product_description)
LOOP
RAISE_APPLICATION_ERROR(-20000, 'Already in database');
END LOOP;
END;



-- ASPECT 2:
-- Table creation:

CREATE TABLE delivery(
delivery_id DECIMAL(10) NOT NULL PRIMARY KEY,
inv_id DECIMAL(10) NOT NULL,
delivery_count DECIMAL(10) NOT NULL,
FOREIGN KEY (inv_id) REFERENCES prod_seller_inventory
);

-- Stored Procedure:

create or replace PROCEDURE deliver_products(
delivery_id_arg IN DECIMAL,
inv_id_arg IN DECIMAL,
delivery_count_arg IN DECIMAL
)
AS
BEGIN
INSERT INTO delivery(delivery_id,inv_id,delivery_count)
VALUES (delivery_id_arg,inv_id_arg,delivery_count_arg);
UPDATE prod_seller_inventory
SET prod_count=(prod_count-delivery_count_arg)
WHERE inv_id=inv_id_arg;
END;



-- ASPECT 3:
-- Table creation:

CREATE TABLE customer_account(
customer_id DECIMAL(10) NOT NULL PRIMARY KEY,
customer_firstname VARCHAR(50) NOT NULL,
customer_lastname VARCHAR(50) NOT NULL,
customer_email VARCHAR(255) NOT NULL
);

-- Stored procedure:

create or replace PROCEDURE create_customer_account(
customer_id_arg IN DECIMAL,
customer_firstname_arg IN VARCHAR,
customer_lastname_arg IN VARCHAR,
customer_email_arg IN VARCHAR
)
AS
BEGIN
INSERT INTO customer_account(customer_id,customer_firstname,customer_lastname,customer_email)
VALUES (customer_id_arg,customer_firstname_arg,customer_lastname_arg,customer_email_arg);
END;


-- ASPECT 4:
-- Table creation:

CREATE TABLE orders(
order_id DECIMAL(10) NOT NULL PRIMARY KEY,
delivery_id DECIMAL(10),
customer_id DECIMAL(10),
order_count DECIMAL(10),
FOREIGN KEY (delivery_id) REFERENCES delivery,
FOREIGN KEY (customer_id) REFERENCES customer_account
);

-- Stored procedure:

create or replace PROCEDURE purchase_products(
order_id_arg IN DECIMAL,
delivery_id_arg IN DECIMAL,
customer_id_arg IN DECIMAL,
order_count_arg IN DECIMAL
)
AS
BEGIN
INSERT INTO orders(order_id,delivery_id,customer_id,order_count)
VALUES (order_id_arg,delivery_id_arg,customer_id_arg,order_count_arg);
UPDATE delivery
SET delivery_count=(delivery_count-order_count_arg)
WHERE delivery_id=delivery_id_arg;
END;


-- ASPECT 5:
-- Table creation:

CREATE TABLE shipment(
shipment_id DECIMAL(10) NOT NULL PRIMARY KEY,
shipment_speed VARCHAR(30) NOT NULL,
date_of_arrival DATE,
tracking_id DECIMAL(38) NOT NULL,
order_id DECIMAL(10) NOT NULL,
FOREIGN KEY (order_id) REFERENCES orders
);

-- Stored procedure:

create or replace PROCEDURE shipping_products(
shipment_id_arg IN DECIMAL,
shipment_speed_arg IN VARCHAR,
date_of_arrival_arg IN DATE,
tracking_id_arg IN DECIMAL,
order_id_arg IN DECIMAL
)
AS
BEGIN
INSERT INTO shipment(shipment_id,shipment_speed,date_of_arrival,tracking_id,order_id)
VALUES(shipment_id_arg,shipment_speed_arg,date_of_arrival_arg,tracking_id_arg,order_id_arg);
END;















