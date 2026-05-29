# 01 — Static Context
> Decay: COLD | Last updated: 2026-05-29

## Project Identity
- **Project name**: TaskFlow API
- **One-line description**: REST API for a task management platform with team collaboration features
- **Repository / workspace**: github.com/acme/taskflow-api
- **In scope**: Backend API, database, auth, real-time notifications
- **Out of scope**: Frontend (separate repo), mobile apps, billing/payments

## Stakeholders & Ownership
| Role | Person | Contact / Notes |
|---|---|---|
| Project Lead | Sarah Chen | sarah@acme.com |
| Tech Lead | Marcus Rivera | Backend architecture decisions |
| Product Owner | Lisa Park | Requirements & prioritization |
| DevOps | James Wu | CI/CD, infrastructure |

## Environment & Tooling
- **Language / framework**: TypeScript / Node.js / Express
- **Infra / cloud**: AWS (ECS Fargate, RDS, ElastiCache)
- **CI/CD**: GitHub Actions → ECR → ECS
- **Key integrations**: SendGrid (email), Stripe (future), Slack webhooks

## Codebase Map

### Structure
```
src/
├── api/            # Express route handlers
│   ├── routes/     # Route definitions by domain
│   └── middleware/  # Auth, validation, error handling
├── services/       # Business logic layer
├── models/         # Sequelize ORM models
├── jobs/           # Background workers (Bull queues)
├── utils/          # Shared helpers (logger, date, crypto)
└── config/         # Environment configs
```

### Key Entry Points
- `src/index.ts` — app bootstrap, server start
- `src/api/routes/index.ts` — route registry
- `src/jobs/worker.ts` — background job processor

### Module Dependencies
- api → services → models → database
- jobs → services (reuses business logic)
- utils ← used by all layers

### Data Model Overview
- **User** → has many Projects (owner) → has many Tasks
- **Project** → has many Members (many-to-many via ProjectMember)
- **Task** → belongs to Project, assigned to User, has Comments

### External API Dependencies
| API / Service | Used By | Purpose |
|---|---|---|
| SendGrid | services/notification.ts | Transactional emails |
| Slack Webhooks | services/notification.ts | Team channel alerts |
| AWS S3 | services/attachment.ts | File uploads |

## Constraints & Guardrails
- SOC 2 compliance required — audit logging on all data mutations
- Max 100ms p95 latency for read endpoints
- PII encrypted at rest (RDS encryption + application-level for sensitive fields)
- No secrets in code — all via AWS Secrets Manager / env vars

## Reference Links
- Repo: github.com/acme/taskflow-api
- Wiki: notion.so/acme/taskflow
- Jira: acme.atlassian.net/browse/TF
- ⚠️ No secrets in memory — reference AWS Secrets Manager
