/*Instructions
Write the SQL queries to answer the following questions: */

-- 1) Select the first name, last name, and email address of all the customers who have rented a movie.

SELECT 
	UPPER(CONCAT(first_name,' ',last_name)) AS 'Customer Name', 
	email
FROM customer; 

-- 2) What is the average payment made by each customer (display the customer id, customer name (concatenated), and the average payment made).

SELECT 
	c.customer_id, 
	UPPER(CONCAT(c.first_name,' ',c.last_name)) AS 'Customer Name',
	c.email, ROUND(AVG(p.amount),2) "Average Rental Payment"
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id 
JOIN payment p ON p.rental_id = r.rental_id
GROUP BY c.customer_id
ORDER BY c.customer_id;

------------

-- 3) Select the name and email address of all the customers who have rented the "Action" movies.
	  # Write the query using multiple join statements

SELECT 
	UPPER(CONCAT(cu.first_name,' ',cu.last_name)) AS 'Customer Name',
	cu.email
FROM customer cu
JOIN rental r ON cu.customer_id = r.customer_id 
JOIN inventory i ON r.inventory_id = i.inventory_id 
JOIN film_category fa on i.film_id = fa.film_id
#JOIN category ca on fa.category_id = ca.category_id
WHERE fa.category_id = 1;

----------
-- Write the query using sub queries with multiple WHERE clause and IN condition

SELECT 
	CONCAT(first_name,' ',last_name) AS 'Customer Name', 
	email 
FROM customer 
WHERE customer_id in /* this 4th outer query links customer names & email to customer IDs*/
 
	(SELECT customer_id 
	FROM rental WHERE inventory_id in /* this 3rd query links customer IDs to previous query's inventory IDs*/

 		(SELECT inventory_id /* this 2nd query links inventory IDs to previous query's film IDs*/
		FROM inventory 
		WHERE film_id in 

  			(SELECT film_id 
			FROM film_category fa 
			JOIN category c on fa.category_id = c.category_id
			WHERE c.name = "Action" /* this is the 1st query and gives me all Action film IDs*/ )
		)
	);

-- Verify if the above two queries produce the same results or not
#1112 for joined solution vs 510 rows for subquery solution

-- 4) Use the case statement to create a new column classifying existing columns as either or high value transactions based on the amount of payment. If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4, the label should be medium, and if it is more than 4, then it should be high.

SELECT 
	payment_id, 
	amount, 
CASE WHEN amount >= 0 AND amount < 2 THEN 'Low' 
	WHEN amount >= 2 AND amount < 4 THEN 'Medium' 
	WHEN amount > 4 THEN 'High' 
END AS transaction_value 
FROM payment;             								 		 				   				            