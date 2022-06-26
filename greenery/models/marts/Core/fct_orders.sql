{{
  config(
      materialized = 'table'
    , unique_key = 'order_id'
  )
}}

SELECT
      orders.order_id
    , orders.session_id
    , orders.user_id
    , orders.zip_code
    , orders.created_at_utc
    , orders.order_cost_usd
    , orders.shipping_cost_usd
    , orders.order_total_usd   
    , orders.pct_discount   
    , orders.pct_discount * orders.order_cost_usd / 100 AS total_discount_usd  -- assumes discount only applies to products (no shipping,...)
    , orders.shipping_service
    , orders.estimated_delivery_at_utc
    , orders.delivered_at_utc
    , orders.days_estimated_vs_delivery
    , orders.is_delayed
    , orders_summed.total_items
    , orders_summed.total_products
FROM {{ ref('int_orders') }} AS orders
LEFT JOIN {{ ref('int_orders_summed') }} as orders_summed
  ON orders.order_id = orders_summed.order_id

      

