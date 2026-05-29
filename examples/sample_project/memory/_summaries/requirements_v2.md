# Summary: requirements_v2.docx
> Source: source_docs/requirements_v2.docx | Last synced: 2026-05-29 | Modified: 2026-04-10

## What This File Is
Product requirements document (PRD) for TaskFlow API v2, authored by Lisa Park (Product Owner). Covers all backend features for the task management platform.

## Key Content
- 4 user roles defined: Owner, Admin, Member, Viewer with permission matrix
- Task workflow: Draft → Open → In Progress → Review → Done → Archived
- 12 API endpoint groups covering auth, projects, tasks, comments, attachments, notifications
- Non-functional requirements: <100ms p95 reads, 99.9% uptime, SOC 2 audit logging
- Notification channels: in-app (WebSocket), email (transactional + digest), Slack webhook
- Phase 2 (future): mobile push, SMS, Stripe billing integration

## Structure
- Section 1: Overview & goals (2 pages)
- Section 2: User roles & permissions (3 pages)
- Section 3: Feature specifications by domain (15 pages)
- Section 4: Non-functional requirements (2 pages)
- Section 5: Phase 2 roadmap (1 page)
- Appendix: Wireframe references (links to Figma, not included)

## Dependencies / Cross-References
- Referenced by: 02 (Requirements Summary), notification_rfc.md
- References: Figma wireframes (external), competitor analysis doc (not in source_docs/)

## Notes
- Phase 2 items are explicitly out of scope for current development
- Permission matrix in Section 2 is the source of truth for auth middleware rules
- [Unverified] Lisa mentioned possible scope addition for guest access — not in this doc
