with products as (
    select * from `olist-analytics-eng`.`silver`.`erp_products`
),

translations as (
    select * from `olist-analytics-eng`.`silver`.`erp_product_category_name_translation`
),

final as (
    select
        p.product_id,
        p.product_category_name,
        coalesce(t.product_category_name_english, p.product_category_name)
            as product_category_name_english,
        p.product_name_length,
        p.product_description_length,
        p.product_photos_qty,
        p.product_weight_g,
        p.product_length_cm,
        p.product_height_cm,
        p.product_width_cm
    from products p
    left join translations t
        on p.product_category_name = t.product_category_name
)

select * from final