/* 
Business rule: price and freight_value must be greater than 0.
A zero or negative value indicates a data entry error in the source system.
Returns rows that violate this rule.
 */

select
    order_id,
    order_item_id,
    price,
    freight_value
from {{ ref('erp_order_items') }}
where price <= 0
    or freight_value < 0
