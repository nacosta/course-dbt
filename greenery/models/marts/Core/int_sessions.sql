{{
  config(
      materialized = 'table'
    , unique_key = 'page_view_id'
  )
}}

SELECT
  session_id,
  MIN(created_at_utc) AS session_start_at_utc,
  MAX(created_at_utc) AS session_end_at_utc,
  MAX(CASE WHEN order_id IS NOT NULL THEN 1 ELSE 0 END)::BOOLEAN AS is_converted_session,
  {{ group_events() }}
  COUNT(*) AS count_total_events
FROM {{ ref('stg_greenery__events') }} AS events
GROUP BY session_id