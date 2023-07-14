-- what was the total quantity sold?
SELECT SUM (qty) AS "Total Quantity" FROM balanced_tree.sales

-- What is the total generated revenue for all products before discounts?
	SELECT SUM(Revenue) AS TotalRevenue
FROM (
    SELECT prod_id, (qty * price) AS Revenue
    FROM balanced_tree.sales
    GROUP BY prod_id, qty, price
) AS subquery;

-- What was the total discount amount for all products?
SELECT SUM (discount) AS "Total Discount"
FROM balanced_tree.sales

-- How many unique transactions were there?
SELECT COUNT(DISTINCT(txn_id )) AS "Unique Transactions"
FROM balanced_tree.sales

-- What is the average unique products purchased in each transaction?
SELECT round(AVG("UniqueProducts"),3) AS "AverageUniqueProducts"
FROM (
	SELECT txn_id, COUNT (DISTINCT prod_id) AS "UniqueProducts"
	FROM balanced_tree.sales
	GROUP BY txn_id) AS subquery;
	
-- What is the average discount value per transaction?
SELECT txn_id, round(AVG (discount),3) AS "Average Discount"
FROM balanced_tree.sales
GROUP BY txn_id;
	
-- What is the percentage split of all transactions for members vs non-members
SELECT
  sa.countOfTransactions,
  sa.member,
  ta.overall_total,
  sa.countOfTransactions/ ta.overall_total::float * 100 AS Percentage
FROM
	(SELECT
    count(txn_id) AS overall_total
    FROM
     balanced_tree.sales 
  ) AS ta,
    (SELECT
      member,
      count(txn_id) AS countOfTransactions
    FROM
      balanced_tree.sales
    GROUP BY
      member
  ) AS sa;
  
  
-- What is the average revenue for member transactions and non-member transactions
SELECT round(avg(Revenue),3),member 
FROM
	(SELECT member,txn_id, SUM(qty * price) AS Revenue
	FROM balanced_tree.sales
	GROUP BY txn_id,member
	) AS subquery
group by member

-- What are the top 3 products by total revenue before discount?
SELECT prod_id, SUM (qty * price) AS TotalRevenue
FROM balanced_tree.sales
GROUP BY prod_id, qty, price
ORDER BY TotalRevenue DESC
LIMIT 3;

-- What is the total quantity, revenue and discount for each segment?
SELECT segment_id, SUM (qty) AS TotalQuantity, SUM (sales.qty * sales.price) AS TotalRevenue,SUM (discount) AS TotalDiscount
FROM balanced_tree.sales
JOIN balanced_tree.product_details
ON sales.prod_id = product_details.product_id
GROUP BY segment_id

-- What is the top selling product for each segment?
SELECT MAX("TopSelling") AS "TopSellingProducts", product_name,segment_id
FROM (
	SELECT segment_id, product_name, COUNT (txn_id) AS "TopSelling"
	FROM balanced_tree.sales
	JOIN balanced_tree.product_details
	ON sales.prod_id = product_details.product_id
	GROUP BY segment_id, product_name
	ORDER BY COUNT (txn_id) DESC
	) AS Subquery
GROUP BY product_name, segment_id

-- What is the top selling product for each category?



-- What is the total quantity, revenue and discount for each category?
SELECT category_id, SUM (qty) AS TotalQuantity, SUM (sales.qty * sales.price) AS TotalRevenue,SUM (discount) AS TotalDiscount
FROM balanced_tree.sales
JOIN balanced_tree.product_details
ON sales.prod_id = product_details.product_id
GROUP BY category_id







