# Data dictionary

This dictionary describes the generated sample data and the three dbt models built
from it. Names and values are generic and do not reproduce an employer system.

## Model overview

| Model | Grain | Purpose |
| --- | --- | --- |
| `operational_events` | One row per team and work date | Generated input seed representing daily workload and capacity observations |
| `stg_operational_events` | One row per team and work date | Cleaned and typed source fields used by downstream models |
| `dim_team` | One row per team | Stable team attributes for reporting and filtering |
| `fct_daily_operations` | One row per team and work date | Decision-ready workload, capacity, productivity and SLA measures |

## `stg_operational_events`

| Field | Type | Nullable | Definition and use |
| --- | --- | --- | --- |
| `work_date` | date | No | Calendar date represented by the daily observation |
| `team_key` | text | No | Generic stable identifier used to join team attributes |
| `team_name` | text | No | Human-readable generic team label |
| `region` | text | No | Reporting scope; accepted sample values are `EMEA` and `GLOBAL` |
| `starting_backlog` | integer | No | Items open at the beginning of the date |
| `incoming_items` | integer | No | New items received during the date |
| `completed_items` | integer | No | Items completed during the date |
| `staffed_hours` | decimal | No | Total staffed hours available to the team during the date |
| `sla_breaches` | integer | No | Completed items recorded outside the target service window |
| `source_updated_at` | timestamp | No | Generated timestamp showing when the source observation was last refreshed |

### Valid operational balance

For each row, all workload and capacity values must be non-negative.
`completed_items` cannot exceed `starting_backlog + incoming_items`, and
`sla_breaches` cannot exceed `completed_items`. A singular dbt test checks these
rules directly. A separate continuity test compares each team's starting backlog
with the previous recorded ending backlog.

## `dim_team`

| Field | Type | Nullable | Definition and use |
| --- | --- | --- | --- |
| `team_key` | text | No | Primary key for the generic operating team |
| `team_name` | text | No | Display name used in dashboards and review outputs |
| `region` | text | No | Reporting scope inherited from the staged event records |

## `fct_daily_operations`

| Field | Type | Nullable | Definition and use |
| --- | --- | --- | --- |
| `work_date` | date | No | Calendar date of the workload observation |
| `team_key` | text | No | Foreign key to `dim_team` |
| `team_name` | text | No | Team label included for convenient review |
| `region` | text | No | Team reporting scope |
| `starting_backlog` | integer | No | Items open at the beginning of the date |
| `incoming_items` | integer | No | New items received during the date |
| `completed_items` | integer | No | Items completed during the date |
| `ending_backlog` | integer | No | `starting_backlog + incoming_items - completed_items` |
| `net_flow` | integer | No | `incoming_items - completed_items`; positive values mean demand exceeded completions |
| `staffed_hours` | decimal | No | Total staffed hours available during the date |
| `throughput_per_staffed_hour` | decimal | Yes | `completed_items / staffed_hours`; null when staffed hours are zero |
| `sla_breaches` | integer | No | Completed items outside the target service window |
| `sla_breach_rate` | decimal | Yes | `sla_breaches / completed_items`; null when no items were completed |
| `capacity_status` | text | No | `pressure`, `recovery` or `stable`, based on the change from starting to ending backlog |
| `source_updated_at` | timestamp | No | Generated source-refresh timestamp retained for traceability |

## Interpretation notes

- Backlog is a stock measure, so the weekly review uses the highest daily closing
  backlog rather than summing it across dates.
- Incoming and completed items are flow measures and can be summed across dates.
- The weekly SLA rate is recalculated from total breaches and completions. It is
  not an unweighted average of daily rates.
- A singular test requires every non-null SLA-breach rate to remain between zero
  and one and requires a null rate when completed items are zero.
- Throughput helps compare output with available time, but it should be interpreted
  alongside workload mix, quality and SLA performance rather than as a standalone
  productivity target.
