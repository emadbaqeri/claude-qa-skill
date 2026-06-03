# QA Runner — Reference

## Page Patterns

Classify each discovered route into one of these patterns, then instantiate the matching test template.

---

### Pattern: CRUD List Page

**Triggers:** A page with a table of records + create/edit/delete actions.
**Examples:** Users, Roles, Clients, Knowledge Documents, Access Requests

**Test cases to generate:**

| # | Category | Test case |
|---|---|---|
| 1 | Load | Page loads with table (correct columns visible) |
| 2 | Search | Search input filters table to matching rows |
| 3 | Filter | Each filter dropdown correctly narrows results |
| 4 | Combined filters | Multiple filters apply simultaneously (AND logic) |
| 5 | Clear filters | Reset button clears all filters and restores full list |
| 6 | Pagination | Next/prev page shows different rows |
| 7 | Empty state | Zero-result filter shows friendly empty state, not blank |
| 8 | Open create modal | Create button opens empty form |
| 9 | Create — success | Fill valid data → submit → success toast → row appears |
| 10 | Create — duplicate | Submit duplicate unique field → clear error shown |
| 11 | Create — missing required | Submit empty form → field validation errors shown |
| 12 | Create — invalid format | Submit malformed field (e.g. bad email) → format error |
| 13 | Cancel create | Open modal → fill data → cancel → no record created |
| 14 | Edit — pre-filled | Edit button opens modal pre-filled with current data |
| 15 | Edit — save | Change a field → save → table reflects new value immediately |
| 16 | Edit — cancel | Change fields → cancel → original data unchanged |
| 17 | Delete — success | Delete unused record → confirm → removed from list |
| 18 | Delete — blocked | Delete record in use → error explaining why |
| 19 | Permission: view-only | User without edit permission sees no Edit/Delete buttons |
| 20 | Permission: create | User without create permission sees no Create button |
| 21 | Table refresh | After mutation, table updates without manual page reload |

---

### Pattern: Settings Page

**Triggers:** A page with configuration fields, toggles, and a Save button (no row-level CRUD).
**Examples:** AI Settings, Follow-up Config, System Settings

**Test cases to generate:**

| # | Category | Test case |
|---|---|---|
| 1 | Load | Page loads with all settings sections visible |
| 2 | Save disabled | Save button is disabled when no changes have been made |
| 3 | Save enabled | Save button becomes active immediately after any change |
| 4 | Persist — text field | Change text field → save → reload → change persists |
| 5 | Persist — toggle | Toggle a switch → save → reload → state persists |
| 6 | Persist — dropdown | Change dropdown → save → reload → persists |
| 7 | Invalid value | Enter invalid value (negative number, empty required field) → save blocked with error |
| 8 | Restore | Change a value → save → change it back → save again → reload → restored |
| 9 | Navigate away | Make unsaved changes → navigate away → come back → values not saved |

---

### Pattern: Approval Workflow Page

**Triggers:** A page where items have a pending/approved/rejected lifecycle and admins take approve/reject actions.
**Examples:** Access Requests, Knowledge Document review

**Test cases to generate:**

| # | Category | Test case |
|---|---|---|
| 1 | Load | Page loads with list/table of items |
| 2 | Status tabs | Each status tab (Pending/Approved/Rejected) filters correctly |
| 3 | Search | Search filters items by name/email/title |
| 4 | Pagination | Pagination works when >1 page of items |
| 5 | Empty state | Status tab with 0 items shows friendly empty state |
| 6 | Approve | Click Approve on pending item → status changes → toast shown |
| 7 | Reject | Click Reject on pending item → status changes → toast shown |
| 8 | Already processed | Approve/Reject buttons absent or disabled on non-pending items |
| 9 | Permission: view-only | User without approve permission sees no Approve/Reject buttons |
| 10 | Permission: approve | User with approve permission sees and can use Approve/Reject |

---

### Pattern: Read-Only Dashboard

**Triggers:** A page that displays charts, stats, or aggregated data with no CRUD actions.
**Examples:** Analytics, Audit Log

**Test cases to generate:**

