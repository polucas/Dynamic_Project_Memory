# `/scanrepo` Skill

**Description**: Scan the repository to compare actual source files with the DPM memory and manifest to find drift.

**Usage**: Use when the user wants to check the status of files, or when ensuring the memory is up to date with `source_files/`.

**Instructions**:
1. Read the contents of `source_files/`.
2. Read `memory/_manifest.json`.
3. Read the Document Index in `memory/03_running_state.md`.
4. Compare the three sources to identify:
   - **NEW files**: Files in `source_files/` but not in the manifest/index.
   - **Stale files**: Files whose hash or modified date differs from what is in the manifest.
   - **Missing files**: Files in the manifest that no longer exist in `source_files/`.
   - **Duplicate files**: Files with identical hashes but different names.
   - **Superseded/Archived/Errored**: Files with these statuses in the manifest.
5. Report the findings to the user clearly.
6. **Do not ingest or edit any files unless explicitly asked to do so.**