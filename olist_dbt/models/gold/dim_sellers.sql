with sellers as (
    select * from {{ ref('erp_sellers') }}
),

geolocation as (
    select * from {{ ref('erp_geolocation') }}
),

final as (
    select
        s.seller_id,
        s.seller_zip_code_prefix,
        s.seller_city,
        s.seller_state,
        g.geolocation_lat as seller_lat,
        g.geolocation_lng as seller_lng
    from sellers s
    left join geolocation g
        on s.seller_zip_code_prefix = g.geolocation_zip_code_prefix
)

select * from final
