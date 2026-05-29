# 03 — Running State
> Decay: HOT | Last updated: 2026-05-29 14:30

## Session Header
- **Today**: 2026-05-29
- **Current phase / milestone**: Phase 1 — Data Assessment (Week 3 of 4)
- **Last session summary**: Reviewed initial data profiling results; identified 3 critical gaps in HCP consent data; drafted escalation email to Marco

## Current Focus
- [ ] Finalize data gap analysis report (due 2026-06-01 for Steering Committee)
- [ ] Map Menarini's HCP segmentation to IQVIA NBA standard segments
- [ ] Prepare Phase 1 gate review deck

## Document Index
| # | Source File | Summary | Extracted | Absorbed Into | Status | Modified |
|---|---|---|---|---|---|---|
| 1 | sow_menarini_nba_v2.docx | ✅ | ✅ | 02 (Scope) | Current | 2026-04-10 |
| 2 | stakeholder_map.pptx | ✅ | ✅ | 01 (Stakeholders) | Current | 2026-04-15 |
| 3 | data_inventory_menarini.xlsx | ✅ | ✅ | 02 (Methodology) | Current | 2026-05-10 |
| 4 | veeva_api_spec.pdf | ✅ | ✅ | 02 (Settled Decisions) | Current | 2026-05-12 |
| 5 | nba_framework_guide.pdf | ✅ | ✅ | 02 (Methodology) | Current | 2026-03-01 |
| 6 | data_profiling_results_w3.xlsx | ❌ | ✅ | — | NEW | 2026-05-28 |

## Open Questions / Blockers
- [ ] HCP consent flags missing for ~15% of records — waiting on Marco's team to investigate (escalated 2026-05-28)
- [ ] Confirm: does Menarini want NBA recommendations at HCP level or brick level? (ask Thomas at Thursday call)
- [ ] French-language NBA message templates — who owns content creation on Menarini side?

## Decisions Log
| Date | Decision | Rationale | Reversible? |
|---|---|---|---|
| 2026-05-15 | Use Veeva API (real-time) over batch file | Reps need intra-day updates; batch = 24h delay | Yes (until integration build starts) |
| 2026-05-20 | Channels: detail + email + remote call only | Swiss market norms; SMS not used professionally | Yes |
| 2026-05-20 | Dual language outputs (DE + FR) | Rep territories are language-defined | No (architectural) |
| 2026-05-28 | Escalate HCP consent gap to client Data Lead | 15% missing = compliance risk; can't proceed without resolution | N/A |

## New Intel / Unverified
- [Unverified] Thomas mentioned Menarini may add oncology as 4th TA in Phase 2 — not in SOW
- [Inference] Data quality issues may push Phase 1 gate review by 1 week (currently monitoring)
- [Confirmed] Veeva sandbox access granted 2026-05-27 — Nina sent credentials via secure channel

## Change Log
| Date | Change |
|---|---|
| 2026-05-20 | Settled on channel mix and language approach |
| 2026-05-25 | Received data_inventory_menarini.xlsx; integrated into 02 |
| 2026-05-28 | Received data_profiling_results_w3.xlsx (NEW); escalated HCP consent gap |
| 2026-05-29 | Promoted Veeva sandbox access to confirmed; updated open questions |
