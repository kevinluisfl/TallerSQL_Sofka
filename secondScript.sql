-- 1. Obtener productos vendidos por tipo y número de documento
SELECT c.customer_name AS Customer,  p.product_name AS Product
FROM sale_detail sd JOIN sale s ON sd.sale_id = s.id_sale
JOIN customer c ON s.customer_id = c.id_customer
JOIN product p ON sd.product_id = p.id_product
WHERE s.customer_id = (SELECT id_customer FROM customer WHERE type_id = 'CC' AND number_id = '136823322')

-- 2. Obtener productos por el nombre, mostrar quien o quienes han sido sus proveedores
SELECT s.supplier_name AS Supplier, p.product_name AS Product, ps.since AS Since
FROM product_supplier ps
JOIN product p ON ps.product_id = p.id_product
JOIN supplier s ON ps.supplier_id = s.id_supplier
WHERE ps.product_id = (SELECT id_product FROM product WHERE product_name = 'Pera')

-- 3. Ver producto más vendido y cantidad de ventas, ordenado de más a menos cantidades
SELECT p.product_name AS Product, SUM(sd.quantity) AS Quantity
FROM sale_detail sd
JOIN product p ON sd.product_id = p.id_product
GROUP BY sd.product_id ORDER BY Quantity DESC;