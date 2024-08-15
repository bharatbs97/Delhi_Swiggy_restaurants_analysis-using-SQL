-- 1 use database
use restaurant_analysis;

-- 2 table name change
ALTER TABLE swiggy_restaurants
RENAME TO delhi_restro_data;

-- 3 print all
select*from delhi_restro_data;

-- 4 alter column name
ALTER TABLE delhi_restro_data
RENAME COLUMN `Avg ratings` to `rating`;
ALTER TABLE delhi_restro_data
RENAME COLUMN `Food type` to `specials`;
ALTER TABLE delhi_restro_data
RENAME COLUMN `Delivery time` to `delivery_time`;

-- 5 describe dataset
describe delhi_restro_data;
select count(*) from delhi_restro_data;

-- 6 rating data type alter 
ALTER TABLE delhi_restro_data
MODIFY COLUMN rating int;

-- 8 print new data type
select*from delhi_restro_data;
describe delhi_restro_data;

-- (01) how many total restaurants are there in the data?
Select count(Restaurant) from delhi_restro_data;

-- (02) no. of restro each category
select specials as category, count(distinct Restaurant) as total_restro from delhi_restro_data
group by specials
order by total_restro desc;

-- (03) Show details of restaurats with Indian speciality, sort cost lowest to highest
Select * from delhi_restro_data
where specials like "%Indian%"
order by Price;

-- (04) How many restaurants have indian as one of their speciality?
with cte1 as (
    select specials as category, count(distinct Restaurant) as total_restro from delhi_restro_data
    where specials like "%Indian%"
    group by specials
    order by total_restro desc)
    
select sum(total_restro)
from cte1;

-- (05) How many restaurants have only indian speciality?
with cte1 as (
     select specials as category, count(distinct Restaurant) as total_restro from delhi_restro_data
     where specials in ("Indian")
     group by specials
     order by total_restro desc)
     
select sum(total_restro)
from cte1; 

-- (06) Total How many restaurants are there by each rating type? No. of restro by rating?
select rating, count(distinct Restaurant) as total_restro 
from delhi_restro_data
group by rating
order by rating desc;

-- (07) Find details of expensive restro 600 plus
with cte1 as(
  select *from delhi_restro_data where Price >599
  order by Price)
  
select*, dense_rank () over (order by Price desc)
from cte1
order by Price desc;

-- (08) How many restro have 800 plus price?
with cte1 as(
  select *from delhi_restro_data where Price >799
  order by Price)
  
select Count(distinct Restaurant) 
from cte1;

-- (09) longest delivery_time 1hr plus
with cte1 as(
  select *from delhi_restro_data 
  where delivery_time > 60
  order by delivery_time)
  
select distinct Restaurant, rating, specials, Price, delivery_time, dense_rank () over (order by delivery_time desc) as denserank 
from cte1
order by delivery_time desc;

-- (10) How many restro have delivery_time 1hr plus?
with cte1 as(
  select *from delhi_restro_data 
  where delivery_time > 60
  order by delivery_time)
  
select Count(distinct Restaurant) as restaurants 
from cte1;

-- (11) Restro with 30min or less delivery_time
with cte1 as(
  select *from delhi_restro_data 
  where delivery_time < 31
  order by delivery_time)
  
select distinct Restaurant, specials, Price, delivery_time, dense_rank () 
over (order by delivery_time) as denserank 
from cte1
order by delivery_time;

-- (12) How many restro have 30min less delivery_time?
with cte1 as(
  select *from delhi_restro_data 
  where delivery_time < 31
  order by delivery_time)
  
 select Count(distinct Restaurant) as restaurants 
 from cte1;

-- (13) Clustering on the basis of type of specials and total number of factors
with cte1 as (
  select specials, count(distinct Restaurant) as total_restro, 
  count(distinct rating) as unique_rating, 
  count(distinct delivery_time) as distinct_time, 
  count(distinct Price) as unique_price
  from delhi_restro_data
  group by specials
)

select specials, sum(total_restro), 
sum(unique_rating), sum(distinct_time), 
sum(unique_price)
from cte1
group by specials
order by sum(total_restro)desc;

-- (14) Clustering on the basis of rating and total number of factors
with cte1 as (
  select rating, count(distinct specials) as distinct_specials,
  count(distinct Restaurant) as total_restro, 
  count(distinct delivery_time) as distinct_time, 
  count(distinct Price) as unique_price
  from delhi_restro_data
  group by rating
)

select rating, sum(total_restro), sum(distinct_specials), sum(distinct_time), 
sum(unique_price)
from cte1
group by rating;


-- (15) Rating wise avg cost time 
select rating, count(distinct Restaurant) as no_of_restro, avg(Price), 
avg(delivery_time) 
from delhi_restro_data
group by rating
order by avg(Price), avg(delivery_time)asc ;

-- (16) Cost wise averages
select Price, count(distinct Restaurant) as no_of_restro,  avg(delivery_time), avg(rating)
from delhi_restro_data
group by Price
order by Price desc ;

-- (17) Show top 5 most expensive restaurants
with cte1 as(
  select * , 
  dense_rank () over (order by Price desc) as ranking
  from delhi_restro_data
)
select distinct Restaurant, Price, ranking
 from cte1
 where ranking <6;
 
-- (18) Show top 5 most budget friendly restaurants
with cte1 as(
  select * , 
  dense_rank () over (order by Price) as ranking
  from delhi_restro_data
)

select distinct Restaurant, Price, ranking
 from cte1
 where ranking <6;

 -- (19) Top 5 most famous specials
 with cte1 as ( 
   select distinct(specials) as specials, count(distinct Restaurant) as total_restro
   from delhi_restro_data
   group by specials
   order by total_restro desc),
cte2 as (
  select *, dense_rank () over (order by total_restro desc) as ranking 
  from cte1)
  
select * from cte2
where ranking <6 ;

-- (20)  Top 5 most famous frequency of delivery time
   with cte1 as(
     select distinct(delivery_time) as delivery_time, count(distinct Restaurant) as total_restro
     from delhi_restro_data
     group by delivery_time
     order by total_restro desc),
cte2 as(
  select *, dense_rank () over (order by total_restro desc) as ranking 
from cte1)

select * from cte2
where ranking <6 ;

