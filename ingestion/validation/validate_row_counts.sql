/* 
Bronze layer row count validation.
Expected counts based on the initial load from source CSVs.
Run after each Bronze load to confirm no rows were dropped or duplicated.
 */

SELECT
  'crm_order_reviews'                    AS table_name,
  COUNT(*)                               AS actual_rows,
  99224                                  AS expected_rows,
  COUNT(*) = 99224                       AS passed
FROM `olist-analytics-eng.bronze.crm_order_reviews`

UNION ALL

SELECT
  'crm_customers',
  COUNT(*),
  99441,
  COUNT(*) = 99441
FROM `olist-analytics-eng.bronze.crm_customers`

UNION ALL

SELECT
  'erp_geolocation',
  COUNT(*),
  1000163,
  COUNT(*) = 1000163
FROM `olist-analytics-eng.bronze.erp_geolocation`

UNION ALL

SELECT
  'erp_order_items',
  COUNT(*),
  112650,
  COUNT(*) = 112650
FROM `olist-analytics-eng.bronze.erp_order_items`

UNION ALL

SELECT
  'erp_order_payments',
  COUNT(*),
  103886,
  COUNT(*) = 103886
FROM `olist-analytics-eng.bronze.erp_order_payments`

UNION ALL

SELECT
  'erp_orders',
  COUNT(*),
  99441,
  COUNT(*) = 99441
FROM `olist-analytics-eng.bronze.erp_orders`

UNION ALL

SELECT
  'erp_products',
  COUNT(*),
  32951,
  COUNT(*) = 32951
FROM `olist-analytics-eng.bronze.erp_products`

UNION ALL

SELECT
  'erp_sellers',
  COUNT(*),
  3095,
  COUNT(*) = 3095
FROM `olist-analytics-eng.bronze.erp_sellers`

UNION ALL

SELECT
  'erp_product_category_name_translation',
  COUNT(*),
  71,
  COUNT(*) = 71
FROM `olist-analytics-eng.bronze.erp_product_category_name_translation`

ORDER BY table_name;
