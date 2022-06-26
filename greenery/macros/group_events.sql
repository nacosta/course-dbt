
{% macro group_events() %}
  {% set event_types = [
    "ADD_TO_CART",
    "PAGE_VIEW", 
    "CHECKOUT",
    "PACKAGE_SHIPPED"
  ]%}
  {% for event_type in event_types %}
    SUM(CASE WHEN event_type = '{{ event_type }}' THEN 1 ELSE 0 END) AS count_{{ event_type.lower() }},
  {% endfor %}
{% endmacro %}