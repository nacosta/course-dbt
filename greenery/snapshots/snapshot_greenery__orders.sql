{% snapshot snapshot_greenery__orders %}

    {{
        config(
          target_schema='snapshots',
          strategy='check',
          unique_key='order_id',
          check_cols=['status'],
        )
    }}

    select * from {{ source('src_greenery', 'orders') }}

{% endsnapshot %}
