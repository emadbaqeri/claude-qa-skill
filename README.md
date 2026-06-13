# qa-skill

A [Claude Code](https://claude.ai/code) skill that runs QA test suites for **web apps** (via Playwright MCP) and **React Native apps** (via Maestro), then produces executive-ready UAT reports.

## What it does

- **`/qa setup`** — explores your codebase, infers routes/screens/auth/roles, asks only what it can't infer, then generates a `qa/tasks/` directory of structured test files
- **`/qa run`** — executes each task file in order, writes per-area result files and a `00-summary.md`
- **`/qa run --resume`** — skips tasks that already have a result file
- **`/qa run 01 04`** — run specific task files by number or name fragment
- **`/qa export report.md`** — converts a result `.md` to `.docx` (via pandoc or python-docx)
- **`/qa --ios`** / **`/qa --android`** — force mobile mode (auto-detected for React Native projects)

Reports follow a UAT executive format: pass/fail/skip counts, bug severity tiers, regression diffs between runs, and device/platform metadata for mobile.

## Requirements

### Web projects
- [Claude Code](https://claude.ai/code) CLI or desktop app
- [Playwright MCP](https://github.com/microsoft/playwright-mcp) configured in your Claude Code settings

### React Native projects
- [Claude Code](https://claude.ai/code) CLI or desktop app
- [Maestro](https://maestro.mobile.dev/) — `curl -Ls "https://get.maestro.mobile.dev" | bash`
- iOS: Xcode + a booted simulator (`xcrun simctl boot <UDID>`)
- Android: Android Studio + a running emulator (`adb devices`)

### Both
- For `.docx` export: `pandoc` (preferred) or `pip install python-docx`

## Install

### One-liner (recommended)

```bash
git clone https://github.com/emadbaqeri/claude-qa-skill.git /tmp/qa-skill && bash /tmp/qa-skill/install.sh && rm -rf /tmp/qa-skill
```

### Manual

```bash
git clone https://github.com/emadbaqeri/claude-qa-skill.git
cd claude-qa-skill
bash install.sh
```

The script copies `skills/qa/` to `~/.claude/skills/qa/`. If a previous install exists it is backed up before overwriting.

## Update

Re-run `install.sh` — it backs up the old version automatically.

```bash
git clone https://github.com/emadbaqeri/claude-qa-skill.git /tmp/qa-skill && bash /tmp/qa-skill/install.sh && rm -rf /tmp/qa-skill
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
| `SKILL.md` | Invocation syntax, setup/run/export flows, decision logic, mobile prerequisites |
| `REFERENCE.md` | Web page patterns, mobile screen patterns, Maestro flow templates, UAT report format, device management commands, export script |

When you type `/qa`, Claude reads both files and follows the instructions. Project type is auto-detected (web vs React Native) from your directory structure. No server, no binary — just structured prompting.
