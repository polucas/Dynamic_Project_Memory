# Dynamic Project Memory (DPM) v2.0
## A Reusable Standard for AI-Assisted Project Context Management

> **Purpose**: Keep an AI coding agent (Cursor, Claude Code, Codex, Windsurf, etc.) current on any project without loading every source file every session. Trade a small, fixed read at session start for on-demand depth via indexes, summaries, and plain-text extracts.

---

## 1. The Problem DPM Solves

| Failure Mode | What Happens Without DPM | What DPM Does Instead |
|---|---|---|
| Re-uploading docs each chat | User pastes same specs/context every session | Canonical files live in `source_docs/`; AI reads structured summaries in `memory/` |
| Re-explaining decisions | Past decisions are lost between sessions | Hot file records decisions + rationale (append-only log) |
| Context window filled with stale content | Old narrative crowds out new work | Tiered decay: cold facts → warm domain → hot session state |
| "Where did we left off?" | User must manually recap | `03_running_state.md` header + changelog |
| Need a verbatim quote | Full PDF/deck must be loaded (thousands of tokens) | Grep `memory/_extracted/*.txt`, not full binaries |
| AI reads everything, burns tokens | Entire codebase loaded per question | Summaries loaded first; originals only on-demand |
| Source file changed, summary stale | AI works from outdated context | File hash tracking in document index flags staleness |

### Token Budget Rule
| What | Tokens (approx.) |
|---|---|
| Session start (3 memory files) | 5,000 – 15,000 |
| + Relevant summaries (on-demand) | 500 – 2,000 per file |
| + Extracted text (grep/quote) | 200 – 5,000 per file |
| Full source file (last resort) | 5,000 – 50,000+ per file |

**Goal**: Stay in the first rule (Session Start token budget rule) for majority of interactions.

---

## 2. Directory Structure

```
project/
├── source_docs/                        # Canonical originals (READ-ONLY for AI)
│   ├── requirements_v2.docx
│   ├── architecture_diagram.pptx
│   ├── api_spec.yaml
│   └── ...
│
├── memory/
│   ├── 01_static_context.md            # COLD  — org, people, platforms, constraints
│   ├── 02_static_work.md               # WARM  — requirements, architecture, conventions
│   ├── 03_running_state.md             # HOT   — today's focus, decisions, changelog
│   │
│   ├── _summaries/                     # One .md per source file (AI-readable digest)
│   │   ├── requirements.md
│   │   ├── architecture_diagram.md
│   │   └── api_spec.md
│   │
│   ├── _extracted/                     # Full plain-text mirrors (for grep/quotes)
│   │   ├── requirements.txt
│   │   ├── architecture_diagram.txt
│   │   └── api_spec.txt
│   │
│   └── _archive/                       # Archived hot content (rotated from 03)
│       └── 03_running_state_2026-05.md
│
├── .UPDATEME                        # .cursorrules OR .cursor/rules/claude.md/*.mdc — agent protocol **UPDATE AS PER YOUR AGENT** 
└── README.md
```

### Key Distinction: `_summaries/` vs `_extracted/`

| Layer | Purpose | Format | When AI Reads It |
|---|---|---|---|
| `_summaries/` | Quick digest of each source file: what it contains, key points, structure | Structured `.md`, 20–80 lines | When it needs to understand a file without loading it |
| `_extracted/` | Full plain-text mirror of binary files (docx/pptx/pdf → txt) | Raw `.txt` via pandoc/pdftotext | When it needs verbatim quotes or line-level detail |

---

## 3. Three-Tier Memory Model

### 3.1 — `01_static_context.md` (COLD)

> **Decay rate**: Months. Update only on confirmed team/platform/scope changes.

```markdown
# 01 — Static Context
> Decay: COLD | Last updated: YYYY-MM-DD

## Project Identity
- **Project name**:
- **One-line description**:
- **Repository / workspace**:
- **In scope**: [what this project covers]
- **Out of scope**: [explicit boundaries]

## Stakeholders & Ownership
| Role | Person | Contact / Notes |
|---|---|---|
| Project Lead | | |
| Tech Lead | | |
| Sponsor | | |

## Environment & Tooling
- **Language / framework**:
- **Infra / cloud**:
- **CI/CD**:
- **Key integrations**:

## Constraints & Guardrails
- [Security / compliance constraints]
- [Budget / timeline hard limits]
- [Data sensitivity classification]

## Reference Links
- [Link to repo, wiki, Jira board, etc.]
- ⚠️ No secrets in memory — reference vault/env vars only
```

