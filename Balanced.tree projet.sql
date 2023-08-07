-- what was the total quantity sold?
SELECT SUM (qty) AS "Total Quantity" FROM balanced_tree.sales

-- What is the total generated revenue for all products before discounts?
SELECT SUM (qty * price) AS TotalRevenueBeforeDiscount
FROM balanced_tree.sales
    
-- What was the total discount amount for all products?
SELECT ROUND(SUM(qty * price * discount::numeric/100),2)AS "Total Discount"
FROM balanced_tree.sales

-- How many unique transactions were there?
SELECT COUNT(DISTINCT(txn_id )) AS "Unique Transactions"
FROM balanced_tree.sales

-- What is the average unique products purchased in each transaction?
SELECT round(AVG("UniqueProducts")) AS "AverageUniqueProducts"
FROM 
	(SELECT txn_id, COUNT (DISTINCT prod_id) AS "UniqueProducts"
	FROM balanced_tree.sales
	GROUP BY txn_id) AS subquery;
-- What are the 25th, 50th and 75th percentile values for the revenue per transaction
WITH t AS
(SELECT txn_id,
        SUM(qty * price) AS transaction_revenue
 FROM balanced_tree.sales
 GROUP BY 1)
SELECT percentile_cont(0.25) WITHIN GROUP (ORDER BY transaction_revenue) AS revenue_25percentile,
       percentile_cont (0.50) WITHIN GROUP (ORDER BY transaction_revenue) AS revenue_50percentile,
	   percentile_cont (0.75) WITHIN GROUP (ORDER BY transaction_revenue) AS revenue_75percentile
FROM t;
	   
-- What is the average discount value per transaction?
With t AS 
(SELECT 
	txn_id,
	SUM(qty * price * discount ::numeric/100) AS Txn_discount
FROM balanced_tree.sales
GROUP BY txn_id)
	SELECT Round(AVG(Txn_discount),2) AS AverageDiscount
	FROM t;

--  What is the percentage split of all transactions for members vs non-members?
SELECT member,
       ROUND(100 * COUNT(member)::numeric / (SELECT COUNT(member)
       FROM balanced_tree.sales)) AS member_percentage  
FROM balanced_tree.sales
GROUP BY 1;
  
-- What is the average revenue for member transactions and non-member transactions
SELECT round(avg(total_revenue_before_discounts )) AS member_transaction,member 
FROM
	(SELECT member,txn_id, SUM(qty * price) AS total_revenue_before_discounts 
	FROM balanced_tree.sales
	GROUP BY txn_id,member
	) AS subquery
group by member

-- What are the top 3 products by total revenue before discount?
SELECT prod_id, 
	   product_name,
		SUM (qty * s.price) AS TotalRevenue
FROM balanced_tree.sales  s
LEFT JOIN balanced_tree.product_details p ON s.prod_id = p.product_id
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 3;

-- What is the total quantity, revenue and discount for each segment?
SELECT 
	segment_id,
	segment_name,
	SUM (qty) AS TotalQuantity, 
	SUM (qty * sales.price) AS Total_Revenue_before_discount,
	SUM (Round(qty * sales.price * discount ::numeric/100)) AS Total_After_Discount
FROM balanced_tree.sales
JOIN balanced_tree.product_details
ON sales.prod_id = product_details.product_id
GROUP BY 1,2

