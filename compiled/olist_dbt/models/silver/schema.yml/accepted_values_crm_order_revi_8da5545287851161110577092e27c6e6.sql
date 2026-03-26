
    
    

with all_values as (

    select
        review_score as value_field,
        count(*) as n_records

    from (select * from `olist-analytics-eng`.`silver`.`crm_order_reviews` where review_score is not null) dbt_subquery
    group by review_score

)

select *
from all_values
where value_field not in (
    1,2,3,4,5
)


