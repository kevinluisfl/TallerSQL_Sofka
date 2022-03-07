-- 1. Obtener productos vendidos por tipo y número de documento
SELECT c.customer_name AS Customer,  p.product_name AS Product
FROM sale_detail sd JOIN sale s ON sd.sale_id = s.id_sale
JOIN customer c ON s.customer_id = c.id_customer
JOIN product p ON sd.product_id = p.id_product
WHERE s.customer_id = (SELECT id_customer FROM customer WHERE type_id='CC' AND number_id='136823322')

-- 2. Obtener productos por el nombre, mostrar quien o quienes han sido sus proveedores

-- 3. Ver producto más vendido ordenado por cantidad de mayor a menor
