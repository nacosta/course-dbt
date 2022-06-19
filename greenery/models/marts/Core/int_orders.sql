{{
  config(
      materialized = 'table'
    , unique_key = 'order_id'
  )
}}


-- test event checkout

SELECT
      orders.order_id
    , orders.user_id
    , promos.pct_discount
    , orders.shipping_address_id
    , addresses.zip_code
    , orders.created_at_utc
    , orders.order_cost_usd
    , orders.shipping_cost_usd
    , orders.order_total_usd
    , orders.tracking_id
    , orders.shipping_service
    , orders.estimated_delivery_at_utc
    , orders.delivered_at_utc
    , EXTRACT(EPOCH FROM orders.delivered_at_utc - orders.created_at_utc) / 86400 AS days_to_deliver
    , EXTRACT(EPOCH FROM orders.estimated_delivery_at_utc - orders.delivered_at_utc) / 86400 AS days_estimated_vs_delivery
    , EXTRACT(EPOCH FROM orders.estimated_delivery_at_utc - orders.delivered_at_utc) / 86400 < 0 AS is_delayed

FROM {{ ref('stg_greenery__orders') }} AS orders
LEFT JOIN {{ ref('stg_greenery__promos') }} AS promos
  ON orders.promo_id = promos.promo_id
LEFT JOIN {{ ref('stg_greenery__addresses')}} AS addresses
  ON orders.shipping_address_id = addresses.address_id
  