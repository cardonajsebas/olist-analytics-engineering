with source as (
    select * from {{ source('bronze', 'crm_order_reviews') }}
),

cleaned as (
    select
        review_id,
        order_id,
        case
            when safe_cast(review_score as int64) between 1 and 5
            then safe_cast(review_score as int64)
            else null
        end                                                        as review_score,
        nullif(trim(review_comment_title), '')                     as review_comment_title,
        nullif(trim(review_comment_message), '')                   as review_comment_message,
        safe_cast(review_creation_date as timestamp)               as review_creation_date,
        safe_cast(review_answer_timestamp as timestamp)            as review_answer_timestamp
    from source
    where review_id is not null
        and order_id is not null
)

select * from cleaned