| # | Category | Test case |
|---|---|---|
| 1 | Load | Page loads, all chart containers/stat cards visible |
| 2 | Data renders | Charts render with data and labeled axes (no blank/broken state) |
| 3 | Filter | Date range or filter controls update displayed data |
| 4 | Empty range | Selecting a period with no data shows empty state, not crash |
| 5 | Loading state | Skeleton/spinner visible during data fetch |
| 6 | Drill-down | Clicking a row/item opens detail view with correct data |
| 7 | Combined filters | Multiple filters apply simultaneously |
| 8 | Clear filters | Reset restores unfiltered view |

---

## Universal Test Cases

These go into `01-auth.md`, `02-navigation.md`, and the final `XX-cross-cutting.md` regardless of project type.

### Auth (01-auth.md)

- Valid login → lands on dashboard/home, not error
- Invalid/expired token → redirected to /login
- Already logged in visiting /login → redirected away
- Logout clears session → subsequent admin route access redirected to /login
- Unauthenticated direct URL to protected route → redirected to /login
- Non-admin visits admin route → redirected to dashboard
- Admin visits /admin → redirected to first accessible page (not stuck on /admin)
- Limited-permission admin visits unauthorized page → redirected away

### Navigation (02-navigation.md)

- Full-permission user sees all nav items
- Limited-permission user sees only permitted nav items
- Active route is visually highlighted
- Inactive route highlighting clears on navigation
- Sidebar collapse state persists across page reload
- "Back to Dashboard" / home link works
- Logout from nav/sidebar clears session

### Cross-Cutting (last task file)

**Permission rendering:**
- View-only user sees no mutating action buttons (Edit, Delete, Deactivate)
- Sidebar only shows permitted items

**Error handling:**
- 404 route → not-found page or redirect (no white screen)
- API 400 validation error → surfaced to user with descriptive message (no "Something went wrong")
- Expired session mid-use → redirect to /login without crash

**Forms:**
- Required fields validated on submit
- Whitespace-only input rejected
- XSS input (`<script>alert('XSS')</script>`) rendered as literal text, no alert fires
- Double submit prevented — only one API request fires
- Cancel discards all changes

**Tables:**
- Pagination works in both directions (next + prev)
- Empty filter result shows friendly state
- Table refreshes after mutation without manual reload

**Loading states:**
- Skeleton/spinner visible on initial page load
- Submit button shows loading state during submission
- Table shows loading indicator during filter change

---

## Result Format

Each task result file and the final summary follow the UAT executive report format below.

### Per-task result file (`qa/results/NN-name.md`)

```markdown
# [Project] QA — [Area Name]

**Date:** YYYY-MM-DD
**Branch:** [branch]
**Tested by:** Automated QA (Playwright)
**Scope:** [one-line description of what this area covers] — [base URL]
**Test accounts:** [list accounts used]

---

## Summary

**Passed:** X | **Failed:** X | **Skipped:** X | **Total:** X

---

## Test Results

| ID  | Test Case | Result |
|-----|-----------|--------|
| X.1 | ... | ✅ PASS |
| X.2 | ... | ❌ FAIL |
| X.3 | ... | ⚠️ SKIP |
| X.4 | ... | 🐛 BUG |

---

## Failures & Gaps

### [ID] — [Test case name]

[Exact description of what happened, what was expected, what was observed. Include selector, URL, or error message if relevant.]

---

## Screenshots

Screenshots saved to `qa/results/screenshots/` — filenames listed here if any were taken.
```

---

### Summary file (`qa/results/00-summary.md`)

```markdown
# [Project] QA — UAT Execution Report

**Date:** YYYY-MM-DD
**Branch:** [branch]
**Reported by:** [name from git config or ask]
**Tested by:** Automated QA (Playwright)
**Scope:** [description of what was covered] — [base URL]
**Test accounts:** [list]

---

## Executive Summary

[2–3 sentences: overall verdict, any critical bugs found, overall health signal.]

|                      | Count |
|----------------------|-------|
| Tests passed         | X     |
| Bugs found           | X     |
| Gaps identified      | X     |
| Blockers             | X     |
| Total tests executed | X     |

---

## Issues Found

### Fix Before Release (Critical)

| # | Area | Issue |
|---|------|-------|
| BUG-001 | [Area] | [Description — root cause if known] |

### Fix Soon (High Priority)

| # | Area | Issue |
|---|------|-------|

### Informational (Low)

| # | Area | Issue | Resolution |
|---|------|-------|------------|
| GAP-001 | [Area] | [Description] | [By design / not implemented / etc.] |

*(Omit any section that has no entries.)*

---

## Area NN — [Name]

**Scope:** [What this area tests]

| ID  | Test Case | Result |
|-----|-----------|--------|
| N.1 | ...       | PASS   |

**Passed:** X | **Failed:** X | **Skipped:** X

**Failed test details:** *(omit if none)*

- **[ID] — [Name].** [Exact description. Root cause if known. PR/fix reference if resolved.]

---

## Regression Diff *(omit if first run)*

| Task | Test | Previous | This Run | Type |
|------|------|----------|----------|------|
| 04-users | U11 | PASS | FAIL | 🔴 Regression |
| 06-knowledge | K7 | FAIL | PASS | 🟢 Fixed |

---

## What's Working Well

- [Area]: [one-line description of what's solid]

---

## Testing Methodology

[Paragraph: tool used, number of test cases, areas covered, auth method, any notable constraints or deviations from the test plan.]
```

