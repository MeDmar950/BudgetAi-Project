# 10-Person Engineering Team: File Map & PR Breakdown

This document outlines the engineering distribution for BudgetAI across 10 contributors. It defines clear file ownership, feature boundaries, dependency chains, and pull request deliverables to ensure parallel development without merge conflicts.

---

## 1. File-to-Feature Ownership Matrix

| Feature / Domain | Primary Owner | Directory Scope |
| :--- | :--- | :--- |
| **Core Design & Tokens** | Dev 1 | `lib/core/theme/`, `lib/core/widgets/` |
| **Localization & RTL** | Dev 2 | `lib/l10n/`, `lib/core/localization/` |
| **Accounts & Wallets** | Dev 3 | `lib/features/accounts/` |
| **Transactions & Ledger** | Dev 4 | `lib/features/transactions/` |
| **Budgets & Caps** | Dev 5 | `lib/features/budgets/` |
| **Analytics & Reports** | Dev 6 | `lib/features/analytics/` |
| **Recurring Schedules** | Dev 7 | `lib/features/recurring/` |
| **OCR Receipt Scanner** | Dev 8 | `lib/features/ocr/` |
| **AI Advisory Assistant** | Dev 9 | `lib/features/ai_assistant/` |
| **Backend, Auth & Infra**| Dev 10| `lib/features/auth/`, `.github/`, `supabase/` |

---

## 2. Dependency Graph & Sprint Sequence

```
                    ┌────────────────────────────┐
                    │ Foundation (Merged)        │
                    │ - Money, L10n, Dark Theme  │
                    └──────────────┬─────────────┘
                                   │
         ┌─────────────────────────┼────────────────────────┐
         │                         │                        │
         ▼                         ▼                        ▼
┌──────────────────┐     ┌──────────────────┐     ┌──────────────────┐
│ Dev 1: Design    │     │ Dev 2: L10n RTL  │     │ Dev 10: Auth/RLS │
│ Tokens & Widgets │     │ Complete Strings │     │ Supabase Client  │
└────────┬─────────┘     └─────────┬────────┘     └─────────┬────────┘
         │                         │                        │
         └─────────────────────────┼────────────────────────┘
                                   │
                   ┌───────────────┴───────────────┐
                   ▼                               ▼
         ┌──────────────────┐            ┌──────────────────┐
         │ Dev 3: Accounts  │            │ Dev 4: Tx Engine │
         │ Domain & UI      │            │ Domain & Ledger  │
         └─────────┬────────┘            └─────────┬────────┘
                   │                               │
         ┌─────────┴───────────────┬───────────────┴────────┐
         │                         │                        │
         ▼                         ▼                        ▼
┌──────────────────┐     ┌──────────────────┐     ┌──────────────────┐
│ Dev 5: Budgets   │     │ Dev 6: Analytics │     │ Dev 7: Recurring │
│ Progress Meters  │     │ Cash Flow Charts │     │ Bill Scheduler   │
└──────────────────┘     └──────────────────┘     └──────────────────┘
                                   │
                   ┌───────────────┴───────────────┐
                   ▼                               ▼
         ┌──────────────────┐            ┌──────────────────┐
         │ Dev 8: OCR Draft │            │ Dev 9: AI Advice │
         │ Confirmation UI  │            │ Non-authoritative│
         └──────────────────┘            └──────────────────┘
```

---

## 3. Contributor PR & Task Breakdown

### Dev 1: Design System & Core Reusable UI Components
- **Goal**: Expand design tokens into reusable, accessible Flutter UI components adhering to Figma dark theme.
- **Assigned Files**:
  - `lib/core/widgets/app_card.dart`
  - `lib/core/widgets/app_button.dart`
  - `lib/core/widgets/app_text_field.dart`
  - `lib/core/widgets/money_display.dart`
- **Dependencies**: Foundation tokens (`lib/core/theme/`).
- **PR 101**: `feat(design): reusable dark theme cards, buttons, and money display widget`.
- **Definition of Done**: 100% widget test coverage, RTL padding symmetry verified.

### Dev 2: Localization, RTL Polish & Egyptian Locale Formatting
- **Goal**: Complete all Arabic and English translations; add date and number formatters supporting Egyptian calendar conventions.
- **Assigned Files**:
  - `lib/l10n/app_en.arb`
  - `lib/l10n/app_ar.arb`
  - `lib/core/localization/date_formatter.dart`
  - `lib/core/localization/number_formatter.dart`
- **Dependencies**: Foundation `l10n.yaml`.
- **PR 102**: `feat(l10n): complete Arabic and English string bundles and Egyptian date formatters`.
- **Definition of Done**: `flutter gen-l10n` passes with zero untranslated keys; RTL/LTR widget tests passing.

### Dev 3: Accounts & Cash Wallets Management
- **Goal**: Implement multi-account support (Bank, Cash, Instapay, Vodafone Cash) with balance tracking.
- **Assigned Files**:
  - `lib/features/accounts/domain/account_repository.dart`
  - `lib/features/accounts/data/account_model.dart`
  - `lib/features/accounts/presentation/accounts_screen.dart`
  - `lib/features/accounts/presentation/create_account_dialog.dart`
