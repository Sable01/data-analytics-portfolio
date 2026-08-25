with events as (
    select * from {{ ref('stg_operational_events') }}
),

teams as (
    select * from {{ ref('dim_team') }}
),

daily as (
    select
        events.work_date,
        events.team_key,
        teams.team_name,
        teams.region,
        events.starting_backlog,
        events.incoming_items,
        events.completed_items,
        events.starting_backlog + events.incoming_items - events.completed_items as ending_backlog,
        events.incoming_items - events.completed_items as net_flow,
        events.staffed_hours,
        round(events.completed_items / nullif(events.staffed_hours, 0), 2) as throughput_per_staffed_hour,
        events.sla_breaches,
        round(events.sla_breaches * 1.0 / nullif(events.completed_items, 0), 4) as sla_breach_rate,
        case
            when events.starting_backlog = 0 and events.incoming_items > events.completed_items then 'pressure'
            when events.starting_backlog = 0 then 'stable'
            when (events.starting_backlog + events.incoming_items - events.completed_items) >= events.starting_backlog * 1.10 then 'pressure'
            when (events.starting_backlog + events.incoming_items - events.completed_items) <= events.starting_backlog * 0.90 then 'recovery'
            else 'stable'
        end as capacity_status,
        events.source_updated_at
    from events
    inner join teams using (team_key)
)

select * from daily
