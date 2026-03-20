---
name: brainstorm
description: "Run a structured brainstorm session. Use when the user says 'brainstorm', 'let's brainstorm', 'ideate', 'think through', 'explore ideas', 'what if we', or wants to collaboratively explore ideas, features, architecture, or solutions to a problem."
---

# Brainstorm Session

A structured ideation session that helps you explore ideas, evaluate tradeoffs, and converge on a direction.

## Step 1: Frame the Problem

Ask the user (if not already clear):

```
What are we brainstorming about? For example:
- A new feature idea
- How to solve a technical problem
- Architecture for a new project
- Product direction
- Anything else
```

Once you have the topic, restate it clearly:

```
## Brainstorm: [Topic]

**Goal:** [What we're trying to figure out]
**Constraints:** [Any known constraints — time, tech, budget, scope]
**Context:** [Relevant background]
```

If the topic relates to a codebase, explore it first to ground the brainstorm in reality.

## Step 2: Diverge — Generate Ideas

Generate 5-10 ideas across a spectrum from conservative to ambitious:

```
### Ideas

1. **[Conservative option]** — Low effort, incremental improvement
   - Pros: Fast, low risk
   - Cons: Doesn't fully solve the problem

2. **[Moderate option]** — Balanced approach
   - Pros: Good tradeoff of effort vs impact
   - Cons: Some complexity

3. **[Ambitious option]** — Big swing, high impact
   - Pros: Solves the problem completely, opens new possibilities
   - Cons: More effort, higher risk

...
```

Ask the user to react:
```
What resonates? What's missing? Should we go deeper on any of these?
```

## Step 3: Explore — Go Deeper

Based on user feedback, explore the promising ideas in more detail:

- Technical feasibility (can we actually build this?)
- Effort estimate (how big is this?)
- Dependencies (what do we need first?)
- Risks (what could go wrong?)
- Similar implementations (has anyone done this before?)

If it's a technical brainstorm, check the codebase:
```
Use the Explore agent to investigate:
- How similar features are implemented
- What existing infrastructure we can leverage
- What the integration points look like
```

## Step 4: Converge — Pick a Direction

Help the user narrow down:

```
### Recommendation

Based on our discussion, I'd suggest **Option 3** because:
- [Reason 1]
- [Reason 2]

With these modifications:
- [Tweak from other ideas]

### Next Steps
1. Write a spec (run `/write-spec`)
2. Get architecture plan (run `/architect`)
3. [Other actions]
```

## Step 5: Capture

Offer to persist the brainstorm:

```
Want me to:
- Save this as a spec? (run /write-spec with these ideas)
- Add to Notion as a task?
- Just keep it in this conversation for now?
```

## Tips

- **Quantity over quality in the diverge phase.** Don't self-censor. Wild ideas often spark practical ones.
- **Ask "what if" questions.** "What if we had unlimited time?" "What if we had to ship tomorrow?" These constraints reveal priorities.
- **Build on ideas, don't just list them.** "And if we combine #2 with #5's approach to caching..."
- **Ground in reality when converging.** Enthusiasm is great, but check against the actual codebase and constraints.
- **The user is the decision maker.** Present options and recommendations, but don't push. They know their context better than you.
