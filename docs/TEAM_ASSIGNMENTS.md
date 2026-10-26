# Team Assignment Proposal (10 contributors)

Assign people by actual skill level. Each issue has one accountable owner. The Team Lead coordinates shared contracts and integration.

## Person 1 — Team Lead / Architecture / Integration
Owns repository rules, architecture decisions, PR review, releases, dependency conflicts, and cross-feature contracts. Does not implement every shared feature.

## Person 2 — Design System / Localization / Navigation
Owns theme tokens derived from Figma, reusable components, typography, spacing, Arabic/English localization setup, RTL/LTR checks, routing shell. Coordinates changes to shared UI files.

## Person 3 — Authentication / Profile
Owns sign-in, sign-up, sign-out, session states, password recovery, profile/settings integration. Uses repository/service interfaces; no direct secrets.

## Person 4 — Accounts
Owns account list/detail/create/edit/archive, opening balance, account selector contract, and account-related tests.

## Person 5 — Transactions
Owns income/expense/transfer flows, transaction list/detail/edit, search/filter, validation, and deterministic transaction tests.

## Person 6 — Budgets / Categories
Owns category management, budget CRUD, spent/remaining calculations, thresholds, and edge-case tests.

## Person 7 — Dashboard / Analytics
Owns dashboard cards, charts, period filters, category breakdowns, projections only when their calculation method is documented, and visual empty/error states.

## Person 8 — Recurring Bills / Subscriptions
Owns recurring obligation CRUD, cadence, due dates, reminders, pause/cancel, duplicate-prevention rules, and subscription detection review flow.

## Person 9 — Receipt OCR
Owns image/file intake, OCR service abstraction, extraction draft model, confidence display, correction/review UI, and safe confirmation. Do not directly save unreviewed OCR output as a final transaction.

## Person 10 — AI Insights / Chat + Test coordination
Owns AI service abstraction, grounded insight prompts/contracts, safe suggestion states, and integration tests. A separate QA rotation should test all PRs; AI/OCR provider secrets remain backend-only.

## Critical coordination rules
- Backend/data schema and offline/sync need a named owner. The Team Lead must explicitly assign this work to a capable contributor or split it between the Transactions owner and Integration owner before parallel feature development.
- Do not start all 10 tracks independently before agreeing the domain contracts.
- Person 1 should create a small vertical-slice plan and assign a reviewer for each track.
- Avoid assigning multiple people to `main`, shared routing, theme tokens, or the same schema migration.