### 3.2 — `02_static_work.md` (WARM)

> **Decay rate**: Weeks. Update when deliverables, specs, or conventions change.

```markdown
# 02 — Static Work Context
> Decay: WARM | Last updated: YYYY-MM-DD

## Requirements Summary
- [Summarized acceptance criteria — NOT full paste of 50-page spec]
- [Link to full spec in source_docs/ or _summaries/]

## Architecture & Design Decisions (Settled)
| Decision | Choice | Date | Rationale |
|---|---|---|---|
| Database | PostgreSQL | 2026-05-01 | Team expertise + JSON support |
| Auth | OAuth2 + PKCE | 2026-05-03 | SPA requirement |

## Conventions
- **Branching**: [strategy]
- **Naming**: [patterns]
- **Code style**: [linter/formatter]
- **Commit format**: [conventional commits, etc.]
- **Deploy process**: [steps or link]

## Known Risks & Mitigations
| Risk | Impact | Mitigation | Status |
|---|---|---|---|
| | | | |

## Appendix: Promoted Decisions
<!-- Decisions promoted from 03 that are now settled and stable -->
```

### 3.3 — `03_running_state.md` (HOT)

> **Decay rate**: Every session. This is the AI's working memory.

```markdown
# 03 — Running State
> Decay: HOT | Last updated: YYYY-MM-DD HH:MM

## Session Header
- **Today**: YYYY-MM-DD
- **Current milestone / sprint**: [name or T-minus]
- **Last session summary**: [1–2 sentences]

## Current Focus
<!-- 3–5 bullets MAX — what we're working on RIGHT NOW -->
- [ ]
- [ ]
- [ ]

## Document Index
<!-- Master registry of all source files → memory location + status -->
| # | Source File | Summary | Extracted | Absorbed Into | Status | Hash/Modified |
|---|---|---|---|---|---|---|
| 1 | requirements_v2.docx | ✅ | ✅ | 02 (Requirements) | Current | 2026-05-28 |
| 2 | architecture_diagram.pptx | ✅ | ✅ | 02 (Architecture) | Current | 2026-05-25 |
| 3 | new_feedback.pdf | ❌ | ✅ | — | NEW | 2026-05-29 |

> **Status values**: `Current` | `NEW` (not yet integrated) | `Stale` (source changed, summary outdated) | `Archived`

## Open Questions / Blockers
- [ ] [Question or blocker — tag owner if known]

## Decisions Log
<!-- APPEND-ONLY — never delete. Date + decision + rationale -->
| Date | Decision | Rationale | Reversible? |
|---|---|---|---|
| 2026-05-29 | Chose approach B for auth flow | Lower latency, simpler FE integration | Yes (until API contract published) |

## New Intel / Unverified
<!-- Tag with [Inference], [Unverified], [Speculation] — promote to 01/02 when confirmed -->
- [Unverified] Client may want to add SSO — mentioned in call, not confirmed

## Change Log
<!-- APPEND-ONLY — one line per session end -->
| Date | Change |
|---|---|
| 2026-05-29 | Integrated new_feedback.pdf; decided on auth approach B |
```

---

## 4. Summary File Standard (`_summaries/`)

Each source file gets a corresponding summary in `_summaries/`. This is the layer that keeps token usage low — the AI reads the summary first and only loads the original if it needs more depth.

### Summary Template

```markdown
# Summary: [filename]
> Source: source_docs/[filename] | Last synced: YYYY-MM-DD | Hash: [first 8 chars or modified date]

## What This File Is
[1–2 sentences: document type, purpose, author/owner]

## Key Content
- [Bullet-point summary of main sections/topics]
- [Key data points, numbers, names]
- [Important conclusions or recommendations]

## Structure
[Brief outline: "5 slides covering X, Y, Z" or "3 chapters: intro, methodology, results"]

## Dependencies / Cross-References
- Referenced by: [other source docs or memory sections]
- References: [external systems, other docs]

## Notes
- [Any caveats, known gaps, or AI-relevant flags]
```

### Summary Rules
1. **Max length**: 80 lines / ~1,500 tokens per summary
2. **No verbatim copying**: Summarize, don't paste. Use `_extracted/` for quotes
3. **Update trigger**: When source file's modified date or hash changes → flag as `Stale` in Document Index → regenerate summary
4. **Naming**: Mirror source filename but with `.md` extension

---

## 5. Session Protocol (The "Dynamic" Part)

### 5.1 — Session Start