- **Dependencies**: Dev 1 (UI components), Dev 10 (Auth session).
- **PR 103**: `feat(accounts): account list, balance summary, and account creation flow`.
- **Definition of Done**: Account balances derive deterministically via `BalanceCalculator`.

### Dev 4: Transactions Engine & Ledger Presentation
- **Goal**: Transaction creation, filtering, and history feed for income, expense, and transfers.
- **Assigned Files**:
  - `lib/features/transactions/data/transaction_model.dart`
  - `lib/features/transactions/presentation/transactions_feed_screen.dart`
  - `lib/features/transactions/presentation/add_transaction_screen.dart`
  - `lib/features/transactions/presentation/widgets/transfer_selector.dart`
- **Dependencies**: Dev 3 (Accounts), Foundation `BalanceCalculator`.
- **PR 104**: `feat(transactions): transaction ledger with transfer validation and filter tags`.
- **Definition of Done**: Invariant verified: transfers enforce destination account != source account; transfers never inflate income/expense.

### Dev 5: Budgets & Category Spending Limits
- **Goal**: Budget caps per category with monthly reset logic and visual progress meters.
- **Assigned Files**:
  - `lib/features/budgets/domain/budget.dart`
  - `lib/features/budgets/domain/budget_calculator.dart`
  - `lib/features/budgets/presentation/budgets_screen.dart`
  - `lib/features/budgets/presentation/widgets/budget_progress_card.dart`
- **Dependencies**: Dev 4 (Transactions data).
- **PR 105**: `feat(budgets): budget creation, threshold tracking, and over-budget warnings`.
- **Definition of Done**: Tested against edge cases (zero budget, over-spending, draft transaction isolation).

### Dev 6: Financial Analytics & Cash Flow Reports
- **Goal**: Monthly cash flow breakdown, category pie/bar charts, and net worth progress.
- **Assigned Files**:
  - `lib/features/analytics/domain/financial_summary.dart`
  - `lib/features/analytics/presentation/analytics_screen.dart`
  - `lib/features/analytics/presentation/widgets/cash_flow_card.dart`
  - `lib/features/analytics/presentation/widgets/category_breakdown_chart.dart`
- **Dependencies**: Dev 4 (Transactions), Dev 3 (Accounts).
- **PR 106**: `feat(analytics): cashflow overview and category distribution view`.
- **Definition of Done**: Transfer transactions confirmed to be completely omitted from income/expense graphs.

### Dev 7: Recurring Payments & Bill Tracking
- **Goal**: Recurring expense tracker (rent, bills, gym, installments) with upcoming payment projection.
- **Assigned Files**:
  - `lib/features/recurring/domain/recurring_schedule.dart`
  - `lib/features/recurring/presentation/recurring_screen.dart`
  - `lib/features/recurring/presentation/add_recurring_sheet.dart`
- **Dependencies**: Dev 4 (Transactions), Dev 2 (Date formatters).
- **PR 107**: `feat(recurring): recurring bills manager and next-due date calculator`.
- **Definition of Done**: Tests covering leap years, 30/31-day months, and weekend shifts.

### Dev 8: OCR Receipt Scanner & Draft Confirmation Flow
- **Goal**: Camera receipt scanner producing draft transactions with an explicit confirmation step.
- **Assigned Files**:
  - `lib/features/ocr/presentation/camera_scanner_screen.dart`
  - `lib/features/ocr/presentation/draft_review_screen.dart`
  - `lib/features/ocr/data/ocr_remote_datasource.dart`
- **Dependencies**: Dev 4 (Transactions), Foundation `ReceiptDraft`.
- **PR 108**: `feat(ocr): receipt scanning preview and draft confirmation screen`.
- **Definition of Done**: Drafts stay isolated with zero balance alteration until user taps "Confirm".

### Dev 9: AI Assistant & Financial Advice
- **Goal**: Chat-based financial advice interface with clear non-authoritative boundaries.
- **Assigned Files**:
  - `lib/features/ai_assistant/presentation/ai_chat_screen.dart`
  - `lib/features/ai_assistant/presentation/widgets/ai_insight_bubble.dart`
  - `lib/features/ai_assistant/data/ai_client.dart`
- **Dependencies**: Dev 1 (UI components), Dev 10 (Backend Edge Functions).
- **PR 109**: `feat(ai): assistive chat interface with disclaimers and category insights`.
- **Definition of Done**: AI prompt guardrails enforced; disclaimers displayed prominently.

### Dev 10: Backend Integration, Supabase Auth & CI/CD
- **Goal**: Authentication flow, PostgreSQL schema with RLS, atomic transfer RPCs, and CI enforcement.
- **Assigned Files**:
  - `lib/features/auth/presentation/login_screen.dart`
  - `lib/features/auth/data/supabase_auth_repository.dart`
  - `supabase/migrations/001_initial_schema.sql`
  - `supabase/migrations/002_atomic_transfers.sql`
  - `.github/workflows/ci.yml`
- **Dependencies**: Foundation `.env.example`, `AuthRepository` interface.
- **PR 110**: `feat(backend): Supabase auth repository, RLS policies, and atomic transfer RPC`.
- **Definition of Done**: PostgreSQL tests verifying tenant isolation (`auth.uid() = owner_id`) and atomic transfer safety.
