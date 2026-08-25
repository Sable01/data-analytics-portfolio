select *
from {{ ref('stg_operational_events') }}
where
    starting_backlog < 0
    or incoming_items < 0
    or completed_items < 0
    or staffed_hours < 0
    or sla_breaches < 0
    or completed_items > starting_backlog + incoming_items
    or sla_breaches > completed_items
