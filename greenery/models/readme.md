# WEEK 1

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

# WEEK 2
-- Answer1: 0.798 of customers repeats after making a purchase
```
WITH orders_per_user AS (
  SELECT 
    user_id
    , count(*) AS n_orders
  FROM dbt_neftali_a.stg_greenery__orders
  GROUP BY user_id
)
SELECT 
  SUM(CASE WHEN n_orders > 1 THEN 1 ELSE 0 END)::FLOAT / COUNT(*) AS repeat_rate
FROM orders_per_user
```

-- Answer2: 
* Customers who has made a purchase have 80% chances to repeat
* Customers who connected recently to the site 
* Customers who visited products with high conversion rate


 # WEEK 3
 ## PART 1: 
-- Session conversion rate: 62.5%

```
select 
  sum(is_converted_session) as n_converted,
  count(session_id) as n_sessions
from dbt_neftali_a.fct_sessions
;
```

-- Product conversion rate:
```
String of pearls, 0.60937500000000000000
Arrow Head, 0.55555555555555555556
Cactus, 0.54545454545454545455
ZZ Plant, 0.53968253968253968254
Bamboo, 0.53731343283582089552
Rubber Plant, 0.51851851851851851852
Monstera, 0.51020408163265306122
Calathea Makoyana, 0.50943396226415094340
Fiddle Leaf Fig, 0.50000000000000000000
Majesty Palm, 0.49253731343283582090
Aloe Vera, 0.49230769230769230769
Devil's Ivy, 0.48888888888888888889
Philodendron, 0.48387096774193548387
Jade Plant, 0.47826086956521739130
Spider Plant, 0.47457627118644067797
Pilea Peperomioides, 0.47457627118644067797
Dragon Tree, 0.46774193548387096774
Money Tree, 0.46428571428571428571
Orchid, 0.45333333333333333333
Bird of Paradise, 0.45000000000000000000
Ficus, 0.42647058823529411765
Birds Nest Fern, 0.42307692307692307692
Pink Anthurium, 0.41891891891891891892
Boston Fern, 0.41269841269841269841
Alocasia Polly, 0.41176470588235294118
Peace Lily, 0.40909090909090909091
Ponytail Palm, 0.40000000000000000000
Snake Plant, 0.39726027397260273973
Angel Wings Begonia, 0.39344262295081967213
Pothos, 0.34426229508196721311
```

```
select  
  product_name,
  count(distinct session_id) as n_sessions,
  sum(case when quantity_sold > 0 then 1 else 0 end)::decimal as n_orders,
  sum(case when quantity_sold > 0 then 1 else 0 end)::decimal / count(distinct session_id) as product_conversion
from dbt_neftali_a.fct_page_views
group by product_id, product_name
order by product_conversion desc;
```

#PART 2:
