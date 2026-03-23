/* 
Bronze layer null check validation.
Checks primary and foreign key columns that should never be null
in a well-formed source file.
 */

SELECT 'crm_order_reviews - review_id'   AS check_name, COUNTIF(review_id IS NULL)   AS null_count FROM `olist-analytics-eng.bronze.crm_order_reviews`
UNION ALL
SELECT 'crm_order_reviews - order_id',    COUNTIF(order_id IS NULL)                                FROM `olist-analytics-eng.bronze.crm_order_reviews`
UNION ALL
SELECT 'crm_customers - customer_id',     COUNTIF(customer_id IS NULL)                             FROM `olist-analytics-eng.bronze.crm_customers`
UNION ALL
SELECT 'erp_orders - order_id',           COUNTIF(order_id IS NULL)                                FROM `olist-analytics-eng.bronze.erp_orders`
UNION ALL
SELECT 'erp_orders - customer_id',        COUNTIF(customer_id IS NULL)                             FROM `olist-analytics-eng.bronze.erp_orders`
UNION ALL
SELECT 'erp_order_items - order_id',      COUNTIF(order_id IS NULL)                                FROM `olist-analytics-eng.bronze.erp_order_items`
UNION ALL
SELECT 'erp_order_items - product_id',    COUNTIF(product_id IS NULL)                              FROM `olist-analytics-eng.bronze.erp_order_items`
UNION ALL
SELECT 'erp_order_payments - order_id',   COUNTIF(order_id IS NULL)                                FROM `olist-analytics-eng.bronze.erp_order_payments`
UNION ALL
SELECT 'erp_products - product_id',       COUNTIF(product_id IS NULL)                              FROM `olist-analytics-eng.bronze.erp_products`
UNION ALL
SELECT 'erp_sellers - seller_id',         COUNTIF(seller_id IS NULL)                               FROM `olist-analytics-eng.bronze.erp_sellers`

ORDER BY null_count DESC, check_name;
