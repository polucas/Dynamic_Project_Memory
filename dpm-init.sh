#!/bin/bash
# dpm-init.sh — Initialize DPM directory structure for a new project
# Usage: ./dpm-init.sh [project_directory]

set -e

PROJECT_DIR="${1:-.}"

echo "🔧 Initializing DPM in: $PROJECT_DIR"

# Create directory structure
mkdir -p "$PROJECT_DIR"/{source_docs,memory/{_summaries,_extracted,_archive}}

# Create stub memory files
cat > "$PROJECT_DIR/memory/01_static_context.md" << 'EOF'
# 01 — Static Context
> Decay: COLD | Last updated: YYYY-MM-DD

## Project Identity
- **Project name**:
- **One-line description**:
- **Repository / workspace**:
- **In scope**:
- **Out of scope**:

## Stakeholders & Ownership
| Role | Person | Contact / Notes |
|---|---|---|

## Environment & Tooling
- **Language / framework**:
- **Infra / cloud**:
- **CI/CD**:
- **Key integrations**:

## Codebase Map
<!-- For code projects: high-level module/service map -->
<!-- For doc-only projects: remove this section -->

### Structure
```
src/
└── [describe top-level layout]
```

### Key Entry Points
- [main file / bootstrap]

### Module Dependencies
- [module A → module B → module C]

### Data Model Overview
- [key entities and relationships]

### External API Dependencies
| API / Service | Used By | Purpose |
|---|---|---|

## Constraints & Guardrails
- [Security / compliance constraints]
- [Budget / timeline hard limits]
- [Data sensitivity classification]

## Reference Links
- [Links to repo, wiki, Jira, etc.]
- ⚠️ No secrets — reference vault/env vars only
EOF

cat > "$PROJECT_DIR/memory/02_static_work.md" << 'EOF'
# 02 — Static Work Context
> Decay: WARM | Last updated: YYYY-MM-DD

## Requirements Summary
- [Summarized acceptance criteria — NOT full paste]
- [Link to full spec in source_docs/ or _summaries/]

## Architecture & Design Decisions (Settled)
| Decision | Choice | Date | Rationale |
|---|---|---|---|

## API Surface / Endpoint Index
<!-- For code projects with APIs -->
| Method | Endpoint | Handler | Auth | Notes |
|---|---|---|---|---|

## DB Schema Summary
<!-- Key tables/collections, relationships, migration status -->

## Conventions
- **Branching**:
- **Naming**:
- **Code style**:
- **Commit format**:
- **Deploy process**:
- **Error handling pattern**:
- **Logging standard**:

## Test Strategy
- **Framework**:
- **Coverage target**:
- **Test locations**:
- **CI integration**:

## CI/CD Pipeline
- **Stages**: [build → test → deploy]
- **Environments**: [dev / staging / prod differences]
- **Deploy trigger**:

## Known Risks & Mitigations
| Risk | Impact | Mitigation | Status |
|---|---|---|---|

## Appendix: Promoted Decisions
<!-- Decisions promoted from 03 that are now settled -->
EOF

cat > "$PROJECT_DIR/memory/03_running_state.md" << 'EOF'
# 03 — Running State
> Decay: HOT | Last updated: YYYY-MM-DD HH:MM

## Session Header
- **Today**: YYYY-MM-DD
- **Current milestone / sprint**:
- **Last session summary**:

## Current Focus
- [ ]
- [ ]
- [ ]

## Document Index
| # | Source File | Summary | Extracted | Absorbed Into | Status | Modified |
|---|---|---|---|---|---|---|

## Open Questions / Blockers
- [ ]

## Decisions Log
<!-- APPEND-ONLY — never delete -->
| Date | Decision | Rationale | Reversible? |
|---|---|---|---|

## New Intel / Unverified
<!-- Tag: [Inference] | [Unverified] | [Speculation] | [Confirmed] -->

## Change Log
<!-- APPEND-ONLY — one line per session end -->
| Date | Change |
|---|---|
EOF

echo "✅ DPM initialized in $PROJECT_DIR"
echo ""
echo "Next steps:"
echo "  1. Drop project files into $PROJECT_DIR/source_docs/"
echo "  2. Give your AI agent DPM_Bootstrap_Agent_Instructions.md"
echo "  3. Tell it: 'Execute all steps for this project starting from STEP 5'"
echo "     (Steps 1-4 are done — structure and stubs are created)"
echo ""
echo "Directory structure:"
find "$PROJECT_DIR" -type f -o -type d | head -20
