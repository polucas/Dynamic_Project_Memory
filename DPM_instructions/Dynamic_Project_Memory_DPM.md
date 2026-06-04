# Dynamic Project Memory (DPM) v2.0
## A Reusable Standard for AI-Assisted Project Context Management

> **Purpose**: Keep an AI agent (Cursor, Claude Code, Codex, Windsurf, etc.) current on any business project without loading every source file every session. Trade a small, fixed read at session start for on-demand depth via indexes, summaries, and plain-text extracts.

---

## 1. The Problem DPM Solves

| Failure Mode | What Happens Without DPM | What DPM Does Instead |
|---|---|---|
| Re-uploading docs each chat | User pastes same specs/context every session | Canonical files live in `source_files/`; AI reads structured summaries in `memory/` |
| Re-explaining decisions | Past decisions are lost between sessions | Hot file records decisions + rationale (append-only log) |
| Context window filled with stale content | Old narrative crowds out new work | Tiered decay: cold facts → warm domain → hot session state |
| "Where did we leave off?" | User must manually recap | `03_running_state.md` header + changelog |
| Need a verbatim quote | Full PDF/deck must be loaded (thousands of tokens) | Grep `memory/_extracted/*.txt`, not full binaries |
| AI reads everything, burns tokens | Entire document set loaded per question | Summaries loaded first; originals only on-demand |
| Source file changed, summary stale | AI works from outdated context | Manifest hash + document index flag staleness |
| Multi-person updates collide | People and agents overwrite or duplicate active context | Stable IDs, ownership, statuses, and small scoped updates |

### Token Budget Rule

| What | Tokens (approx.) |
|---|---|
| Session start (3 memory files) | 5,000 – 15,000 |
| + Relevant summaries (on-demand) | 500 – 2,000 per file |
| + Extracted text (grep/quote) | 200 – 5,000 per file |
| Full source file (last resort) | 5,000 – 50,000+ per file |

**Goal**: Stay in the first row for 80%+ of interactions.

---

## 2. Directory Structure

```
project/
├── source_files/                        # Canonical originals (READ-ONLY for agents)
│   ├── sow_v2.docx
│   ├── stakeholder_map.pptx
│   ├── market_analysis.pdf
│   └── ...
│
├── memory/
│   ├── 01_static_context.md            # COLD  — org, people, platforms, constraints
│   ├── 02_static_work.md               # WARM  — scope, deliverables, methodology
│   ├── 03_running_state.md             # HOT   — today's focus, decisions, changelog
│   ├── _manifest.json                  # Machine-readable processed-file registry
│   ├── .dpm_lock                       # Concurrency lock for multi-agent use
│   │
│   ├── _summaries/                     # One .md per source file (AI-readable digest)
│   │   ├── sow_v2.md
│   │   ├── stakeholder_map.md
│   │   └── market_analysis.md
│   │
│   ├── _extracted/                     # Full plain-text mirrors (for grep/quotes)
│   │   ├── sow_v2.txt
│   │   ├── stakeholder_map.txt
│   │   └── market_analysis.txt
│   │
│   └── _archive/                       # Archived hot content (rotated from 03)
│       └── 03_running_state_2026-05.md
│
├── DPM_instructions/                    # Agent rules, DPM protocol, project-specific AI instructions
├── agent_outputs/                       # AI-generated working outputs and deliverables
├── .agent/                              # Agent rules, skills, and configuration (e.g., .cursor/, .claude/, etc.)
└── README.md
```

### Key Distinction: _manifest.json vs _summaries/ vs _extracted/

| Layer | Purpose | Format | When AI Reads It |
|---|---|---|---|
| `_manifest.json` | Machine-readable registry of source files, hashes, processing status, and generated memory artifacts | JSON | During scan/ingest workflows and staleness checks |
| `_summaries/` | Quick digest of each source file: what it contains, key points, structure | Structured `.md`, 20–80 lines | When it needs to understand a file without loading it |
| `_extracted/` | Full plain-text mirror of binary files (docx/pptx/pdf → txt) | Raw `.txt` via pandoc/pdftotext | When it needs verbatim quotes or line-level detail |