```
1. READ memory/01_static_context.md
2. READ memory/02_static_work.md
3. READ memory/03_running_state.md
4. CHECK Document Index for any Status = "NEW" or "Stale"
   → If found: notify user, offer to integrate
5. UPDATE Session Header in 03 (date, last session summary)
6. Proceed with user's task
```

### 5.2 — During Session

```
IF user asks about a specific file:
   → READ _summaries/[file].md first (low token cost)
   → Only READ _extracted/[file].txt or source_docs/[file] if:
      • User needs verbatim quote
      • Summary lacks needed detail
      • User explicitly requests full file

IF a decision is made:
   → APPEND to Decisions Log in 03 (date + decision + rationale + reversibility)

IF new information emerges:
   → Add to New Intel section in 03 with uncertainty tag
   → [Inference] | [Unverified] | [Speculation] | [Confirmed]

IF a new source file is added:
   → Add file to source_docs/
   → Generate extract → _extracted/
   → Generate summary → _summaries/
   → Add row to Document Index in 03 with Status = "NEW"
   → Fold key points into 01 or 02 as appropriate
```

### 5.3 — Session End

```
1. APPEND one-line entry to Change Log in 03
2. Review New Intel: promote confirmed items to 01 or 02
3. Check 03 size:
   → If > 300 lines: archive old decisions to 02 Appendix or _archive/
   → Keep: header + last 2 weeks of hot content
4. Promote stable patterns:
   → Repeated hot notes → merge into 02
   → Settled warm facts → merge into 01
```

### Decision Flow

```
                    ┌─────────────┐
                    │ Session Start│
                    └──────┬──────┘
                           │
                    Read 01 + 02 + 03
                           │
                    ┌──────▼──────┐
                    │  Work using  │
                    │  memory as   │
                    │    truth     │
                    └──────┬──────┘
                           │
                  ┌────────▼────────┐
                  │ Decision made?  │
                  └───┬─────────┬───┘
                   Yes│         │No
            ┌─────────▼──┐      │
            │ Append to   │      │
            │ Decisions   │      │
            │ Log in 03   │      │
            └─────────┬──┘      │
                      │         │
                      ▼         ▼
                  ┌──────────────┐
                  │ Continue work │
                  └──────┬───────┘
                         │
                  ┌──────▼───────┐
                  │  Session End  │
                  └──────┬───────┘
                         │
              Append changelog line
              Promote stable facts
              Archive if 03 > 300 lines
```

---

## 6. Content Rules (Context Discipline)

### 6.1 — Writing Rules

| Rule | Rationale |
|---|---|
| **Summarize in memory; cite sources in index** | Don't duplicate 50-page specs in 02 |
| **One fact, one home** | Org fact → 01, feature spec → 02, "we chose B on Tuesday" → 03 |
| **Label uncertainty** | `[Inference]`, `[Unverified]`, `[Speculation]` in 03 until confirmed |
| **No secrets in memory** | Reference vault/env vars; never hardcode credentials or tokens |
| **Summaries ≠ extracts** | `_summaries/` = AI-readable digest; `_extracted/` = full text for grep |

### 6.2 — Size Caps & Hygiene

| File | Max Size | Action When Exceeded |
|---|---|---|
| `01_static_context.md` | ~200 lines | Split into `01a_`, `01b_` by domain if needed |
| `02_static_work.md` | ~400 lines | Split by workstream; move settled appendices to `_archive/` |
| `03_running_state.md` | ~300 lines | Archive old decisions/changelog to `_archive/`; keep last 2 weeks |
| Each `_summaries/*.md` | ~80 lines | If longer, you're copying not summarizing |

### 6.3 — Staleness Detection

The Document Index in `03_running_state.md` tracks file freshness:

```
For each source file:
   current_hash = hash(source_docs/[file]) OR modified_date
   indexed_hash = Hash/Modified column in Document Index

   IF current_hash ≠ indexed_hash:
      → Set Status = "Stale"
      → Notify user at session start
      → Regenerate summary and extract when directed
```

**For AI agents without filesystem hash access**: Use file modified date, or prompt the user to confirm if files have changed at session start.

---

## 7. Bootstrap Checklist (New Project Setup)

