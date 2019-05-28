-- ASPECT 1:
-- Stored procedure invocations:

BEGIN
add_products_new(1000,'self-driving video camera','Electronics','automatically follows subject being recorded',28,1,100,'canon',100,'new');
END;
/

BEGIN
add_products_new(1001,'holographic keyboard','Computers','3d keyboard that recognizes virtual key presses from typist',25,2,101,'AGS',70,'new');
END;
/

BEGIN
add_products_new(1002,'black cardigan','Clothing','f21 layered cardigan',14,3,102,'forever21',30,'new');
END;
/

BEGIN
add_products_new(1004,'hard drive','Electronics','sandisk 1tb harddisk',60,4,104,'sandisk',35,'new');
END;
/

BEGIN
add_products_new(1005,'hp laptop','Computers','hp 360x touch screen laptop',899,5,105,'HP',20,'new');
END;
/

BEGIN
add_products_new(1006,'lenovo laptop','Computers','lenovo touch screen laptop',499,6,106,'lenovo',40,'new');
END;
/

BEGIN
add_products_new(1007,'black jacket','Clothing','north face jacket',80,7,107,'north face',30,'new');
END;
/

-- SQL Query for aspect 1:

SELECT * FROM new_product WHERE product_category='Electronics' OR product_category='Computers' AND price<=30;



-- ASPECT 2:
-- Stored procedure invocations:

BEGIN
deliver_products(1,1,4);
END;
/

BEGIN
deliver_products(2,2,4);
END;
/


-- SQL Query for aspect 2:

SELECT * FROM prod_seller_inventory
WHERE prod_count<11;



-- ASPECT 3:
-- Stored procedure invocations:

BEGIN
create_customer_account(1,'swetha','mandala','ssm@gmail.com');
END;
/

BEGIN
create_customer_account(2,'olive','green','olive@gmail.com');
END;
/

-- SQL Query for aspect 3:

SELECT customer_lastname,COUNT(customer_id)
FROM customer_account
GROUP BY customer_lastname
HAVING COUNT(customer_lastname)>4;



-- ASPECT 4:
-- Stored procedure invocations:

BEGIN
purchase_products(1,1,1,1);
END;
/

BEGIN
purchase_products(2,2,2,3);
END;
/

BEGIN
purchase_products(3,1,3,1);
END;
/

BEGIN
purchase_products(4,1,4,1);
END;
/

BEGIN
purchase_products(5,3,5,1);
END;
/

BEGIN
purchase_products(6,3,6,1);
END;
/

BEGIN
purchase_products(7,3,7,2);
END;
/

BEGIN
purchase_products(8,3,8,1);
END;
/

-- SQL Query for aspect 4:

SELECT customer_account.customer_id,customer_account.customer_firstname,customer_account.customer_lastname,customer_account.customer_email,orders.delivery_id
FROM customer_account
JOIN orders ON orders.customer_id = customer_account.customer_id
JOIN delivery ON orders.delivery_id = delivery.delivery_id
WHERE orders.delivery_id IN (SELECT o.delivery_id FROM DELIVERY d, ORDERS o 
WHERE o.delivery_id=d.delivery_id 
GROUP BY o.delivery_id
HAVING count(o.delivery_id)>2)
GROUP BY customer_account.customer_id,customer_account.customer_firstname,customer_account.customer_lastname,customer_account.customer_email,orders.delivery_id
;



-- ASPECT 5:
-- Stored procedure invocations:

BEGIN
shipping_products(1,'standard shipping','08-dec-18',45678,1);
END;
/

BEGIN
shipping_products(2,'super saver shipping','02-dec-18',45679,2);
END;
/

BEGIN
shipping_products(3,'one-day shipping','12-dec-18',45680,3);
END;
/

BEGIN
shipping_products(4,'two-day shipping','07-dec-18',45681,4);
END;
/

BEGIN
shipping_products(5,'super saver shipping','02-dec-18',45682,7);
END;
/

-- SQL Query for aspect 5:

SELECT customer_account.customer_id,customer_account.customer_firstname,new_product.product_name,orders.order_count,
to_char(orders.order_count*new_product.price,'FML9999.00','NLS_CURRENCY=$') as tot_cost_of_order,
shipment.tracking_id,(shipment.date_of_arrival-TO_DATE(SYSDATE,'dd-mon-yy')) as days_left_to_ship
FROM new_product
JOIN prod_seller_inventory ON new_product.product_id=prod_seller_inventory.product_id
JOIN delivery ON prod_seller_inventory.inv_id=delivery.inv_id
JOIN orders ON orders.delivery_id = delivery.delivery_id
JOIN customer_account ON orders.customer_id=customer_account.customer_id
JOIN shipment ON orders.order_id=shipment.order_id
WHERE customer_account.customer_firstname IN (SELECT c.customer_firstname FROM customer_account c WHERE c.customer_firstname='swetha' or c.customer_firstname='olive')
;



-- INDEX:

CREATE INDEX cust_name_index ON customer_account(customer_firstname,customer_lastname)

CREATE INDEX products_index ON new_product(product_id,product_name)
