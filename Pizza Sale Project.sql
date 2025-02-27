-- Retrieve the total number of orders placed.
SELECT 
    COUNT(order_id) AS total_orders
FROM
    orders;
    
-- Calculate the total revenue generated from pizza sales.

SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price),
            2) AS total_revenue
FROM
    order_details
        JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id
    
-- Identify the highest-priced pizza.
SELECT 
    pt.name, p.price
FROM
    pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
ORDER BY p.price DESC
LIMIT 1;

-- Identify the most common pizza size ordered.
SELECT 
    p.size, COUNT(od.order_details_id) AS total_order
FROM
    pizzas p
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY p.size
ORDER BY COUNT(od.order_details_id) DESC;

-- the top 5 most ordered pizza types along with their quantities.

SELECT 
    pt.name, SUM(od.quantity) AS quantity
FROM
    pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY pt.name
ORDER BY COUNT(od.quantity) DESC
LIMIT 5;

-- Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT 
    pt.category, SUM(od.quantity) AS total_quantity
FROM
    pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY pt.category
ORDER BY total_quantity DESC;

-- Determine the distribution of orders by hour of the day
SELECT 
    HOUR(order_time) AS hour, COUNT(order_id) AS order_count
FROM
    orders
GROUP BY HOUR(order_time)
ORDER BY HOUR(order_time);

-- Join relevant tables to find the category-wise distribution of pizzas
SELECT 
    category, COUNT(name)
FROM
    pizza_types
GROUP BY category;

-- Group the orders by date and calculate the average number of pizzas ordered per day
SELECT 
     ROUND(AVG(total_quantity), 0) AS avg_pizza_ordered_per_day
FROM
    (SELECT 
        o.order_date, SUM(od.quantity) AS total_quantity
    FROM
        orders o
    JOIN order_details od ON o.order_id = od.order_id
    GROUP BY o.order_date) AS quantity_per_day;

-- Calculate the percentage contribution of each pizza type to total revenue.

SELECT 
    pt.category,
    ROUND(SUM(p.price * od.quantity) / (SELECT 
                    ROUND(SUM(p.price * od.quantity), 2) AS 'Total revenue'
                FROM
                    pizzas p
                        JOIN
                    order_details od ON p.pizza_id = od.pizza_id) * 100,
            2) AS revenue
FROM
    pizzas p
        JOIN
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY pt.category
ORDER BY revenue DESC

-- Determine the top 3 most ordered pizza types based on revenue
SELECT 
    pt.name, SUM(p.price * od.quantity) AS revenue
FROM
    pizzas p
        JOIN
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY pt.name
ORDER BY revenue DESC
LIMIT 3;

-- Calculate the percentage contribution of each pizza type to total revenue.

SELECT 
    pt.category,
    ROUND(SUM(p.price * od.quantity) / (SELECT 
                    ROUND(SUM(p.price * od.quantity), 2) AS 'Total revenue'
                FROM
                    pizzas p
                        JOIN
                    order_details od ON p.pizza_id = od.pizza_id) * 100,
            2) AS revenue
FROM
    pizzas p
        JOIN
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY pt.category
ORDER BY revenue DESC