```markdown
## DPM Bootstrap — [Project Name]
- [ ] Create directory structure: source_docs/, memory/, memory/_summaries/,
      memory/_extracted/, memory/_archive/
- [ ] Drop all existing artifacts into source_docs/
- [ ] Run extraction for binary files (docx/pptx/pdf → txt):
      • pandoc, pdftotext, or manual export → _extracted/
- [ ] Generate summaries for each source file → _summaries/
- [ ] Distill key facts into 01_static_context.md
- [ ] Distill requirements/architecture/conventions into 02_static_work.md
- [ ] Create 03_running_state.md with:
      • Session header (today's date, milestone)
      • Document Index (all source files mapped)
      • Empty sections for: Focus, Open Qs, Decisions, Changelog
- [ ] Add agent rules file (.cursorrules or equivalent)
- [ ] Validate: agent can start a session reading only the 3 memory files
```

### Bootstrap Commands (Optional Automation)

```bash
#!/bin/bash
# dpm-init.sh — Initialize DPM structure for a new project

PROJECT_DIR=${1:-.}

mkdir -p "$PROJECT_DIR"/{source_docs,memory/{_summaries,_extracted,_archive}}

# Create stub memory files
for f in 01_static_context.md 02_static_work.md 03_running_state.md; do
  touch "$PROJECT_DIR/memory/$f"
done

echo "# DPM initialized in $PROJECT_DIR"
echo "# Next: drop files into source_docs/, then run extraction + summarization"
```

---

## 8. Agent Rules Template

### For Cursor (`.cursorrules` or `.cursor/rules/01-dpm-protocol.mdc`)

```yaml
---
description: Dynamic Project Memory protocol — enforces context-efficient session management
globs: ["**/*"]
alwaysApply: true
---

# DPM Protocol — Agent Instructions

## Session Start (MANDATORY)
1. Read these files IN ORDER before any other action:
   - memory/01_static_context.md
   - memory/02_static_work.md
   - memory/03_running_state.md
2. Check the Document Index in 03 for Status = "NEW" or "Stale"
   - If found, notify the user and offer to integrate
3. Update the Session Header in 03 with today's date

## During Session
- When you need context about a source file:
  → Read memory/_summaries/[file].md FIRST
  → Only open source_docs/[file] or memory/_extracted/[file].txt if:
    • The user needs a verbatim quote
    • The summary lacks the detail you need
    • The user explicitly asks to load the full file
- When a decision is made:
  → APPEND a row to the Decisions Log in 03 (date, decision, rationale, reversibility)
- When new unverified information appears:
  → Add to New Intel in 03 with tag: [Inference] | [Unverified] | [Speculation]
- When a new source file is added to source_docs/:
  → Generate plain-text extract → memory/_extracted/
  → Generate summary → memory/_summaries/
  → Add row to Document Index in 03 with Status = "NEW"
  → Integrate key points into 01 or 02 as appropriate

## Session End
- Append one-line summary to Change Log in 03
- If any [Unverified] items were confirmed, promote to 01 or 02
- If 03 exceeds ~300 lines, archive older content to memory/_archive/

## Guardrails
- NEVER edit files in source_docs/ — they are read-only canonical inputs
- NEVER load full source files into context unless explicitly needed
- NEVER delete entries from Decisions Log or Change Log (append-only)
- NEVER store secrets, credentials, or tokens in memory files
- Keep memory files in plain Markdown for portability across AI tools
```

### For Claude Code (CLAUDE.md)

```markdown
# CLAUDE.md — Project Memory Protocol

## Context Loading
At the start of every task, read these files for project context:
- memory/01_static_context.md (stable project facts)
- memory/02_static_work.md (requirements, architecture, conventions)
- memory/03_running_state.md (current state, decisions, changelog)

For file-specific context, check memory/_summaries/ before loading full files.
For verbatim quotes, use memory/_extracted/.

## Update Protocol
- Append decisions to the Decisions Log in memory/03_running_state.md
- Append session changes to the Change Log in memory/03_running_state.md
- Never modify files in source_docs/ (read-only)
- Never delete log entries (append-only)

## Token Efficiency
- Read summaries before full files
- Only load source_docs/ originals when summaries are insufficient
- Keep memory/03_running_state.md under 300 lines; archive excess
```

### For OpenAI Codex or Other Agents

