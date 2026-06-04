#!/bin/bash
# dpm-init.sh — Initialize DPM directory structure for a business project
# Usage: ./dpm-init.sh [project_directory]

set -e

PROJECT_DIR="${1:-.}"

echo "🔧 Initializing DPM in: $PROJECT_DIR"

mkdir -p "$PROJECT_DIR"/{source_files,DPM_instructions,agent_outputs,.cursor/{rules,skills},memory/{_summaries,_extracted,_archive}}

cat > "$PROJECT_DIR/memory/01_static_context.md" << 'EOF'
# 01 — Static Context
> Decay: COLD | Last updated: YYYY-MM-DD

## Project Identity
- **Project name**:
- **One-line description**:
- **Client / sponsor**:
- **In scope**:
- **Out of scope**:

## Stakeholders & Ownership
| Role | Person | Contact / Notes |
|---|---|---|

## Tools & Platforms
- **Collaboration**: [Teams, Slack, SharePoint, etc.]
- **Project tracking**: [Jira, Planner, Asana, etc.]
- **Data / analytics**: [platforms, BI tools, data sources]
- **Document repository**: [SharePoint, Google Drive, etc.]

## Constraints & Guardrails
- [Budget / timeline hard limits]
- [Compliance / regulatory requirements]
- [Data sensitivity / NDA scope]
- [Approval gates or governance processes]

## Reference Links
- [Links to project site, shared drives, trackers]
- No confidential data in memory — reference secure locations only
EOF

cat > "$PROJECT_DIR/memory/02_static_work.md" << 'EOF'
# 02 — Static Work Context
> Decay: WARM | Last updated: YYYY-MM-DD

## Scope & Requirements Summary
- [Summarized objectives and deliverables — NOT full paste]
- [Link to full SOW/brief in source_files/ or _summaries/]

## Key Deliverables
| ID | Deliverable | Owner | Due | Status | Last Updated |
|---|---|---|---|---|---|

## Settled Decisions
| ID | Decision | Choice | Date | Rationale |
|---|---|---|---|---|

## Methodology / Approach
- [Frameworks, methodologies, analytical approaches being used]

## Known Risks & Mitigations
| ID | Risk | Impact | Mitigation | Owner | Status | Review Date |
|---|---|---|---|---|---|---|

## Appendix: Promoted Decisions
<!-- Decisions promoted from 03 that are now settled -->
EOF

cat > "$PROJECT_DIR/memory/03_running_state.md" << 'EOF'
# 03 — Running State
> Decay: HOT | Last updated: YYYY-MM-DD HH:MM

## Session Header
- **Today**: YYYY-MM-DD
- **Actor**: [person/agent]
- **Current phase / milestone**:
- **Last session summary**:
- **Last maintenance check**:

## Current Focus
| ID | Item | Owner | Status | Review Date |
|---|---|---|---|---|

## Document Index
| Doc ID | Source File | Summary | Extracted | Absorbed Into | Status | Modified | Hash |
|---|---|---|---|---|---|---|---|

## Open Questions / Blockers
| ID | Question / Blocker | Owner | Status | Due / Review | Notes |
|---|---|---|---|---|---|

## Decisions Log
<!-- APPEND-ONLY — never delete -->
| ID | Date | Decision | Rationale | Reversible? | Actor |
|---|---|---|---|---|---|

## New Intel / Unverified
<!-- Tag: [Inference] | [Unverified] | [Speculation] | [Confirmed] -->
| ID | Tag | Item | Source | Owner | Review Date |
|---|---|---|---|---|---|

## Change Log
<!-- APPEND-ONLY — one line per session end -->
| Date | Actor | Change |
|---|---|---|
EOF

cat > "$PROJECT_DIR/memory/_manifest.json" << 'EOF'
{
  "schema_version": "1.0",
  "last_scan": "",
  "files": []
}
EOF

echo "✅ DPM initialized in $PROJECT_DIR"
echo ""
echo "Next steps:"
echo "  1. Drop project files into $PROJECT_DIR/source_files/"
echo "  2. Give your AI agent DPM_Bootstrap_Agent_Instructions.md"
echo "  3. Tell it: 'Execute all steps starting from STEP 5'"
