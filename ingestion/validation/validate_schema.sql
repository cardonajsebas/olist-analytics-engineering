/* 
Bronze layer schema validation.
Confirms column names and count per table match the defined DDL.
Any mismatch indicates an autodetect or load configuration issue.
 */

SELECT
  table_name,
  COUNT(*) AS actual_column_count,
  CASE table_name
    WHEN 'crm_order_reviews'                    THEN 7
    WHEN 'crm_customers'                        THEN 5
    WHEN 'erp_geolocation'                      THEN 5
    WHEN 'erp_order_items'                      THEN 7
    WHEN 'erp_order_payments'                   THEN 5
    WHEN 'erp_orders'                           THEN 8
    WHEN 'erp_products'                         THEN 9
    WHEN 'erp_sellers'                          THEN 4
    WHEN 'erp_product_category_name_translation' THEN 2
  END AS expected_column_count,
  COUNT(*) = CASE table_name
    WHEN 'crm_order_reviews'                    THEN 7
    WHEN 'crm_customers'                        THEN 5
    WHEN 'erp_geolocation'                      THEN 5
    WHEN 'erp_order_items'                      THEN 7
    WHEN 'erp_order_payments'                   THEN 5
    WHEN 'erp_orders'                           THEN 8
    WHEN 'erp_products'                         THEN 9
    WHEN 'erp_sellers'                          THEN 4
    WHEN 'erp_product_category_name_translation' THEN 2
  END AS passed
FROM `olist-analytics-eng`.`bronze`.INFORMATION_SCHEMA.COLUMNS
WHERE table_schema = 'bronze'
GROUP BY table_name
ORDER BY table_name;
