---
name: qa
description: Browser-based QA test suite runner using Playwright MCP. Explores the codebase to generate project-specific test task files, executes them via browser automation, and writes structured UAT reports matching executive-ready format. Supports selective runs, resume after interruption, and .docx export. Use when user wants to run QA tests, generate a test suite, write a UAT report, test the app before release, or invokes /qa.
---

# QA Runner

## Invocation

```
/qa                           # auto-detect: setup if no qa/tasks/, run all if exists
/qa setup                     # (re)generate qa/tasks/ from codebase analysis
/qa <topic>                   # focused setup: generate + run task files for one topic area
/qa run                       # run full suite
/qa run 01 04 14              # run specific tasks by number
/qa run auth users            # run tasks whose filename matches
/qa run --resume              # skip tasks that already have a result file
/qa export <file.md>          # convert a results .md to .docx
```

## Auto-detect (bare `/qa`)

- `qa/tasks/` does not exist → **Setup flow**
- `qa/tasks/` exists → **Run flow** (full suite)

## Recognising `/qa <topic>`

If the argument is not one of the reserved keywords (`setup`, `run`, `export`) and does not look like a flag or file path, treat it as a **topic** and enter the **Focused setup flow**.

Examples that trigger focused setup:
- `/qa authentication & authorization`
- `/qa payments`
- `/qa user roles`
- `/qa onboarding flow`

---

## Focused setup flow

Triggered by `/qa <topic>`. Generates task files scoped to one area and immediately runs them.

**Step 1 — Explore for the topic.** Read only what's relevant:
- Files whose name or path relates to the topic (e.g. `auth`, `login`, `session`, `permission`, `middleware`, `guard`, `role`)
- Middleware, guards, decorators, or interceptors that enforce the topic's rules
- Route definitions that are gated by the topic's logic
- Models / schemas involved (e.g. `User`, `Role`, `Session`, `Permission`)
- Seed files or fixtures that create accounts / roles relevant to the topic

**Step 2 — Infer.** Build a mental model limited to the topic:
- What flows exist (e.g. login, logout, token refresh, role-based redirects)
- What's enforced server-side vs. client-side
- What user types / roles interact with this area

**Step 3 — Gap interview.** Ask ONLY what code cannot reveal:
- Test account credentials if not in seed/fixture files
- Anything genuinely ambiguous after exploration

**Step 4 — Confirm.** Present your plan:
> "Here's what I'll generate for [topic]: [list of task files + test cases + accounts + base URL]. Does this look right?"

**Step 5 — Generate.** Write only the task files relevant to the topic into `qa/tasks/`. Use existing file numbering if `qa/tasks/` already contains files (pick the next available number); otherwise start from `01`.

**Step 6 — Run.** Immediately execute the generated task files using the Run flow. Write results to `qa/results/`.

---

## Setup flow

**Step 1 — Explore.** Read without asking:
- Routes / page components (what pages exist)
- Auth middleware (how login works, is there a dev bypass?)
- User / role / permission models (how many user types, what roles exist)
- Seed files, fixtures, `.env.example`, README

**Step 2 — Infer.** Build a mental model:
- Base URL (from env/config)
- Auth method + dev bypass URL (if any)
- User types and their permission levels
- Page inventory → classify each page by pattern (see [REFERENCE.md](REFERENCE.md#page-patterns))

**Step 3 — Gap interview.** Ask ONLY about what code cannot reveal:
- Seeded test account emails and their roles
- Any pages that are out of scope for this run
- Anything genuinely ambiguous after exploration

**Step 4 — Confirm.** Present your full understanding before writing:
> "Here's what I'll generate: [list of task files + accounts + base URL]. Does this look right?"

**Step 5 — Generate.** Write `qa/tasks/` using patterns from [REFERENCE.md](REFERENCE.md).

Always generate (in this order):
1. `01-auth.md` — login, logout, route protection, unauthenticated redirects, session expiry
2. `02-navigation.md` — nav/sidebar rendering, permission-gated links, active states, collapse
3. Feature task files — one per major area, numbered from `03`, pattern from REFERENCE.md
4. `XX-cross-cutting.md` (always last) — XSS, double-submit, empty states, error handling, loading states

---

## Run flow

For each task file (in order, or filtered by args):
1. Navigate → interact → `browser_snapshot` → assess pass/fail/skip
2. On **FAIL**: `browser_take_screenshot` → save to `qa/results/screenshots/` → note exact reason
3. On **SKIP**: note why (missing data, feature not built, N/A for this project)
4. Never stop on a single failure — complete all cases in the task
5. After each task: write result to `qa/results/` in UAT report format (see [REFERENCE.md](REFERENCE.md#result-format))

After all tasks complete:
- Write `qa/results/00-summary.md`
- If a previous run exists, diff and flag regressions (PASS → FAIL) and fixes (FAIL → PASS)

### Resume

`/qa run --resume`: check `qa/results/` for existing result files. Skip any task whose result file already exists. Start from the first task missing a result file.

---

## Export flow

`/qa export <file.md>`:
1. Read the markdown file
2. Run the Python export script from [REFERENCE.md](REFERENCE.md#export-script)
3. Save output as `<same-name>.docx` in the same directory

If `python-docx` is not installed: `pip install python-docx` first.
If `pandoc` is available: prefer `pandoc -f markdown -t docx -o <output>.docx <input>.md`.
