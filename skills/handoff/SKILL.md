---
name: handoff
description: "Only when the user asks for a handoff (/handoff): ends a session with a note a fresh session, or another person, can continue from (where we stopped, exact next steps, decisions), plus what the user learnt and the session's main themes."
argument-hint: "What will the next session focus on?"
disable-model-invocation: true
---

# Handoff

Adapted from Matt Pocock's `handoff` skill (mattpocock/skills). His note is a document in transit. This one has three jobs:
1. **Resume:** a fresh session knows exactly where we stopped and what to do next.
2. **Share:** a friend can read it cold and continue the work.
3. **Remember:** the user comes back to it later to relearn a topic from the session.

If the user passed arguments, they describe what the next session will focus on. Tailor the note to that.

## Rules
- **Write for a cold reader.** No "as we discussed". Define project terms or link `CONTEXT.md`.
- **Detailed on work in flight, links for settled work.** Specs, ADRs, issues, commits and diffs are referenced by path or URL, never copied, because copies drift.
- **Verified vs assumed.** Check facts before writing them (`git status`, `git log`, the files themselves). Anything not checked is marked **(unverified)**. The next session trusts this note and won't re-check it.
- **No secrets.** Redact API keys, passwords, tokens and personal data.
- **Language:** the one the user used most in the session.

## Template
```markdown
# Handoff: <project>: <topic>
<YYYY-MM-DD> · <repo path, branch, last commit> · Next session: <focus>

## 1. Where we stopped
2 to 4 sentences: the current state, the last thing done, and what is half-finished (file, function, step).

## 2. Next steps
1. <first action, concrete enough to start without asking: a file, command or ticket>
2. ...
- **Open questions:** <question>, and who decides
- **Blockers:** <blocker or "none">

## 3. Done this session
- <what changed and why> → <commit, path or ADR>
- **Decisions:** <decision>, because <reason> → <link>

## 4. Keep in mind
Constraints, gotchas, things tried that failed (and why), conventions to follow.

## 5. What I learnt
### Lessons
- **<concept>:** what it is, why it mattered here, and a small example from this session.
### Themes
#### <theme>
3 to 6 lines the user can reread months later without the session: the core idea, how we used it, where to look (links).
### Retro
One mistake caught and why it happened; one thing to try next time.

## 6. References and suggested skills
- <artifacts by path or URL>
- Skills the next session should load, e.g. `/real-engineer-workflow`
```

## Steps
1. **Gather.** Go through the session. If a repo is open, run `git status -sb` and `git log --oneline` to get the facts right.
2. **Write** the note from the template. Leave out sections that would be empty, except 1, 2 and 5.
3. **Save** it as `YYYY-MM-DD-<project>-<topic>.md`:
   - In Claude Code: `~/handoffs/<project>/`, unless the user names another folder. Never inside a repo.
   - In the claude.ai chat: create the file and send it to the user as a download.
4. **Log line.** If the project has `docs/learning-log.md` and you can write to it, append one line: `- YYYY-MM-DD: <themes> → handoff <file name>`. Don't commit it. Otherwise, put that line in your reply for the user to paste.
5. **Reply** with the file's path, next step 1, the log line, and any **(unverified)** items for the user to check before handing the note over.
