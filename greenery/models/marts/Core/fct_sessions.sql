{{
  config(
      materialized = 'table'
    , unique_key = 'page_view_id'
  )
}}


SELECT
  session_id,
  session_start_at_utc,
  session_end_at_utc,
  is_converted_session,
  count_total_events
FROM {{ ref("int_sessions") }}