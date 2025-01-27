with rfm_table_1 as (
    select 
        customer_id,
        max(cast(InvoiceDate as date)) as last_purchase_date, 
        count(invoice) as total_no_of_orders, cast('12/9/2011' as date) as close_date,
        sum(price * quantity) as total_amnt_spent
    from 
        tableRetail
    group by 
        customer_id
)
select *,extract(month from age(close_date,last_purchase_date))  from rfm_table_1;

select cast ('9/9/2011' as date) from tableRetail;
-- Step #3 using NTILE to segment the 2 factors (Recency and Monetary) *removed frequency since it indicates the volume as Monetary does* to segment customers in the next step
SELECT customer_id,
       NTILE(5) OVER(ORDER BY Recency) AS Recency,
       NTILE(5) OVER(ORDER BY Total_Price) AS Monetary
FROM( SELECT customer_id,
             Last_Date,
             ROUND((ROUND(MONTHS_BETWEEN(TO_DATE('12/9/2011 12:20','MM/DD/YYYY HH24:MI'),Last_Date),2)/30)*1000,0) Recency,
             Order_Count,
             Total_Price
       FROM (SELECT customer_id,
                    MAX(TO_DATE(invoicedate, 'MM/DD/YYYY HH24:MI')) AS Last_Date,
                    COUNT(invoice) AS Order_Count,
                    SUM(price*quantity) AS Total_Price
             FROM tableretail
             GROUP BY customer_id
             ORDER BY customer_id) inner_table) outer_table;
----------
select ntile(5) over(order by extract(month from age(close_date,last_purchase_date))) as recency, ntile(5) over(order by total_no_of_orders) as frequency ,
ntile(5) over(order by total_amnt_spent) from (
    select 
        customer_id,
        max(cast(InvoiceDate as date)) as last_purchase_date, 
        count(invoice) as total_no_of_orders, cast('12/9/2011' as date) as close_date,
        sum(price * quantity) as total_amnt_spent
    from 
        tableRetail
    group by 
        customer_id


)


select max(date(InvoiceDate)) from tableRetail;
-------------customer segmentation
select *,(case when recency=5 and frequency=5 and monetary=5 then 'Champions' when recency=4 and frequency=4 and monetary=5 then 'Loyal Customers' 
when recency=3 and frequency=2 and  monetary=4 then 'Potential Loyalist' when recency=5 and monetary=2 and frequency=1 then 'New Customers' when recency=2 and frequency=3 and monetary=4 then 'Needs Attention' else 'No Group' end) 
as CustomerSegment
from
(select ntile(5) over(order by extract(month from age(close_date,last_purchase_date))) as recency, ntile(5) over(order by total_no_of_orders) as frequency , 
ntile(5) over(order by total_amnt_spent) as monetary from (
    select 
        customer_id,
        max(cast(InvoiceDate as date)) as last_purchase_date, 
        count(invoice) as total_no_of_orders, cast('12/9/2011' as date) as close_date,
        sum(price * quantity) as total_amnt_spent
    from 
        tableRetail
    group by 
        customer_id


)s1
)s2


