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
  count_page_view,
  count_add_to_cart,
  count_checkout,
  count_package_shipped,
  count_total_events
FROM {{ ref("int_sessions") }}