# Retrieval evaluation log

| Round | Date | Questions | Top-3 rate | Top-1 rate | Notes |
| --- | --- | --- | --- | --- | --- |
| 1 | 2026-10-04 | 22 in-scope | 100% | 95% | Easy questions, written from the documents |
| 2 | 2026-10-04 | 34 in-scope + 8 out-of-scope | 97% | 94% | Harder and casual phrasing, one Arabic. Miss: "i want to negotiate the price" (an intent, not an information request; handled by escalation rules). Out-of-scope similarity 0.50-0.65 overlaps the weakest good match (0.62), so a cutoff alone can't reject unanswerable questions |

## Decisions
- Retrieve 4 chunks per question.
- Weak similarity floor of 0.55; the main protection against unanswerable questions is the agent's instructions (to be tested in Phase 3).
- Escalation (negotiation, complaints, visas, mortgages) is handled by agent rules, not retrieval.