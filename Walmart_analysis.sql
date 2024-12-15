SELECT *
	FROM Walmart;
--EDA
--	
select count(branch),branch
from walmart
group by 2
order by 1 desc
--

--Q1) What are the different payment methods, and how many transactions and items were sold with each method?
SELECT DISTINCT payment_method, count(invoice_id) as no_of_transactions, sum(quantity) as Total_quantity
from walmart
group by 1

--Q2)Which category received the highest average rating in each branch?
Select branch,category,avg_rating
from(
	select branch,category,avg(rating) as avg_rating,rank()over(partition by branch order by avg(rating) desc) as rnk
	from walmart
	group by 1,2)
where rnk =1

--Q3) What is the busiest day of the week for each branch based on transaction volume?

select * from walmart

SELECT 
    branch, 
    TO_CHAR(TO_DATE(date,'dd/mm/yy'), 'Day') AS Day_name, 
    COUNT(invoice_id) AS invoice_count
FROM 
    walmart
GROUP BY 
    1,2
order by
	1,3 desc;

--Q4)  How many items were sold through each payment method?

SELECT payment_method,sum(quantity) as total_sold_quantity
from walmart
group by 1
order by 2 desc;

--Q5) What are the average, minimum, and maximum ratings for each category in each city?

select category, city, avg(rating), min(rating), max(rating)
from walmart
group by 1,2

--Q6) What is the total profit for each category, ranked from highest to lowest?

select * from walmart

select category,sum(total_sales*(profit_margin/100)) as profit
from walmart
group by 1
order by 2 desc

--Q7)What is the most frequently used payment method in each branch?

with CTE as (
select branch,payment_method,count(*) as total_trans,
	rank() over(partition by branch order by count(*) DESC) as rnk
	from walmart
group by 1,2)

select *
from cte
where rnk =1


--Q8)How many transactions occur in each shift (Morning, Afternoon, Evening)

SELECT 
    branch,
    COUNT(*) AS transaction_count,
    CASE 
        WHEN EXTRACT(HOUR FROM time::time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM time::time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS Shift
FROM 
    walmart
GROUP BY 
    1,3
order by 3

--Q9)Which branches experienced the largest decrease in revenue compared to the previous year?

with previousyear as(
	SELECT branch,
	sum(total_sales) as revenue
	from walmart
	where extract(year from to_date(date,'dd-mm-yy')) = 2022
	group by 1
),
curryear as(
	SELECT branch,
	sum(total_sales) as revenue
	from walmart
	where extract(year from to_date(date,'dd-mm-yy')) = 2023
	group by 1
)

Select p.branch,p.revenue,c.revenue, ROUND((p.revenue - c.revenue)::numeric / p.revenue::numeric *100,2)
from previousyear p
join curryear c
on p.branch = c.branch
where p.revenue > c.revenue
order by 4 desc



