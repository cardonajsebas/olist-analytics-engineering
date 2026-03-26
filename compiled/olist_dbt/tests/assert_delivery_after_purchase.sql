/* 
Business rule: order delivery date must be after the purchase date.
A delivery timestamp earlier than or equal to the purchase timestamp 
indicates corrupt or incorrectly recorded data in the source system.
Only evaluated for delivered orders where both timestamps are present.
 */

select
    order_id,
    order_purchase_timestamp,
    order_delivered_customer_date
from `olist-analytics-eng`.`silver`.`erp_orders`
where order_delivered_customer_date is not null
  and order_purchase_timestamp is not null
  and order_delivered_customer_date < order_purchase_timestamp