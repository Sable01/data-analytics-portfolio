with source as (
    select * from {{ ref('operational_events') }}
),

typed as (
    select
        cast(work_date as date) as work_date,
        trim(team_key) as team_key,
        trim(team_name) as team_name,
        upper(trim(region)) as region,
        cast(starting_backlog as integer) as starting_backlog,
        cast(incoming_items as integer) as incoming_items,
        cast(completed_items as integer) as completed_items,
        cast(staffed_hours as decimal(12, 2)) as staffed_hours,
        cast(sla_breaches as integer) as sla_breaches,
        cast(source_updated_at as timestamp) as source_updated_at
    from source
)

select * from typed
