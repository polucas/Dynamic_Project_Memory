# Dynamic Project Memory (DPM)

A lightweight, agent-agnostic system that gives AI coding assistants persistent project context without burning through your context window or token budget.

## What It Does

DPM replaces the cycle of re-uploading files, re-explaining decisions, and losing context between sessions. Instead, the AI reads 3 small memory files at session start and pulls deeper context only when needed.

## How It Works

**Three-tier memory model:**

| Tier | File | What It Holds | Update Frequency |
|---|---|---|---|
| 🧊 Cold | `01_static_context.md` | Org, people, tech stack, codebase map | Months |
| 🟡 Warm | `02_static_work.md` | Requirements, architecture, APIs, conventions | Weeks |
| 🔴 Hot | `03_running_state.md` | Current focus, decisions, changelog | Every session |

**Two supporting layers (loaded on-demand, not at startup):**

- `_summaries/` — short digest of each source/code file (~80 lines). AI reads this first.
- `_extracted/` — full plain-text mirror of binary files. AI reads this only for quotes or search.

**Result:** session startup costs 5–15K tokens instead of 50–200K+ for loading full files.

## Project Structure

```
project/
├── source_docs/              # Your original files (read-only for AI)
├── memory/
│   ├── 01_static_context.md  # Cold tier
│   ├── 02_static_work.md     # Warm tier
│   ├── 03_running_state.md   # Hot tier
│   ├── _summaries/           # AI-readable digests
│   ├── _extracted/           # Full text for grep/quotes
│   └── _archive/             # Rotated old content
├── .cursorrules              # Agent protocol (or CLAUDE.md, etc.)
└── README.md
```

## Quick Start

### Option A — Automated (recommended)
```bash
chmod +x dpm-init.sh
./dpm-init.sh ./my-project
```
Then give your AI agent `DPM_Bootstrap_Agent_Instructions.md` and tell it:
*"Execute all steps starting from STEP 5 for this project"*

### Option B — Fully agent-driven
1. Drop your project files into a `source_docs/` folder
2. Give the agent `DPM_Bootstrap_Agent_Instructions.md`
3. Tell it: *"Execute all steps for this project"*

The agent will create the structure, extract, summarize, populate all tiers, and install its own rules.

## After Setup

The agent will automatically:
- Read the 3 memory files at every session start
- Check for new or changed source files
- Log decisions and changes
- Escalate from summary → extract → full file only when needed
- Keep the hot file trimmed (auto-archive after 300 lines)

If you add a new file to `source_docs/`, tell the agent — it will extract, summarize, and index it.

## Repo Contents

| File | Audience | Purpose |
|---|---|---|
| `README.md` | Humans | Quick orientation (this file) |
| `Dynamic_Project_Memory_DPM_v2.md` | Humans | Full reference: rationale, templates, maintenance, examples |
| `DPM_Bootstrap_Agent_Instructions.md` | AI Agents | Step-by-step executable setup instructions |
| `dpm-init.sh` | Humans/CI | Shell script to scaffold the directory structure |
| `CONTRIBUTING.md` | Contributors | How to contribute to the DPM standard |
| `LICENSE` | Legal | MIT License |
| `examples/` | Both | Sample DPM for a fictional project (filled-in templates) |

## Works With

Cursor · Claude Code · Codex · Windsurf · Aider · any agent that reads Markdown files.

## License

MIT — see [LICENSE](LICENSE).

## Credits
Created by Jed Malec (https://www.linkedin.com/in/jed-malec/)