---

## 3. Three-Tier Memory Model

### 3.1 — `01_static_context.md` (COLD)

> **Decay rate**: Months. Update only on confirmed org/scope/platform changes.

**Sections**:
- **Project Identity**: name, description, client, in/out of scope
- **Stakeholders & Ownership**: role/person/contact table
- **Tools & Platforms**: collaboration, tracking, data/analytics, document storage
- **Constraints & Guardrails**: budget, compliance, data sensitivity, approval gates
- **Reference Links**: project site, shared drives, trackers (no confidential data — reference secure locations only)

Max ~200 lines.

### 3.2 — `02_static_work.md` (WARM)

> **Decay rate**: Weeks. Update when deliverables, scope, or approach changes.

**Sections**:
- **Scope & Requirements Summary**: summarized objectives (not full paste), link to full SOW
- **Key Deliverables**: table with deliverable, owner, due date, status
- **Settled Decisions**: table with decision, choice, date, rationale
- **Methodology / Approach**: frameworks, analytical approaches
- **Known Risks & Mitigations**: risk, impact, mitigation, status
- **Appendix: Promoted Decisions**: decisions promoted from 03

Max ~400 lines.

### 3.3 — `03_running_state.md` (HOT)

> **Decay rate**: Every session. This is the AI's working memory.

**Sections**:
- **Session Header**: today, current phase/milestone, last session summary, last maintenance check
- **Current Focus**: 3–5 active items max, each with ID, owner, status, review date
- **Document Index**: human-readable registry of all source files, backed by `_manifest.json`
- **Open Questions / Blockers**: active items only, each with ID, owner, status, due/review date
- **Decisions Log**: append-only audit log (decision ID, date, decision, rationale, reversible?)
- **New Intel / Unverified**: active unverified items tagged [Inference] | [Unverified] | [Speculation] | [Confirmed]
- **Change Log**: append-only audit log, one line per session end

**Document Index status values**: `NEW` | `Current` | `Stale` | `Needs Review` | `Superseded` | `Archived` | `Error`

**Active item status values**: `Open` | `Blocked` | `Resolved` | `Promoted` | `Rejected` | `Archived`

Active sections are not append-only. Remove or archive completed, resolved, rejected, or promoted items during maintenance so 03 remains a current working state. Append-only protection applies only to Decisions Log and Change Log.

Max ~300 lines.

---

## 4. Summary File Standard (_summaries/)

Each source file gets a corresponding summary. This is the layer that keeps token usage low.

### Template
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
- References: [external data, other docs]

## Notes
- [Caveats, gaps, flags]
- Processed by: [person/agent] on YYYY-MM-DD
```

### Rules
- Max 80 lines / ~1,500 tokens per summary
- Summarize, don't copy — `_extracted/` exists for verbatim quotes
- Update trigger: source file hash changes, or modified date changes when hash is unavailable → flag `Stale` in Document Index → regenerate
- Naming: mirror source filename with `.md` extension

---

## 5. Session Protocol

### Session Start
1. Read 01 + 02 + 03
2. Check `_manifest.json` + Document Index for Status = `NEW`, `Stale`, `Needs Review`, or `Error` → notify user
3. On first boot, or before the first ingestion run, check file-conversion prerequisites and prompt the user about missing tools
4. Update Session Header in 03 with today's date and actor
5. Before editing memory, re-read the target memory section to avoid overwriting another person's recent update

### First-Run Conversion Tool Check

Before `/scanrepo`, `/ingestfile`, or `/scanandingest`, the agent must check whether deterministic extractors are available. If key tools are missing, prompt the user with the missing tools, why they matter, and installation options. Do not read full binary files directly as a substitute unless the user explicitly approves.

Minimum checks:

```bash
python --version
python -m pip show pymupdf python-docx python-pptx pandas openpyxl
pdftotext -v
pandoc --version
```

If scanned PDFs or legacy Office files are expected, also check:

```bash
tesseract --version
soffice --version
```

First-run prompt pattern:

```text
I need file-conversion tools before ingesting source_files/.
Found: [list detected tools]
Missing or unverified: [list missing tools]
Recommended installs: [commands for this OS]

