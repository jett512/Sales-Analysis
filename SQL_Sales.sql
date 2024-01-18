
--  1. Retrieve the average net sales, gross sales, and discounts for each month across all years. Order the results by month.
-- select * from sale_over_time;
SELECT
    Month,
    ROUND(AVG(Net_Sales), 2) AS Avg_Net_Sales,
    ROUND(AVG(Gross_Sales), 2) AS Avg_Gross_Sales,
    ROUND(AVG(Discounts), 2) AS Avg_Discounts,
    ROUND(AVG(Total_Orders), 2) AS Avg_Total_Orders
FROM sale_over_time
GROUP BY Month;

-- Average return percentage for each month
SELECT
    Month,
    ROUND(AVG((Returns * -1) / Gross_Sales) * 100, 2) AS Return_Percentage
FROM sale_over_time
GROUP BY Month;

-- Average discount percentage for each month
SELECT
    Month,
    ROUND(AVG((Discounts * -1) / Gross_Sales) * 100, 2) AS Discounts_Percentage
FROM sale_over_time
GROUP BY Month;

-- 2. Product type analysis: Find the product type with the highest gross sales and the corresponding total net sales
-- select * from retailsales;
DELETE FROM retailsales
WHERE product_type IS NULL;

select product_type, SUM(gross_sales) as Sum_Sales
from retailsales
group by product_type
order by Sum_Sales desc;


-- Find the products with the highest net quantity sold
select product_type, SUM(net_quantity) as Sum_Quantity
from retailsales
group by product_type
order by Sum_Quantity desc;


-- Find the price of each individual product BEFORE any discounts
select
    product_type,
    ROUND(SUM(Gross_Sales) / SUM(Net_Quantity),2) as Price
from retailsales
where Net_Quantity > 0 -- Added condition to avoid division by zero
group by product_type;


-- Find the price of each individual product AFTER any discounts
select
    product_type,
    ROUND(SUM(total_Net_Sales) / SUM(Net_Quantity),2) as Price
from retailsales
where Net_Quantity > 0 -- Added condition to avoid division by zero
group by product_type;


-- Find the difference between the individual price per item vs after discounts
select
    product_type,
    ROUND(SUM(Gross_Sales) / SUM(Net_Quantity) - SUM(total_Net_Sales) / SUM(Net_Quantity),2) as Discount_From_Price
from retailsales
where Net_Quantity > 0 -- Added condition to avoid division by zero
group by product_type;


-- Find the products with the highest amount refunded/returned in desc order
select product_type, (SUM(returns) * -1) as amount_refunded
from retailsales
group by product_type
order by amount_refunded desc;


-- Find the products with the highest amount refunded/returned in desc order
select product_type, (SUM(Discounts) * -1) as amount_discounted
from retailsales
group by product_type
order by amount_discounted desc;


-- Find the products with the least amount of times refunded
select
    product_type, SUM(Net_Quantity) as total_quantity, 
    (SUM(returns) *-1) as total_return_price,
    ROUND(SUM(Gross_Sales) / SUM(Net_Quantity),2) as Price_per_unit,
    ROUND((SUM(returns) * -1) / (SUM(Gross_Sales) / SUM(Net_Quantity)), 0) as num_returned
from retailsales
where Net_Quantity > 0 -- Added condition to avoid division by zero
group by product_type
order by num_returned desc;


-- Find the products with the highest percentage of quantity returned
select
    product_type, SUM(Net_Quantity) as total_quantity, 
    ROUND((SUM(returns) * -1) / (SUM(Gross_Sales) / SUM(Net_Quantity)), 0) as num_returned,
    ROUND((ROUND((SUM(returns) * -1) / (SUM(Gross_Sales) / SUM(Net_Quantity)), 0) / SUM(Net_Quantity))* 100,2) as return_percentage
from retailsales
where Net_Quantity > 0 -- Added condition to avoid division by zero
group by product_type
order by return_percentage desc;