-- What is the top selling product for each segment?
With t AS
(SELECT segment_id, segment_name, product_name, product_id,SUM (qty) AS Total_qty
	FROM balanced_tree.sales
JOIN balanced_tree.product_details
	ON sales.prod_id = product_details.product_id
	GROUP BY 1,2,3,4
 	ORDER BY SUM(qty) DESC
	LIMIT 5;
SELECT segment_id,
       segment_name,
       product_id,
       product_name,
       total_qty
FROM t;

-- What is the top selling product for each category?
With t AS
(SELECT category_id, category_name, product_name, product_id,SUM (qty) AS Total_qty
	FROM balanced_tree.sales
JOIN balanced_tree.product_details
	ON sales.prod_id = product_details.product_id
	GROUP BY 1,2,3,4
 	ORDER BY SUM(qty) DESC
	LIMIT 3)
SELECT category_id,
       category_name,
       product_id,
       product_name,
       total_qty
FROM t;

-- What is the total quantity, revenue and discount for each category?
SELECT category_id, SUM (qty) AS TotalQuantity, SUM (sales.qty * sales.price) AS Total_Discount,Round(SUM (sales.qty * sales.price * discount::numeric/100),2) AS Total_After_Discount
FROM balanced_tree.sales
JOIN balanced_tree.product_details
ON sales.prod_id = product_details.product_id
GROUP BY category_id

-- What is the percentage split of revenue by product for each segment?
WITH t AS
(SELECT segment_id,
        segment_name,
        product_id,
        product_name,
        SUM(qty * sales.price) AS total_revenue_before_discounts
 FROM balanced_tree.sales
	JOIN balanced_tree.product_details
	ON sales.prod_id = product_details.product_id
	GROUP BY 1,2,3,4)
 SELECT *,
       ROUND(100*total_revenue_before_discounts / (SUM(total_revenue_before_discounts) OVER(PARTITION BY segment_id)),2) AS revenue_percentage
FROM t
ORDER BY segment_id, revenue_percentage DESC;
	
-- What is the percentage split of revenue by segment for each category?
WITH t AS
(SELECT segment_id,
        segment_name,
        category_id,
        category_name,
        SUM(qty * sales.price) AS total_revenue_before_discounts
 FROM balanced_tree.sales
	JOIN balanced_tree.product_details
	ON sales.prod_id = product_details.product_id
	GROUP BY 1,2,3,4)
 SELECT *,
       ROUND(100*total_revenue_before_discounts / (SUM(total_revenue_before_discounts) OVER(PARTITION BY category_id)),2) AS revenue_percentage
FROM t
ORDER BY category_id, revenue_percentage DESC;
 
-- What is the percentage split of total revenue by category?
SELECT 
 	rev.category_id,
	rev.category_name,
	Round((rev.TotalRevenue / Ot.Overall_Total::float) * 100 )AS PercentageSplit
FROM
	(SELECT SUM(sales.qty * sales.price) AS Overall_Total
	FROM balanced_tree.sales) 
	AS Ot,
	(SELECT SUM(sales.qty * sales.price) AS TotalRevenue,category_id,category_name
	FROM balanced_tree.sales
	JOIN balanced_tree.product_details
	ON sales.prod_id = product_details.product_id
	GROUP BY category_id, category_name) AS rev

-- What is the total transaction “penetration” for each product? (hint: penetration = number of transactions where at least 1 quantity of a product was purchased divided by total number of transactions
SELECT 
	product_id,
  	product_name,
     ROUND(COUNT(txn_id)::numeric / (SELECT COUNT(DISTINCT txn_id) 
                                       FROM balanced_tree.sales), 3) AS txn_penetration
    FROM balanced_tree.sales
	JOIN balanced_tree.product_details
	ON sales.prod_id = product_details.product_id
	Group BY 1,2 
 
-- What is the most common combination of at least 1 quantity of any 3 products in a 1 single transaction?
SELECT s.prod_id, t1.prod_id, t2.prod_id, COUNT(*) AS combination_cnt       
FROM balanced_tree.sales s
JOIN balanced_tree.sales t1 ON t1.txn_id = s.txn_id 
AND s.prod_id < t1.prod_id
JOIN balanced_tree.sales t2 ON t2.txn_id = s.txn_id
AND t1.prod_id < t2.prod_id
GROUP BY 1, 2, 3
ORDER BY 4 DESC
LIMIT 1;
 
--  Write a single SQL script that combines all of the previous questions into a scheduled report that the Balanced Tree team can run at the beginning of each month to calculate the previous month’s values
CREATE TEMP TABLE sales_monthly AS
(SELECT *
FROM balanced_tree.sales
WHERE EXTRACT(MONTH FROM start_txn_time) = 1   
AND EXTRACT(YEAR FROM start_txn_time) = 2021);
	

	
