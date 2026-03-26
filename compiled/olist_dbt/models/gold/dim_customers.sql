with customers as (
    select * from `olist-analytics-eng`.`silver`.`crm_customers`
),

geolocation as (
    select * from `olist-analytics-eng`.`silver`.`erp_geolocation`
),

final as (
    select
        c.customer_id,
        c.customer_unique_id,
        c.customer_zip_code_prefix,
        c.customer_city,
        c.customer_state,
        g.geolocation_lat as customer_lat,
        g.geolocation_lng as customer_lng
    from customers c
    left join geolocation g
        on c.customer_zip_code_prefix = g.geolocation_zip_code_prefix
)

select * from final