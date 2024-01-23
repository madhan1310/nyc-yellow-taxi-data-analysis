CREATE DATABASE  IF NOT EXISTS `TRIP`;
USE `TRIP`;
CREATE TABLE TAXI(
vendorid int,
  tpep_pickup_datetime datetime,
  tpep_dropoff_datetime datetime,
  passenger_count int,
  trip_distance double,
  pickup_longitude double,
  pickup_latitude double,
  RatecodeID int,
  store_and_fwd_flag varchar(5),
  dropoff_longitude double,
  dropoff_latitude double,
  payment_type int,
  fare_amount double,
  extra double,
  mta_tax double,
  tip_amount double,
  tolls_amount double,
  improvement_surcharge double,
  total_amount double
);

truncate table taxi; 
 
set global local_infile=on;

LOAD DATA LOCAL INFILE '//Users/charansaialaparthi/Desktop/data warehouse/yellow_tripdata_2015-01.csv'
INTO TABLE taxi
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
ignore 1 rows;


select * from taxi;


SELECT DATE_FORMAT(tpep_pickup_datetime, '%H') AS pickup_hour, round(AVG(trip_distance),2) AS avg_distance, 
round(AVG(fare_amount),2) AS avg_fare
FROM TAXI WHERE trip_distance < 1000
GROUP BY pickup_hour 
order by pickup_hour,avg_distance desc;


SELECT payment_type, COUNT(*) AS num_trips
FROM TAXI
GROUP BY payment_type;


SELECT COUNT(*) AS central_park_rides
FROM TAXI
WHERE dropoff_latitude BETWEEN 40.764071 AND 40.800872
  AND dropoff_longitude BETWEEN -73.981363 AND -73.958014;


select tip_amount, count(*) as num_trips
from taxi 
group by tip_amount  
order by num_trips Desc;


select passenger_count, count(*) as num_trips 
from taxi 
group by passenger_count  
order by num_trips Desc;


select *, round(avg_total_amt/passenger_count,2) as average_per_person 
from ((select passenger_count, count(*) as count, round(avg(total_amount),2) as avg_total_amt 
from taxi 
where passenger_count in (1,2,3,4,5,6)
group by passenger_count)) as a order by average_per_person;


create  table payment_type(
paymentid int primary key,
type varchar(35)
);
INSERT INTO payment_type (paymentid, type)
VALUES 
(1, 'credit_card'),
(2, 'cash'),
(3, 'no_charge'),
(4, 'Dispute'),
(5, 'unknown'),
(6, 'voidedtrip');


create table rate_code(
ratecode_id int primary key,
type varchar(35)
);
INSERT INTO rate_code (ratecode_id, type)
VALUES
(1,'Standard rate'),
(2,'JFK'),
(3,'Newark'),
(4,'Nassau or Westchester'),
(5,'Negotiated fare'),
(6,'Group ride');


ALTER TABLE TAXI ADD CONSTRAINT fk_payment_type
FOREIGN KEY (payment_type)
REFERENCES payment_type(paymentid),
ADD CONSTRAINT fk_rate_code
FOREIGN KEY (RatecodeID)
REFERENCES rate_code(RatecodeID);


select vendorid, count(*) as num_trips, round(avg(fare_amount),2) as average, 
round(sum(fare_amount),2) as total
from taxi 
group by vendorid;


select round(sum(fare_amount)/sum(total_amount)*100,2) as fare_amount_percent,
round(sum(tip_amount)/sum(total_amount)*100,2) as tip_amount_percent,
round(sum(tolls_amount)/sum(total_amount)*100,2) as tolls_amount_percent,
round(sum(mta_tax)/sum(total_amount)*100,2) as mta,
round(sum(extra)/sum(total_amount)*100,2) as extra,
round(sum(improvement_surcharge)/sum(total_amount)*100,2) as improvement_surcharge 
from taxi;


select RatecodeID, round(avg(fare_amount),2) as average_fare_amount, 
count(*) as number_of_trips
from taxi 
group by RatecodeID;
 
 

 
 
 
 
 