# DPM Bootstrap — Agent Instructions
> Execute step by step. Do not skip steps. This file is consumed once during setup, then archived.

---

## STEP 1 — Create DPM-Managed Directory Structure

```
project/
├── source_files/                 # Canonical originals — READ-ONLY for agents
├── memory/
│   ├── 01_static_context.md      # COLD tier
│   ├── 02_static_work.md         # WARM tier
│   ├── 03_running_state.md       # HOT tier
│   ├── _manifest.json            # Machine-readable processed-file registry
│   ├── _summaries/               # One .md digest per source file (20–80 lines)
│   ├── _extracted/               # Full plain-text mirrors of binary files
│   └── _archive/                 # Rotated hot content, superseded files
├── DPM_instructions/             # Agent rules, DPM protocol, project-specific AI instructions
├── agent_outputs/                # AI-generated working outputs and deliverables
├── .cursor/                      # Cursor rules, skills, and agent configuration
└── README.md
```

Agents may create or modify files only in:
- `memory/`
- `DPM_instructions/`
- `agent_outputs/`
- `.cursor/`

**STRICTLY FORBIDDEN — WILL LEAD TO TERMINATION OF THE AGENT RUN**: creating, modifying, moving, renaming, or deleting files outside `memory/`, `DPM_instructions/`, `agent_outputs/`, or `.cursor/`.

Create those DPM-managed folders, the three memory files, and `_manifest.json` using the templates below. Do not create, modify, move, rename, or delete files in `source_files/`. If `source_files/` does not exist or has no project artifacts, ask the human/project owner to add the source files there.

> If `dpm-init.sh` was already run, skip to STEP 5 — structure and stubs exist.

---

## STEP 2 — Populate 01_static_context.md (COLD)

Decay: months. Only update on confirmed scope/org/platform changes.

```markdown
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
```

**Fill instructions**: Scan source_files/ for SOWs, contracts, org charts, project briefs. Extract stable facts into each section. Max 200 lines.

---

## STEP 3 — Populate 02_static_work.md (WARM)

Decay: weeks. Update when deliverables, scope, or approach changes.

```markdown
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
```

**Fill instructions**: Read SOW, project plan, requirements docs, and methodology/approach documents in source_files/. Summarize — do not paste full specs. Max 400 lines.

---

## STEP 4 — Populate 03_running_state.md (HOT)

Decay: every session. This is your working memory.

```markdown
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
```

**Fill instructions**: Set today's date and actor. Build the Document Index by listing every file in source_files/. Assign stable Doc IDs and set Status = `NEW` for all. Fill Current Focus with immediate priorities only. Max 300 lines.

---

## STEP 5 — Create File Manifest (_manifest.json)

Create `memory/_manifest.json`:

```json
{
  "schema_version": "1.0",
  "last_scan": "YYYY-MM-DDTHH:MM:SS",
  "files": [
    {
      "doc_id": "DOC-YYYYMMDD-001",
      "source_path": "source_files/example.pdf",
      "sha256": "hash-or-unavailable",
      "modified": "YYYY-MM-DDTHH:MM:SS",
      "processed": "",
      "summary_path": "",
      "extract_path": "",
      "absorbed_into": [],
      "status": "NEW",
      "processed_by": "",
      "notes": ""
    }
  ]
}
```

**Fill instructions**: Add one entry per file in `source_files/`. Use content hashes when possible; if unavailable, set `sha256` to `hash-unavailable` and rely on modified time. Keep `_manifest.json` aligned with the 03 Document Index.

---

## STEP 6 — Generate Extracts (_extracted/)

For each binary file in source_files/ (docx, pptx, pdf, xlsx):

1. Convert to plain text → save as `memory/_extracted/[filename_without_ext].txt`
2. Methods:
   - PDF: `pdftotext`; fallback: PyMuPDF (`pymupdf`)
   - DOCX: `pandoc -t plain`; fallback: `python-docx`
   - PPTX: `python-pptx`, slide-by-slide with slide numbers
   - XLSX: `pandas` + `openpyxl`, sheet names + dimensions + headers + representative rows
3. Text-native files (md, txt, csv): no extract needed — the source IS the extract

Update `_manifest.json` and the Document Index in 03: set Extracted = `yes` for each processed file and record the extract path.

---

## STEP 7 — Generate Summaries (_summaries/)

For each source file, create `memory/_summaries/[filename_without_ext].md`:

```markdown
# Summary: [filename]
> Doc ID: DOC-YYYYMMDD-001 | Source: source_files/[filename] | Last synced: YYYY-MM-DD | Modified: [file date] | Hash: [sha256]

## What This File Is
[1–2 sentences: type, purpose, author]

## Key Content
- [Main topics, key data points, conclusions, recommendations]

## Structure
[Outline: "5 slides covering X, Y, Z" or "3 sections: A, B, C"]

## Dependencies / Cross-References
- Referenced by: [other docs or memory sections]
- References: [external systems, other docs]

## Notes
- [Caveats, gaps, flags]
- Processed by: [person/agent] on YYYY-MM-DD
```

