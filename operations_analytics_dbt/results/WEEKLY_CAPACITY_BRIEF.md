# Weekly capacity decision brief

## Executive signal

Demand increased from 2,263 to 2,398 items between the two generated five-day
weeks, a rise of approximately 6.0%. Completions kept pace, increasing from 2,268
to 2,411, but the combined SLA-breach rate rose from 3.66% to 4.36%.

The workload was handled in aggregate, but service performance weakened as volume
grew. The immediate question is therefore not simply whether more work was
completed; it is why a larger share of completed items missed the service window.

## Team-level interpretation

| Team | Week-two demand | Completed | Highest closing backlog | Throughput/hour | SLA breach rate | Pressure days |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Team Atlas | 797 | 791 | 349 | 1.45 | 4.42% | 0 |
| Team Borealis | 637 | 636 | 261 | 1.37 | 3.93% | 0 |
| Team Cedar | 964 | 984 | 492 | 1.57 | 4.57% | 1 |

Team Cedar deserves the first review. It recorded the highest workload, the only
pressure day and the highest weekly SLA-breach rate. Its completions exceeded new
demand by 20 items over the week, so the evidence suggests a short-lived pressure
point rather than an unresolved week-long capacity deficit.

Atlas and Borealis recorded no pressure days, and throughput improved for both.
However, their SLA-breach rates also increased. That combination suggests checking
work mix, prioritisation and ageing items before concluding that staffing alone is
the cause.

## Recommended next actions

1. Review Team Cedar's pressure date and separate ordinary workload from unusually
   complex or ageing items.
2. Compare SLA breaches by age band or work type for all teams; aggregate throughput
   may conceal late completion of older work.
3. Continue the weekly review before changing baseline staffing. Two generated
   weeks are sufficient to identify a question, not to establish a lasting trend.

## Scope and limitation

All values come from the project's generated sample seed. The data does not contain
work type, case complexity, absence, carry-over age or service-target detail. A
production decision would add those dimensions and confirm the operational context
with Team Leads before changing capacity.
