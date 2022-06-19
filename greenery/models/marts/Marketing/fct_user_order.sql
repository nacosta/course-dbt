{{
  config(
      materialized = 'table'
    , unique_key = 'user_id'
  )
}}

WITH user_orders AS (
  SELECT 
    user_id
    , COUNT(DISTINCT order_id) AS orders_count
    , SUM(order_total_usd) AS orders_total_usd
    , AVG(order_total_usd) AS orders_avg_usd
    , MIN(created_at_utc) AS first_order_created_at_utc
  FROM {{ ref('fct_orders') }}
  GROUP BY user_id
)

SELECT
    users.user_id
    , users.state
    , users.country
    , users.is_active
    , users.last_interaction_utc
    , user_orders.orders_count
    , user_orders.orders_total_usd
    , user_orders.orders_avg_usd
    , user_orders.first_order_created_at_utc
    , user_last_order.created_at_utc as last_created_at_utc
    , user_last_order.order_total_usd
    , (EXTRACT(EPOCH FROM user_last_order.created_at_utc - user_orders.first_order_created_at_utc) / 86400) / orders_count AS days_to_deliverdays_repeat_rate
FROM {{ ref('dim_users') }} AS users
LEFT JOIN user_orders
  ON users.user_id = user_orders.user_id
LEFT JOIN {{ ref('int_user_last_order')}} AS user_last_order
  ON users.user_id = user_last_order.user_id