DROP TABLE IF EXISTS goldusers_signup;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS product;

CREATE TABLE goldusers_signup(userid INTEGER, gold_signup_date DATE);
CREATE TABLE users(userid INTEGER, signup_date DATE);
CREATE TABLE sales(userid INTEGER, created_date DATE, product_id INTEGER);
CREATE TABLE product(product_id INTEGER, product_name TEXT, price INTEGER);

INSERT INTO goldusers_signup(userid, gold_signup_date) 
VALUES 
(1, '2017-09-22'),
(3, '2017-04-21');

INSERT INTO users(userid, signup_date) 
VALUES 
(1, '2014-09-02'),
(2, '2015-01-15'),
(3, '2014-04-11');

INSERT INTO sales(userid, created_date, product_id) 
VALUES 
(1, '2017-04-19', 2),
(3, '2019-12-18', 1),
(2, '2020-07-20', 3),
(1, '2019-10-23', 2),
(1, '2018-03-19', 3),
(3, '2016-12-20', 2),
(1, '2016-11-09', 1),
(1, '2016-05-20', 3),
(2, '2017-09-24', 1),
(1, '2017-03-11', 2),
(1, '2016-03-11', 1),
(3, '2016-11-10', 1),
(3, '2017-12-07', 2),
(3, '2016-12-15', 2),
(2, '2017-11-08', 2),
(2, '2018-09-10', 3);

INSERT INTO product(product_id, product_name, price) 
VALUES
(1, 'p1', 980),
(2, 'p2', 870),
(3, 'p3', 330);

SELECT * FROM sales;
SELECT * FROM product;
SELECT * FROM goldusers_signup;
SELECT * FROM users;


-- What is the total amount each customer spent in Zomato?


SELECT s.userid, SUM(p.price) AS total_amount_spent
FROM SALES AS s
INNER JOIN product AS p
ON s.product_id = p.product_id
GROUP BY s.userid;

-- How many days has each customer visited Zomato?

SELECT userid, COUNT(DISTINCT created_date) AS distinct_days
FROM Sales
GROUP BY userid;

-- What was the first product purchased by each customer?

SELECT * 
FROM
(SELECT *,
RANK() OVER(PARTITION BY userid ORDER BY created_date) rnk FROM SALES)
s WHERE rnk = 1;

-- What is the most purchased item on the menu and how many times was it purchased by the customer?

SELECT userid, COUNT(product_id) AS Purchase_Time
FROM SALES
WHERE product_id = 
(SELECT product_id
FROM sales
GROUP BY product_id
ORDER BY COUNT(product_id) DESC
LIMIT 1)
GROUP BY userid
;

-- Which item was the most popular for each Customer?

SELECT *
FROM 
(
SELECT *, RANK() OVER(PARTITION BY userid ORDER BY CNT DESC) Ranking
FROM
(
SELECT userid, product_id, COUNT(product_id) AS CNT
FROM SALES
GROUP BY userid, product_id
) AS subquery
) AS subquery2
WHERE Ranking = 1;



-- Which item was purchased first by the Customer after they became a member?
SELECT *
FROM
(
    SELECT 
        s.userid, 
        s.created_date, 
        s.product_id, 
        g.gold_signup_date,
        RANK() OVER(PARTITION BY s.userid ORDER BY s.created_date DESC) AS Ranking2
    FROM Sales AS s
    -- Inner join because we want to only see members who have signed up
    INNER JOIN goldusers_signup AS g
    ON s.userid = g.userid
    WHERE s.created_date > g.gold_signup_date
) AS sq2 
WHERE Ranking2 = 1;

-- Which item was purchased just before the customer became a member?
SELECT order_details
(SELECT s.userid, s.created_date, s.product_id, g.gold_signup_date
FROM SALES AS s
INNER JOIN goldusers_signup AS g
ON s.userid = g.userid 
AND created_date <= gold_signup_date);


































