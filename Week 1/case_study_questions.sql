/* --------------------
   Case Study Questions
   --------------------*/

-- 1. What is the total amount each customer spent at the restaurant?
-- 2. How many days has each customer visited the restaurant?
-- 3. What was the first item from the menu purchased by each customer?
-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
-- 5. Which item was the most popular for each customer?
-- 6. Which item was purchased first by the customer after they became a member?
-- 7. Which item was purchased just before the customer became a member?
-- 8. What is the total items and amount spent for each member before they became a member?
-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
   
SET search_path TO dannys_diner;

----- 1. What is the total amount each customer spent at the restaurant?
SELECT 
	s.customer_id, 
	SUM(m.price) AS total_spendings 
FROM sales AS s
LEFT JOIN menu AS m 
	USING(product_id)
GROUP BY s.customer_id 
ORDER BY s.customer_id;

----- 2. How many days has each customer visited the restaurant?
SELECT 
	customer_id,
	COUNT(DISTINCT order_date) AS days_visited 
FROM sales 
GROUP BY customer_id
ORDER BY customer_id;

----- 3. What was the first item from the menu purchased by each customer?
SELECT 
	s.customer_id,
	m.product_name AS first_item_purchased
FROM sales AS s 
LEFT JOIN menu AS m 
	USING(product_id)
WHERE s.order_date IN (SELECT MIN(order_date)
					   FROM sales
					   GROUP BY customer_id);
					   
----- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT 
	m.product_name,
	COUNT(s.product_id) AS sales
FROM sales AS s
LEFT JOIN menu AS m 
	USING (product_id)
GROUP BY product_name
ORDER BY sales DESC; 

----- 5. Which item was the most popular for each customer?
-- Create a common table expression that ranks the number of orders purchased by each customer from largest to smallest
WITH cte AS (
	SELECT 
		customer_id, 
		product_id, 
		COUNT(*) AS order_count,
		RANK() OVER(PARTITION BY customer_id
					ORDER BY COUNT(*) DESC) AS order_rank 
	FROM sales
	GROUP BY customer_id, product_id
	ORDER BY customer_id, product_id
)

-- Find item that has the biggest order count, which is also the most popular item purchased 
SELECT 
	customer_id, 
	product_name AS most_popular_item,
	order_count
FROM cte 
LEFT JOIN menu 
	USING (product_id)
WHERE order_rank = 1
ORDER BY customer_id, product_name; 

----- 6. Which item was purchased first by the customer after they became a member?
-- Create a common table expression that ranks the order date from earliest to latest since the customer became a member
WITH order_date_cte AS (
	SELECT 
		m.customer_id,
		m.join_date, 
		s.order_date, 
		s.product_id, 
		menu.product_name,
		RANK() OVER(PARTITION BY m.customer_id
					ORDER BY order_date) AS order_date_rank
	FROM members AS m
	-- Left join to ensure that only customers that have become a member are included
	LEFT JOIN sales AS s 
		USING (customer_id)
	LEFT JOIN menu 
		USING (product_id)
	-- Filter for orders that were purchased after the customer became a member
	WHERE order_date >= join_date
)

-- Find the item that was purchased first by the customer after they became a member
SELECT 
	customer_id,
	product_name
FROM order_date_cte
WHERE order_date_rank = 1
ORDER BY customer_id;
	
----- 7. Which item was purchased just before the customer became a member?
-- 8. What is the total items and amount spent for each member before they became a member?
-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all 

					  


	


