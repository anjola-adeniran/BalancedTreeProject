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
-- What is the average revenue for member transactions and non-member transactions
