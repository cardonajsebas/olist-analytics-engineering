/* 
Business rule: review_score must be between 1 and 5 inclusive.
Null scores are allowed (out-of-range values are nulled in Silver).
Returns rows where a non-null score falls outside the valid range.
 */

select
    review_id,
    order_id,
    review_score
from `olist-analytics-eng`.`silver`.`crm_order_reviews`
where review_score is not null
  and review_score not between 1 and 5