Do you want me to continue with available tools, skip unsupported files, or pause while you install the missing prerequisites?
```

### During Session
- File context needed → read `_summaries/` first → `_extracted/` if needed → `source_files/` as last resort
- Decision made → append to Decisions Log in 03 with a stable decision ID
- New information → add to New Intel in 03 with uncertainty tag, owner, and review date
- New source file → run `/ingestfile` workflow: extract + summarize + manifest + index + integrate into 01 or 02 if durable
- Completed/resolved active item → remove from active section after logging, promoting, or archiving as appropriate
- Conflicting source facts → do not choose silently; mark `Needs Review` and ask the owner/human lead

### Session End
1. Append one-line entry to Change Log in 03
2. Promote confirmed items from New Intel to 01 or 02, then remove them from New Intel
3. Close or remove completed Current Focus, Open Questions, and Blockers from active lists
4. Archive only audit-worthy resolved items; do not preserve routine completed tasks in hot memory
5. If 03 > 300 lines → archive older audit content to `_archive/`
6. Promote stable patterns: repeated hot notes → 02; settled warm facts → 01

---

## 6. Content Rules

### Writing Rules
| Rule | Rationale |
|---|---|
| **Summarize in memory; cite sources in index** | Don't duplicate 50-page docs in 02 |
| **One fact, one home** | Org fact → 01, deliverable → 02, "we decided X on Tuesday" → 03 |
| **Label uncertainty** | [Inference], [Unverified], [Speculation] in 03 until confirmed |
| **Stable IDs for shared work** | IDs let multiple people update the same decision, blocker, deliverable, risk, or source file unambiguously |
| **Active memory is pruned** | Resolved/promoted/rejected items leave active sections after the audit trail or promoted home is updated |
| **Writable folders are limited** | Agents may create or modify files only in `memory/`, `DPM_instructions/`, `agent_outputs/`, or `.agent/` |
| **No confidential data in memory** | Reference secure locations; never hardcode sensitive info |
| **Summaries ≠ extracts** | _summaries/ = AI digest; _extracted/ = full text for grep |

### Lifecycle Rules

| Content Type | Active Home | When Done | Final Home |
|---|---|---|---|
| Current focus item | 03 Current Focus | Completed, no longer relevant, or moved to tracker | Remove from 03; mention in Change Log only if meaningful |
| Open question/blocker | 03 Open Questions / Blockers | Answered, unblocked, rejected, or superseded | Promote answer to 01/02 if durable; otherwise remove |
| New intel | 03 New Intel / Unverified | Confirmed, disproven, or stale | Promote confirmed facts to 01/02; remove disproven/stale items |
| Decision | 03 Decisions Log | Decision becomes settled project guidance | Keep log row; add/update 02 Settled Decisions; cross-reference ID |
| Risk | 02 Known Risks & Mitigations | Resolved or no longer relevant | Move to resolved/archived risk note or remove if low-value |
| Source document | 03 Document Index + `_manifest.json` | Superseded, deleted, or archived | Set status to `Superseded`/`Archived`; retain summary only if useful |

### Size Caps
| File | Max | Action When Exceeded |
|---|---|---|
| 01 | ~200 lines | Split into 01a_, 01b_ by domain |
| 02 | ~400 lines | Split by workstream; archive settled appendices |
| 03 | ~300 lines | Archive entries older than 2 weeks to _archive/ |
| Each summary | ~80 lines | If longer, you're copying not summarizing |

### Staleness Detection
Track each source file in `_manifest.json` using path, content hash, modified time, processed time, generated artifacts, status, and processor. If the source hash differs from the manifest hash, set Status = `Stale` in the manifest and Document Index. If hashing is unavailable, fall back to modified time.

### Manifest Standard

`memory/_manifest.json` is the machine-readable source of truth for scan and ingest workflows. The Document Index in 03 is the human-readable view.

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
      "processed": "YYYY-MM-DDTHH:MM:SS",
      "summary_path": "memory/_summaries/example.md",
      "extract_path": "memory/_extracted/example.txt",
      "absorbed_into": ["02_static_work.md"],
      "status": "Current",
      "processed_by": "person-or-agent",
      "notes": "Optional caveats or conflicts"
    }
  ]
}
```

