
CREATE TABLE orders (
    [order_id] INT PRIMARY KEY,
    [order_date] DATE,
    [ship_mode] NVARCHAR(20),
    [segment] NVARCHAR(20),
    [country] NVARCHAR(20),
    [city] NVARCHAR(20),
    [state] NVARCHAR(20),
    [postal_code] NVARCHAR(20),
    [region] NVARCHAR(20),
    [category] NVARCHAR(20),
    [sub_category] NVARCHAR(20),
    [product_id] NVARCHAR(50),
    [quantity] INT,
    [discount] DECIMAL(7,2),
    [sales_price] DECIMAL(7,2),
    [profit] DECIMAL(7,2)
);
SELECT * from orders