# 02 — Static Work Context
> Decay: WARM | Last updated: 2026-05-29

## Requirements Summary
- Users can create projects, invite members, manage tasks with status workflows
- Real-time notifications via WebSocket + email digests
- Role-based access: Owner, Admin, Member, Viewer
- Full spec: source_docs/requirements_v2.docx → _summaries/requirements_v2.md

## Architecture & Design Decisions (Settled)
| Decision | Choice | Date | Rationale |
|---|---|---|---|
| Database | PostgreSQL 15 (RDS) | 2026-03-01 | Team expertise, JSON support, strong typing |
| ORM | Sequelize v6 | 2026-03-01 | Existing team knowledge, migration support |
| Auth | JWT + refresh tokens | 2026-03-05 | Stateless API, mobile-ready |
| Cache | Redis (ElastiCache) | 2026-03-10 | Session store + query cache + pub/sub |
| Queue | Bull (Redis-backed) | 2026-03-10 | Email jobs, webhook delivery, cleanup tasks |
| Real-time | Socket.io | 2026-04-01 | Broad client support, fallback to polling |

## API Surface / Endpoint Index
| Method | Endpoint | Handler | Auth | Notes |
|---|---|---|---|---|
| POST | /auth/register | auth.register | Public | Rate-limited 5/min |
| POST | /auth/login | auth.login | Public | Returns JWT + refresh |
| GET | /projects | project.list | User | Paginated, filterable |
| POST | /projects | project.create | User | Creates + assigns owner |
| GET | /projects/:id/tasks | task.list | Member | Supports status filter |
| POST | /projects/:id/tasks | task.create | Member | Validates assignee membership |
| PATCH | /tasks/:id | task.update | Member | Status transition validation |
| WS | /ws | websocket.handler | User | Real-time task/comment updates |

## DB Schema Summary
- 8 tables: users, projects, project_members, tasks, comments, attachments, notifications, audit_log
- Key indexes: tasks(project_id, status), project_members(user_id), audit_log(created_at)
- Migrations: 14 applied, all current
- Full schema: _summaries/schema_dump.md

## Conventions
- **Branching**: GitFlow — main, develop, feature/*, bugfix/*, release/*
- **Naming**: camelCase (code), snake_case (DB), kebab-case (URLs)
- **Code style**: ESLint + Prettier, enforced in CI
- **Commit format**: Conventional Commits (feat:, fix:, chore:, docs:)
- **Deploy process**: PR → develop → CI green → merge to main → auto-deploy to staging → manual promote to prod
- **Error handling**: All services return `Result<T, AppError>` — no thrown exceptions in business logic
- **Logging**: Structured JSON via Winston, correlation IDs on all requests

## Test Strategy
- **Framework**: Jest + Supertest
- **Coverage target**: 80% lines, enforced in CI
- **Test locations**: `__tests__/` mirrors `src/` structure
- **CI integration**: Tests run on every PR, block merge if failing

## CI/CD Pipeline
- **Stages**: lint → test → build → push to ECR → deploy
- **Environments**: dev (auto-deploy from develop), staging (auto from main), prod (manual promotion)
- **Deploy trigger**: GitHub Actions on push to develop/main

## Known Risks & Mitigations
| Risk | Impact | Mitigation | Status |
|---|---|---|---|
| WebSocket scaling on ECS | High concurrency may need sticky sessions | Redis pub/sub adapter for Socket.io | Implemented |
| Sequelize N+1 queries | Slow list endpoints | Eager loading + query review checklist | Monitoring |
| Email deliverability | Users miss notifications | SendGrid dedicated IP + SPF/DKIM | Configured |

## Appendix: Promoted Decisions
- 2026-04-15: Decided to use cursor-based pagination (not offset) for all list endpoints — better performance at scale
- 2026-05-01: Adopted Result pattern for error handling — cleaner than try/catch in service layer
