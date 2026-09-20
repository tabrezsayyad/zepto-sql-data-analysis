drop table if exists zepto;

create table zepto(
	sku_id SERIAL PRIMARY KEY,
	Category VARCHAR(120),
	name VARCHAR(150),
	mrp NUMERIC(8,2),
	dicountPercent NUMERIC(5,2),
	availableQuantity INTEGER,
	discountSellingPrice NUMERIC(8,2),
	weightInGms INTEGER,
	outOfStock BOOLEAN,
	quantity INTEGER
);

--Data exploration

--Count of rows
SELECT COUNT(*)FROM zepto;

--Sample data
SELECT * FROM zepto
LIMIT 10;

--Null Values
SELECT * FROM zepto
WHERE name IS NULL
	OR category IS NULL
	OR mrp IS NULL
	OR dicountPercent IS NULL
	OR discountSellingPrice IS NULL
	OR weightInGms IS NULL
	OR outOfStock IS NULL
	OR quantity IS NULL;

--Different product categories
SELECT DISTINCT category
FROM zepto
ORDER BY category;

--Product in stock VS Out of Stock
SELECT outOfStock, COUNT(sku_id)
FROM zepto
GROUP BY outOfStock;

--Product names present multiple time 
SELECT name, COUNT(sku_id) AS  "Number of SKUs"
FROM zepto
GROUP BY name
HAVING COUNT(sku_id) > 1
ORDER BY COUNT(sku_id) DESC;

--Data cleaning 
--Product with price = 0

SELECT * FROM zepto
WHERE mrp = 0 OR discountSellingPrice = 0;

DELETE FROM zepto
WHERE mrp = 0;

--converd Paise to Rupees
UPDATE zepto
SET mrp = mrp/100.0,
discountSellingPrice = discountSellingPrice/100.0;


SELECT mrp, discountSellingPrice FROM zepto;

--Q1. Find the top 10 best-value products based on the discount percentage.
SELECT DISTINCT name, mrp, dicountPercent
FROM zepto
ORDER BY dicountPercent DESC
LIMIT 10;


--Q2. What are the products with high MRP but out of stock?
SELECT DISTINCT name, mrp, outOfStock
FROM zepto
WHERE outOfStock = TRUE AND mrp > 300
ORDER BY mrp DESC; 


--Q3. Calculate Estimated Revenue for each category.
SELECT Category,
SUM(discountSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY Category
ORDER BY total_revenue;


--Q4. Find all products where MRP is greater than 500 and discount is less than 10%.
SELECT DISTINCT name, mrp, dicountPercent
FROM zepto
WHERE mrp > 500 AND dicountPercent < 10
ORDER BY mrp DESC, dicountPercent DESC;


--Q5. Identify the top 5 categories offering the highest average discount percentage.
SELECT category,
ROUND(AVG(dicountPercent), 2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

--Q6. Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name, weightInGms, discountSellingPrice,
ROUND(discountSellingPrice / weightInGms, 2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram;


--Q7. Group the products into categories like Low, Medium, Bulk.
SELECT DISTINCT name, weightInGms,
	CASE 
		WHEN weightInGms <  1000 THEN 'Low'
		WHEN weightInGms <  5000 THEN 'Medium'
		ELSE 'Bulk'
	END AS weight_category
FROM zepto;	

	

--Q8. What is the Total Inventory Value per Category?
SELECT category,
SUM(discountSellingPrice  * availableQuantity) AS total_inventory_value
FROM zepto
GROUP BY category
ORDER BY total_inventory_value;





