{{
  config(
    materialized = 'view'
    , unique_key = 'order_id'
  )
}}

WITH orders_source AS (
  SELECT * FROM {{ source('src_greenery', 'orders')}}
)

, renamed_casted AS (
  SELECT
    order_id
    , user_id
    , LOWER(promo_id) as promo_id
    , address_id
    , created_at AS created_at_utc
    , order_cost AS order_cost_usd
    , shipping_cost AS shipping_cost_usd
    , order_total AS order_total_usd
    , tracking_id
    , UPPER(shipping_service) AS shipping_service
    , estimated_delivery_at AS estimated_delivery_at_utc
    , delivered_at AS delivered_at_utc
    , UPPER(status) AS status
  FROM orders_source
)

SELECT * FROM renamed_casted