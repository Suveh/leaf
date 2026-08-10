# Leaf — Plant Care Companion App
## Agent Instructions (CLAUDE.md)

## Project Overview
Leaf is a Flutter (Android) app that helps users track houseplants: watering schedules,
care reminders, a photo log per plant, a searchable plant-care library, and a
community tips feed.

## Tech Stack
- Flutter (stable channel) + Dart, null-safety enforced
- State management: **Provider** (do NOT use GetX — black-box architecture, hard to debug)
- Local persistence: sqflite or Hive (choose one and stay consistent)
- Theming: centralized in `lib/theme/theme_data.dart` — no inline colors/styles in widgets

## Folder Structure (enforce this — do not deviate)
```
lib/
  features/
    onboarding/
    auth/
    dashboard/
    plants/          # list, detail, add/edit
    reminders/
    camera_log/
    plant_library/
    community_feed/
    profile/
    settings/
  theme/
  shared/            # shared widgets, utils
test/
```

## Screens Required (10+ minimum)
1. Onboarding / welcome
2. Sign up
3. Log in
4. Dashboard / home
5. Plant list
6. Plant detail
7. Add / edit plant
8. Watering schedule & reminders
9. Photo log (camera capture per plant)
10. Plant library / search
11. Community tips feed
12. Profile
13. Settings

## Coding Standards
- Follow `analysis_options.yaml` lint rules — do not disable lints to silence warnings.
- Every new widget file: one public widget per file, named to match filename.
- Prefer `const` constructors wherever possible.
- Isolate state so a single Provider change does not rebuild the entire tree — scope
  Consumer/Selector widgets narrowly.
- Write a test in `test/` for any new business logic (not required for pure UI widgets).

## Git & Workflow Rules
- **Never commit directly to `main`.** All work happens on feature branches
  (`feature/<short-name>` or `fix/<issue-number>`), merged via Pull Request only.
- Every PR must reference its GitHub Issue number.
- Commit early and often — each commit is a checkpoint the agent (and you) can roll back to.
- Before any schema change or destructive data operation, run a backup step first and
  say so explicitly in the commit message.

## GitHub MCP Usage
- When given a change request, first **read the request**, then **create a GitHub Issue**
  describing it (title, description, acceptance criteria) before writing any code.
- After implementation, open a PR against the issue's branch — do not merge automatically.
- Move the linked Project board card to "In Review" only after the PR is opened and the
  code-review sub-agent has approved.

## Guardrails
- Do not read or print the contents of `.env` or any file containing API keys/secrets.
- Do not run `flutter build` with production signing configs during development/testing.
- Do not use YOLO / auto-approve mode for anything touching git history or deleting files.
- If a request is ambiguous, ask a clarifying question rather than guessing on
  architecture-level decisions (state management, folder placement, data model changes).

## Sub-Agents
- **UI/Design sub-agent**: builds and refines widget trees, follows `theme_data.dart`,
  no business logic.
- **Code-composition sub-agent**: implements feature logic, wires state, handles
  navigation.
- **Code-review sub-agent** (read-only, high-reasoning model): reviews diffs before merge.
  Checks for logic bugs, state-management misuse, null-safety violations, and adherence
  to this file — not just syntax. Must explicitly approve or reject with reasons before
  a PR can be opened.