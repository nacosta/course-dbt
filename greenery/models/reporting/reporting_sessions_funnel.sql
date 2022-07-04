{{
  config(
      materialized = 'table'
  )
}}

with dedup_metric_by_date as ( --if the snapshot runs multiple times on the same day we keep the last snapshot
  select
    dbt_valid_from::date as date,
    pct_drop_at_page_view_funnel,
    pct_drop_at_cart_funnel,
    row_number() over(partition by dbt_valid_from::date order by dbt_valid_from desc) as rn
  from {{ ref('snapshot_session_funnel') }}
)
select 
  date, 
  pct_drop_at_page_view_funnel,
  pct_drop_at_cart_funnel
from dedup_metric_by_date
where rn = 1
order by date