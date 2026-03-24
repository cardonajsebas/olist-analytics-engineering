with source as (
    select * from {{ source('bronze', 'erp_sellers') }}
),

cleaned as (
    select
        seller_id,
        lpad(seller_zip_code_prefix, 5, '0') as seller_zip_code_prefix,
        lower(trim(seller_city))             as seller_city,
        upper(trim(seller_state))            as seller_state
    from source
    where seller_id is not null
)

select * from cleaned
