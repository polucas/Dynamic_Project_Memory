# Contributing to DPM

## How to Contribute

### Reporting Issues
- Open a GitHub issue describing the problem
- Include which AI agent you used (Cursor, Claude Code, Codex, etc.) and how DPM failed or could improve

### Pull Requests
1. Fork the repo
2. Create a branch: `feature/your-change` or `fix/your-fix`
3. Ensure all templates still parse as valid Markdown
4. Update the example project if your change affects templates
5. Submit a PR with a clear description

## Guidelines
- **Keep it agent-agnostic** — DPM works with any AI tool that reads Markdown
- **Keep it lightweight** — the point is low token cost; don't inflate memory files
- **Templates over prose** — the bootstrap file is for agents; write imperatives, not explanations
- **Test with an agent** — verify your change works by having an AI agent execute the bootstrap
