# `/scanandingest` Skill

**Description**: Perform a full repository scan and automatically ingest safe new and stale files.

**Usage**: Use when the user wants to bulk-update DPM memory with all recent file changes in `source_files/`.

**Instructions**:
1. First, execute the equivalent of the `/scanrepo` workflow to identify all NEW, Stale, Missing, Duplicate, and Conflicting files.
2. For all safe `NEW` and `Stale` files, automatically run the `/ingestfile` workflow (extract, summarize, manifest, index).
3. **Pause and prompt the user** for:
   - Duplicates
   - Unsupported file formats
   - Manifest/Index drift
   - Conflicting facts
   - Likely superseded files
4. After processing, provide a summary report containing:
   - Processed files
   - Skipped files
   - Conflicts found
   - Memory sections (01/02/03) that were updated