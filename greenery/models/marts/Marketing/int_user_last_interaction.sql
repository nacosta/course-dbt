{{
  config(
      materialized = 'table'
    , unique_key = 'user_id'
  )
}}

WITH rank_events AS (
  SELECT
    user_id
    , event_type
    , created_at_utc
    , ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY created_at_utc DESC) AS row_number
  FROM {{ ref('stg_greenery__events') }}
)

SELECT
  user_id,
  event_type AS last_event_type,
  created_at_utc AS last_interaction_utc
FROM rank_events
WHERE row_number = 1
  