# BudgetAI MVP Scope

## In scope
1. Authentication/profile
2. Accounts and opening balances
3. Income, expense, and transfer transactions
4. Categories
5. Dashboard and financial summaries
6. Budgets and threshold alerts
7. Analytics and period comparisons
8. Recurring obligations and subscriptions
9. Receipt image import + OCR draft + manual review
10. AI insights/chat grounded in verified app data
11. Arabic/English localization
12. Offline behavior and synchronization plan
13. Settings, privacy, export/import decisions

## Product constraints
- Egypt-first; EGP default.
- No direct bank connection or real-money movement unless separately approved and technically implemented.
- AI recommendations do not claim an action occurred until a real, authorized action succeeds.
- OCR never silently posts a final transaction.
- All money calculations are deterministic.
- Subscription detection is a suggestion; user confirms or dismisses it.
- Keep scope explicit: a visually designed control is not proof the corresponding service exists.

## Required acceptance outcomes
- A user can create an account, record income/expense/transfer, and see correct balances.
- Transfers do not inflate income or expense reports.
- Budgets show documented, testable spent/remaining calculations.
- Recurring items generate due reminders without duplicate charges.
- OCR data can be corrected before saving.
- AI explanations match deterministic aggregates and disclose insufficient data.
- Arabic/English direction and formatting are correct.
- Offline changes and sync conflicts follow documented rules.
