{{
  config(
      materialized = 'table'
    , unique_key = 'page_view_id'
  )
}}

SELECT
    events.event_id AS page_view_id
    , events.session_id
    , events.created_at_utc
    , events.product_id
    , products.product_name
    , order_items.price_usd
    , order_items.quantity AS quantity_sold
FROM {{ ref("stg_greenery__events") }} as events
LEFT JOIN {{ ref('int_order_items')}} AS order_items
  ON events.session_id = order_items.session_id
     AND events.product_id = order_items.product_id
LEFT JOIN {{ ref("stg_greenery__products") }} AS products
  ON events.product_id = products.product_id
WHERE event_type ='PAGE_VIEW'