select distinct
    team_key,
    team_name,
    region
from {{ ref('stg_operational_events') }}
