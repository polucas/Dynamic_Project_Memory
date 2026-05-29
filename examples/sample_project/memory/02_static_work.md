# 02 — Static Work Context
> Decay: WARM | Last updated: 2026-05-29

## Scope & Requirements Summary
- Deploy IQVIA NBA solution for 3 therapeutic areas (cardiology, respiratory, diabetes)
- ~120 field reps across German-speaking and French-speaking Switzerland
- Integration with Menarini's Veeva CRM (push NBA recommendations as tasks)
- Full SOW: source_docs/sow_menarini_nba_v2.docx → _summaries/sow_menarini_nba_v2.md

## Key Deliverables
| # | Deliverable | Owner | Due | Status |
|---|---|---|---|---|
| 1 | Data assessment & gap analysis | Sara Fontana | 2026-06-15 | In progress |
| 2 | NBA model configuration (3 TAs) | Sara Fontana | 2026-07-15 | Not started |
| 3 | Veeva CRM integration (API + UI) | Nina Huber / IQVIA | 2026-08-01 | Not started |
| 4 | UAT with 10 pilot reps | Jed Malec | 2026-08-20 | Not started |
| 5 | Training materials + workshops | Jed Malec | 2026-09-01 | Not started |
| 6 | Go-live + 2-week hypercare | Full team | 2026-09-15 | Not started |

## Settled Decisions
| Decision | Choice | Date | Rationale |
|---|---|---|---|
| NBA platform | IQVIA Orchestrated Analytics | 2026-04-10 | Client requirement per SOW |
| CRM integration method | Veeva API (real-time push) | 2026-05-15 | Batch rejected — reps need intra-day updates |
| Channel prioritization | Detail, email, remote call | 2026-05-20 | Aligned with Swiss market norms; no SMS |
| Language handling | Dual outputs (DE + FR) | 2026-05-20 | Rep territories are language-defined |

## Methodology / Approach
- IQVIA standard NBA deployment framework (5-phase)
- Phase 1: Data assessment → Phase 2: Model config → Phase 3: Integration → Phase 4: UAT → Phase 5: Go-live
- Agile within phases (2-week sprints), waterfall across phases (gate reviews)
- Weekly client status call (Thursdays 10:00 CET)

## Known Risks & Mitigations
| Risk | Impact | Mitigation | Status |
|---|---|---|---|
| Menarini data quality issues (missing HCP consent flags) | Delays Phase 1 by 2+ weeks | Early data profiling sprint; escalation path to Marco | Monitoring |
| Veeva API rate limits during peak hours | NBA recommendations delayed for reps | Implement queuing + off-peak batch fallback | Planned |
| French-language content gaps in NBA templates | Poor adoption in Romandie region | Engage Menarini's local marketing for FR content review | Not started |
| Fixed-price overrun on integration complexity | Margin erosion | Detailed integration spike in Week 3; CR process defined | Planned |

## Appendix: Promoted Decisions
<!-- Decisions promoted from 03 that are now settled -->
