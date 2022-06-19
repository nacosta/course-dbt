{{
  config(
      materialized = 'table'
    , unique_key = 'user_id'
  )
}}

WITH rank_urser_orders AS (
  SELECT
    *
    , ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY created_at_utc DESC) AS row_number
  FROM {{ ref('int_orders') }}
)

SELECT
  *
FROM rank_urser_orders
WHERE row_number = 1