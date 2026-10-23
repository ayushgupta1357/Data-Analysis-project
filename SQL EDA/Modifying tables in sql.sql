use sales_database;


##Primary key customer data
select * from customer_data;
describe customer_data;

select customer_id,count(*) as total_count
from customer_data
group by customer_id
having count(*)>1 or customer_id is null ;    #Can be used for Primary

alter table customer_data
modify column customer_id varchar(20) primary key,modify column gender varchar(12),  #modifying datatypes 
modify column city varchar(15),modify column email varchar (50);


#Primary Key Product data
select * from product_data;
describe product_data;

select product_id,count(*)
from product_data
group by product_id
having count(*)> 1 or product_id is null;  #Can be used for primary key

alter table product_data
modify column product_id varchar(20) primary key,modify column category varchar(20),
modify column color varchar(12),modify column size varchar(3),modify column season varchar(12)                     #modifying datatypes 
,modify column supplier varchar(14),modify column cost_price decimal(10,2),modify column list_price decimal(10,2);

#Primary key for sales data

select * from sales_data;
describe sales_data;

select transaction_id,count(*)
from sales_data
group by transaction_id
having count(*)> 1 or transaction_id is null;

alter table sales_data
modify column transaction_id varchar(20) primary key,modify column quantity int,      #modifying datatypes 
modify column discount decimal(5,3),modify column returned int;

#Primary key for store_id

select * from store_data;
describe store_data;

select store_id,count(*)
from store_data
group by store_id
having count(*)> 1 or store_id is null;   #can be used for primary key

alter table store_data
modify column store_id varchar(20) primary key,modify column store_name varchar(30),     #modifying datatypes   
modify column region varchar(15),modify column store_size_m2 int;


#Modifying main table
alter table sales_data
modify column date datetime;

alter table sales_data
modify column product_id varchar(20),modify column store_id varchar(20),
modify column customer_id varchar(20);

