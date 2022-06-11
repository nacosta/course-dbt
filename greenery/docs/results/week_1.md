-- How many users do we have?
-- Answer: 130
```
SELECT 
  COUNT(DISTINCT user_id) 
FROM dbt_neftali_a.stg_users
;
```


-- On average, how many orders do we receive per hour?
-- Answer: 7.52
```
WITH count_orders_hours AS (
  SELECT
    COUNT(DISTINCT order_id) AS n_orders,
    COUNT(DISTINCT DATE_TRUNC('hour', created_at_utc)) as n_hours
  FROM dbt_neftali_a.stg_orders
)
SELECT
  ROUND(n_orders::DECIMAL / n_hours, 2) AS avg_orders_per_hour
FROM count_orders_hours
;
```


-- On average, how long does an order take from being placed to being delivered?
-- Answer:3 days 21:24:11.803279
```
WITH delivered_orders AS (
  SELECT
    order_id
    , created_at_utc
    , delivered_at_utc
  FROM dbt_neftali_a.stg_orders
  WHERE status = 'DELIVERED'
)
SELECT 
  AVG(delivered_at_utc - created_at_utc) AS avg_delivery_time
FROM delivered_orders
;
```


-- How many users have only made one purchase? Two purchases? Three+ purchases?
-- Answer:  
-- 25 users with only one order
-- 28 users with two orders
-- 71 users with three or more orders
```
WITH user_orders_count AS (
  SELECT
    user_id
    , count(distinct order_id) n_orders
  FROM dbt_neftali_a.stg_orders
  GROUP BY user_id
)
SELECT
  SUM(CASE WHEN n_orders = 1 THEN 1 ELSE 0 END) AS users_one_order,
  SUM(CASE WHEN n_orders = 2 THEN 1 ELSE 0 END) AS users_two_orders,
  SUM(CASE WHEN n_orders >= 3 THEN 1 ELSE 0 END) AS users_three_plus_orders
FROM user_orders_count
;
```


-- On average, how many unique sessions do we have per hour?
-- Two possible answers depending what we consider a unique session is
-- Answer 1: 9.97 (We only consider one session event in the whole dataset)
```
WITH count_sessions_hours AS (
  SELECT
    COUNT(DISTINCT session_id) AS n_sessions,
    COUNT(DISTINCT DATE_TRUNC('hour', created_at_utc)) AS n_hours
  FROM dbt_neftali_a.stg_events
)
SELECT
  ROUND(n_sessions::DECIMAL / n_hours, 2) AS avg_sessions_per_hour
FROM count_sessions_hours
;
```

-- Answer2: 16.33 (We only consider one session event per hour)
```
WITH count_sessions_hours AS (
  SELECT
    DATE_TRUNC('hour', created_at_utc) AS date_hour
    , COUNT(DISTINCT session_id) AS n_sessions
  FROM dbt_neftali_a.stg_events
  GROUP BY date_hour
)
SELECT
  ROUND(AVG(n_sessions), 2) AS avg_sessions_per_hour
FROM count_sessions_hours
;
```