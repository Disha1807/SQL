use project;

select * from swiggy;

/*
QUESTIONS

01 HOW MANY RESTAURANTS HAVE A RATING GREATER THAN 4.5?
02 WHICH IS THE TOP 1 CITY WITH THE HIGHEST NUMBER OF RESTAURANTS?
02 HOW MANY RESTAURANTS SELL( HAVE WORD "PIZZA" IN THEIR NAME)?
03 WHAT IS THE MOST COMMON CUISINE AMONG THE RESTAURANTS IN THE DATASET?
05 WHAT IS THE AVERAGE RATING OF RESTAURANTS IN EACH CITY?
06 WHAT IS THE HIGHEST PRICE OF ITEM UNDER THE 'RECOMMENDED' MENU CATEGORY FOR EACH RESTAURANT?
07 FIND THE TOP 5 MOST EXPENSIVE RESTAURANTS THAT OFFER CUISINE OTHER THAN INDIAN CUISINE. 
08 FIND THE RESTAURANTS THAT HAVE AN AVERAGE COST WHICH IS HIGHER THAN THE TOTAL AVERAGE COST OF ALL    
   RESTAURANTS TOGETHER.
09 RETRIEVE THE DETAILS OF RESTAURANTS THAT HAVE THE SAME NAME BUT ARE LOCATED IN DIFFERENT CITIES.
10 WHICH RESTAURANT OFFERS THE MOST NUMBER OF ITEMS IN THE 'MAIN COURSE' CATEGORY?
11 LIST THE NAMES OF RESTAURANTS THAT ARE 100% VEGEATARIAN IN ALPHABETICAL ORDER OF RESTAURANT NAME
12 WHICH IS THE RESTAURANT PROVIDING THE LOWEST AVERAGE PRICE FOR ALL ITEMS?
13 WHICH TOP 5 RESTAURANT OFFERS HIGHEST NUMBER OF CATEGORIES?
14 WHICH RESTAURANT PROVIDES THE HIGHEST PERCENTAGE OF NON-VEGEATARIAN FOOD?
15 Determine the Most Expensive and Least Expensive Cities for Dining:
16 Calculate the Rating Rank for Each Restaurant Within Its City
*/

-- 01 HOW MANY RESTAURANTS HAVE A RATING GREATER THAN 4.5?

select count(distinct restaurant_name) as No_of_Restaurants
from swiggy
where rating > 4.5;

-- 02 WHICH IS THE TOP 1 CITY WITH THE HIGHEST NUMBER OF RESTAURANTS?

select city,max(distinct restaurant_name) as Restaurant_name,count(distinct restaurant_name) as no_of_rest
from swiggy
group by city
order by no_of_rest desc
limit 1;

-- 03 HOW MANY RESTAURANTS SELL( HAVE WORD "PIZZA" IN THEIR NAME)?

select count(distinct restaurant_name) as no_of_rest
from swiggy
where restaurant_name like '%PIZZA%';

-- 04 WHAT IS THE MOST COMMON CUISINE AMONG THE RESTAURANTS IN THE DATASET?

select restaurant_name,max(cuisine) as cuisine_name,count(cuisine) as cuisine_count
from swiggy
group by restaurant_name
order by cuisine_count desc;

select cuisine,count(*) as cuisine_count
from swiggy
group by cuisine
order by cuisine_count desc
limit 1;

-- 05 WHAT IS THE AVERAGE RATING OF RESTAURANTS IN EACH CITY?

select city,avg(rating) as AVG_Rating
from swiggy
group by city;

-- 06 WHAT IS THE HIGHEST PRICE OF ITEM UNDER THE 'RECOMMENDED' MENU CATEGORY FOR EACH RESTAURANT?

select distinct restaurant_name,menu_category,max(price) as Highest_price
from swiggy
where menu_category = 'RECOMMENDED'
group by restaurant_name,menu_category;

-- 07 FIND THE TOP 5 MOST EXPENSIVE RESTAURANTS THAT OFFER CUISINE OTHER THAN INDIAN CUISINE. 

select distinct restaurant_name,cost_per_person
from swiggy 
where cuisine <> 'INDIAN' 
order by cost_per_person desc
limit 5;

/* 08 FIND THE RESTAURANTS THAT HAVE AN AVERAGE COST WHICH IS HIGHER THAN THE TOTAL AVERAGE COST OF ALL    
   RESTAURANTS TOGETHER.*/
   
   select distinct restaurant_name ,cost_per_person
   from swiggy
   where cost_per_person > (select avg(cost_per_person) as AVG_price from swiggy);
   
   /* 09 RETRIEVE THE DETAILS OF RESTAURANTS THAT HAVE THE SAME NAME BUT ARE LOCATED IN DIFFERENT CITIES.*/
   
   select distinct s.restaurant_name,s.city,y.city
   from swiggy s 
   join swiggy y
   on s.restaurant_name = y.restaurant_name
   and s.city <> y.city;
   
   -- 10 WHICH RESTAURANT OFFERS THE MOST NUMBER OF ITEMS IN THE 'MAIN COURSE' CATEGORY?
   
   select distinct restaurant_name,menu_category,count(item) as item_count
   from swiggy
   where menu_category = 'MAIN COURSE'
   group by restaurant_name
   order by item_count desc
   limit 1;
  
  -- 11 LIST THE NAMES OF RESTAURANTS THAT ARE 100% VEGEATARIAN IN ALPHABETICAL ORDER OF RESTAURANT NAME.
  
  select distinct restaurant_name,
  (count(case when veg_or_nonveg = 'veg' then 1 end)*100/count(*)) as vegetarian_percentage
  from swiggy 
  group by restaurant_name
  having vegetarian_percentage = 100.00
  order by restaurant_name;
  
  -- 12 WHICH IS THE RESTAURANT PROVIDING THE LOWEST AVERAGE PRICE FOR ALL ITEMS?
  
  select distinct restaurant_name,avg(price) as AVG_PRICE
  from swiggy
  group by restaurant_name
  order by AVG_PRICE
  limit 1;
  
  -- 13 WHICH TOP 5 RESTAURANT OFFERS HIGHEST NUMBER OF CATEGORIES?
  
  select distinct restaurant_name,count(distinct menu_category) as N0_of_category
  from swiggy
  group by restaurant_name
  order by N0_of_category desc
  limit 5;
  
  -- 14 WHICH RESTAURANT PROVIDES THE HIGHEST PERCENTAGE OF NON-VEGEATARIAN FOOD?
  
  select distinct restaurant_name,
  (count(case when veg_or_nonveg = 'non-veg' then 1 end)*100/count(*)) as non_veg_percent
  from swiggy
  group by restaurant_name
  order by non_veg_percent desc limit 1;
  
  -- 15 Determine the Most Expensive and Least Expensive Cities for Dining:
  
  with minmax as (
	select city,
    max(cost_per_person) as most_expensive,
    min(cost_per_person) as least_expensive
    from swiggy
    group by city
  )
  
  select city,most_expensive,least_expensive from minmax;
    
-- 16 Calculate the Rating Rank for Each Restaurant Within Its City

with ranked_rating as (
select distinct restaurant_name,city,rating,
dense_rank() over(partition by city order by rating desc) as ranked_ratings
from swiggy)

select distinct restaurant_name,city,rating,ranked_ratings from ranked_rating
where ranked_ratings =1;