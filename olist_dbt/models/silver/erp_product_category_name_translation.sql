with source as (
    select * from {{ source('bronze', 'erp_product_category_name_translation') }}
),

cleaned as (
    select
        lower(trim(product_category_name))         as product_category_name,
        lower(trim(product_category_name_english)) as product_category_name_english
    from source
    where product_category_name is not null
)

select * from cleaned
