/* 
Business rule: every row in fact_orders must join to a valid customer
in dim_customers. An orphan row indicates a referential integrity failure
between the orders and customers source tables.
Returns fact rows with no matching customer dimension record.
 */

select
    f.order_id,
    f.order_item_id,
    f.customer_id
from {{ ref('fact_orders') }} f
left join {{ ref('dim_customers') }} c
    on f.customer_id = c.customer_id
where c.customer_id is null
