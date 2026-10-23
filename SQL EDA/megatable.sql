#creating a mega table for proper analysis
create table megatable as
select * from sales_data
left join customer_data
using(customer_id)
left join product_data
using(product_id)
left join store_data
using(store_id);

select * from megatable;

select distinct(age)from megatable;
update megatable
set age=(select avg(age) from customer_data)      #outliers not present already checked whle data cleaning
where age is null;

select distinct(gender)from megatable;
update megatable
set gender='Unknown'
where gender is null;

select distinct(city)from megatable;
update megatable
set city='Not mentioned'
where city is null;

select distinct(email)from megatable;
update megatable
set email='www.company@gmail.com'
where email is null;

#Total quantity sold
select sum(quantity) as total_quantity_sold from megatable;

#Quantity sold based on category
select category,sum(quantity) as total_quantity
from megatable group by category order by total_quantity desc;          #512 null values as a productid is not listed in the productData

update megatable
set category="Not Mentioned"     
where category is null;                      #cleaning null values


#Quantity sold based on color
select color,sum(quantity) as total_quantity from megatable
group by color order by total_quantity desc;

update megatable
set color="Not Defined"                    #Data Cleaning
where color is null;  

#Quantity sold based on Category and Color
select category,color,sum(quantity) as total_quantity
from megatable
group by category,color
order by category;

#max Quantity sold based on color and category
select category,color,sum(quantity) as total_quantity
from megatable
group by category,color
order by category,total_quantity desc;

#quantity sold based on size
select size,sum(quantity) as total_quantity
from megatable
group by size
order by total_quantity desc;

#quantity sold based on supplier
select supplier,sum(quantity) as total_quantity
from megatable
group by supplier
order by total_quantity desc;

#CostVSList PRICE
select cost_price,list_price from megatable;
select *,(list_price-cost_price) as profit  from megatable;

alter table megatable
add column profit decimal(10,4);          #adding profit column

update megatable
set profit=(list_price-cost_price);       #updating profit column

alter table megatable
add column loss decimal(10,4);            #adding loss column

update megatable
set loss=(list_price-cost_price)          #updating loss column
where (list_price-cost_price)<0;

update megatable
set profit=0                              #data cleaning
where (list_price-cost_price)<0;

update megatable                      #data cleaning
set loss=0 where loss is null;

update megatable
set profit=0   							#data cleaning
where profit is null;  

update megatable
set loss=0    							#data cleaning
where loss is null;  

alter table megatable
rename column profit to profit_per_quantity;

alter table megatable
rename column loss to loss_per_quantity;


#profit by category
select category,sum(profit_per_quantity*quantity) as total_profit
from megatable
group by category
order by total_profit desc;

#profit by category and color
select category,color,sum(profit_per_quantity*quantity) as total_profit
from megatable
group by category,color
order by category,total_profit desc;

#profit based on size
select size,sum(profit_per_quantity*quantity) as total_profit
from megatable
group by size
order by total_profit desc;

update megatable
set size="NM"   					#Data Cleaning  
where size is null;  

#profit based on supplier
select supplier,sum(profit_per_quantity*quantity) as total_profit
from megatable
group by supplier
order by total_profit desc;

update megatable
set supplier="Unknown"   					#Data Cleaning  
where supplier is null;


#loss by category
select category,sum(loss_per_quantity*quantity) as total_loss
from megatable
group by category
order by total_loss ;

#loss by category and color
select category,color,sum(loss_per_quantity*quantity) as total_loss
from megatable
group by category,color
order by category,total_loss;

#loss based on size
select size,sum(loss_per_quantity*quantity) as total_loss
from megatable
group by size
order by total_loss;

#loss based on supplier
select supplier,sum(loss_per_quantity*quantity) as total_loss
from megatable
group by supplier
order by total_loss;

#returns 
#no of returns
select sum(returned) from megatable;

#returns on category
select category,sum(returned) as total_returns
from megatable group by category
order by total_returns desc;

#returns on size
select size,sum(returned) as total_returns
from megatable group by size
order by total_returns desc;

#returns on supplier
select supplier,sum(returned) as total_returns
from megatable group by supplier
order by total_returns desc;

#quantity sales based on seasons
select season,sum(quantity) as total_sales
from megatable
group by season
order by total_sales desc;

update megatable
set season="Not Recorded"   					#Data Cleaning  
where season is null;

#revenue by season
select season,sum(profit_per_quantity*quantity) as total_profit
from megatable
group by season
order by total_profit desc;

#loss by season
select season,sum(loss_per_quantity*quantity) as total_loss
from megatable
group by season
order by total_loss;

#discount Allowed
select category,sum(quantity) as total_quantity,avg(discount) as average_discount
from megatable
group by category
order by average_discount desc;

#date
select max(date),min(date) from megatable;

select category,sum(profit_per_quantity*quantity) as total_sales
from megatable
where date between "2022-06-15" and "2023-07-13"
group by category;