---

## 7. Bootstrap Checklist

- [ ] Human/project owner or approved setup script creates `source_files/` and places source artifacts there
- [ ] Agent creates DPM-managed structure: memory/, _summaries/, _extracted/, _archive/, DPM_instructions/, agent_outputs/, .agent/
- [ ] Agent performs first-run conversion tool check and prompts user about missing prerequisites
- [ ] Create `memory/_manifest.json`
- [ ] Drop all existing artifacts into source_files/
- [ ] Extract binary files → _extracted/
- [ ] Generate summaries → _summaries/
- [ ] Distill stable facts into 01_static_context.md
- [ ] Distill scope/deliverables/approach into 02_static_work.md
- [ ] Create 03_running_state.md with session header, document index, empty active sections, empty logs
- [ ] Verify Document Index and `_manifest.json` agree on source file status
- [ ] Install agent rules file
- [ ] Validate: agent can start a session reading only the 3 memory files (< 15K tokens)

---

## 8. Selective Loading Guide

| User Ask / Task Type | What to Load | Token Cost |
|---|---|---|
| "Continue where we left off" | 03 only (skim 01+02 if stale) | ~2K–5K |
| "Who owns deliverable X?" | 01 or 02 relevant section | ~2K–5K |
| "Quote the SOW clause on Y" | _extracted/[sow].txt (grep for Y) | ~1K–5K |
| "What did we decide about Y?" | 03 Decisions Log → check 02 if promoted | ~1K–3K |
| "Integrate this new document" | New file → extract + summarize + index | ~5K–15K |
| "Scan for unprocessed docs" | `_manifest.json` + source_files listing + 03 Document Index | ~1K–3K |
| "Summarize the market analysis" | _summaries/market_analysis.md | ~1K–2K |
| "Full deep-dive on [file]" | source_files/[file] (full load — last resort) | ~10K–50K+ |

---

## 9. Maintenance & Lifecycle

### Promotion Flow
```
HOT (03)                     WARM (02)                    COLD (01)
───────────────────────────  ───────────────────────────  ────────────────────
New Intel [Unverified]
        │
        ▼ (confirmed)
Decisions Log ──────────►   Settled Decisions table
                                     │
                                     ▼ (stable for months)
                             Methodology / Approach ────► Constraints
                                                          Stakeholders
```

### Archival Protocol
| Trigger | Action |
|---|---|
| 03 exceeds 300 lines | Move entries older than 2 weeks to `_archive/03_running_state_YYYY-MM.md` |
| 02 exceeds 400 lines | Split by workstream or move settled appendices to `_archive/` |
| Project phase complete | Snapshot all 3 files to `_archive/` with date suffix; reset 03 |
| Source file superseded | Move old version to `_archive/`; update index |

### Maintenance Cadence

| Cadence | Required Actions |
|---|---|
| Daily/session end | Close resolved active items, remove stale hot notes, update Change Log, scan for `NEW`/`Stale` files when daily updates are expected |
| Weekly | Review 02 deliverables, risks, decisions, and promoted items; archive or remove completed work that no longer guides action |
| Monthly or phase-end | Snapshot 01/02/03 to `_archive/`, validate cold facts, clear obsolete warm context, reconcile manifest and Document Index |

### Multi-Person Collaboration Rules

