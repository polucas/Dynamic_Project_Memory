# Dynamic Project Memory (DPM)

A lightweight, agent-agnostic system that gives AI assistants persistent project context without burning through your context window or token budget.

## What It Does

DPM replaces the cycle of re-uploading files, re-explaining decisions, and losing context between sessions. Instead, the AI reads 3 small memory files at session start, tracks source files through a manifest, and pulls deeper context only when needed.

## How It Works

**Three-tier memory model:**

| Tier | File | What It Holds | Update Frequency |
|---|---|---|---|
| 🧊 Cold | `01_static_context.md` | Org, people, platforms, constraints | Months |
| 🟡 Warm | `02_static_work.md` | Scope, deliverables, methodology, risks | Weeks |
| 🔴 Hot | `03_running_state.md` | Current focus, active blockers, decisions, changelog | Every session |

**Three supporting layers (loaded on-demand, not at startup):**

- `_manifest.json` — machine-readable file registry with hashes, processing status, generated artifact paths, and processor metadata.
- `_summaries/` — short digest of each source file (~80 lines). AI reads this first.
- `_extracted/` — full plain-text mirror of binary files. AI reads this only for quotes or search.

**Result:** session startup costs 5–15K tokens instead of 50–200K+ for loading full files.

## Project Structure

```
project/
├── source_files/             # Your original files (read-only for agents)
├── memory/
│   ├── 01_static_context.md  # Cold tier
│   ├── 02_static_work.md     # Warm tier
│   ├── 03_running_state.md   # Hot tier
│   ├── _manifest.json        # Source file registry and processing state
│   ├── _summaries/           # AI-readable digests
│   ├── _extracted/           # Full text for grep/quotes
│   └── _archive/             # Rotated old content
├── DPM_instructions/         # Agent rules, DPM protocol, project-specific AI instructions
├── agent_outputs/            # AI-generated working outputs and deliverables
├── .agent/                   # Agent rules, skills, and configuration (e.g., .cursor/, .claude/, etc.)
└── README.md
```

## Quick Start

### File Ingestion Prerequisites

Install deterministic conversion tools before the first `/scanrepo`, `/ingestfile`, or `/scanandingest` run. This keeps binary processing cheap, repeatable, and outside the LLM context window.

| Source Type | Ideal Tooling | Notes |
|---|---|---|
| `.pdf` | Poppler `pdftotext`; fallback: PyMuPDF (`pymupdf`) | Use OCR only for scanned/image PDFs |
| `.docx` | `pandoc`; fallback: `python-docx` | For legacy `.doc`, use LibreOffice conversion or ask the owner for `.docx` |
| `.pptx` | `python-pptx` | Extract slide-by-slide text with slide numbers |
| `.xlsx` | `pandas` + `openpyxl` | Extract sheet names, dimensions, headers, and representative rows |
| `.txt`, `.md`, `.csv` | Direct read or lightweight normalization | Treat as already text-native |
| Scanned PDFs/images | Tesseract OCR | Optional; use only when no embedded text exists |

Recommended Python packages:

```powershell
python -m pip install pymupdf python-docx python-pptx pandas openpyxl
```

Recommended system tools on Windows:

```powershell
winget install --id Python.Python.3.12
winget install --id JohnMacFarlane.Pandoc
winget install --id oschwartz10612.Poppler
```

Optional for OCR or legacy Office conversion:

```powershell
winget install --id UB-Mannheim.TesseractOCR
winget install --id TheDocumentFoundation.LibreOffice
```

On first boot, the agent must check whether these tools are available and prompt the user before ingestion if anything important is missing. The agent should not open full binary files directly as a substitute for missing extractors unless the user explicitly approves.

### Option A — Automated (recommended)
```bash
chmod +x dpm-init.sh
./dpm-init.sh ./my-project
```
Then give your AI agent `DPM_Bootstrap_Agent_Instructions.md` and tell it:
*"Execute all steps starting from STEP 5 for this project"*

### Option B — Fully agent-driven
1. Create `source_files/` and drop your project files there
2. Give the agent `DPM_Bootstrap_Agent_Instructions.md` and `Dynamic_Project_Memory_DPM_v2.md`
3. Tell it: *"Execute all steps for this project"*

The agent will create only the DPM-managed writable areas, build the manifest, extract, summarize, populate all tiers, and write its protocol under `DPM_instructions/` and `.agent/` (or your platform's equivalent) as needed.

## After Setup

The agent will automatically:
- Read the 3 memory files at every session start
- Check `_manifest.json` and the Document Index for new, changed, stale, or errored source files
- Log decisions and changes while pruning resolved active work from hot memory
- Escalate from summary → extract → full file only when needed
- Keep the hot file useful by closing, promoting, removing, or archiving completed items

## Multi-Person Projects

DPM is designed for shared, long-running projects when agents follow these rules:

- Use stable IDs for documents, decisions, questions, risks, and deliverables.
- Attribute durable updates with actor and date.
- Keep `source_files/` read-only for agents. Agents must not create, modify, move, rename, or delete files there.
- Allow agents to create or modify files only in `memory/`, `DPM_instructions/`, `agent_outputs/`, or `.agent/` (e.g., `.cursor/`, `.claude/`).
- STRICTLY FORBIDDEN — WILL LEAD TO TERMINATION OF THE AGENT RUN: creating, modifying, moving, renaming, or deleting files anywhere else.
- Treat Decisions Log and Change Log as append-only audit logs.
- Prune active sections such as Current Focus, Open Questions, Blockers, and New Intel when items are resolved or promoted.
- Use content hashes in `_manifest.json` to detect stale summaries and extracts.
- Mark conflicting source facts as `Needs Review` instead of silently choosing the newest file.

## Daily File Workflows

- `/ingestfile [path]` processes one explicit new or changed source file.
- `/scanrepo` reports new, changed, missing, duplicate, stale, or unprocessed files without editing.
- `/scanandingest` scans the repo, ingests safe new or stale files, and pauses for conflicts or ambiguous cases.

For regular ingestion, install deterministic extractors rather than asking the LLM to read full binaries: `pdftotext` or PyMuPDF for PDFs, `pandoc` or `python-docx` for Word files, `python-pptx` for PowerPoint, and `pandas` + `openpyxl` for Excel. Put reusable agent skills under your agent's skills directory (e.g., `.cursor/skills/`) and rules under its rules directory (e.g., `.cursor/rules/`).

## Repo Contents

| File | Audience | Purpose |
|---|---|---|
| `README.md` | Humans | Quick orientation (this file) |
| `Dynamic_Project_Memory_DPM_v2.md` | Humans | Full reference: rationale, templates, maintenance |
| `DPM_Bootstrap_Agent_Instructions.md` | AI Agents | Step-by-step executable setup instructions |
| `dpm-init.sh` | Humans/CI | Shell script to scaffold the current DPM directory structure and stubs |
| `CONTRIBUTING.md` | Contributors | How to contribute to the DPM standard |
| `LICENSE` | Legal | MIT License |
| `examples/` | Both | Sample DPM for a fictional project (filled-in templates) |

## Works With

Cursor · Claude Code · Codex · Windsurf · Aider · any agent that reads Markdown files.

## License

MIT — see [LICENSE](LICENSE).

## Credits

Created by Jed Malec (https://www.linkedin.com/in/jed-malec/)