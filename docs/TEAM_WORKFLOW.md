# GitHub Team Workflow

## Branches
- `main`: protected, releasable baseline.
- `feat/<ticket>-short-name`: feature work.
- `fix/<ticket>-short-name`: bug fixes.
- `docs/<ticket>-short-name`: documentation.

## Pull requests
Every PR must include:
- What changed and why
- Linked issue
- Screenshots/video for UI changes
- Tests added/updated
- `flutter analyze` result
- Risk/migration notes where relevant

Require at least one reviewer. Shared architecture, financial rules, database schema, localization conventions, and security changes require team-lead review.

## Definition of Done
- Acceptance criteria met
- No unrelated changes
- Formatting and static analysis pass
- Tests cover relevant domain behavior
- Arabic RTL and English LTR checked where applicable
- Loading, empty, error, success, and offline states handled as relevant
- No secrets or real user financial data committed
- PR reviewed and merged

## Issue template
Use: Goal, Context/Figma link, scope, out of scope, acceptance criteria, dependencies, test plan, owner.

## Coordination
- One owner per issue.
- Do not let multiple contributors edit the same shared file simultaneously.
- Announce shared contract changes before implementation.
- Rebase/update feature branches regularly; merge through PRs.
- Never make independent assumptions about transaction or budget semantics.
