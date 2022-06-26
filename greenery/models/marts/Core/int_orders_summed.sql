  {{
  config(
      materialized = 'table'
    , unique_key = 'order_id'
  )
}}

SELECT
    order_id
    , sum(quantity) AS total_items
    , count(distinct product_id) AS total_products
  FROM {{ ref('int_order_items') }}
  GROUP BY order_id