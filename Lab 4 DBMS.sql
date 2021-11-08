/*Q3 Display the number of the customer group by their genders 
who have placed any order of amount greater than or equal to Rs.3000. */
SELECT customer.CUS_GENDER, count(orderdetails.customer.cus_id) AS COUNT
FROM customer, orders
WHERE orders.CUS_ID = customer.CUS_ID
AND orders.ORD_AMOUNT >= 3000
GROUP BY CUS_GENDER;

/*Q4 Display all the orders along with the product name 
ordered by a customer having Customer_Id=2. */
SELECT orders.*, product.PRO_NAME FROM orders, product
WHERE orders.PRO_ID = product.PRO_ID
AND orders.CUS_ID = 2;

/*Q5 Display the Supplier details who can supply more than one product.*/
SELECT supplier.* FROM product_details, supplier
WHERE supplier.SUPP_ID = product_details.SUPP_ID 
GROUP BY product_details.SUPP_ID
HAVING COUNT(product_details.SUPP_ID) > 1;

/*Q6 Find the category of the product whose order amount is minimum.*/
SELECT category.* FROM orders, product, category
WHERE orders.PRO_ID = product.PRO_ID
AND product.CAT_ID = category.CAT_ID
HAVING MIN(orders.ORD_AMOUNT);

/*Q7 Display the Id and Name of the Product ordered after “2021-10-05”.*/
SELECT product.PRO_ID, product.PRO_NAME FROM orders
INNER JOIN product_details ON product_details.PRO_ID = orders.PRO_ID
INNER JOIN product ON product.PRO_ID = product_details.PRO_ID 
WHERE orders.ORD_DATE > '2021-10-05';

/*Q8 Print the top 3 supplier name and id and their rating 
on the basis of their rating along with the customer name who has given the rating.*/
SELECT supplier.SUPP_ID, supplier.SUPP_NAME, customer.CUS_NAME, rating.RAT_RATSTARS  
FROM customer, rating, supplier
WHERE customer.cus_id = rating.cus_id
AND rating.supp_id = supplier.supp_id
ORDER BY rating.RAT_RATSTARS DESC
LIMIT 3;

/*Q9 Display customer name and gender whose names start or end with character 'A'.*/
SELECT CUS_NAME, CUS_GENDER FROM customer
WHERE CUS_NAME LIKE '%A' OR CUS_NAME LIKE 'A%';

/*Q10 Display the total order amount of the male customers.*/
SELECT customer.CUS_GENDER, sum(orders.ORD_AMOUNT) AS ORD_SUM FROM customer, orders
WHERE customer.CUS_ID = orders.CUS_ID
AND customer.CUS_GENDER = 'M';

/*Q11 Display all the Customers left outer join with  the orders.*/
SELECT * FROM customer
LEFT OUTER JOIN orders ON customer.CUS_ID = orders.CUS_ID;

/*Q12 Create a stored procedure to display the Rating for a Supplier if any along with the 
Verdict on that rating if any like if rating >4 then “Genuine Supplier” if rating >2 “Average 
Supplier” else “Supplier should not be considered” */
USE `orderdetails`;
DROP procedure IF EXISTS `sup_review`;

USE `orderdetails`;
DROP procedure IF EXISTS `orderdetails`.`sup_review`;
;

DELIMITER $$
USE `orderdetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sup_review`()
BEGIN
SELECT supplier.SUPP_ID, supplier.SUPP_NAME, rating.RAT_RATSTARS,
CASE
	WHEN rating.RAT_RATSTARS > 4 THEN 'Genuine Supplier'
    WHEN rating.RAT_RATSTARS > 2 THEN 'Average Supplier'
    ELSE 'Supplier should not be Considered'
END AS SUP_REVIEW
FROM rating INNER JOIN supplier ON supplier.SUPP_ID = rating.SUPP_ID
ORDER BY rating.RAT_RATSTARS DESC;
END$$

DELIMITER ;
;
call sup_review();

