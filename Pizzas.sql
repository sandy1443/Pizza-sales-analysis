create database pizzahut;
show tables;
select * from pizzas;
create table orders 
(
order_id int not null,
order_date date not null,
order_time time not null,
primary key (order_id)
);

select * From orders;
desc orders;

create table order_details
(
order_details_id int not null,
order_id int not null,
pizza_id text not null,
quantity int not null,
primary key (order_details_id)
);

select * from orders;
select * from order_details;
select * from pizza_types;
select * from pizzas;

desc order_details;

-- Retrieve the total number of orders placed.

select count(order_id) from  orders; 

-- Calculate the total revenue generated from pizza sales.
select * from pizzas;
select * from order_details;

SELECT 
    ROUND(SUM(o.quantity * p.price), 2) AS total_revenue
FROM
    pizzas AS p
        JOIN
    order_details AS o ON o.pizza_id = p.pizza_id;

-- Identify the highest-priced pizza.

select * from pizzas;
select * from pizza_types;
select * from orders;
select * from order_details;


SELECT 
    name, pi.price
FROM
    pizza_types AS pt
        JOIN
    pizzas AS pi ON pt.pizza_type_id = pi.pizza_type_id
ORDER BY price DESC
LIMIT 1;


-- Identify the most common pizza size ordered.

select * from pizzas;

select * from order_details;

select size,count(size) from pizzas group by size;

--select quantity,count(order_details_id) from order_details group by quantity;

SELECT 
    pizzas.size, COUNT(order_details.order_details_id) AS Count
FROM
    pizzas
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY size
ORDER BY count DESC;



-- List the top 5 most ordered pizza types along with their quantities.

select * from pizza_types;
select * from order_details;

select order_details.quantity,pizza_types.pizza_type_id 
from pizza_types
join
order_details on
pizza_types.pizza_type_id=order_details.;

SELECT 
    pizza_types.name,sum(order_details.quantity) as quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
    group by pizza_types.name order by quantity desc limit 5;
    
--     Join the necessary tables to find the total quantity of each pizza category ordered.
-- Intermediate

select * from pizzas;
select * from pizza_types;
select * from orders;
select * from order_details;

SELECT 
    pizza_types.category, SUM(order_details.quantity)
FROM
    pizza_types
        JOIN
    pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY category;


-- Determine the distribution of orders by hour of the day.

select * from pizzas;
select * from pizza_types;
select * from orders;
select * from order_details;

SELECT 
    HOUR(order_time) AS Hour, COUNT(order_id) AS Order_count
FROM
    orders
GROUP BY HOUR(order_time);	

-- Join relevant tables to find the category-wise distribution of pizzas.

select * from pizzas;
select * from pizza_types;
select * from orders;
select * from order_details;

select category,count(name) from pizza_types group by category;


-- Group the orders by date and calculate the average number of pizzas ordered per day.


select * from pizzas;
select * from pizza_types;
select * from orders;
select * from order_details;

SELECT 
    ROUND(AVG(Avergae_orders), 0)
FROM
    (SELECT 
        orders.order_date,
            SUM(order_details.quantity) AS Avergae_orders
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY orders.order_date) AS order_quantity;
    
    
    
--     Determine the top 3 most ordered pizza types based on revenue.

select * from pizzas;
select * from pizza_types;
select * from orders;
select * from order_details;

SELECT 
    pizza_types.name,
    SUM(order_details.quantity * pizzas.price) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY revenue DESC
LIMIT 3;


-- Calculate the percentage contribution of each pizza type to total revenue.

select * from pizzas;
select * from pizza_types;
select * from orders;
select * from order_details;

SELECT 
    pizza_types.category,
    ROUND(SUM(pizzas.price * order_details.quantity) / (SELECT 
                    ROUND(SUM(pizzas.price * order_details.quantity),
                                2) AS total_sale
                FROM
                    order_details
                        JOIN
                    pizzas ON pizzas.pizza_id = order_details.pizza_id) * 100,
            2) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.category;




-- Analyze the cumulative revenue generated over time.

select order_date,SUM(revenue) over(order by order_date) as cum_revenue from
(select orders.order_date ,sum(order_details.quantity*pizzas.price) as revenue
from order_details join 
pizzas
on order_details.pizza_id=pizzas.pizza_id
join orders
on orders.order_id=order_details.order_id
group by orders.order_date) as sales;	



-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.

select * from pizzas;
select * from pizza_types;
select * from orders;
select * from order_details;

select pizza_types.name ,pizza_types.category,pizzas.price*order_details.quantity AS PIZZA_PRICE
from pizzas
join 
pizza_types 
on
pizzas.pizza_type_id=pizza_types.pizza_type_id
join 
order_details on
order_details.pizza_id=pizzas.pizza_id
group by pizza_types.category;
-----------------------------------
select name,revenue from 
(select category,name,revenue,rank()over(partition by category order by revenue desc) as rn from
(select pizza_types.category,pizza_types.name ,
sum(pizzas.price*order_details.quantity) AS revenue
from pizzas
join 
pizza_types 
on
pizzas.pizza_type_id=pizza_types.pizza_type_id
join 
order_details on
order_details.pizza_id=pizzas.pizza_id
group by pizza_types.category ,pizza_types.name) as a)as b
where rn<=3;