**Rules**:
- Max 80 lines per summary
- Summarize, never copy verbatim — _extracted/ exists for quotes
- Include specific numbers, names, dates — not vague descriptions
- Flag uncertain content with [Unverified]

Update `_manifest.json` and the Document Index in 03: set Summary = `yes`, record the summary path, and set Status = `Current` after integration.

---

## STEP 8 — Install Agent Rules

Create the agent protocol under `DPM_instructions/`, for example `DPM_instructions/dpm-protocol.md`. For Cursor, create rules under `.cursor/rules/` and reusable ingestion skills under `.cursor/skills/`.

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
2. Check memory/_manifest.json and Document Index in 03 for Status = "NEW", "Stale", "Needs Review", or "Error"
   → If found: notify user, offer to integrate
3. Update Session Header in 03 with today's date and actor
4. Before editing shared memory, re-read the target section and make the smallest scoped change

## During Session
- Need context on a source file? → Read memory/_summaries/[file].md FIRST
  → Only open source_files/ or _extracted/ if:
    • User needs verbatim quote
    • Summary lacks needed detail
    • User explicitly requests full file
- Decision made? → APPEND to Decisions Log in 03 with stable ID, date, decision, rationale, reversible?, actor
- New unverified info? → Add to New Intel in 03 with tag, owner, and review date
- Completed/resolved active item? → Remove from active section after logging, promoting, or archiving as appropriate
- New source file added? →
    1. Run /ingestfile workflow
    2. Generate extract → _extracted/ (if binary)
    3. Generate summary → _summaries/
    4. Update _manifest.json and Document Index
    5. Integrate durable key points into 01 or 02
- Conflicting source facts? → Mark Needs Review and ask the owner/human lead

## Session End
- Append one-line summary to Change Log in 03
- Promote confirmed [Unverified] items to 01 or 02, then remove them from New Intel
- Close/remove resolved Current Focus, Open Questions, and Blockers from active lists
- If 03 > 300 lines → archive older audit content to _archive/

## Guardrails
- NEVER create, modify, move, rename, or delete files in source_files/
- ONLY create or modify files in memory/, DPM_instructions/, agent_outputs/, or .cursor/
- STRICTLY FORBIDDEN — WILL LEAD TO TERMINATION OF THE AGENT RUN: writing anywhere else
- NEVER load full source files unless explicitly needed
- NEVER delete from Decisions Log or Change Log (append-only)
- DO prune active working sections when items are completed, resolved, rejected, or promoted
- Use stable IDs for shared items: DOC-, DEC-, Q-, RISK-, DEL-
- NEVER store confidential data or credentials in memory files
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
Check memory/_manifest.json for changed hashes, manifest/index drift, and processing errors.

## During Session
- File context needed → read memory/_summaries/ first, then _extracted/, then source_files/ (escalation order)
- Decision made → append to Decisions Log in 03 with stable ID and actor
- New info → add to New Intel in 03 with uncertainty tag, owner, and review date
- New source file → run /ingestfile: extract (if binary) + summarize + manifest + index + integrate
- Resolved active item → remove from active list after logging/promoting/archiving

## Session End
- Append to Change Log in 03
- Promote confirmed items to 01/02, then remove from active hot sections
- Close/remove resolved Current Focus, Open Questions, and Blockers
- Archive 03 if > 300 lines

## Rules
- source_files/ is read-only
- Agents may create or modify files only in memory/, DPM_instructions/, agent_outputs/, or .cursor/
- STRICTLY FORBIDDEN — WILL LEAD TO TERMINATION OF THE AGENT RUN: writing anywhere else
- Logs are append-only
- Active sections are pruned
- No confidential data in memory
- Summaries before full files — always
```

### Codex / Other Agents

Adapt the rules above. The contract:
1. Read 3 memory files at start
2. Summaries before originals
3. Manifest and Document Index stay aligned
4. Append-only logs, pruned active sections
5. Never create or modify source_files/
6. Create or modify files only in memory/, DPM_instructions/, agent_outputs/, or .cursor/
7. STRICTLY FORBIDDEN — WILL LEAD TO TERMINATION OF THE AGENT RUN: writing anywhere else

---

## STEP 9 — Validate

- [ ] `source_files/` contains all project artifacts and was supplied by a human/project owner or approved setup script
- [ ] `memory/01_static_context.md` has project identity, stakeholders, tools, constraints
- [ ] `memory/02_static_work.md` has scope, deliverables, settled decisions, methodology, risks
- [ ] `memory/03_running_state.md` has session header, document index, empty logs
- [ ] `memory/_manifest.json` has one entry per source file with Doc ID, path, hash/modified time, status, and artifact paths
- [ ] `memory/_extracted/` has .txt for every binary source file
- [ ] `memory/_summaries/` has .md for every source file
- [ ] Document Index agrees with `_manifest.json`
- [ ] Agent rules file created in `DPM_instructions/` and, for Cursor, `.cursor/rules/`
- [ ] Optional ingestion skills created under `.cursor/skills/`
- [ ] Agent can start a session reading ONLY the 3 memory files (< 15K tokens)

---

## ONGOING MAINTENANCE

### Staleness Detection
```
For each indexed file:
  IF file hash differs from sha256 in _manifest.json:
    → Set Status = "Stale"
    → Notify user at session start
    → Regenerate summary + extract when directed
  ELSE IF hashing is unavailable AND file modified date differs:
    → Set Status = "Stale"
    → Notify user at session start
