# skills

My agent skills for [Claude Code](https://code.claude.com/docs/en/skills). Each skill is a folder with a `SKILL.md` file, the open Agent Skills format, so other agents that read `SKILL.md` can use them too.

I'm a software engineering student. These skills are how I work with AI agents: with a method, and with me still making the decisions.

## Skills

| Skill | What it does |
|---|---|
| [`real-engineer-workflow`](skills/real-engineer-workflow/SKILL.md) | Runs a whole project or feature as **grill → spec → vertical-slice tickets → TDD → review → retro**, in *learning mode*: the agent asks for my reasoning before it gives its own, so I learn the decisions instead of just accepting them. |

## Install

Clone the repo, then **link** each skill into your personal skills folder. Don't copy it: a link keeps one source of truth, so `git pull` updates the skill everywhere.

**Windows (PowerShell, no admin needed):**
```powershell
New-Item -ItemType Junction `
  -Path   "$env:USERPROFILE\.claude\skills\real-engineer-workflow" `
  -Target "<path-to-this-repo>\skills\real-engineer-workflow"
```

**macOS / Linux:**
```bash
ln -s "<path-to-this-repo>/skills/real-engineer-workflow" ~/.claude/skills/real-engineer-workflow
```

Personal skills load in every project. Check it worked by starting `claude` and typing `/real`; the skill should autocomplete.

## Credits

The workflow is adapted from **Matt Pocock's [Skills For Real Engineers](https://github.com/mattpocock/skills)** (MIT) and his AI Engineer 2026 workshop. His repo splits the process into small, composable skills (`grill-me`, `to-spec`, `to-tickets`, `tdd`, `code-review`, `retro`, `handoff`, …). If you want the original, use his.

### What I changed
- **One skill, start to finish.** The grill → spec → tickets → TDD → review → retro pipeline lives in a single skill I start at the beginning of every project.
- **Learning mode.** For decisions I can reason about, the agent asks what I'd pick and why *before* recommending, then compares the two answers and explains the difference.
- **USER-DRIVES tickets.** At least one substantial ticket per project is written by me, with the agent giving hints and reviewing, so I keep coding skills and don't only review.
- **A learning log.** Every retro appends a concept learned, a mistake caught and why it happened, and one thing to try next time.

### How this was made
I wrote this skill with Claude (Anthropic), starting from Matt's workflow, and I review and use it on my own projects.

## License

[MIT](LICENSE). The copyright notice keeps Matt Pocock's line, because this is a derivative of his work.
