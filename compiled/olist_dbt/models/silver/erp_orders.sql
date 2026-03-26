with source as (
    select * from `olist-analytics-eng`.`bronze`.`erp_orders`
),

cleaned as (
    select
        order_id,
        customer_id,
        lower(trim(order_status))                          as order_status,
        safe_cast(order_purchase_timestamp as timestamp)   as order_purchase_timestamp,
        safe_cast(order_approved_at as timestamp)          as order_approved_at,
        safe_cast(order_delivered_carrier_date as timestamp)
                                                            as order_delivered_carrier_date,
        safe_cast(order_delivered_customer_date as timestamp)
                                                            as order_delivered_customer_date,
        safe_cast(order_estimated_delivery_date as timestamp)
                                                            as order_estimated_delivery_date
    from source
    where order_id is not null
        and customer_id is not null
)

select * from cleaned