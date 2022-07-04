{% snapshot snapshot_session_funnel %}

    {{
config(
          target_schema='snapshots',
          strategy='timestamp',
          unique_key='updated_at',
          updated_at='updated_at',
        )
    }}

with grouped_sessions as (
  select 
    count(distinct session_id) as count_sessions,
    sum(case when count_page_view > 0 then 1 else 0 end) as count_sessions_with_page_views,
    sum(case when count_add_to_cart > 0 then 1 else 0 end) as count_sessions_with_add_to_cart,
    sum(case when count_checkout > 0 then 1 else 0 end) as count_sessions_with_purchases,
    sum(case when count_package_shipped > 0 then 1 else 0 end) as count_sessions_package_shipped
from dbt_neftali_a.fct_sessions
)
select
  current_timestamp as updated_at, 
  round(100 * count_sessions_with_add_to_cart::DECIMAL / count_sessions_with_page_views, 2) as pct_drop_at_page_view_funnel,
  round(100 * count_sessions_with_purchases::DECIMAL / count_sessions_with_add_to_cart, 2) as pct_drop_at_cart_funnel
from grouped_sessions

{% endsnapshot %}