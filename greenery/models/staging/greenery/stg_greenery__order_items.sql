{{
  config(
    materialized = 'view'
    , unique_key = 'order_item_id'
  )
}}

WITH order_items_source AS (
  SELECT * FROM {{ source('src_greenery', 'order_items') }}
)

, unique_key AS (
  SELECT
    CONCAT(order_id, product_id) AS order_item_id
    , order_id
    , product_id
    , quantity
  FROM order_items_source
)

SELECT * FROM unique_key