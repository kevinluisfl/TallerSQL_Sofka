-- TODAS LAS CONSULTAS SE REALIZARON EN MARIADB
-- 1. Obtener productos vendidos por tipo y número de documento
SELECT c.customer_name AS Customer, c.type_id AS Type_Id , c.number_id AS Number_Id, s.sale_invoice AS Invoice, p.product_name AS Product
FROM sale_detail sd
JOIN sale s ON sd.sale_id = s.id_sale
JOIN customer c ON s.customer_id = c.id_customer
JOIN product p ON sd.product_id = p.id_product
WHERE c.type_id = 'CE' AND c.number_id = '056345309';

-- Con esta consulta se omiten las facturas borradas de forma lógica
SELECT c.customer_name AS Customer, c.type_id AS Type_Id , c.number_id AS Number_Id, s.sale_invoice AS Invoice, p.product_name AS Product
FROM sale_detail sd
JOIN sale s ON sd.sale_id = s.id_sale
JOIN customer c ON s.customer_id = c.id_customer
JOIN product p ON sd.product_id = p.id_product
WHERE c.type_id = 'CE' AND c.number_id = '056345309' AND s.deleted != 'true';

-- 2. Obtener productos por el nombre, mostrar quien o quienes han sido sus proveedores
SELECT s.supplier_name AS Supplier, p.product_name AS Product, ps.since AS Since
FROM product_supplier ps
JOIN product p ON ps.product_id = p.id_product
JOIN supplier s ON ps.supplier_id = s.id_supplier
WHERE p.product_name = 'Manzana';

-- 3. Ver producto más vendido y cantidad de ventas, ordenado de más a menos cantidades
SELECT p.product_name AS Product, SUM(sd.quantity) AS Quantity
FROM sale_detail sd
JOIN product p ON sd.product_id = p.id_product
GROUP BY sd.product_id
ORDER BY Quantity DESC;

-- Con esta consulta se omiten las facturas borradas de forma lógica
SELECT p.product_name AS Product, SUM(sd.quantity) AS Quantity
FROM sale_detail sd
JOIN sale s ON sd.sale_id = s.id_sale
JOIN product p ON sd.product_id = p.id_product
WHERE s.deleted != 'true'
GROUP BY sd.product_id
ORDER BY Quantity DESC;