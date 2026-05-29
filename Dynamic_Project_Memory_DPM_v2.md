# Dynamic Project Memory (DPM) v2.0
## A Reusable Standard for AI-Assisted Project Context Management

> **Purpose**: Keep an AI agent (Cursor, Claude Code, Codex, Windsurf, etc.) current on any business project without loading every source file every session. Trade a small, fixed read at session start for on-demand depth via indexes, summaries, and plain-text extracts.

---

## 1. The Problem DPM Solves

| Failure Mode | What Happens Without DPM | What DPM Does Instead |
|---|---|---|
| Re-uploading docs each chat | User pastes same specs/context every session | Canonical files live in `source_docs/`; AI reads structured summaries in `memory/` |
| Re-explaining decisions | Past decisions are lost between sessions | Hot file records decisions + rationale (append-only log) |
| Context window filled with stale content | Old narrative crowds out new work | Tiered decay: cold facts → warm domain → hot session state |
| "Where did we leave off?" | User must manually recap | `03_running_state.md` header + changelog |
| Need a verbatim quote | Full PDF/deck must be loaded (thousands of tokens) | Grep `memory/_extracted/*.txt`, not full binaries |
| AI reads everything, burns tokens | Entire document set loaded per question | Summaries loaded first; originals only on-demand |
| Source file changed, summary stale | AI works from outdated context | File date tracking in document index flags staleness |

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
├── source_docs/                        # Canonical originals (READ-ONLY for AI)
│   ├── sow_v2.docx
│   ├── stakeholder_map.pptx
│   ├── market_analysis.pdf
│   └── ...
│
├── memory/
│   ├── 01_static_context.md            # COLD  — org, people, platforms, constraints
│   ├── 02_static_work.md               # WARM  — scope, deliverables, methodology
│   ├── 03_running_state.md             # HOT   — today's focus, decisions, changelog
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
├── .cursorrules                        # OR CLAUDE.md — agent protocol
└── README.md
```

### Key Distinction: _summaries/ vs _extracted/

| Layer | Purpose | Format | When AI Reads It |
|---|---|---|---|
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
- **Session Header**: today, current phase/milestone, last session summary
- **Current Focus**: 3–5 bullets max
- **Document Index**: master registry of all source files → memory location + status
- **Open Questions / Blockers**: tagged with owner
- **Decisions Log**: append-only (date, decision, rationale, reversible?)
- **New Intel / Unverified**: tagged [Inference] | [Unverified] | [Speculation] | [Confirmed]
- **Change Log**: append-only, one line per session end

**Status values in Document Index**: `Current` | `NEW` (not yet integrated) | `Stale` (source changed) | `Archived`

Max ~300 lines.

---

## 4. Summary File Standard (_summaries/)

Each source file gets a corresponding summary. This is the layer that keeps token usage low.

### Template
```markdown
# Summary: [filename]
> Source: source_docs/[filename] | Last synced: YYYY-MM-DD | Modified: [file date]

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
```

### Rules
- Max 80 lines / ~1,500 tokens per summary
- Summarize, don't copy — `_extracted/` exists for verbatim quotes
- Update trigger: source file modified date changes → flag `Stale` in Document Index → regenerate
- Naming: mirror source filename with `.md` extension

---

## 5. Session Protocol

### Session Start
1. Read 01 + 02 + 03
2. Check Document Index for Status = "NEW" or "Stale" → notify user
3. Update Session Header in 03

### During Session
- File context needed → read `_summaries/` first → `_extracted/` if needed → `source_docs/` as last resort
- Decision made → append to Decisions Log in 03
- New information → add to New Intel in 03 with uncertainty tag
- New source file → extract + summarize + index + integrate into 01 or 02

### Session End
1. Append one-line entry to Change Log in 03
2. Promote confirmed items from New Intel to 01 or 02
3. If 03 > 300 lines → archive older content to `_archive/`
4. Promote stable patterns: repeated hot notes → 02; settled warm facts → 01

---

## 6. Content Rules

### Writing Rules
| Rule | Rationale |
|---|---|
| **Summarize in memory; cite sources in index** | Don't duplicate 50-page docs in 02 |
| **One fact, one home** | Org fact → 01, deliverable → 02, "we decided X on Tuesday" → 03 |
| **Label uncertainty** | [Inference], [Unverified], [Speculation] in 03 until confirmed |
| **No confidential data in memory** | Reference secure locations; never hardcode sensitive info |
| **Summaries ≠ extracts** | _summaries/ = AI digest; _extracted/ = full text for grep |

### Size Caps
| File | Max | Action When Exceeded |
|---|---|---|
| 01 | ~200 lines | Split into 01a_, 01b_ by domain |
| 02 | ~400 lines | Split by workstream; archive settled appendices |
| 03 | ~300 lines | Archive entries older than 2 weeks to _archive/ |
| Each summary | ~80 lines | If longer, you're copying not summarizing |

### Staleness Detection
Track file modified dates in the Document Index. If source file date ≠ indexed date → set Status = "Stale" → notify user at session start → regenerate when directed.

---

## 7. Bootstrap Checklist

- [ ] Create directory structure: source_docs/, memory/, _summaries/, _extracted/, _archive/
- [ ] Drop all existing artifacts into source_docs/
- [ ] Extract binary files → _extracted/
- [ ] Generate summaries → _summaries/
- [ ] Distill stable facts into 01_static_context.md
- [ ] Distill scope/deliverables/approach into 02_static_work.md
- [ ] Create 03_running_state.md with session header, document index, empty logs
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
| "Summarize the market analysis" | _summaries/market_analysis.md | ~1K–2K |
| "Full deep-dive on [file]" | source_docs/[file] (full load — last resort) | ~10K–50K+ |

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

### Multi-Project Scaling
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
| **Tool-agnostic** | Plain Markdown works in Cursor, Claude Code, Codex, Windsurf, any agent |
| **Cost-efficient** | Summary-first pattern reduces token consumption by 60–90% |
| **Staleness-resistant** | Date tracking in Document Index flags outdated summaries |

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

# XLSX → text
python3 -c "
import pandas as pd, sys
for sheet in pd.ExcelFile(sys.argv[1], engine='openpyxl').sheet_names:
    df = pd.read_excel(sys.argv[1], sheet_name=sheet, engine='openpyxl')
    print(f'--- Sheet: {sheet} ({len(df)} rows) ---')
    print(df.head(20).to_string())
" source_docs/data.xlsx > memory/_extracted/data.txt
```

## Appendix B — Summary Generation Prompt

```
Read the following file and produce a structured summary:

# Summary: [filename]
> Source: source_docs/[filename] | Last synced: [today] | Modified: [file date]

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

Rules:
- Max 80 lines
- Summarize, don't copy
- Flag anything uncertain with [Unverified]
- Include specific numbers, names, dates — not vague descriptions
```
