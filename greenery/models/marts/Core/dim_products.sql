{{
  config(
      materialized = 'table'
    , unique_key = 'product_id'
  )
}}

SELECT
  product_id,
  product_name,
  inventory >= 0 AS in_stock
FROM {{ ref('stg_greenery__products' )}}