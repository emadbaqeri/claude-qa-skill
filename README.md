# qa-skill

A [Claude Code](https://claude.ai/code) skill that runs browser-based QA test suites using Playwright MCP and produces executive-ready UAT reports.

## What it does

- **`/qa setup`** — explores your codebase, infers routes/auth/roles, asks only what it can't infer, then generates a `qa/tasks/` directory of structured test files
- **`/qa run`** — executes each task file in order using Playwright, writes per-area result files and a `00-summary.md`
- **`/qa run --resume`** — skips tasks that already have a result file
- **`/qa run 01 04`** — run specific task files by number or name fragment
- **`/qa export report.md`** — converts a result `.md` to `.docx` (via pandoc or python-docx)

Reports follow a UAT executive format: pass/fail/skip counts, bug severity tiers, regression diffs between runs.

## Requirements

- [Claude Code](https://claude.ai/code) CLI or desktop app
- [Playwright MCP](https://github.com/microsoft/playwright-mcp) configured in your Claude Code settings
- For `.docx` export: `pandoc` (preferred) or `pip install python-docx`

## Install

### One-liner (recommended)

```bash
git clone https://github.com/YOUR_ORG/qa-skill.git /tmp/qa-skill && bash /tmp/qa-skill/install.sh && rm -rf /tmp/qa-skill
```

### Manual

```bash
git clone https://github.com/YOUR_ORG/qa-skill.git
cd qa-skill
bash install.sh
```

The script copies `skills/qa/` to `~/.claude/skills/qa/`. If a previous install exists it is backed up before overwriting.

## Update

Re-run `install.sh` — it backs up the old version automatically.

```bash
git clone https://github.com/YOUR_ORG/qa-skill.git /tmp/qa-skill && bash /tmp/qa-skill/install.sh && rm -rf /tmp/qa-skill
```

## Uninstall

```bash
bash uninstall.sh
```

Or manually: `rm -rf ~/.claude/skills/qa`

## Usage

Open any project in Claude Code and type:

```
/qa
```

Claude will auto-detect whether to run setup (first time) or execute the full suite (tasks already exist).

## How it works

The skill is two files loaded into Claude Code's context:

| File | Purpose |
|------|---------|
| `SKILL.md` | Invocation syntax, setup/run/export flows, decision logic |
| `REFERENCE.md` | Page-pattern test templates, UAT report format, export script |

When you type `/qa`, Claude reads both files and follows the instructions. No server, no binary — just structured prompting.
