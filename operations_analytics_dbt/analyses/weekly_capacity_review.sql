select
    date_trunc('week', work_date) as week_start,
    team_key,
    team_name,
    sum(incoming_items) as incoming_items,
    sum(completed_items) as completed_items,
    max(ending_backlog) as highest_closing_backlog,
    round(avg(throughput_per_staffed_hour), 2) as avg_throughput_per_staffed_hour,
    round(sum(sla_breaches) * 1.0 / nullif(sum(completed_items), 0), 4) as sla_breach_rate,
    sum(case when capacity_status = 'pressure' then 1 else 0 end) as pressure_days
from {{ ref('fct_daily_operations') }}
group by 1, 2, 3
order by week_start, pressure_days desc, highest_closing_backlog desc
