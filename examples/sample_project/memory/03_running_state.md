# 03 — Running State
> Decay: HOT | Last updated: 2026-05-29 14:30

## Session Header
- **Today**: 2026-05-29
- **Current milestone / sprint**: Sprint 12 — Notification overhaul
- **Last session summary**: Implemented WebSocket reconnection logic; fixed race condition in task status transitions

## Current Focus
- [ ] Add email digest feature (daily summary of task changes per project)
- [ ] Refactor notification service to support pluggable channels
- [ ] Write integration tests for WebSocket events

## Document Index
| # | Source File | Summary | Extracted | Absorbed Into | Status | Modified |
|---|---|---|---|---|---|---|
| 1 | requirements_v2.docx | ✅ | ✅ | 02 (Requirements) | Current | 2026-04-10 |
| 2 | api_spec_v3.yaml | ✅ | N/A | 02 (API Surface) | Current | 2026-05-20 |
| 3 | schema_dump.sql | ✅ | N/A | 02 (DB Schema) | Current | 2026-05-25 |
| 4 | architecture_diagram.pptx | ✅ | ✅ | 01 (Codebase Map) | Current | 2026-03-15 |
| 5 | notification_rfc.md | ✅ | N/A | 02 (Architecture) | Current | 2026-05-22 |
| 6 | client_feedback_may.pdf | ❌ | ✅ | — | NEW | 2026-05-28 |

## Open Questions / Blockers
- [ ] Should email digests be opt-in or opt-out by default? (waiting on Lisa)
- [ ] Redis memory limits on staging — need DevOps to increase (tagged James)

## Decisions Log
| Date | Decision | Rationale | Reversible? |
|---|---|---|---|
| 2026-05-22 | Notification service uses strategy pattern for channels | Easy to add SMS/push later without modifying core | Yes |
| 2026-05-25 | Email digests sent at 8am user-local-time | Matches competitor behavior, avoids midnight noise | Yes |
| 2026-05-29 | Use Bull's built-in cron for digest scheduling | Simpler than separate cron service, already in stack | Yes (until prod deploy) |

## New Intel / Unverified
- [Unverified] Client may request Slack DM notifications (mentioned in feedback PDF, not confirmed)
- [Inference] Current Redis instance may need upgrade if digest jobs exceed 10K/day

## Change Log
| Date | Change |
|---|---|
| 2026-05-22 | Created notification_rfc.md; decided on strategy pattern for channels |
| 2026-05-25 | Implemented WebSocket reconnection; fixed task status race condition |
| 2026-05-29 | Decided on Bull cron for digests; flagged client_feedback_may.pdf as NEW |
