{{
  config(
    materialized = 'view'
    , unique_key = 'user_id'
  )
}}

WITH users_source AS (
  SELECT * FROM {{ source('src_greenery', 'users')}}
)

, renamed AS (
  SELECT
    user_id
    , first_name
    , last_name
    , email
    , phone_number
    , created_at AS created_at_utc
    , updated_at AS updated_at_utc
    , address_id
  FROM users_source
)

SELECT * FROM renamed