```

### Size Caps
| File | Max | Action When Exceeded |
|---|---|---|
| 01 | ~200 lines | Split into 01a_, 01b_ by domain |
| 02 | ~400 lines | Split by workstream; archive settled appendices |
| 03 | ~300 lines | Archive entries older than 2 weeks to _archive/ |
| Each summary | ~80 lines | You're copying, not summarizing — rewrite |

### Status Values
| Area | Values |
|---|---|
| Document Index / Manifest | `NEW`, `Current`, `Stale`, `Needs Review`, `Superseded`, `Archived`, `Error` |
| Active work items | `Open`, `Blocked`, `Resolved`, `Promoted`, `Rejected`, `Archived` |

### Promotion Flow
- Confirmed hot notes (03) → merge into warm (02)
- Settled warm facts (02) → merge into cold (01)
- Remove from active source tier after promoting

### Active Memory Cleanup
- Current Focus: remove completed or tracker-owned items unless they still drive today's work.
- Open Questions / Blockers: remove answered, rejected, or superseded items after the answer is captured in 01/02 or Change Log.
- New Intel / Unverified: promote confirmed durable facts; delete disproven or stale items.
- Decisions Log and Change Log: never delete rows; these are audit logs.
- Routine completed tasks do not need archival. Archive only items with future audit value.

### Multi-Person Rules
- Read the latest target section before editing shared memory.
- Make small, scoped updates; avoid reformatting unrelated tables.
- Create or modify files only in `memory/`, `DPM_instructions/`, `agent_outputs/`, or `.cursor/`.
- STRICTLY FORBIDDEN — WILL LEAD TO TERMINATION OF THE AGENT RUN: creating, modifying, moving, renaming, or deleting files anywhere else.
- Never create, modify, move, rename, or delete files in `source_files/`.
- Attribute durable changes with date and actor.
- Use stable IDs for documents, decisions, questions, risks, and deliverables.
- Mark conflicting source facts as `Needs Review`; do not silently choose the newest file.

### Daily / Weekly / Monthly Cadence
- Daily/session end: cleanup active hot sections, update Change Log, scan for expected daily file drops.
- Weekly: review 02 deliverables, risks, settled decisions, and promoted items.
- Monthly or phase-end: snapshot 01/02/03 to `_archive/`, reconcile `_manifest.json` with Document Index, and remove obsolete warm/cold facts.

### File Processing Skills

#### `/ingestfile [path]`
Process one explicit file: validate path, assign/reuse Doc ID, compute hash, extract text if binary, generate/update summary, update `_manifest.json` and Document Index, integrate durable facts into 01/02, and flag conflicts as `Needs Review`.

Stop before overwriting an existing summary if the same filename appears to represent a different document.

Recommended extractors:
| Source Type | Preferred Extractor | Output |
|---|---|---|
| `.pdf` | `pdftotext`; fallback: PyMuPDF (`pymupdf`) | Full text in `memory/_extracted/[name].txt` |
| `.docx` | `pandoc -t plain`; fallback: `python-docx` | Full text with headings/lists preserved where possible |
| `.pptx` | `python-pptx` | Slide-by-slide text with slide numbers |
| `.xlsx` | `pandas` + `openpyxl` | Sheet names, dimensions, headers, and representative rows |
| `.txt`, `.md`, `.csv` | Direct read/copy or lightweight normalization | Treat source as extract; summarize directly |

Recommended setup:
```bash
pip install pymupdf python-docx python-pptx pandas openpyxl
```

Optional system tools:
```bash
# macOS
brew install poppler pandoc

# Windows with Chocolatey
choco install poppler pandoc
```

For daily ingestion, create Cursor skills under `.cursor/skills/`, for example `.cursor/skills/ingestfile/SKILL.md`, `.cursor/skills/scanrepo/SKILL.md`, and `.cursor/skills/scanandingest/SKILL.md`.

#### `/scanrepo`
Compare `source_files/`, `_manifest.json`, and the 03 Document Index. Report new, changed, missing, duplicate, superseded, archived, errored, and unprocessed files. Do not ingest or edit unless asked.

#### `/scanandingest`
Run `/scanrepo`, ingest safe `NEW` and `Stale` files, and pause for duplicates, unsupported formats, manifest/index drift, conflicting facts, or likely superseded files. Report processed files, skipped files, conflicts, and memory sections updated.

### Content Discipline
- One fact, one home: org/people → 01, deliverables/approach → 02, session decisions → 03
- Label uncertainty: [Inference] | [Unverified] | [Speculation] | [Confirmed]
- Summarize in memory, cite in index — never duplicate full documents
- No confidential data — reference secure locations only
