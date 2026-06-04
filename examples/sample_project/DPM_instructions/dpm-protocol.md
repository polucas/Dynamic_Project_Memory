# DPM Protocol

Agent rules for this sample project live under `DPM_instructions/` and `.cursor/`.

- Read `memory/01_static_context.md`, `memory/02_static_work.md`, and `memory/03_running_state.md` at session start.
- Treat `source_files/` as read-only.
- Create or modify files only in `memory/`, `DPM_instructions/`, `agent_outputs/`, or `.cursor/`.
- STRICTLY FORBIDDEN — WILL LEAD TO TERMINATION OF THE AGENT RUN: creating, modifying, moving, renaming, or deleting files anywhere else.
- Read summaries before extracted text, and extracted text before full source files.
