SET search_path TO dannys_diner;
-- 1. What is the total amount each customer spent at the restaurant?
SELECT
	s.customer_id, 
	s.product_id, 
	COUNT(s.product_id) as product_count
FROM sales AS s
GROUP BY s.customer_id, s.product_id