- Treat memory files as shared project state. Read the latest target section immediately before editing it.
- Make small, scoped updates. Avoid reformatting whole tables or rewriting unrelated sections.
- Create or modify files only in `memory/`, `DPM_instructions/`, `agent_outputs/`, or `.agent/`. Never create, modify, move, rename, or delete files in `source_files/`.
- **STRICTLY FORBIDDEN — WILL LEAD TO TERMINATION OF THE AGENT RUN**: creating, modifying, moving, renaming, or deleting files outside `memory/`, `DPM_instructions/`, `agent_outputs/`, or `.agent/`.
- Store agent rules and skills under `.agent/` (or the equivalent, e.g. `.cursor/rules/` and `.cursor/skills/`).
- Attribute durable changes with date and actor in the relevant row or log entry.
- Use stable IDs for decisions (`DEC-...`), questions (`Q-...`), risks (`RISK-...`), deliverables (`DEL-...`), and documents (`DOC-...`).
- If two sources conflict on owner, date, scope, requirement, or decision, keep both citations and mark the item `Needs Review`.
- Newer files do not automatically supersede older files unless the source states that relationship or a human confirms it.
- Do not delete append-only audit logs. Prune only active working sections and archived low-value resolved items.

#### Agent Lock Mechanism

To prevent concurrent memory overwrites by multiple agents, agents must respect the file-based soft-lock mechanism.

**Lock File Schema (`memory/.dpm_lock`)**:
```json
{
  "actor": "user@machine (or Agent ID)",
  "timestamp": "YYYY-MM-DDTHH:MM:SSZ",
  "status": "LOCKED"
}
```

**Lifecycle (Acquire / Override / Release)**:
1. **Acquire**: At session start, before making edits, check for `memory/.dpm_lock`. If it does not exist, create it.
2. **Warn/Abort**: If it exists and is less than 2 hours old, warn the user that the lock is active. Abort unless the user explicitly forces an override.
3. **Override**: If the lock is more than 2 hours old (stale), prompt the user to override it. If approved, overwrite the file.
4. **Release**: Delete `memory/.dpm_lock` at the end of the session.

### File Processing Skills

#### `/ingestfile [path]`

Use for one explicit new or changed file.

1. Confirm the file exists under `source_files/` or ask before processing an external path.
2. Assign or reuse a `doc_id`.
3. Compute content hash and modified time.
4. Extract text to `_extracted/` when the source is binary, using deterministic local tools where available.
5. Generate or update `_summaries/[filename].md`.
6. Update `_manifest.json` and the 03 Document Index.
7. Integrate durable facts into 01 or 02; add only immediate implications to 03.
8. Mark conflicts, unsupported formats, or uncertain facts as `Needs Review`.

Stop and ask before overwriting a summary when the source appears to be a different document with the same filename.

#### `/scanrepo`

Use to inspect repository state without ingesting.

1. Compare `source_files/` to `_manifest.json` and the 03 Document Index.
2. Report new, changed, missing, duplicate, superseded, archived, and errored files.
3. Flag manifest/index drift.
4. Recommend the smallest next action, such as `/ingestfile [path]` or `/scanandingest`.

Do not update summaries, extracts, or memory files unless explicitly asked.

#### `/scanandingest`

Use for routine daily document drops.

1. Run `/scanrepo`.
2. Ingest safe `NEW` and `Stale` files.
3. Pause for duplicates, unsupported formats, manifest/index drift, conflicting source facts, or likely superseded files.
4. Produce a final report listing processed files, skipped files, conflicts, and memory sections updated.

### Recommended Ingestion Tooling

For recurring ingestion, install deterministic extractors or package them as Cursor skills/scripts. This is faster, cheaper, and more repeatable than asking the model to read full binaries. The agent must prompt for these prerequisites on initial boot or before the first ingestion run.

