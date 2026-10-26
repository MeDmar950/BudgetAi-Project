# BudgetAI Architecture Guide

## 1. Product Vision & Principles

BudgetAI is an Egypt-first personal finance mobile application designed to provide intuitive, accurate, and automated budgeting for individuals and households in Egypt.

### Core Tenets
1. **Financial Correctness Above All Else**: Financial amounts are stored as exact integer minor units (piastres, 1 EGP = 100 Piastres). Binary floating-point math (`double`) is prohibited in persistence, aggregations, and business logic.
2. **First-Class RTL & Egyptian Localization**: Arabic is an equal first-class citizen alongside English. Layouts, currency formats (`ج.م` / `EGP`), date pickers, and number formatting support Egyptian conventions seamlessly.
3. **Dark Design Source of Truth**: Material 3 dark theme powered by shared design tokens inspired by the Figma specification (obsidian backgrounds `#0B0F17`, card surfaces `#242E42`, emerald accents `#10B981`).
4. **Assistive, Non-Authoritative AI**: AI and OCR are assistants, not accountants. AI recommendations and OCR draft scans never mutate user balances or finalize transactions without explicit user review and confirmation.
5. **Zero Trust Client Authorization**: All tenant isolation and data ownership is enforced server-side (Supabase Row-Level Security on `auth.uid()`). The backend never trusts client-supplied user identifiers.

---

## 2. Architectural Pattern: Feature-First Clean Architecture

The codebase organizes code by **feature domain**, not by technical layer. Within each feature, clean architectural boundaries separate domain logic from presentation and persistence.

```
lib/
├── core/                           # Shared cross-cutting concerns
│   ├── localization/               # l10n extensions and helpers
│   ├── money/                      # Money value object, Currency, exact arithmetic
│   ├── routing/                    # Declarative navigation contracts
│   └── theme/                      # Figma dark design tokens (colors, spacing, typography)
├── l10n/                           # ARB source files and generated localizations
│   ├── app_ar.arb                  # Arabic strings (RTL)
│   ├── app_en.arb                  # English strings (LTR)
│   └── app_localizations.dart      # Generated Flutter localization
├── features/                       # Modular business domains
│   ├── accounts/                   # Cash wallets, bank accounts, Instapay, Vodafone Cash
│   │   ├── domain/                 # Account entity, repository interfaces
│   │   ├── data/                   # Supabase / SQLite datasources & DTOs
│   │   └── presentation/           # Account lists, balance cards
│   ├── transactions/               # Income, Expense, Transfer records
│   │   ├── domain/                 # Transaction, BalanceCalculator, rules
│   │   ├── data/                   # Transaction repository implementation
│   │   └── presentation/           # Feed, transaction creator, filters
│   ├── budgets/                    # Category budgets, period caps, progress
│   │   ├── domain/                 # Budget entities, threshold calculations
│   │   ├── data/                   # Budget repository
│   │   └── presentation/           # Budget progress meters, alerts
│   ├── analytics/                  # Financial summaries, cashflow, net worth
│   │   ├── domain/                 # Cashflow metrics, aggregation queries
│   │   └── presentation/           # Charts, breakdowns, monthly comparisons
│   ├── auth/                       # User session, onboarding, authentication
│   │   ├── domain/                 # UserSession, AuthRepository contract
│   │   ├── data/                   # Supabase auth implementation
│   │   └── presentation/           # Login, OTP, registration screens
│   ├── recurring/                  # Scheduled bills, subscriptions, installments
│   │   ├── domain/                 # Schedule frequency, due date projector
│   │   ├── data/                   # Recurring task repository
│   │   └── presentation/           # Upcoming bills, subscription tracker
│   ├── ocr/                        # Receipt scanning, Fawry / Instapay draft extraction
│   │   ├── domain/                 # ReceiptDraft, extraction confidence
│   │   ├── data/                   # OCR client (MLKit / Cloud Vision)
│   │   └── presentation/           # Camera preview, draft confirmation modal
│   └── ai_assistant/               # Conversational financial advisor & categorizer
│       ├── domain/                 # AiInsight, query request contracts
│       ├── data/                   # AI Edge Function client
│       └── presentation/           # Chat interface, insight cards
└── main.dart                       # App entry point & foundation shell
```

---

## 3. Dependency & Technology Proposals

To prevent unreviewed bloat, all major package introductions follow this RFC evaluation protocol:

| Package Candidate | Purpose | Status | Evaluation Criteria & Notes |
| :--- | :--- | :--- | :--- |
| **flutter_localizations & intl** | RTL/LTR Arabic & English localization | **Adopted (Foundation)** | Official Flutter SDK package; fully stable on Flutter 3.47.2. |
| **flutter_riverpod** | State management & DI | *Proposed* | Evaluated for compile-time safety and testability. Requires team review before adding. |
| **go_router** | Declarative navigation & deep linking | *Proposed* | Evaluated for URL sync on web, deep link routing for notification clicks. |
| **supabase_flutter** | Auth, Postgres sync & Realtime | *Proposed* | Requires RLS schema migration and Edge Functions for AI/OCR calls. |
| **drift** (SQLite) | Offline-first local database | *Proposed* | Requires sync queue architecture and migration schema definition. |

---

## 4. Financial Domain Rules & Invariants

### 4.1. Minor Unit Representation (Piastres)
- 1 EGP = 100 Piastres.
- Amounts are stored in the database as `bigint minor_units` or `integer minor_units`.
- No floating-point division is allowed when splitting transactions. `Money.allocate()` uses Martin Fowler's proportional distribution algorithm to distribute remainders deterministicly without rounding loss.

### 4.2. Invariant: Transfers are Neither Income nor Expense
- A transfer from Account A to Account B decreases Account A by `amount` and increases Account B by `amount`.
- In cash flow and analytics aggregates, **transfers contribute exactly 0 to income and exactly 0 to expense**.
- Net savings formula: `Net Savings = Total Income - Total Expense`.
- Internal money movement between a user's own accounts never inflates earned income or spent expense.

### 4.3. Invariant: Draft Isolation
- Scanned receipts from OCR or AI-parsed SMS/notifications are assigned `isDraft = true`.
- Draft transactions are excluded from:
  - Account balances
  - Budget consumption
  - Analytics & cashflow totals
- A draft only becomes a live transaction when the user explicitly reviews, edits, and taps **Confirm**.

---

## 5. Security & Tenant Isolation

1. **Row-Level Security (RLS)**:
   Every table (`accounts`, `transactions`, `budgets`, `receipt_drafts`) requires RLS enabled:
   ```sql
   ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;
   CREATE POLICY "User can only access own transactions"
     ON transactions FOR ALL
     USING (auth.uid() = owner_id);
   ```
2. **Never Trust Client-Supplied Owner IDs**:
   The client application never sends `owner_id` as an authoritative field for writes. The server overrides or verifies that `owner_id == auth.uid()`.
3. **No Secrets in Source Control**:
   API keys, service-role tokens, database credentials, and AI secret keys are strictly kept on the backend or in Edge Functions. The mobile client only receives public anon keys through `.env.example`.
