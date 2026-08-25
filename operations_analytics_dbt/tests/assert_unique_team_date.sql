select
    work_date,
    team_key,
    count(*) as row_count
from {{ ref('stg_operational_events') }}
group by 1, 2
having count(*) > 1
