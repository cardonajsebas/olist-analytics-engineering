with source as (
    select * from {{ source('bronze', 'erp_geolocation') }}
),

typed as (
    select
        lpad(geolocation_zip_code_prefix, 5, '0') as geolocation_zip_code_prefix,
        safe_cast(geolocation_lat as float64)      as geolocation_lat,
        safe_cast(geolocation_lng as float64)      as geolocation_lng,
        lower(trim(geolocation_city))              as geolocation_city,
        upper(trim(geolocation_state))             as geolocation_state
    from source
),

filtered as (
    select * from typed
    where geolocation_lat between -33.75 and 5.27
        and geolocation_lng between -73.99 and -34.79
),

deduplicated as (
    select
        geolocation_zip_code_prefix,
        round(avg(geolocation_lat), 6) as geolocation_lat,
        round(avg(geolocation_lng), 6) as geolocation_lng,
        max(geolocation_city)          as geolocation_city,
        max(geolocation_state)         as geolocation_state
    from filtered
    group by geolocation_zip_code_prefix
)

select * from deduplicated
