CREATE database ecommerce_sales;
use ecommerce_sales;

SELECT * FROM details;

SELECT * FROM orders_new;

-- Ecommerce Sales Analysis
-- 1. Which states generate the highest sales revenue?
SELECT o.state, SUM(d.amount) as highest_revenue
FROM details d
JOIN orders_new o
ON o.`Order ID` = d.`Order ID`
GROUP BY o.state
ORDER BY highest_revenue DESC;

-- 2. Which states are generating losses despite good sales?
SELECT o.state, SUM(d.Amount), SUM(d.Profit) 
FROM details d
JOIN orders_new o
ON o.`Order ID` = d.`Order ID`
GROUP BY o.state
HAVING SUM(d.Profit) < 0
ORDER BY SUM(d.Amount) DESC;

-- 3. Which product category contributes the highest revenue?
SELECT Category, sum(Amount) as Total_sales FROM details
GROUP BY category
ORDER BY Total_sales desc;

-- 4. Which sub-categories are the most profitable?
SELECT Category, `Sub-Category` , sum(Profit) FROM details
GROUP BY Category, `Sub-Category`
ORDER BY sum(Profit) desc;

-- 5. Which sub-categories are causing losses?
SELECT `Sub-Category`, sum(Profit) FROM details
GROUP BY `Sub-Category`
HAVING sum(Profit) < 0
ORDER BY sum(Profit);

-- 6. Who are the top customers by total purchase amount?
SELECT o.CustomerName, sum(d.Amount) as Total_purchase_amount FROM details d
JOIN orders_new o
ON o.`Order ID` = d.`Order ID`
GROUP BY o.CustomerName
ORDER BY sum(d.Amount) DESC;

-- 7. Which customers generate the highest profits?
SELECT o.CustomerName, sum(d.Profit) as highest_profits FROM details d
JOIN orders_new o
ON o.`Order ID` = d.`Order ID`
GROUP BY o.CustomerName
ORDER BY highest_profits DESC;

-- 8. What is the monthly sales trend?
SELECT monthname(o.`Order Date`), month(o.`Order Date`) AS Month, SUM(d.Profit) FROM details d
JOIN orders_new o
ON o.`Order ID` = d.`Order ID`
GROUP BY Month, monthname(o.`Order Date`)
ORDER BY Month, monthname(o.`Order Date`) ;

-- 9. Which month had the highest profit?
SELECT monthname(o.`Order Date`) as Month, SUM(d.Profit) FROM details d
JOIN orders_new o
ON o.`Order ID` = d.`Order ID`
GROUP BY monthname(o.`Order Date`)
ORDER BY SUM(d.Profit) DESC;

-- 10. Which payment mode is most preferred by customers?
SELECT distinct (PaymentMode), count(PaymentMode) FROM details
GROUP BY (PaymentMode);

-- 11. What is the Average Order Value (AOV)?
SELECT sum(Amount)/count(distinct `Order ID`) as average_order_value FROM details

-- 12. Rank customers based on sales performance
SELECT o.CustomerName, sum(d.Amount) as Total_sales, rank () over(ORDER BY sum(d.Amount) desc ) as sales_rank FROM details d
JOIN orders_new o
ON o.`Order ID` = d.`Order ID`
GROUP BY o.CustomerName;

-- 13. Find the contribution percentage of each category in total sales
With category_sales AS (
	SELECT Category, sum(Amount) as total_sales FROM details
    GROUP BY Category
    )

SELECT Category, total_sales, 
	total_sales * 100 /(SELECT sum(total_sales) FROM category_sales) as contribution_percentage
    FROM category_sales;

-- 14. Identify the most sold product category by quantity
SELECT Category, sum(Quantity) FROM details
GROUP BY Category
ORDER BY sum(Quantity) DESC;

-- 15. Find customers who placed multiple orders
SELECT CustomerName, count(`Order ID`) AS Total_Orders FROM Orders_new
GROUP BY CustomerName
HAVING count(`Order ID`) > 1
ORDER BY Total_Orders DESC;

-- 16. Identify the top 3 profitable sub-categories
SELECT `Sub-Category`, sum(Profit) as profitable_categories FROM details
GROUP BY `Sub-Category`
ORDER BY profitable_categories DESC
LIMIT 3;

-- 17. Compare sales and profit together by category
SELECT Category, SUM(Amount) as sales, SUM(Profit) as Profit FROM details
GROUP BY Category
ORDER BY sales, Profit DESC;






