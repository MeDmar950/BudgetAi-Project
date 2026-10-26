# Architecture & Product Decision Records (ADRs)

This document tracks agreed decisions, established conventions, and unresolved product/technical questions requiring stakeholder alignment. Unresolved items are explicitly marked as **TODO**.

---

## ADR-001: Money Representation & Arithmetic

- **Status**: Decided & Implemented in Foundation
- **Context**: Financial calculations in personal finance applications suffer from precision loss and rounding errors if stored as standard IEEE 754 floating-point numbers (`double`). In Egypt, 1 Egyptian Pound (EGP) is divided into 100 Piastres (قرش).
- **Decision**: 
  1. All financial values in domain entities, repositories, and persistence are strictly represented as 64-bit integer minor units (`minorUnits` / Piastres).
  2. The `Money` value object encapsulates exact integer arithmetic (`+`, `-`, `*`), comparison, and Martin Fowler's proportional allocation algorithm (`allocate()`) to ensure no fractions of piastres are lost during multi-way splits.
  3. Floating-point `double` is strictly prohibited for monetary persistence and balance aggregation.
- **Consequences**: Deterministic financial math, zero accumulator drift across record additions, updates, or deletions.

---

## ADR-002: Transfer Treatment in Cash Flow & Analytics

- **Status**: Decided & Implemented in Foundation
- **Context**: Users frequently move money between their accounts (e.g., ATM cash withdrawal from a bank account, transfer to Vodafone Cash, or Instapay transfer to another personal account).
- **Decision**: 
  1. Transactions have three distinct types: `income`, `expense`, and `transfer`.
  2. Transfers require a valid `destinationAccountId` distinct from the source `accountId`.
  3. A transfer decreases the source account and increases the destination account by `amount`.
  4. In cash flow summaries and income/expense reports, **transfers are strictly excluded from both total income and total expense**. Net savings is strictly `Income - Expense`.
- **Consequences**: Accurate, truthful financial reporting that does not distort user savings or expenses when shifting funds between their own accounts.

---

## ADR-003: Isolation of OCR & AI Scanned Drafts

- **Status**: Decided & Implemented in Foundation
- **Context**: Mobile OCR and AI-assisted receipt scanning often misread characters, merchant names, or totals (especially on degraded Egyptian paper receipts or thermal paper).
- **Decision**: 
  1. All OCR and AI extractions are initially saved in a designated `draft` status (`isDraft = true`).
  2. Drafts are excluded from live account balances, budget calculations, and cash flow reports.
  3. Only when the user manually reviews, validates, and taps "Confirm" does the draft transition to an active `Transaction`.
  4. AI has zero permission to execute money movements or mutate ledger records autonomously.
- **Consequences**: Users retain full control over financial accuracy; scanning errors cannot corrupt accounts.

---

## UNRESOLVED DECISION 001: Offline-First Architecture & Sync Strategy

- **Status**: **TODO (Pending Architecture & Backend Team Alignment)**
- **Options Under Consideration**:
  1. **Option A: Full Local-First with Drift (SQLite) + Background Sync Queue**
     - *Pros*: Instant UI responsiveness, 100% offline functionality in low-connectivity areas (e.g. Cairo metro, underground shops).
     - *Cons*: High complexity for multi-device sync, conflict resolution, and schema migrations.
  2. **Option B: Supabase Direct with Cache-and-Retry**
     - *Pros*: Simpler architecture, built-in Supabase Realtime subscriptions and PostgreSQL RLS.
     - *Cons*: Limited offline capabilities if write operations fail without network.
- **Conflict Resolution Strategy**:
  - Needs decision: Last-Write-Wins (LWW) based on server-verified timestamp vs Conflict-Free Replicated Data Types (CRDTs) vs manual user conflict prompt.
- **Action Item**: Tech lead and backend engineer to benchmark Drift sync performance and decide before Sprint 2.

---

## UNRESOLVED DECISION 002: Recurring Schedule Semantics & Calendar Edge Cases

- **Status**: **TODO (Pending Product Alignment)**
- **Open Questions**:
  1. **End-of-Month Behavior**: If a recurring salary or bill is scheduled for the 31st of each month:
     - Does February execute on Feb 28 (or Feb 29 in leap years)?
     - In 30-day months (April, June, September, November), does it execute on the 30th?
     - If yes, does it return to the 31st in the following month?
  2. **Weekend & Bank Holiday Shifts**: In Egypt, the standard banking weekend is Friday and Saturday. Should recurring transfers shift to the preceding Thursday or following Sunday?
  3. **Representation**: Should we use RFC 5545 `RRULE` strings or a custom structured schedule schema (`frequency`, `interval`, `dayOfMonth`, `shiftPolicy`)?
- **Action Item**: Product manager to specify recurring rule edge-case requirements for Egyptian salary and bill cycles.

---

## UNRESOLVED DECISION 003: Egyptian Receipt OCR Provider Selection

- **Status**: **TODO (Pending Benchmarking & Budget Approval)**
- **Requirements**:
  - Must accurately extract totals, dates, and merchant names from Egyptian paper receipts (Arabic and English), Fawry bills, and Instapay transfer screenshot receipts.
  - Must handle Western Arabic numerals (`1, 2, 3`) and Eastern Arabic numerals (`١, ٢, ٣`).
- **Options Under Consideration**:
  1. **Google ML Kit (On-Device)**: Zero server cost, fast, private, but lower accuracy on cursive Arabic merchant receipts.
  2. **Google Cloud Vision API (Server-Side via Supabase Edge Function)**: High Arabic OCR accuracy, moderate cost per 1,000 requests.
  3. **Mindee / Azure AI Document Intelligence**: Specialized receipt parsing schemas, higher unit cost.
- **Action Item**: Dev 8 (OCR specialist) to execute a test benchmark on 50 Egyptian receipts across all three providers.

---

## UNRESOLVED DECISION 004: AI Provider & Privacy Guardrails

- **Status**: **TODO (Pending Legal & Privacy Review)**
- **Candidate Providers**: Google Gemini 1.5 Flash / Pro vs OpenAI GPT-4o-mini vs Anthropic Claude 3.5 Haiku.
- **Key Constraints**:
  1. Financial data anonymization: Personal identifiers (user names, national IDs, bank account numbers) must be masked before sending prompts to external LLM endpoints.
  2. Prompts and completions must strictly be routed via backend Edge Functions; mobile client never holds API keys.
  3. AI is strictly assistive: No automated ledger writes or third-party money movement.
- **Action Item**: Security and compliance officer to review data transfer regulations under Egyptian Personal Data Protection Law (PDPL).

---

## UNRESOLVED DECISION 005: Backend Authorization & Atomic Transfers

- **Status**: **TODO (Drafted in Foundation, Pending Backend Implementation)**
- **Agreed Core Principle**: All tenant isolation is enforced at the database level with PostgreSQL Row-Level Security (RLS) linked to `auth.uid()`.
- **Transfer Atomicity Requirement**:
  - Creating a transfer involves debiting the source account and crediting the destination account.
  - This operation must execute within an atomic PostgreSQL transaction (e.g. database function / RPC) so that a failure in crediting the destination cannot result in money vanishing from the source.
- **Action Item**: Backend engineer to implement and test atomic transfer RPC function and tenant isolation unit tests in Supabase migration.
