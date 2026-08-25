select *
from {{ ref('fct_daily_operations') }}
where
    sla_breach_rate < 0
    or sla_breach_rate > 1
    or (completed_items > 0 and sla_breach_rate is null)
    or (completed_items = 0 and sla_breach_rate is not null)
