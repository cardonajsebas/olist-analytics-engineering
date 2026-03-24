with source as (
    select * from {{ source('bronze', 'erp_order_payments') }}
),

cleaned as (
    select
        order_id,
        safe_cast(payment_sequential as int64)    as payment_sequential,
        lower(trim(payment_type))                 as payment_type,
        safe_cast(payment_installments as int64)  as payment_installments,
        safe_cast(payment_value as numeric)        as payment_value
    from source
    where order_id is not null
)

select * from cleaned
