-- Question 1
select ch.channel_class,
       ch.channel_id,
       co.unit_price
  from sh.channels ch
  join costs co
on ch.channel_id = co.channel_id
 order by ch.channel_class;

-- Question 2
select s.prod_id,
       s.cust_id,
       s.channel_id,
       s.quantity_sold,
       case
         when s.quantity_sold > 10000                then
           'Above Average'
         when s.quantity_sold between 4000 and 10000 then
           'Average'
         else
           'Below Average'
       end as sales_category
  from sh.sales s;

-- Question 3
select s.channel_id,
       s.prod_id,
       p.prod_name,
       c.cust_first_name,
       c.cust_last_name,
       sum(s.amount_sold) as total_amount_sold
  from sh.sales s
  join sh.customers c
on c.cust_id = s.cust_id
  join sh.products p
on s.prod_id = p.prod_id
 group by s.channel_id,
          s.prod_id,
          p.prod_name,
          c.cust_first_name,
          c.cust_last_name,
          s.cust_id;

-- Question 4
select s.prod_id,
       p.prod_name,
       s.channel_id,
       round(
	       avg(s.amount_sold),
	       2
       ) as average_sold,
       min(p.PROD_MIN_PRICE) as min_sold
  from sh.sales s
  join sh.products p
on s.prod_id = p.prod_id
 group by s.prod_id,
          p.prod_name,
          s.channel_id;