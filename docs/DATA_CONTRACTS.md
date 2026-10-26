# Initial Domain/Data Contracts (Draft)

These are conceptual contracts, not a finalized SQL schema. Review them before creating migrations.

## Account
- id
- owner_user_id
- name
- account_type (cash, bank, wallet, other; finalize supported values)
- currency_code (default EGP)
- opening_balance_minor
- is_archived
- created_at / updated_at

## Transaction
- id
- owner_user_id
- account_id
- type (income, expense, transfer)
- amount_minor (positive magnitude; direction is represented by type)
- currency_code
- category_id (nullable where allowed)
- payee_or_merchant (nullable)
- note (nullable)
- occurred_at
- status (finalize whether pending is in MVP)
- receipt_id (nullable)
- transfer_group_id (nullable)
- created_at / updated_at

## Category
- id
- owner_user_id or system category marker
- name_key / localized display name
- transaction_type compatibility
- icon_key / color_token
- is_archived

## Budget
- id
- owner_user_id
- name
- category_id (nullable only if whole-budget supported)
- limit_minor
- currency_code
- period_type and period boundaries
- alert_thresholds
- created_at / updated_at

## Recurring obligation/subscription
- id
- owner_user_id
- name / merchant
- amount_minor
- currency_code
- cadence
- next_due_date
- category_id
- linked_account_id (optional)
- reminder settings
- status (active, paused, cancelled)
- detection_source (manual, AI suggestion)
- user_confirmed

## Receipt/OCR draft
- id
- owner_user_id
- file reference (private)
- extracted merchant, date, currency, total, tax, line items
- confidence metadata per field if available
- review_status (needs_review, confirmed, discarded)
- linked_transaction_id (nullable)

## AI insight
- id
- owner_user_id
- period_start / period_end
- insight_type
- grounded input metrics/reference identifiers
- explanation
- suggested_action
- status (new, accepted, dismissed)
- created_at

## Required invariants
- Every user-owned record is tenant-isolated by authorization policies.
- A transfer must link the outflow and inflow legs atomically, or use a single canonical transfer record with derived postings.
- Never trust `owner_user_id` supplied by the client without server-side authorization.
- Amounts must be positive magnitudes; type determines financial meaning.
- Define soft-delete/archive behavior before migrations.
- No schema migration is considered final until reviewed and tested against authorization and data-integrity cases.
