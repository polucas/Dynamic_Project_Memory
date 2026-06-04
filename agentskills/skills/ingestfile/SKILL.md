# `/ingestfile` Skill

**Description**: Process a source file for Dynamic Project Memory (DPM), extract its text, summarize it, and integrate it into the memory.

**Usage**: Use when the user asks to ingest a file, or when a new source file is added to `source_files/`.

**Instructions**:
1. Take the `[path]` of the file to ingest.
2. Validate the path exists in `source_files/`.
3. Assign or reuse a stable Doc ID.
4. Compute the SHA256 hash of the file.
5. If it's a binary file (PDF, DOCX, PPTX, XLSX), extract its text:
   - `.pdf`: Use `pdftotext` (if available) or Python with `pymupdf`. Save to `memory/_extracted/[name].txt`.
   - `.docx`: Use `pandoc -t plain` or Python with `python-docx`. Save to `memory/_extracted/[name].txt`.
   - `.pptx`: Use `python-pptx` to extract slide-by-slide text. Save to `memory/_extracted/[name].txt`.
   - `.xlsx`: Use `pandas` and `openpyxl` to extract sheet names, dimensions, headers, and representative rows. Save to `memory/_extracted/[name].txt`.
   - Text native (TXT, MD, CSV): Do not extract, treat source as extract.
6. Generate or update a summary of the file (max 80 lines) in `memory/_summaries/[name].md`.
7. Update `memory/_manifest.json` with the new file information, Doc ID, hash, and status.
8. Update the Document Index in `memory/03_running_state.md`.
9. Integrate durable facts into `01_static_context.md` or `02_static_work.md` if appropriate.
10. Flag any conflicts as `Needs Review`.

**Stop before overwriting an existing summary if the same filename appears to represent a different document.**