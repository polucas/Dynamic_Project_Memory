# Contributing to DPM

Thanks for your interest in improving Dynamic Project Memory.

## How to Contribute

### Reporting Issues
- Open a GitHub issue with a clear description of the problem
- Include your agent (Cursor, Claude Code, Codex, etc.) and how DPM failed or could improve

### Suggesting Improvements
- Open an issue tagged `enhancement`
- Describe the problem the improvement solves, not just the feature

### Pull Requests
1. Fork the repo
2. Create a branch: `feature/your-change` or `fix/your-fix`
3. Make your changes
4. Ensure all templates still parse as valid Markdown
5. Update the example project if your change affects templates
6. Submit a PR with a clear description

## Guidelines

- **Keep it agent-agnostic** — DPM works with any AI tool that reads Markdown. Don't add vendor-specific logic to core templates.
- **Keep it lightweight** — the whole point is low token cost. Don't add sections that inflate memory files.
- **Templates over prose** — the bootstrap file is for agents. Write imperatives, not explanations.
- **Test with an agent** — before submitting, verify your change works by having an AI agent execute the bootstrap.

## Scope

DPM is a **pattern**, not a product. Contributions should improve the pattern's clarity, portability, or efficiency — not add tooling, CLI apps, or vendor integrations (those belong in separate repos).
