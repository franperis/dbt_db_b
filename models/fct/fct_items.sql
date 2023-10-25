{{
    config(
        materialized = 'incremental',
        on_schema_change = 'fail'
    )
}}

with raw_items as (
    select * from {{ source('nylmxsqe', 'items')}}
)

select
    id,
    name,
    description,
    price,
    created_at,
    _airbyte_normalized_at
from
    raw_items
where
    {% if is_incremental() %}
      _airbyte_normalized_at >= (select max(_airbyte_normalized_at) from {{ this }})
    {% else %}
      1=1
    {% endif %}
