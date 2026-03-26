
    
    

with child as (
    select seller_id as from_field
    from `olist-analytics-eng`.`gold`.`fact_orders`
    where seller_id is not null
),

parent as (
    select seller_id as to_field
    from `olist-analytics-eng`.`gold`.`dim_sellers`
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


