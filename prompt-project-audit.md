# Project Audit — Perfume Organizer

You are auditing the current state of the Perfume Organizer project before
spec-driven development begins. Your job is to read the actual files and report
exactly what exists — not what was planned, not what is in docs, but what is
implemented in code right now.

Be precise and honest. If something is partially done, say so. If a file exists
but is empty or is a stub, say so. Do not infer intent from file names — read
the file contents.

---

## Step 1 — Read the context files first

Before touching source code, read these files to understand the project:

```
cat CLAUDE.md
cat DESIGN.md
cat README.md
```

Summarize what each file says in 2-3 sentences. This gives you the intended
state of the project, which you will contrast with reality in the next steps.

---

## Step 2 — Audit the folder structure

Run the following and report the exact output:

```bash
find . -type f \
  -not -path '*/node_modules/*' \
  -not -path '*/.git/*' \
  -not -path '*/.expo/*' \
  -not -path '*/ios/*' \
  -not -path '*/android/*' \
  -not -path '*/drizzle/*' \
  | sort
```

From the output, identify:
- Which folders under `src/` actually exist (not just planned)
- Which folders are empty or only have placeholder files
- Anything unexpected that shouldn't be there per CLAUDE.md conventions

---

## Step 3 — Audit each layer

### 3.1 — Database layer (`src/db/`)

Read and report:

```bash
cat src/db/schema.ts
cat src/db/index.ts
cat src/db/migrate.ts
ls src/db/repositories/ 2>/dev/null || echo "repositories/ does not exist or is empty"
ls src/db/drizzle/ 2>/dev/null
```

Report for each file:
- Does it exist?
- What does it actually contain? (tables defined, methods implemented, etc.)
- Is it complete, partial, or a stub?

### 3.2 — App entry point (`app/`)

```bash
cat app/_layout.tsx
find app/ -type f | sort
```

Report:
- What routes exist?
- Is `_layout.tsx` complete? (font loading, migrations gate, error handling)
- Are there any screens with actual content vs default Expo template content?

### 3.3 — Features (`src/features/`)

```bash
find src/features/ -type f | sort
```

For each feature folder, report:
- Does it have any actual implementation files (not just empty folders)?
- List what exists (screens, hooks, schemas, components, index.ts)

### 3.4 — Shared UI (`src/shared/`)

```bash
find src/shared/ -type f | sort
```

Report:
- Which design system components exist (Button, Text, Input, Card, Tag, Rating)?
- For each that exists, read the file and report if it's implemented or a stub

### 3.5 — Catalog (`src/catalog/`)

```bash
find src/catalog/ -type f | sort
cat src/catalog/data/perfumes.json 2>/dev/null | head -30 || echo "perfumes.json does not exist"
```

Report:
- Does the catalog structure exist?
- Does perfumes.json exist and have data?

### 3.6 — Configuration files

Read and report the status of each:

```bash
cat babel.config.js
cat metro.config.js
cat tailwind.config.js
cat tsconfig.json
cat app.json | python3 -c "import sys,json; d=json.load(sys.stdin); print(json.dumps({'name':d['expo'].get('name'),'sdk':d['expo'].get('sdkVersion'),'plugins':d['expo'].get('plugins'),'newArch':d['expo'].get('newArchEnabled')}, indent=2))"
cat drizzle.config.ts
cat package.json | python3 -c "import sys,json; d=json.load(sys.stdin); print(json.dumps({'dependencies':d.get('dependencies',{}),'devDependencies':d.get('devDependencies',{}),'scripts':d.get('scripts',{})}, indent=2))"
```

Report:
- Is NativeWind configured correctly? (babel + metro + tailwind + global.css)
- Is Drizzle configured correctly? (config + schema + migrations)
- Is Expo SDK version correct? (expect ~54)
- Which dependencies are actually installed?

---

## Step 4 — Produce the audit report

After reading all files, produce a structured report in the following format:

---

### AUDIT REPORT — Perfume Organizer

**Date:** [today's date]

#### What is confirmed working
List only things you verified exist AND have real implementation (not stubs).

#### What is partially implemented
List things that exist but are incomplete — with a brief note on what's missing.

#### What is planned but not started
List things mentioned in CLAUDE.md/DESIGN.md that have zero files in the codebase.

#### Unexpected findings
Anything you found that wasn't expected — wrong files, template code that should
have been removed, naming inconsistencies, etc.

#### Dependency snapshot
List the key installed packages and their versions (from package.json), grouped:
- Expo/React Native core
- Database (Drizzle, expo-sqlite)
- State (Zustand, TanStack Query)
- Forms (react-hook-form, zod)
- Styling (NativeWind, tailwindcss, cva)
- Dev tools (drizzle-kit, etc.)

---

## Rules for this audit

- Read actual file contents — do not assume from file names or folder structure
- If a file is too long to read fully, read the first 80 lines and note it was truncated
- Do not make changes to any file during this audit
- Do not run expo start, prebuild, or any build command
- Report findings in the structured format above — no freeform narrative
- If you cannot read a file (permission error, doesn't exist), explicitly say so