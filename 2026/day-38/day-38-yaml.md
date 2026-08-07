# Day 38 – YAML Basics

---

## Task 1 & 2: `person.yaml` — Key-Value Pairs and Lists

```yaml
---
name: Mohammad Meraj
role: DevOps Engineer
experience_years: 0-1
learning: true

tools:
  - docker
  - kubernetes
  - git
  - jenkins
  - terraform

hobbies: [reading, cycling, gaming]
```

**Verify — `cat person.yaml`:** clean output, no stray characters. I also ran `cat -A person.yaml` (which shows tabs as `^I` and line ends as `$`) and confirmed every indent is plain spaces — no tabs anywhere.

**Two ways to write a list in YAML:**
1. **Block style** — each item on its own line, prefixed with `- ` and indented under the key (used for `tools`).
2. **Flow / inline style** — comma-separated items inside square brackets on one line, e.g. `hobbies: [reading, cycling, gaming]` (used for `hobbies`).

Both produce the same data structure (a list/array); block style is easier to read and diff in git, inline style is more compact for short lists.

---

## Task 3 & 4: `server.yaml` — Nested Objects and Multi-line Strings

```yaml
---
server:
  name: web-server-01
  ip: 192.168.1.10
  port: 8080

database:
  host: db_server
  name: appdb
  credentials:
    user: admin
    password: admin123

startup_script_block: |
  #!/bin/bash
  echo "Starting server..."
  systemctl start nginx
  systemctl start docker
  echo "Server started."

startup_script_fold: >
  This script starts nginx and docker,
  then waits for the health check to pass
  before marking the server as ready.
```

Each level of nesting (`server` → its keys, `database` → `credentials` → `user`/`password`) is indented by 2 extra spaces relative to its parent key. Nesting depth is what makes YAML a tree structure instead of a flat list of keys.

**Verify — tab instead of spaces:** I deliberately built a file with a tab character before `name:`:

```
server:
	name: web-server
  ip: 192.168.1.10
```

Running `yamllint` on it gave:

```
tab-test.yaml
  2:1       error    syntax error: found character '\t' that cannot start any token (syntax)
```

**Result: a hard parse error.** YAML's spec does not allow tabs for indentation at all — the parser refuses to even build a document. This is different from an indentation-count mistake (which sometimes still "parses" but produces the wrong structure, see Task 6). Tabs fail loudly; that's actually the safer failure mode.

**`|` vs `>` — when to use which:**
- **`|` (literal block style)** — keeps line breaks exactly as written. Use it for scripts, multi-line commands, config file contents — anything where the newlines are meaningful (e.g. a shell script that needs each command on its own line).
- **`>` (folded block style)** — replaces single line breaks with spaces, folding the text into one line (blank lines become line breaks). Use it for plain prose/descriptions that just wrapped for readability in the source file but should read as one sentence/paragraph, like a description field or a comment.

Rule of thumb: if it's *code or commands* → `|`. If it's *human-readable prose* → `>`.

---

## Task 5: Validation

Installed and ran `yamllint` (v1.38.0) locally against both files.

**Before adding `---` document markers**, both files gave one warning each:
```
person.yaml
  1:1       warning  missing document start "---"  (document-start)
```
Not an error — just a style convention (YAML files should start with `---` to mark the beginning of a document, useful when a single file has multiple documents). I added `---` at the top of both files.

**After the fix**, both files validate completely clean:
```
$ yamllint person.yaml
$ yamllint server.yaml
```
(no output = no errors or warnings)

**Intentionally breaking indentation** (see Task 6 below for the exact broken snippet) produced:
```
indent-test.yaml
  3:1       error    wrong indentation: expected at least 1  (indentation)
```

Interestingly, I also fed the broken file straight to Python's `yaml.safe_load()` (bypassing yamllint) and it did **not** crash — it silently parsed `tools` as a one-item list: `['docker - kubernetes']` (the string got mashed together) instead of the intended two-item list `['docker', 'kubernetes']`. This is the real danger of YAML indentation mistakes: sometimes they don't error at all, they just silently produce the wrong data. This is exactly why running a linter (not just "did it parse") matters before trusting a YAML file in a pipeline.

**After fixing indentation:**
```yaml
---
name: devops
tools:
  - docker
  - kubernetes
```
`yamllint` → clean, no errors. `yaml.safe_load()` → correctly returns `{'name': 'devops', 'tools': ['docker', 'kubernetes']}`.

---

## Task 6: Spot the Difference

```yaml
# Block 1 - correct
name: devops
tools:
  - docker
  - kubernetes
```

```yaml
# Block 2 - broken
name: devops
tools:
- docker
  - kubernetes
```

**What's wrong with Block 2:**
1. `- docker` is at **column 0**, not indented under `tools:` — while YAML technically allows list items to align with their parent key (no extra indent required for a sequence directly under a mapping key), the real bug here is the *next* line.
2. `- kubernetes` is indented **2 spaces further than** `- docker`. Since they're not at the same indentation level, YAML doesn't read them as two items of the same list. Instead, the second `-` gets swallowed as extra content of the first item's value, effectively merging into something like a single scalar `"docker - kubernetes"` rather than two separate list items.
3. **The fix:** both `-` markers must be at the *exact same* indentation column so YAML recognizes them as siblings in the same list:
   ```yaml
   tools:
     - docker
     - kubernetes
   ```

**Takeaway:** in YAML, list items belonging to the same list must share identical indentation — even one space of difference changes the structure or breaks it.

---

## What I Learned — 3 Key Points

1. **Indentation is structural, not cosmetic.** Unlike most config formats, YAML has no braces or brackets to mark nesting for block style — the number of leading spaces *is* the syntax. Two spaces is the accepted standard, and it must be *consistent siblings-must-match* indentation, not just "roughly aligned."
2. **Tabs are a hard failure, but bad spacing can be a silent one.** A tab character makes the parser throw an immediate syntax error. A wrong number of spaces, on the other hand, can still "parse successfully" while producing completely different (wrong) data — which is far more dangerous in a CI/CD pipeline because it won't necessarily crash, it'll just misbehave. Always run a linter (`yamllint`), don't just eyeball it or check "does it parse."
3. **YAML gives you multiple ways to express the same thing** (block vs. flow lists, `|` vs `>` multi-line strings, quoted vs unquoted strings) — the right choice depends on readability and intent (e.g. `|` for scripts where line breaks matter, `>` for prose, block lists for anything you'll diff in git, inline lists for short one-off values).

---

## Files in this submission

- `person.yaml` — Tasks 1 & 2 (key-value pairs, lists)
- `server.yaml` — Tasks 3 & 4 (nested objects, multi-line strings)
- `day-38-yaml.md` — this file