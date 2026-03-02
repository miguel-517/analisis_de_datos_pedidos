use master;
select *
from orders;
-- Encontrar los 10 productos más vendidos
SELECT TOP 10
    product_id, SUM(sales_price) AS sales
FROM orders
GROUP BY product_id
ORDER BY sales DESC;
-- Encontrar los 5 productos más vendidos por región
WITH
    cte
    AS
    (
        SELECT DISTINCT product_id, region, SUM(sales_price) AS sales
        FROM orders
        GROUP BY product_id, region
    )
SELECT *
FROM(
    SELECT *,
        ROW_NUMBER() OVER(PARTITION BY region ORDER BY sales DESC) as rn
    FROM cte 
) a
WHERE rn <= 5;
--Encontrar una comparación entre las ventas de enero de 2022 y enero de 2023
WITH cte AS (
SELECT DISTINCT YEAR(order_date) order_year, MONTH(order_date) order_month, SUM(sales_price) as sales
FROM orders
GROUP BY YEAR(order_date), MONTH(order_date)
-- ORDER BY YEAR(order_date), sales DESC
)
SELECT order_month
, SUM(CASE WHEN order_year = 2022 THEN sales ELSE 0 END) AS sales_2022
, SUM(CASE WHEN order_year = 2023 THEN sales ELSE 0 END) AS sales_2023
FROM cte
GROUP BY order_month
ORDER BY order_month

-- Cuáles son las ventas mensuales más altas para cada categoría
WITH cte AS(
SELECT category, FORMAT(order_date,'yyyy/MM') as order_year_month, 
SUM(sales_price) AS sales FROM orders
GROUP BY category, FORMAT(order_date,'yyyy/MM')
ORDER BY category, FORMAT(order_date,'yyyy/MM')
)
SELECT * FROM (
SELECT *, ROW_NUMBER() over(PARTITION BY category ORDER BY sales DESC) as rn
from cte
) a WHERE rn = 1
--Cuál de las subcategorías tiene más ganancias comparando 2023 a 2022

WITH cte AS (
SELECT DISTINCT sub_category, YEAR(order_date) order_year, SUM(sales_price) as sales
FROM orders
GROUP BY sub_category, YEAR(order_date)
)
, cte2 AS (SELECT sub_category
, SUM(CASE WHEN order_year = 2022 THEN sales ELSE 0 END) AS sales_2022
, SUM(CASE WHEN order_year = 2023 THEN sales ELSE 0 END) AS sales_2023
FROM cte
GROUP BY sub_category
)
SELECT TOP 1 *, (sales_2023 - sales_2022) * 100 /sales_2022 AS top_one  
FROM cte2
ORDER BY (sales_2023 - sales_2022) * 100 /sales_2022 DESC  