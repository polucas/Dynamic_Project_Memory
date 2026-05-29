# DPM Bootstrap — Agent Instructions
> Execute step by step. Do not skip steps. This file is consumed once during setup, then archived.

---

## STEP 1 — Create Directory Structure

```
project/
├── source_docs/                  # Canonical originals — READ-ONLY, never edit
├── memory/
│   ├── 01_static_context.md      # COLD tier
│   ├── 02_static_work.md         # WARM tier
│   ├── 03_running_state.md       # HOT tier
│   ├── _summaries/               # One .md digest per source file (20–80 lines)
│   ├── _extracted/               # Full plain-text mirrors of binary files
│   └── _archive/                 # Rotated hot content, superseded files
├── .cursorrules                  # OR CLAUDE.md / agent config — paste Section 7
└── README.md
```

Create all folders and the three memory files using the templates below.

> If `dpm-init.sh` was already run, skip to STEP 5 — structure and stubs exist.

---

## STEP 2 — Populate 01_static_context.md (COLD)

Decay: months. Only update on confirmed org/platform/scope changes.

```markdown
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
<!-- For code projects only. Remove for doc-only projects. -->

### Structure
[Top-level directory layout with one-line descriptions per folder]

### Key Entry Points
- [main file / app bootstrap]
- [route registry / API gateway]

### Module Dependencies
- [layer A → layer B → layer C]

### Data Model Overview
- [key entities and relationships, or link to schema in 02]

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
```

**Fill instructions**: Scan source_docs/, project config files (README, package.json, pyproject.toml, docker-compose, CI configs), and the codebase itself. Extract stable facts into each section. For code projects, populate the Codebase Map by reading the directory tree and key entry points. Max 200 lines.

---

## STEP 3 — Populate 02_static_work.md (WARM)

Decay: weeks. Update when deliverables, specs, or conventions change.

```markdown
# 02 — Static Work Context
> Decay: WARM | Last updated: YYYY-MM-DD

## Requirements Summary
- [Summarized acceptance criteria — NOT full paste]
- [Link to full spec in source_docs/ or _summaries/]

## Architecture & Design Decisions (Settled)
| Decision | Choice | Date | Rationale |
|---|---|---|---|

## API Surface / Endpoint Index
<!-- For projects with APIs. Remove if not applicable. -->
| Method | Endpoint | Handler | Auth | Notes |
|---|---|---|---|---|

## DB Schema Summary
<!-- Key tables/collections, relationships, migration status -->
<!-- Link to full schema in _summaries/ or _extracted/ if large -->

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
```

**Fill instructions**: Read requirements docs, architecture docs, contributing guides, and the codebase structure. For code projects: scan route files for API index, schema/migration files for DB summary, CI config for pipeline, test config for test strategy. Summarize — do not paste full specs. Max 400 lines.

---

## STEP 4 — Populate 03_running_state.md (HOT)

Decay: every session. This is your working memory.

```markdown
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
```

**Fill instructions**: Set today's date. Build Document Index listing every file in source_docs/. Set Status = "NEW" for all. Fill Current Focus with immediate priorities. For code projects: also index key code files (entry points, core modules) if they need summaries. Max 300 lines.

---

## STEP 5 — Generate Extracts (_extracted/)

For each binary file in source_docs/ (docx, pptx, pdf, xlsx):

1. Convert to plain text → save as `memory/_extracted/[filename_without_ext].txt`
2. Methods:
   - PDF: `pdftotext` or pymupdf
   - DOCX: `pandoc -t plain` or python-docx
   - PPTX: iterate slides/shapes, extract text
   - XLSX: sheet names + headers + first 20 rows
3. Text-native files (md, txt, yaml, json, csv): no extract needed — source IS the extract

For code projects: no extraction needed for code files — the source is already text. Only extract binary docs (specs, diagrams, exports).

Update Document Index: set Extracted = ✅ for each processed file.

---

## STEP 6 — Generate Summaries (_summaries/)

For each source file, create `memory/_summaries/[filename_without_ext].md`:

```markdown
# Summary: [filename]
> Source: source_docs/[filename] | Last synced: YYYY-MM-DD | Modified: [file date]

## What This File Is
[1–2 sentences: type, purpose, author]

## Key Content
- [Main topics, key data points, conclusions]

## Structure
[Outline: "5 slides covering X, Y, Z" or "3 sections: A, B, C"]

## Dependencies / Cross-References
- Referenced by: [other docs or memory sections]
- References: [external systems, other docs]

## Notes
- [Caveats, gaps, flags]
```

For **code files** (when key modules need summaries):

```markdown
# Summary: [filename]
> Source: src/[path]/[filename] | Last synced: YYYY-MM-DD

## Purpose
[1–2 sentences: what this module/file does]

## Public Interface
- [exported functions / classes / endpoints with signatures]

## Dependencies
- Imports: [key internal and external dependencies]
- Used by: [which modules call this]

## Key Logic
- [Core algorithm or business logic, summarized]

## Notes
- [Edge cases, known issues, TODO items]
```

