with source as (
    select * from `olist-analytics-eng`.`bronze`.`crm_customers`
),

cleaned as (
    select
        customer_id,
        customer_unique_id,
        lpad(customer_zip_code_prefix, 5, '0') as customer_zip_code_prefix,
        lower(trim(customer_city))             as customer_city,
        upper(trim(customer_state))            as customer_state
    from source
    where customer_id is not null
)

select * from cleaned