---

## Export Script

Use this when `/qa export <file.md>` is invoked. Prefer `pandoc` if available; fall back to `python-docx`.

### Option A — pandoc (preferred)

```bash
# Check if pandoc is available
pandoc --version 2>/dev/null && \
  pandoc -f markdown -t docx \
    --reference-doc ~/.claude/skills/qa/reference.docx \
    -o "${INPUT%.md}.docx" "$INPUT" \
  || echo "pandoc not found, falling back to python-docx"
```

### Option B — python-docx fallback

Write and run this Python script:

```python
#!/usr/bin/env python3
"""Convert a QA results markdown file to a formatted .docx"""
import sys, re
from pathlib import Path

try:
    from docx import Document
    from docx.shared import Pt, RGBColor
    from docx.enum.text import WD_ALIGN_PARAGRAPH
except ImportError:
    import subprocess
    subprocess.check_call([sys.executable, "-m", "pip", "install", "python-docx"])
    from docx import Document
    from docx.shared import Pt, RGBColor

def convert(md_path: str):
    src = Path(md_path)
    lines = src.read_text().splitlines()
    doc = Document()

    # Styles
    style = doc.styles['Normal']
    style.font.name = 'Calibri'
    style.font.size = Pt(11)

    i = 0
    while i < len(lines):
        line = lines[i]

        # Headings
        if line.startswith('# ') and not line.startswith('## '):
            p = doc.add_heading(line[2:], level=1)
        elif line.startswith('## '):
            doc.add_heading(line[3:], level=2)
        elif line.startswith('### '):
            doc.add_heading(line[4:], level=3)

        # Horizontal rule
        elif line.strip() == '---':
            doc.add_paragraph('─' * 60)

        # Table
        elif line.startswith('|'):
            rows = []
            while i < len(lines) and lines[i].startswith('|'):
                row_line = lines[i]
                if re.match(r'^\|[-| :]+\|$', row_line):
                    i += 1
                    continue
                cells = [c.strip() for c in row_line.strip('|').split('|')]
                rows.append(cells)
                i += 1
            if rows:
                table = doc.add_table(rows=len(rows), cols=len(rows[0]))
                table.style = 'Table Grid'
                for r_idx, row_data in enumerate(rows):
                    for c_idx, cell_text in enumerate(row_data):
                        cell = table.rows[r_idx].cells[c_idx]
                        cell.text = cell_text
                        if r_idx == 0:
                            for run in cell.paragraphs[0].runs:
                                run.bold = True
            continue

        # Bold metadata lines (**Key:** Value)
        elif line.startswith('**') and ':**' in line:
            p = doc.add_paragraph()
            parts = line.split(':**', 1)
            key = parts[0].lstrip('*')
            value = parts[1].rstrip('*') if len(parts) > 1 else ''
            run = p.add_run(key + ': ')
            run.bold = True
            p.add_run(value.strip())

        # Bullet points
        elif line.startswith('- '):
            doc.add_paragraph(line[2:], style='List Bullet')

        # Blank line
        elif line.strip() == '':
            doc.add_paragraph('')

        # Normal paragraph
        elif line.strip():
            doc.add_paragraph(line)

        i += 1

    out = src.with_suffix('.docx')
    doc.save(str(out))
    print(f"Saved: {out}")

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: python export.py <file.md>")
        sys.exit(1)
    convert(sys.argv[1])
```

Save this script to a temp file and run: `python /tmp/qa_export.py <file.md>`