Adapt the rules above into whatever instruction format the agent supports. The key contract is:
1. **Read 3 files at start**
2. **Summaries before originals**
3. **Append-only logs**
4. **Never edit source_docs/**

---

## 9. Selective Loading Guide

| User Ask / Task Type | What to Load | Token Cost |
|---|---|---|
| "Continue where we left off" | 03 only (skim 01+02 if stale) | ~2K–5K |
| "How does X work in our stack?" | 01 or 02 relevant section; `_summaries/` if needed | ~3K–8K |
| "Quote the contract clause on Y" | `_extracted/[contract].txt` (grep for Y) | ~1K–5K |
| "What did we decide about Y?" | 03 Decisions Log → check 02 if promoted | ~1K–3K |
| "Integrate this new document" | New file → extract + summarize + index | ~5K–15K |
| "Refactor module Z" | 01 (constraints) + 02 (conventions) + `_summaries/` for Z | ~5K–10K |
| "Full deep-dive on [file]" | `source_docs/[file]` (full load — last resort) | ~10K–50K+ |

---

## 10. Maintenance & Lifecycle

### 10.1 — Promotion Flow

```
HOT (03)                    WARM (02)                   COLD (01)
─────────────────────────── ─────────────────────────── ───────────────────────
New Intel [Unverified]
        │
        ▼ (confirmed)
Decisions Log ──────────►  Settled Decisions table
                                    │
                                    ▼ (stable for months)
                            Conventions / Architecture ──► Environment & Tooling
                                                           Constraints
```

### 10.2 — Archival Protocol

| Trigger | Action |
|---|---|
| `03` exceeds 300 lines | Move entries older than 2 weeks to `_archive/03_running_state_YYYY-MM.md` |
| `02` exceeds 400 lines | Split by workstream or move settled appendices to `_archive/` |
| Project phase complete | Snapshot all 3 files to `_archive/` with date suffix; reset 03 |
| Source file superseded | Move old version to `_archive/`; update index |

### 10.3 — Multi-Project Scaling

For users managing multiple projects, each project gets its own DPM:

```
workspace/
├── project-alpha/
│   ├── source_docs/
│   ├── memory/
│   └── .cursorrules
├── project-beta/
│   ├── source_docs/
│   ├── memory/
│   └── .cursorrules
└── _global_memory/          # Optional: cross-project facts
    └── org_context.md        # Shared org info referenced by all projects
```

---

## 11. Why This Scales

| Property | Mechanism |
|---|---|
| **Fixed session cost** | 3 files, 5–15K tokens, predictable every time |
| **Unbounded corpus** | N source docs via index + summaries + extracts, not N full loads |
| **Cross-session continuity** | Hot file + agent rules survive thread/chat boundaries |
| **Human-auditable** | Decisions and changelog are git-diffable plain text |
| **Decay-aware** | Cold/warm/hot prevents stale noise AND frozen wrong "facts" |
| **Tool-agnostic** | Plain Markdown works in Cursor, Claude Code, Codex, Windsurf, any IDE |
| **Cost-efficient** | Summary-first pattern reduces token consumption by 60–90% vs full-file loading |
| **Staleness-resistant** | Hash/date tracking in Document Index flags outdated summaries |

---

## Appendix A — Extraction Commands

```bash
# PDF → text
pdftotext source_docs/report.pdf memory/_extracted/report.txt

# DOCX → text
pandoc source_docs/spec.docx -t plain -o memory/_extracted/spec.txt

# PPTX → text (slide-by-slide)
python3 -c "
from pptx import Presentation
import sys
prs = Presentation(sys.argv[1])
for i, slide in enumerate(prs.slides, 1):
    print(f'--- Slide {i} ---')
    for shape in slide.shapes:
        if shape.has_text_frame:
            print(shape.text)
" source_docs/deck.pptx > memory/_extracted/deck.txt

# XLSX → text (headers + first rows)
python3 -c "
import pandas as pd, sys
for sheet in pd.ExcelFile(sys.argv[1], engine='openpyxl').sheet_names:
    df = pd.read_excel(sys.argv[1], sheet_name=sheet, engine='openpyxl')
    print(f'--- Sheet: {sheet} ({len(df)} rows) ---')
    print(df.head(20).to_string())
" source_docs/data.xlsx > memory/_extracted/data.txt
```

## Appendix B — Summary Generation Prompt

When bootstrapping, use this prompt to generate `_summaries/` files:

```
Read the following file and produce a structured summary following this template:

# Summary: [filename]
> Source: source_docs/[filename] | Last synced: [today] | Modified: [file date]

## What This File Is
[1-2 sentences: type, purpose, author]

## Key Content
[Bullet points: main topics, key data, important conclusions]

## Structure
[Brief outline of sections/slides/chapters]

## Dependencies / Cross-References
[What it links to, what references it]

## Notes
[Caveats, gaps, AI-relevant flags]

Rules:
- Max 80 lines
- Summarize, don't copy
- Flag anything uncertain with [Unverified]
- Include specific numbers, names, dates — not vague descriptions
```
