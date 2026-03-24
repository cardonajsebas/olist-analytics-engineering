with source as (
    select * from {{ source('bronze', 'erp_order_items') }}
),

cleaned as (
    select
        order_id,
        safe_cast(order_item_id as int64)          as order_item_id,
        product_id,
        seller_id,
        safe_cast(shipping_limit_date as timestamp) as shipping_limit_date,
        safe_cast(price as numeric)                 as price,
        safe_cast(freight_value as numeric)         as freight_value
    from source
    where order_id is not null
        and product_id is not null
)

select * from cleaned
