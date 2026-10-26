# BudgetAI — Egypt-First Personal Finance App

BudgetAI is a smart personal finance application tailored for Egypt, supporting Arabic (RTL) and English (LTR), Egyptian Pound (EGP) as the default currency, and modern Material 3 dark aesthetics inspired by Figma.

---

## 🚀 Quick Start & Setup

### Prerequisites
- Flutter SDK **3.47.2+** (Dart 3.13+)
- Android SDK 36.0+ / Java JDK 21+ (for Android builds)
- Visual Studio / Chrome (for desktop / web development)

### Setup Commands

```bash
# 1. Clone and enter the repository
cd BudgetAi

# 2. Configure environment variables (client non-privileged config only)
cp .env.example .env

# 3. Fetch dependencies
flutter pub get

# 4. Generate localization files (Arabic & English)
flutter gen-l10n

# 5. Run the application
flutter run
```

---

## 🧪 Testing & Code Quality

BudgetAI enforces strict formatting, static analysis, and 100% pass rates on financial core tests.

```bash
# Check code formatting
dart format --output=none --set-exit-if-changed .

# Run static analysis
flutter analyze

# Execute test suite
flutter test --coverage
```

Continuous integration runs on GitHub Actions via [`.github/workflows/ci.yml`](.github/workflows/ci.yml).

---

## 🏛️ Architecture & Principles

BudgetAI follows a **Feature-First Clean Architecture** with strict layer separation:
- `lib/core/`: Cross-cutting concerns including `Money`, design tokens, localization, and routing.
- `lib/features/<feature>/`: Self-contained business domains (`accounts`, `transactions`, `budgets`, `analytics`, `ocr`, `ai_assistant`, `auth`).
  - `domain/`: Pure business models, value objects, and repository interfaces.
  - `data/`: DTOs, datasources, and repository implementations.
  - `presentation/`: Screens, widgets, and state management.

### Financial Correctness Invariants
1. **Integer Minor Units (`Money`)**: Stored in piastres (1 EGP = 100 Piastres) to eliminate binary floating-point (`double`) precision loss. Allocations use Martin Fowler's proportional distribution algorithm.
2. **Transfer Isolation**: Transfers move funds between accounts without inflating income or expense totals in cash flow reports.
3. **Draft Isolation**: Scanned receipts from OCR or AI remain drafts until explicitly confirmed by the user. Drafts never alter live balances.
4. **Non-Authoritative AI**: AI provides assistive insights only; it cannot execute transactions or modify ledgers directly.
5. **Zero-Trust Backend Authorization**: Row-Level Security (RLS) is enforced in PostgreSQL on `auth.uid()`. Client-supplied owner IDs are never trusted.

---

## 📚 Documentation Index

- [Architecture Guide](docs/ARCHITECTURE.md): Comprehensive system design, folder structure, and dependency evaluation protocol.
- [Decisions & Open Questions (ADRs)](docs/DECISIONS.md): Architectural decisions and unresolved product questions (offline-first sync, OCR provider, recurring schedules, AI privacy).
- [10-Person Team Task Breakdown](docs/TEAM_TASK_BREAKDOWN.md): Issue, PR, and file ownership breakdown for all 10 contributors.

---

## 🔒 Security & Secrets Hygiene

- Never commit secrets, service-role keys, private AI API keys, or database credentials to version control.
- Only non-privileged client identifiers belong in `.env.example`.
- All privileged calls (AI inference, OCR processing, atomic transfers) must be executed through backend Edge Functions.