#average profit per transaction based on category
select category,avg(profit_per_quantity*quantity) as average_revenue
from megatable
group by category
order by average_revenue desc;

#return rate
select sum(returned)/count(returned) as returned_rate
from megatable;



#quantity based on age
select age,sum(quantity) as total_quantity
from megatable
group by age
order by total_quantity desc;

#quantity based on gender
select gender,sum(quantity) as total_quantity
from megatable
group by gender
order by total_quantity desc;

#quantity based on city
select city,sum(quantity) as total_quantity
from megatable
group by city
order by total_quantity desc;

#average discount based on age
select age,avg(discount) as avg_discount
from megatable
group by age
order by avg_discount desc;

#average discount based on gender
select gender,avg(discount) as avg_discount
from megatable
group by gender
order by avg_discount desc;

#average discount based on city
select city,avg(discount) as avg_discount
from megatable
group by city
order by avg_discount desc;

#returns based on age
select age,sum(returned) as total_returns
from megatable
group by age
order by total_returns desc;

#returns based on gender
select gender,sum(returned) as total_returns
from megatable
group by gender								#Two columns of unknown and not verified is present 
order by total_returns desc;

update megatable
set gender="Unknown"
where gender ="Not Verified";


#returns based on city
select city,sum(returned) as total_returns
from megatable
group by city
order by total_returns desc;

#genders and their avg age
select gender,avg(age) as avg_age
from megatable
group by gender
order by avg_age desc;

#city and avg age
select city,avg(age) as avg_age
from megatable
group by city
order by avg_age desc;




#Quantity based on store id and store name
select store_id,store_name,sum(quantity) as total_quantity
from megatable
group by store_id,store_name
order by total_quantity desc;                             /*S999 is not present in store data but present in sales so we will
															update the table*/

update megatable
set store_name='Not Listed/Third Party'
where store_name is null;

#returns based on store
select store_id,store_name,sum(returned) as total_returns
from megatable
group by store_id,store_name
order by total_returns desc;     
                        
#quantity sold based on region
select region,sum(quantity) as total_quantity
from megatable
group by region order by total_quantity desc;      #481 null regions

update megatable
set region="Not Mentioned"
where region is null;


#profit based on gender
select gender,sum(profit_per_quantity*quantity) as total_profit
from megatable
group by gender
order by total_profit desc;

#profit based on city
select city,sum(profit_per_quantity*quantity) as total_profit
from megatable
group by city
order by total_profit desc;

#profit based on store name
select store_name,sum(profit_per_quantity*quantity) as total_profit
from megatable
group by store_name
order by total_profit desc;

#profit based on region
select region,sum(profit_per_quantity*quantity) as total_profit
from megatable
group by region
order by total_profit desc;


#loss based on gender
select gender,sum(loss_per_quantity*quantity) as total_loss
from megatable
group by gender
order by total_loss ;

#loss based on city
select city,sum(loss_per_quantity*quantity) as total_loss
from megatable
group by city
order by total_loss ;

#loss based on store name
select store_name,sum(loss_per_quantity*quantity) as total_loss
from megatable
group by store_name
order by total_loss ;

#loss based on region
select region,sum(loss_per_quantity*quantity) as total_loss
from megatable
group by region
order by total_loss;


#total selling during different seasons
select season,sum(list_price*quantity) as total_selling
from megatable
group by season
order by total_selling desc;

#Profit based on different years and month
create table sales_table as 
select year(date)sales_year,month(date)as sales_month,sum(profit_per_quantity*quantity) as profits,sum(quantity) as quantity_sold
from megatable
group by year(date),month(date)
order by sales_year,sales_month;


#Gross Profit and net profit
select category,sum(profit_per_quantity*quantity) as gross_profit,
sum((profit_per_quantity*quantity)-(list_price*discount)*quantity) as net_profit
from megatable
group by category
order by gross_profit desc;

alter table megatable
add column profit_after_discount decimal(10,5);

update megatable
set profit_after_discount=((list_price-cost_price)*quantity-(list_price*discount)*quantity)
where profit_per_quantity !=0;

update megatable
set profit_after_discount=0
where profit_per_quantity =0;



alter table megatable
add column loss_after_discount decimal(10,5);

update megatable
set loss_after_discount=(((list_price-cost_price)*quantity)-((list_price*discount)*quantity))
where loss_per_quantity !=0;

update megatable
set loss_after_discount=0
where loss_per_quantity =0;


#year to year sales/profits/loss/quantity sold
select year(date) as sales_year,sum(list_price*quantity) as gross_sales,sum(profit_per_quantity*quantity) as total_profit,
sum(loss_per_quantity*quantity) as total_loss,sum(quantity) as total_quantity,sum(profit_per_quantity*quantity)- -
sum(loss_per_quantity*quantity) as revenue_before_discount,sum(profit_after_discount) as net_profit
from megatable
group by sales_year
order by net_profit desc;

select * from megatable;
