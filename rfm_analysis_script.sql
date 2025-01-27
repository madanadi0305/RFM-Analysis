--total number of customers, orders per country
select country,count(distinct customer_id) as total_customers,count(distinct Invoice) as total_orders,avg(price*quantity) as avg_revenue from tableRetail
group by country
;
--total number of distinct countries
SELECT Distinct country from tableRetail;
--total number of orders made based on time intervals
--monthly
with monthly_orders as(
select *,DATE(InvoiceDate) as Invoice_Date from tableRetail
)
select to_char(invoice_date, 'YYYY-MM') as year_month,count( Invoice) as number_of_orders from monthly_orders group by year_month;

--total quantities sold based on time intervals
with monthly_quantities as(
select *,DATE(InvoiceDate) as Invoice_Date from tableRetail
)
select to_char(invoice_date, 'YYYY-MM') as year_month,count( quantity) from monthly_quantities group by year_month;
--based on invoice date
select distinct InvoiceDate,count(invoice) over (partition by InvoiceDate) as number_of_orders_per_date 
from tableRetail 
order by number_of_orders_per_date desc;
--total Price per month
with monthly_price as(
select *,DATE(InvoiceDate) as invoice_date from tableRetail
)
select to_char(invoice_date,'yyyy-mm') as year_month,sum(price*quantity) as monthly_total_revenue from monthly_price
group by year_month; 
--total Price paid per time interval
select distinct InvoiceDate,sum(price*quantity) over(partition by InvoiceDate) as total_Price_per_date from tableRetail order by total_Price_per_date desc;

--rfm analysis
--checking for each customer, when was the most recent purchase they made
--checking the frequency of purchases for every customer-> Number of purchases/orders
--checking how much these customers spent
with rfm_table as(
select customer_id,max(date(InvoiceDate))  as last_purchase_date, count(invoice) as total_no_of_orders, (sum(price*quantity),2) as total_amnt_spent 
from tableRetail
group by customer_id;
),
with max_date_table as (
select max(DATE(InvoiceDate)) as max_date from tableRetail
)
select * from max_date_table;

--recency 

with rfm_table_1 as (
    select 
        customer_id,
        max(cast(InvoiceDate as date)) as last_purchase_date, 
        count(invoice) as total_no_of_orders, cast('9/9/2011' as date) as close_date,
        sum(price * quantity) as total_amnt_spent
    from 
        tableRetail
    group by 
        customer_id
)
select *,extract(month from age(close_date,last_purchase_date))  from rfm_table_1;


select cast(InvoiceDate as date) from tableRetail;

