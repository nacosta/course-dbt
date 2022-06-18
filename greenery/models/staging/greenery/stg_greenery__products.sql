{{
  config(
    materialized = 'view'
    , unique_key = 'product_id'
  )
}}

WITH products_source AS (
  SELECT * FROM {{ source('src_greenery', 'products')}}
)

SELECT
  product_id
  , name
  , price
  , inventory
FROM products_source