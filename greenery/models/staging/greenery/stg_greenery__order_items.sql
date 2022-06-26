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
    {{ dbt_utils.surrogate_key(['order_id', 'product_id']) }} AS order_item_id
    , order_id
    , product_id
    , quantity
  FROM order_items_source
)

SELECT * FROM unique_key