---
name: "real-engineer-workflow"
description: "Use at the start of every new coding project or significant feature: runs a Matt Pocock-style grill → spec → vertical-slice tickets → TDD → review loop, in learning mode."
---

# Real-engineer project workflow (learning mode)

Adapted from Matt Pocock's AI coding workflow (mattpocock/skills and his AI Engineer 2026 workshop). There are two goals: ship working software, and leave the user a better engineer than before. The user makes the decisions. Claude asks, proposes, explains the trade-offs with reasoning (not bare prescriptions), and keeps the process rigorous.

## When to use
Use it for a new project, a new feature or any non-trivial change. Skip it for one-line fixes and small edits.

## Phase 0: Repo docs
Create these, or read them first if they already exist:
- `CONTEXT.md`: the domain glossary, with each term, what it means and which synonyms to avoid.
- `docs/adr/NNNN-title.md`: one short file per decision with real trade-offs, covering context, decision and consequences.
- `issues/`: the spec and tickets as markdown, with finished tickets moved to `issues/done/`.
- `docs/learning-log.md`: the running learning retro.

## Phase 1: Grill (alignment before anything else)
- Interview the user one question at a time. Each question says why it matters, gives Claude's recommended answer and names one alternative. Then wait for the reply.
- Walk the whole decision tree: the user and their goal, scope and non-goals, the data model, edge cases (empty data, failure, offline, invalid input, concurrency), auth, stack, deployment and testing.
- If the repo or the docs can answer a question, look there instead of asking.
- Learning mode: for decisions the user can reason about, ask what they would pick and why before giving Claude's recommendation, then compare the two and explain the difference.
- Stop only when no open branches remain. Add new terms to CONTEXT.md and write an ADR for each decision that had real trade-offs.

## Phase 2: Spec
Write `issues/spec.md` with these sections: problem, solution, numbered user stories, implementation decisions, testing decisions and out of scope.
- The implementation decisions cover modules and interfaces. Prefer deep modules, meaning a small interface with the complexity hidden inside.
- Leave out file paths and code snippets, because they go stale and mislead later sessions.
- The user reviews and approves the spec before Phase 3.

## Phase 3: Tickets as vertical slices
Split the spec into `issues/NNN-short-title.md` files. Each ticket is:
- a tracer-bullet vertical slice through every layer (data → logic/API → UI → test) that can be demoed on its own
- listed with the user stories it covers, its dependencies and its acceptance criteria
- tagged AFK (Claude can do it alone) or HITL (it needs a human decision or review)

Learning mode: tag at least one substantial ticket per project USER-DRIVES. The user writes that code, and Claude gives hints and reviews it.

Present the breakdown and wait for the user's approval.

## Phase 4: Implement with TDD, one ticket per session
- Work in this order: blocking bugs, then dev infrastructure (tests, typecheck and lint must run first), then tracer bullets, then polish, then refactors.
- Red: write one failing test for the next behaviour, show it and run it.
- Green: write the minimum code that makes it pass.
- Refactor: clean up while the tests stay green.
- Tests and typecheck (and lint, if configured) gate every commit. Never call something done without running them.
- The commit message records what changed, the key decisions and notes for the next ticket. Then move the ticket to `issues/done/`.

## Phase 5: Review
Check the diff against the acceptance criteria and spec, CONTEXT.md vocabulary, code smells, edge-case test coverage and module depth. Report findings most severe first. The user decides what gets fixed.

## Phase 6: Handoff and retro
- When the context is getting long or a ticket ends, write a handoff note so a fresh session can continue. It covers status, decisions made, open questions, the next ticket and paths to the artifacts. Fresh sessions beat one long thread, because quality drops as context grows.
- Learning retro: append 2 to 4 lines to `docs/learning-log.md` covering one concept learned, one mistake caught and why it happened, and one thing to try next time.

## Standing rules
- Never skip the grill because a request seems clear.
- The user owns the decisions and Claude owns the rigor.
- Bad codebases make bad agents. Flag architecture drift, such as shallow modules or one feature smeared across many files, and suggest an architecture-improvement pass every few tickets.
- Back recommendations with reasoning the user can check.