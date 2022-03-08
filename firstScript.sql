-- TODAS LAS SENTENCIAS SE REALIZARON EN MARIADB
-- crear base de datos
CREATE DATABASE IF NOT EXISTS store_sofka_db;
USE store_sofka_db;

-- Sentencias para iniciar la base de datos desde 0
DROP TABLE if EXISTS sale_detail;
DROP TABLE if EXISTS product_supplier;
DROP TABLE if EXISTS product;
DROP TABLE if EXISTS supplier;
DROP TABLE if EXISTS sale;
DROP TABLE if EXISTS customer;
DROP TABLE if EXISTS seller;

-- 1. Creacioin de tablas
-- crear tabla proveedor
CREATE TABLE IF NOT EXISTS supplier (
	id_supplier INT(10) NOT NULL AUTO_INCREMENT,
	nit VARCHAR(15) NOT NULL DEFAULT '',
	supplier_name VARCHAR(50) NOT NULL DEFAULT '',
	supplier_phone VARCHAR(15) NULL DEFAULT '',
    deleted ENUM('true','false') NULL DEFAULT 'false',
	PRIMARY KEY (id_supplier)
)ENGINE=InnoDB
COMMENT='table for storing supplier information'
COLLATE='utf8mb4_0900_ai_ci';

-- crear tabla producto
CREATE TABLE IF NOT EXISTS product (
	id_product INT(10) NOT NULL AUTO_INCREMENT,
    supplier_id INT(10) NOT NULL DEFAULT 0,
	product_name VARCHAR(50) NOT NULL DEFAULT '',
	description VARCHAR(150) NULL DEFAULT '',
	price DOUBLE NOT NULL DEFAULT 0,
    deleted ENUM('true','false') NULL DEFAULT 'false',
	PRIMARY KEY (id_product),
    INDEX supplier_id (supplier_id),
    CONSTRAINT FK_supplier_product FOREIGN KEY (supplier_id) REFERENCES supplier (id_supplier) ON UPDATE RESTRICT ON DELETE RESTRICT
)ENGINE=InnoDB
COMMENT='table for storing product information'
COLLATE='utf8mb4_0900_ai_ci';

-- crear tabla cliente
CREATE TABLE IF NOT EXISTS customer (
	id_customer INT(10) NOT NULL AUTO_INCREMENT,
	customer_name VARCHAR(50) NOT NULL DEFAULT '',
	type_id VARCHAR(10) NOT NULL DEFAULT '',
	number_id VARCHAR(15) NOT NULL DEFAULT '',
	customer_phone VARCHAR(15) NULL DEFAULT '',
    deleted ENUM('true','false') NULL DEFAULT 'false',
	PRIMARY KEY (id_customer)
)ENGINE=InnoDB
COMMENT='table for storing customer information'
COLLATE='utf8mb4_0900_ai_ci';

-- crear tabla vendedor
CREATE TABLE IF NOT EXISTS seller (
	id_seller INT(10) NOT NULL AUTO_INCREMENT,
	seller_name VARCHAR(50) NOT NULL DEFAULT '',
	position_seller VARCHAR(50) NOT NULL DEFAULT '',
    deleted ENUM('true','false') NULL DEFAULT 'false',
	PRIMARY KEY (id_seller)
)ENGINE=InnoDB
COMMENT='table for storing seller information'
COLLATE='utf8mb4_0900_ai_ci';

-- crear tabla venta
CREATE TABLE IF NOT EXISTS sale (
	id_sale INT(10) NOT NULL AUTO_INCREMENT,
	customer_id INT(10) NOT NULL DEFAULT 0,
	seller_id INT(10) NOT NULL DEFAULT 0,
	sale_invoice VARCHAR(50) NOT NULL DEFAULT '0',
	sale_date DATETIME NOT NULL,
    deleted ENUM('true','false') NULL DEFAULT 'false',
	PRIMARY KEY (id_sale),
	INDEX customer_id (customer_id),
	INDEX seller_id (seller_id),
	CONSTRAINT FK_customer_sale FOREIGN KEY (customer_id) REFERENCES customer (id_customer) ON UPDATE CASCADE ON DELETE NO ACTION,
	CONSTRAINT FK_seller_sale FOREIGN KEY (seller_id) REFERENCES seller (id_seller) ON UPDATE CASCADE ON DELETE NO ACTION
)ENGINE=InnoDB
COMMENT='table for storing sale information'
COLLATE='utf8mb4_0900_ai_ci';

-- crear tabla detalle venta
CREATE TABLE IF NOT EXISTS sale_detail (
	id_sale_detail INT(10) NOT NULL AUTO_INCREMENT,
	sale_id INT(10) NOT NULL DEFAULT 0,
	product_id INT(10) NOT NULL DEFAULT 0,
	quantity FLOAT NOT NULL DEFAULT 0,
	unit_price DOUBLE NOT NULL DEFAULT 0,
	subtotal DOUBLE NOT NULL DEFAULT 0,
	PRIMARY KEY (id_sale_detail),
	INDEX sale_id (sale_id),
	INDEX product_id (product_id),
	CONSTRAINT FK_sale_sale_detail FOREIGN KEY (sale_id) REFERENCES sale (id_sale) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT FK_product_sale_detail FOREIGN KEY (product_id) REFERENCES product (id_product) ON UPDATE CASCADE ON DELETE CASCADE
)ENGINE=InnoDB
COMMENT='table for storing sale detail information'
COLLATE='utf8mb4_0900_ai_ci';

