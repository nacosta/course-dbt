{{
  config(
    materialized = 'view'
    , unique_key = 'address_id'
  )
}}

WITH addresses_source AS (
  SELECT * FROM {{ source('src_greenery', 'addresses') }}
)

, renamed_casted AS (
  SELECT
    address_id
    , address AS street_address
    , LPAD(zipcode::VARCHAR, 5, '0') as zip_code
    , state
    , country
  FROM addresses_source
)

SELECT * FROM renamed_casted