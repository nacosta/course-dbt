{{
  config(
      materialized = 'table'
    , unique_key = 'user_id'
  )
}}

SELECT
  users.user_id
  , users.created_at_utc
  , addresses.state
  , addresses.country
  , last_interaction.last_event_type
  , last_interaction.last_interaction_utc 

  -- Active user has interaction in the last 30 days
  , EXTRACT(DAY FROM NOW() - last_interaction.last_interaction_utc) >= 30 AS is_active
FROM {{ ref('stg_greenery__users') }} AS users
LEFT JOIN {{ ref('stg_greenery__addresses')}} AS addresses
  ON users.address_id = addresses.address_id
LEFT JOIN {{ ref('int_user_last_interaction') }} AS last_interaction
  ON users.user_id = last_interaction.user_id