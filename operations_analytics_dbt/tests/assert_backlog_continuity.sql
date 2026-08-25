with ordered_backlog as (
    select
        work_date,
        team_key,
        starting_backlog,
        lag(ending_backlog) over (
            partition by team_key
            order by work_date
        ) as previous_ending_backlog
    from {{ ref('fct_daily_operations') }}
)

select *
from ordered_backlog
where
    previous_ending_backlog is not null
    and starting_backlog != previous_ending_backlog
