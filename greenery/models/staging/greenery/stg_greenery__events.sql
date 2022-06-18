{{
  config(
    materialized = 'view'
    , unique_key = 'event_id'
  )
}}

WITH events_source AS (
  SELECT * FROM {{ source('src_greenery', 'events') }}
)

, renamed_casted AS (
  SELECT
    event_id
    , session_id
    , user_id
    , UPPER(event_type) AS event_type
    , page_url
    , created_at AS created_at_utc
    , order_id
    , product_id
  FROM events_source
)

SELECT * FROM renamed_casted