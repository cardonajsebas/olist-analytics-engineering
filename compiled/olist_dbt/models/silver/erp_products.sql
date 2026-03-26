with source as (
    select * from `olist-analytics-eng`.`bronze`.`erp_products`
),

cleaned as (
    select
        product_id,
        lower(trim(product_category_name))              as product_category_name,
        safe_cast(product_name_lenght as int64)         as product_name_length,
        safe_cast(product_description_lenght as int64)  as product_description_length,
        safe_cast(product_photos_qty as int64)          as product_photos_qty,
        safe_cast(product_weight_g as numeric)          as product_weight_g,
        safe_cast(product_length_cm as numeric)         as product_length_cm,
        safe_cast(product_height_cm as numeric)         as product_height_cm,
        safe_cast(product_width_cm as numeric)          as product_width_cm
    from source
    where product_id is not null
)

select * from cleaned