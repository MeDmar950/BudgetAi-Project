# Security and Privacy Baseline

- Never commit `.env`, service-role keys, AI provider keys, access tokens, or real receipt images/financial records.
- Client-side environment variables are not a safe place for privileged secrets.
- Enforce authorization server-side and enable/test row-level security for all user-owned tables.
- Keep receipt files in private storage and use authorized access paths.
- Minimize data sent to AI/OCR services; document purpose, retention, and provider settings.
- Do not send passwords, access tokens, or unnecessary personal data to AI prompts/logs.
- Redact sensitive values from logs and crash reports.
- Use explicit confirmation for consequential actions and make AI suggestions distinguishable from completed actions.
- Provide a user-facing data export/delete policy before production.
- Test cross-user data access, unauthorized updates, and file access boundaries.
- This document is a baseline checklist, not a security audit or certification.
