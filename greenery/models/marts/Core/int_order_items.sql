{{
  config(
    materialized = 'table'
    , unique_key = 'order_item_id'
  )
}}

SELECT 
  oi.order_item_id
  , o.order_id
  , o.created_at_utc
  , o.session_id
  , oi.product_id
  , p.product_name
  , oi.quantity
  , p.price_usd
FROM {{ ref("int_orders") }} as o
INNER JOIN {{ ref("stg_greenery__order_items") }} oi
  ON o.order_id = oi.order_id
LEFT JOIN {{ ref("stg_greenery__products") }} p
  ON oi.product_id = p.product_id