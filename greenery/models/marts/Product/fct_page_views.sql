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
  , ROW_NUMBER() OVER (PARTITION BY events.session_id ORDER BY created_at_utc) AS seq_page_view_session
  , events.product_id
  , MAX(CASE WHEN events.order_id IS NOT NULL THEN 1 ELSE 0 END) OVER (PARTITION BY events.session_id) AS is_converted_session
  , order_items.quantity AS quantity_sold
FROM {{ ref('stg_greenery__events') }} AS events
LEFT JOIN {{ ref('stg_greenery__order_items')}} AS order_items
  ON events.order_id = order_items.order_id
     AND events.product_id = order_items.product_id
WHERE event_type = 'PAGE_VIEW'