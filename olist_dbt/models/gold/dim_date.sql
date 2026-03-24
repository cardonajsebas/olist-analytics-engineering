with order_dates as (
    select distinct
        date(order_purchase_timestamp) as date_day
    from {{ ref('erp_orders') }}
    where order_purchase_timestamp is not null
),

final as (
    select
        date_day,
        extract(year from date_day)                             as year,
        extract(quarter from date_day)                          as quarter,
        extract(month from date_day)                            as month,
        format_date('%B', date_day)                             as month_name,
        extract(week from date_day)                             as week_of_year,
        extract(day from date_day)                              as day_of_month,
        extract(dayofweek from date_day)                        as day_of_week,
        format_date('%A', date_day)                             as day_name,
        case when extract(dayofweek from date_day) in (1, 7)
            then true else false end                            as is_weekend,
        date_trunc(date_day, month)                             as first_day_of_month,
        last_day(date_day)                                      as last_day_of_month
    from order_dates
)

select * from final