| Source Type | Preferred Extractor | Output |
|---|---|---|
| `.pdf` | `pdftotext`; fallback: PyMuPDF (`pymupdf`) | Full text in `memory/_extracted/[name].txt` |
| `.docx` | `pandoc -t plain`; fallback: `python-docx` | Full text with headings/lists preserved where possible |
| `.pptx` | `python-pptx` | Slide-by-slide text with slide numbers |
| `.xlsx` | `pandas` + `openpyxl` | Sheet names, dimensions, headers, and representative rows |
| `.txt`, `.md`, `.csv` | Direct read/copy or lightweight normalization | Treat source as extract; summarize directly |
| Scanned PDFs/images | Tesseract OCR | Optional; use only when no embedded text exists |
| Legacy `.doc`, `.ppt`, `.xls` | LibreOffice headless conversion | Prefer asking owner for modern Office formats when possible |

Recommended local setup:

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

Windows with winget:

```powershell
winget install --id Python.Python.3.12
winget install --id JohnMacFarlane.Pandoc
winget install --id oschwartz10612.Poppler
```

Optional OCR and legacy Office support:

```powershell
winget install --id UB-Mannheim.TesseractOCR
winget install --id TheDocumentFoundation.LibreOffice
```

Create reusable ingestion skills under the agent's skills directory (e.g., `.cursor/skills/`), such as `.../ingestfile/SKILL.md` and `.../scanrepo/SKILL.md`, if the same project will ingest files daily.

### Multi-Project Scaling
```
workspace/
├── project-alpha/
│   ├── source_files/
│   ├── memory/
│   ├── DPM_instructions/
│   ├── agent_outputs/
│   └── .agent/
├── project-beta/
│   ├── source_files/
│   ├── memory/
│   ├── DPM_instructions/
│   ├── agent_outputs/
│   └── .agent/
└── _global_memory/          # Optional: cross-project facts
    └── org_context.md
```

---

## 10. Why This Scales

| Property | Mechanism |
|---|---|
| **Fixed session cost** | 3 files, 5–15K tokens, predictable every time |
| **Unbounded corpus** | N source docs via index + summaries + extracts, not N full loads |
| **Cross-session continuity** | Hot file + agent rules survive thread/chat boundaries |
| **Human-auditable** | Decisions and changelog are git-diffable plain text |
| **Decay-aware** | Cold/warm/hot prevents stale noise AND frozen wrong "facts" |
| **Multi-person feasible** | Stable IDs, ownership, statuses, and manifest checks reduce duplicate or conflicting updates |
| **Tool-agnostic** | Plain Markdown works in Cursor, Claude Code, Codex, Windsurf, any agent |
| **Cost-efficient** | Summary-first pattern reduces token consumption by 60–90% |
| **Staleness-resistant** | Content hashes in `_manifest.json` flag outdated summaries |

---

## Appendix A — Extraction Commands

```bash
# PDF → text
pdftotext source_files/report.pdf memory/_extracted/report.txt

# DOCX → text
pandoc source_files/spec.docx -t plain -o memory/_extracted/spec.txt

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
" source_files/deck.pptx > memory/_extracted/deck.txt

# XLSX → text
python3 -c "
import pandas as pd, sys
for sheet in pd.ExcelFile(sys.argv[1], engine='openpyxl').sheet_names:
    df = pd.read_excel(sys.argv[1], sheet_name=sheet, engine='openpyxl')
    print(f'--- Sheet: {sheet} ({len(df)} rows) ---')
    print(df.head(20).to_string())
" source_files/data.xlsx > memory/_extracted/data.txt
```

## Appendix B — Summary Generation Prompt

```
Read the following file and produce a structured summary:

# Summary: [filename]
> Doc ID: [DOC-ID] | Source: source_files/[filename] | Last synced: [today] | Modified: [file date] | Hash: [sha256]

## What This File Is
[1-2 sentences: type, purpose, author]

## Key Content
[Bullet points: main topics, key data, conclusions]

## Structure
[Brief outline of sections/slides/chapters]

## Dependencies / Cross-References
[What links to it, what it references]

## Notes
[Caveats, gaps, flags]
- Processed by: [person/agent]

Rules:
- Max 80 lines
- Summarize, don't copy
- Flag anything uncertain with [Unverified]
- Include specific numbers, names, dates — not vague descriptions
```
