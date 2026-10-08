# Case Study: A WhatsApp-style AI Assistant for a Dubai Real Estate Brokerage

*A portfolio project built by [Your name]. The client, data and documents are fictional.*

## The problem

Dubai property leads arrive at all hours and mostly through chat. For a brokerage, a slow reply often means a lost lead, and agents waste time on enquiries that were never qualified. The fictional client, a 15-agent brokerage, wanted instant answers, structured lead data in its CRM, and a reliable way to hand difficult conversations to a person.

## What I built

An assistant that answers customer questions from an approved knowledge base, qualifies leads in a natural conversation, saves them to HubSpot as a contact and a deal, and hands over to a human agent when needed. It runs on n8n, Gemini, Supabase (Postgres and pgvector) and HubSpot, all on free tiers. I built it on Telegram so I could iterate quickly at zero cost; the channel is a thin layer, so moving to the WhatsApp Cloud API would change the trigger and send steps rather than the logic.

## How it works

Customer messages arrive through a webhook and are logged with an idempotent insert, so repeated deliveries do nothing. An AI agent decides what to do. For facts it searches a vector index of the knowledge base; for lead details it calls a CRM tool; for sensitive topics it hands over. The workflow, not the model, supplies the customer's identity. Every step is logged, and failures raise an alert.

## Key decisions

1. **Test retrieval before the chatbot.** I measured search quality on its own: 97% of 34 realistic questions had the right chunk in the top three results.
2. **Don't trust a similarity cutoff alone.** Scores for unanswerable questions overlapped those of answerable ones, so I added a second layer: strict grounding rules in the agent's instructions, tested with out-of-scope and adversarial questions.
3. **Make everything repeatable.** Unique constraints and upserts mean re-running ingestion or receiving a duplicate message cannot create duplicate records.
4. **Own the customer mapping.** A small table links each chat to its HubSpot records, which avoids duplicate contacts caused by the CRM's search delay and gives an instant "is the bot paused?" check.
5. **Keep escalation rule-based.** Negotiation, complaints, visas and mortgages are handled by explicit rules and a marker the workflow acts on, not by search.

## Results

| Measure | Result |
| --- | --- |
| Retrieval, top-3 hit rate (34 in-scope questions, including Arabic) | 97% |
| Agent evaluation, round 1 (35 cases) | [X]% |
| Agent evaluation, round 2 after fixes | [Y]% |
| First response time | [measure and add, for example under 10 seconds] |
| Conversations logged and linked to CRM records | 100% in testing |

## Problems I hit and what I learned

- **Empty source files** made ingestion return nothing. I found the cause by printing file sizes. Lesson: check the input before the code.
- **A "do nothing on duplicate" database rule is not an error**, so the workflow would still have replied twice. I added an explicit branch on the returned ID.
- **Free-tier realities:** a CRM free plan limited custom properties, private apps were being retired in favour of service keys, and model rate limits shaped how I built tests (paced runs and a fallback reply).
- **Silent failures are worse than loud ones:** I added dimension checks, an error workflow, and a customer fallback so nothing fails quietly.

More detail is in `docs/problems-and-fixes.md`.

## Limitations

Telegram rather than WhatsApp; runs on a laptop; synthetic data; no calendar booking; the alert depends on the database; no consent or data-retention flow, which a real UAE deployment would need.

## What I would do next

Deploy to an always-on server, add the WhatsApp adapter and approved templates, add viewing booking, add a one-tap handback command for agents, add an LLM judge to the evaluation, and add consent and retention handling.

## Skills demonstrated

Workflow automation (n8n), LLM agents with tool calling, RAG (chunking, embeddings, retrieval evaluation), CRM integration (HubSpot REST API, idempotent upserts), PostgreSQL and pgvector, Docker, Git, error handling and observability, evaluation design, and clear documentation.

## CV bullets (replace X and Y with your real results)

- Built an AI assistant on n8n, HubSpot and Supabase (pgvector) that answers customer queries via RAG and qualifies leads, reaching [X]% on a 35-case agent evaluation after prompt iteration.
- Designed and tested a RAG pipeline (section-based chunking, task-typed embeddings, retrieval tuning), achieving 97% top-3 retrieval accuracy on 34 realistic questions.
- Implemented production safeguards: idempotent message and CRM writes, human handover with CRM notes, error alerting, rate limiting and a customer-facing fallback.
- Designed a channel-agnostic architecture, running on Telegram with a documented path to the WhatsApp Cloud API.
