with orders as (
    select * from {{ ref('erp_orders') }}
),

order_items as (
    select * from {{ ref('erp_order_items') }}
),

payments as (
    select
        order_id,
        sum(payment_value)                  as total_payment_value,
        max(payment_installments)           as max_payment_installments,
        count(distinct payment_type)        as payment_type_count
    from {{ ref('erp_order_payments') }}
    group by order_id
),

final as (
    select
        -- keys
        oi.order_id,
        oi.order_item_id,
        oi.product_id,
        oi.seller_id,
        o.customer_id,
        date(o.order_purchase_timestamp)    as order_date,

        -- order status and timestamps
        o.order_status,
        o.order_purchase_timestamp,
        o.order_approved_at,
        o.order_delivered_carrier_date,
        o.order_delivered_customer_date,
        o.order_estimated_delivery_date,

        -- metrics
        oi.price,
        oi.freight_value,
        oi.price + oi.freight_value         as total_item_value,
        p.total_payment_value,
        p.max_payment_installments,
        p.payment_type_count,

        -- derived metrics
        date_diff(
            date(o.order_delivered_customer_date),
            date(o.order_purchase_timestamp),
            day
        )                                   as delivery_time_days,
        date_diff(
            date(o.order_estimated_delivery_date),
            date(o.order_delivered_customer_date),
            day
        )                                   as days_early_or_late,
        case
            when o.order_status = 'delivered'
            then true else false
        end                                 as is_delivered
    from order_items oi
    inner join orders o
        on oi.order_id = o.order_id
    left join payments p
        on oi.order_id = p.order_id
)

select * from final
