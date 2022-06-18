{{
  config(
    materialized = 'view'
    , unique_key = 'promo_id'
  )
}}

WITH promos_source AS (
  SELECT * FROM {{ source('src_greenery', 'promos')}}
)

, lower_upper AS (
  SELECT 
    LOWER(promo_id) AS promo_id
    , discount as pct_discount
    , UPPER(status) AS status
  FROM promos_source
)

SELECT * FROM lower_upper