-- crear tabla producto proveedor
CREATE TABLE IF NOT EXISTS product_supplier (
	id_product_supplier INT(10) NOT NULL AUTO_INCREMENT,
	product_id INT(10) NOT NULL DEFAULT 0,
	supplier_id INT(10) NOT NULL DEFAULT 0,
	since DATETIME NOT NULL,
	PRIMARY KEY (id_product_supplier)
)ENGINE=InnoDB
COMMENT='table for storing historical product supplier information'
COLLATE='utf8mb4_0900_ai_ci'
;

-- TRIGGERS
-- Para cuando se ingresan nuevos roductos
DROP TRIGGER IF EXISTS INSERT_PRODUCT_SUPPLIER;

CREATE TRIGGER INSERT_PRODUCT_SUPPLIER AFTER INSERT ON product FOR EACH ROW INSERT INTO product_supplier
(product_id, supplier_id, since) VALUES (NEW.id_product, NEW.supplier_id, NOW());

-- Para cuando se actualiza proveedor en porductos
DROP TRIGGER IF EXISTS UPDATE_PRODUCT_SUPPLIER;
DELIMITER $$
CREATE TRIGGER UPDATE_PRODUCT_SUPPLIER BEFORE UPDATE ON product FOR EACH ROW
BEGIN
IF OLD.supplier_id != NEW.supplier_id THEN
INSERT INTO product_supplier (product_id, supplier_id, since) VALUES (NEW.id_product, NEW.supplier_id, NOW());
END IF;
END $$
DELIMITER ;

-- 2. inserción de información
-- datos de proveedor
INSERT INTO supplier (nit, supplier_name, supplier_phone)
VALUES
	("123953304","Carlos Jefferson","1-618-705-1891"),
	("26485770","Karen Banks","(537) 705-2494"),
	("408322286","Linus Parrish","(465) 265-9052"),
	("68776902","Bruno Monroe","(693) 452-4545"),
	("41500530K","Cameron Garner","(683) 364-1311");

-- datos de cliente
INSERT INTO customer (customer_name, type_id, number_id, customer_phone)
VALUES
	("Derek Jones","CC","618935861","1-285-614-8953"),
	("Lev Knowles","TI","571255789","(214) 217-1256"),
	("Inga Ross","CE","056345309","1-448-834-6696"),
	("Skyler Allison","CC","136823322","1-610-467-8675"),
	("Macon Morrow","CC","842892453","(850) 651-8776");

-- datos de producto
INSERT INTO product (supplier_id, product_name, description, price)
VALUES
	(2,"Sibasa","commodo ipsum. Suspendisse non leo.",493.88),
  	(1,"Lanco","imperdiet, erat nonummy ultricies ornare,",371.12),
  	(5,"Kavaratti","Proin sed turpis nec mauris",688.78),
  	(3,"Glendon","libero. Donec consectetuer mauris id",924.82),
  	(1,"Rance","nunc id enim. Curabitur massa.",211.03);

-- datos vendedor - el taller indica que solo hay 1
INSERT INTO seller (seller_name, position_seller)
VALUES
	("Barrett Rivas","propietario");

-- datos de venta
INSERT INTO sale (customer_id, seller_id, sale_invoice, sale_date)
VALUES
  (2,1,"YO-056", NOW()),
  (2,1,"WK-318", ADDDATE(NOW(), INTERVAL 1 DAY)),
  (4,1,"NZ-633", ADDDATE(NOW(), INTERVAL 1 DAY)),
  (3,1,"CC-559", ADDDATE(NOW(), INTERVAL 2 DAY)),
  (3,1,"LX-428", ADDDATE(NOW(), INTERVAL 3 DAY));

-- datos de detalle venta
INSERT INTO sale_detail (sale_id, product_id, quantity, unit_price, subtotal)
VALUES
	(1,3,23, 66.87, 1538.01),
	(1,2,41, 83.99, 3443.59),
	(1,4,78, 21.00, 1638),
	(1,1,13, 59.03, 767.39),
	(2,5,53, 19.10, 1012.3),
	(2,2,13, 59.92, 778.96),
	(2,3,95, 94.64, 8990.8),
	(3,2,77, 98.49, 7583.73),
	(3,4,26, 73.58, 1913.08),
	(3,5,82, 31.14, 2553.48),
	(4,5,15, 62.56, 938.4),
	(4,2,99, 44.22, 4377.78),
	(4,1,3, 30.62, 91.86),
	(4,4,21, 43.43, 912.03),
	(5,4,53, 33.67, 1784.51);

-- 3. Dos borrados lógicos y dos borrados físicos en ventas
-- Borrados lógicos
UPDATE sale SET deleted = 'true' WHERE id_sale = 2;
UPDATE sale SET deleted = 'true' WHERE id_sale = 5;
-- Borrados físicos
DELETE FROM sale WHERE id_sale = 2;
DELETE FROM sale WHERE id_sale = 4;

-- 4. Modificar tres productos en su nombre y proveedor
-- actualizacion de nombre producto y proveedor
UPDATE product SET product_name = 'Pera', supplier_id = 4 WHERE id_product = 1;
UPDATE product SET product_name = 'Manzana', supplier_id = 3 WHERE id_product = 3;
UPDATE product SET product_name = 'Aguacate', supplier_id = 4 WHERE id_product = 5;

-- probando que lleve registro en product_supplier solo cuando cambia el proveedor
UPDATE product SET supplier_id = 1 WHERE id_product = 3;
UPDATE product SET product_name = 'Limone' WHERE id_product = 4;