**Rules**:
- Max 80 lines per summary
- Summarize, never copy verbatim
- Include specific names, numbers, types — not vague descriptions
- Flag uncertain content with [Unverified]
- Only summarize key code files (entry points, core services, shared utils) — not every file

Update Document Index: set Summary = ✅ for each processed file.

---

## STEP 7 — Install Agent Rules

Paste the appropriate block into your agent's config file.

### Cursor (.cursorrules or .cursor/rules/01-dpm-protocol.mdc)

```yaml
---
description: DPM protocol — context-efficient session management
globs: ["**/*"]
alwaysApply: true
---

# DPM Protocol

## Session Start (MANDATORY)
1. Read IN ORDER before any other action:
   - memory/01_static_context.md
   - memory/02_static_work.md
   - memory/03_running_state.md
2. Check Document Index in 03 for Status = "NEW" or "Stale"
   → If found: notify user, offer to integrate
3. Update Session Header in 03 with today's date

## During Session
- Need context on a source file? → Read memory/_summaries/[file].md FIRST
  → Only open source_docs/ or _extracted/ if:
    • User needs verbatim quote
    • Summary lacks needed detail
    • User explicitly requests full file
- Need context on a code file? → Read memory/_summaries/[file].md if it exists
  → Only open the source code file if no summary exists or more detail needed
- Decision made? → APPEND to Decisions Log in 03 (date, decision, rationale, reversible?)
- New unverified info? → Add to New Intel in 03 with tag: [Inference] | [Unverified] | [Speculation]
- New source file added? →
    1. Generate extract → _extracted/ (if binary)
    2. Generate summary → _summaries/ (if key file)
    3. Add row to Document Index in 03 (Status = "NEW")
    4. Integrate key points into 01 or 02

## Session End
- Append one-line summary to Change Log in 03
- Promote confirmed [Unverified] items to 01 or 02
- If 03 > 300 lines → archive older content to _archive/

## Guardrails
- NEVER edit files in source_docs/
- NEVER load full source files unless explicitly needed
- NEVER delete from Decisions Log or Change Log (append-only)
- NEVER store secrets or credentials in memory files
- Plain Markdown only — no proprietary formats
```

### Claude Code (CLAUDE.md)

```markdown
# CLAUDE.md — DPM Protocol

## Session Start
Read these files before any action:
- memory/01_static_context.md
- memory/02_static_work.md
- memory/03_running_state.md
Check Document Index for "NEW" or "Stale" entries. Update Session Header date.

## During Session
- File/code context needed → read memory/_summaries/ first, then _extracted/, then source file (escalation order)
- Decision made → append to Decisions Log in 03
- New info → add to New Intel in 03 with uncertainty tag
- New source file → extract (if binary) + summarize + index + integrate

## Session End
- Append to Change Log in 03
- Promote confirmed items to 01/02
- Archive 03 if > 300 lines

## Rules
- source_docs/ is read-only
- Logs are append-only
- No secrets in memory
- Summaries before full files — always
```

### Codex / Other Agents

Adapt the rules above. The contract:
1. Read 3 memory files at start
2. Summaries before originals
3. Append-only logs
4. Never edit source_docs/

---

## STEP 8 — Validate

- [ ] `source_docs/` contains all project artifacts
- [ ] `memory/01_static_context.md` has project identity, stakeholders, environment, constraints
- [ ] `memory/01_static_context.md` has Codebase Map (if code project)
- [ ] `memory/02_static_work.md` has requirements, settled decisions, conventions
- [ ] `memory/02_static_work.md` has API index, DB schema, test strategy, CI/CD (if code project)
- [ ] `memory/03_running_state.md` has session header, document index, empty logs
- [ ] `memory/_extracted/` has .txt for every binary source file
- [ ] `memory/_summaries/` has .md for key source files and key code modules
- [ ] Document Index shows ✅ for Summary and Extracted columns
- [ ] Agent rules file installed (.cursorrules / CLAUDE.md / equivalent)
- [ ] Agent can start a session reading ONLY the 3 memory files (< 15K tokens)

---

## ONGOING MAINTENANCE

### Staleness Detection
```
For each indexed file:
  IF file modified date ≠ Modified column in Document Index:
    → Set Status = "Stale"
    → Notify user at session start
    → Regenerate summary + extract when directed
```

### Size Caps
| File | Max | Action When Exceeded |
|---|---|---|
| 01 | ~200 lines | Split into 01a_, 01b_ by domain |
| 02 | ~400 lines | Split by workstream; archive settled appendices |
| 03 | ~300 lines | Archive entries older than 2 weeks to _archive/ |
| Each summary | ~80 lines | You're copying, not summarizing — rewrite |

### Promotion Flow
- Confirmed hot notes (03) → merge into warm (02)
- Settled warm facts (02) → merge into cold (01)
- Remove from source tier after promoting

### Content Discipline
- One fact, one home: org fact → 01, spec → 02, session decision → 03
- Label uncertainty: [Inference] | [Unverified] | [Speculation] | [Confirmed]
- Summarize in memory, cite in index — never duplicate full specs
- No secrets — reference vault/env vars only
