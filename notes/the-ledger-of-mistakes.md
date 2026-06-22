# The Ledger of Mistakes

*When agent retrospectives become engineering culture instead of prompt bloat*

*Łukasz Stafiniak and GPT-5.5 Pro*

---

The agents were too helpful.

That sounds like a joke, or at least like the kind of complaint one makes only after forgetting what bad agents feel like. Usually the failure mode is the opposite. The agent ignores the instruction, invents an API, writes a test that only passes in the universe of its own explanation, or turns a crisp change into a vague refactor. Ludics has plenty of those failures.

But the stranger problem came from a more productive place.

After difficult Ludics tasks, I started asking for retrospectives: not only what went wrong in the project, but what went wrong in the workflow. The instruction was deliberately ambitious: quality improvements until fixpoint. If a task took three rounds because a test passed vacuously, I wanted the system to notice. If a reviewer caught a stale assumption, I wanted the failure to become less likely. If a coder had to be reminded that an AC names a contract rather than a vibe, I wanted that reminder to go somewhere.

The retrospectives had two scopes. Some findings were project-specific: this OCaml module has a hidden serializer consumer, this Ludics config surface has four places that must be updated together, this proposal was stale against the current codebase. Others were workflow-specific: when should a reviewer ask for mutation evidence, when should a coder revise the proposal rather than invent a proxy verification, when should a feedback item become a task rather than a memory?

The agents responded in the most natural way. They proposed adding instructions.

Add this to the coder prompt. Add that to the reviewer prompt. Remind future agents to run this grep, mistrust that fixture, split that OR clause into both arms, assert on the artifact the AC names, spawn the real CLI when the AC names an exit code, never use a constant as its own oracle.

Most of the suggestions were not wrong. That was the problem.

A prompt can survive bad advice more easily than it can survive unlimited good advice.

Every sentence loaded into an agent's context has a cost. It competes with the task. It changes what the model attends to. It teaches the agent that this concern is always relevant, even when it is not. It turns one review scar into a permanent anxiety. A prompt is not a notebook. A prompt is an execution environment.

So Ludics needed somewhere for true things that should not become prompt text.

That place became the SWE Textbook: a ledger of mistakes.

## The third disposition

The interesting object is not the document by itself. The interesting object is the routing mechanism around it.

A completed task produces retrospective material: refactor suggestions, workflow feedback, review comments, and sometimes reviewer blocks from earlier rounds. Ludics now has a process-suggestions skill that reads this material, splits it into individual items, deduplicates them, and chooses among three dispositions.

A substantive item becomes a follow-up task. This is for real work: a missing edge case, a test-coverage gap, an architectural cleanup, a workflow improvement that reduces friction across many future tasks.

A one-off hygiene item is skipped with a reason. This is for style nits, already-covered suggestions, tiny comment changes, or reminders not worth preserving.

The middle category is the important one: recurring-but-not-doctrine. These are lessons with real signal that are too general, too obvious, too situational, or too expensive to add to every future prompt. They are captured in the SWE Textbook.

The feedback-digest path does the same thing at a larger cadence. It reads accumulated workflow feedback, clusters items by theme, deduplicates them against existing GitHub issues, and files actionable workflow defects. But it also has the same third disposition: capture-textbook. A theme may both file an issue and capture a textbook entry, because the actionable defect and the underlying engineering lesson are not the same thing.

This is the small design move that makes the article possible. Without the third disposition, the retrospective loop has only two outputs: bloat the prompt, or forget the lesson. The SWE Textbook gives Ludics a way to remember without instructing every future agent to remember.

The document is explicitly a write-only journal. Coder agents do not consult it. Reviewer agents do not consult it. Its active consumers are Mag and the feedback-digest worker. It is also, deliberately, a publication seed. Entries are meant to be plain English, not private system jargon.

That directionality matters. The textbook is not a hidden mega-prompt. It is a memory store for routing decisions: things the competent-SWE filter would otherwise discard, preserved for Mag, digest workers, future review patterns, and human writing.

The naive story of AI memory is accumulation. Give the agent everything. Let it remember every correction, every failure, every preference, every old review. Bigger context, fewer repeated mistakes.

Ludics taught me the opposite lesson. The hard problem is not remembering everything. The hard problem is deciding where each memory belongs.

Some memories belong in always-loaded prompts. Some belong in agent-facing pattern references. Some belong in lints. Some belong in reviewer probes. Some belong in Mag-side memory. Some belong in a GitHub issue. Some belong in a blog post. Most do not belong in every coder's context.

A system does not learn by adding every lesson to the prompt. It learns by routing lessons.

## The ledger's first law

The strongest teaching in the ledger is simple:

Passing is not evidence.

That sentence is too strong in ordinary programming. Of course passing tests are evidence of something. But in agentic coding workflows, the phrase "tests pass" is dangerously underspecified. The test may never have reached the branch it claims to exercise. The fixture may already have had the expected property. The assertion may check a helper rather than the artifact the acceptance criterion names. The test may drive the function under a default config that returns before doing any work. The code path may be traversed, but the invariant may remain untouched.

A passing test becomes evidence only when you can name the falsifier.

What would fail if the AC were violated?

This question appears in several forms across Ludics documentation: invariant versus capability, harness instantiation, mutation evidence, vacuous harnesses. The words vary, but the discipline is the same.

A capability claim says: serialization coverage exists; the path is exercised; the option is passed; the freshen step is covered. These are sentences agents naturally produce. They sound like verification, but often they are only descriptions of motion.

An invariant claim says: the parent releases before the child acquires; the journal line contains this structured field; this file's bytes remain identical after the operation; this downstream code path does not run after the hard failure. These claims have pressure points. You can point to the assertion that flips.

That is why mutation evidence became central. Do not merely say the test would catch the regression. Break the production code and watch the test fail. Flip the guard. Remove the field. Neuter the comparator. Stash the production change while leaving the test in place. Append the extra literal to a sibling file. Then revert and write the verification line.

The order matters. One SWE Textbook entry exists because a coder wrote the mutation claim from a confident mental model, then ran the mutation after the verification line was already written. The claim happened to be true. The order was still wrong.

That is an excellent ledger entry because it is both obvious and real. Agents are not the only ones who confuse a confident prediction with an observation. Humans do it constantly. Under pressure, "I know this would fail" quietly becomes "I verified that this fails."

The ledger preserves the embarrassment:

Run the experiment before writing the result.

## Test the verb

Another recurring teaching is: test the verb, not the helper.

This came through most cleanly in an OCANNL case. The acceptance criterion said that buffers were allocated with a certain storage mode. The first test checked the pure classifier that maps memory mode to storage mode. That test was not worthless. It pinned the helper. But it did not prove that actual buffers were allocated with that mode. The allocator could have ignored the helper. It could have threaded the result through one allocation path but not another.

The non-vacuous test allocated real buffers and inspected the storage mode on the resulting buffer.

The general form is portable:

If the AC says "is allocated," inspect the allocation. If it says "is emitted," capture the event. If it says "is written," read the file. If it says "the CLI exits with code 1," spawn the CLI. If it says "the event payload contains `divergedBy`," capture the structured event, not a formatted message that happens to include the number.

A beautiful unit test of the wrong surface is worse than an ugly integration test of the right one, because the beautiful test gives false confidence.

This is the kind of thing a competent engineer already knows, and therefore exactly the kind of thing that should not become prompt text. But the fact that competent engineers know it does not mean agents always do it. It does not even mean humans always do it. The ledger keeps it available as a recognition pattern: when the AC's verb names a produced artifact, the test's direct object should be that artifact.

## Rewrite the harness, not the gate

The most interesting teaching is the one that first looked like a rule against cheating:

Do not weaken the production invariant to make the test easier.

The crude version is obvious. A production path is gated by an invariant. The AC names that gate. The test needs to reach code behind the gate. The easiest move is to add an override: `forceX`, `skipGate`, an env var, an extra option whose only consumer is the test. Now the test can exercise the side effect. The suite goes green.

But the invariant has changed.

The gate no longer says "freshen only when no `argRoot` and not CI." It says "freshen only when no `argRoot` and not CI, unless this other knob says otherwise." The test no longer proves that the gate opens under the named condition. It proves that the override bypasses the gate.

This is not only about cheating. It is about where complexity belongs.

Tests need controllability. Production invariants need integrity. Perfect black-box testing is often too expensive. Some seams are good design. An injectable subprocess runner can be a good seam. A tmpdir plus environment override can be a good seam. A PATH-shimmed fake binary can be a good seam. Backend-specific visibility that lets a concrete backend test inspect a concrete object can be a good seam.

The distinction is whether the seam substitutes the world or changes permission.

A good seam says: run the same production boundary, but in a controlled world. Use a fake `bun` found through PATH. Use a temporary harness directory. Use a fake clock. Use a concrete backend interface to inspect a real allocator result.

A bad seam says: let production enter a state the invariant used to forbid.

That is the more precise rule:

Add seams at boundaries of observation or substitution, not at boundaries of permission.

The reviewer heuristic is correspondingly simple. Any new `force...` flag, test-only env var, or `opts.skipGate` on a path whose gate the AC names should trigger suspicion. The right default is not "never add a seam." The right default is: rewrite the harness, not the gate.

When the ideal harness is too expensive, the compromise should be explicit. Revise the proposal. Split the scope. File an operational follow-up. State the limitation. Do not smuggle a hidden production mode into the code and call the resulting green test evidence.

## Fixtures are part of the proof

A fixture is not just setup. It is part of the argument.

The ordering-test example is the cleanest. A test claimed to prove deterministic ordering. It seeded several tasks and asserted the output order. But the fixture IDs were already correlated with the expected sort order. On a filesystem whose natural order was alphabetical, removing the production sort still produced the expected order. The comparator-neutering mutation passed.

The test did not prove sorting. It proved that already-sorted input stayed sorted.

The fix was obvious after the fact: choose fixtures whose alphabetical order and creation order are the inverse of the expected order; use enough cases to avoid accidental success; include a tie case; then neuter the comparator and watch the assertion fail.

A config-gated early return is another version. A test asserts that nothing was enqueued twice. But under the default config, the function returns before trying to enqueue anything. The test passes because the behavior never ran. The fix is to open the gate in the harness and add a positive control proving the path actually executed.

A negative predicate is a third version. `assert (not (f X))` may pass because `f` returned false for the wrong reason. The stronger form embeds `X` in a larger context where the wrong classification changes an observable, then asserts the positive result.

These are not profound ideas. They are professional habits. But the ledger's value is precisely that many important failures are obvious only after pain. A system that records only profound lessons misses most of engineering.

## The type checker is not the audit

The ledger also records misplaced trust in tools.

A typed language is an extraordinary ally. It is not an oracle. It catches what its type system expresses. It does not catch old meanings that still typecheck.

One OCaml refactor moved a field across a structural boundary. Constructors and pattern matches failed cleanly. The compiler did its job. But silent reader sites remained: code that still read the old field path, now with a different meaning. A length calculation saw fewer axes than before. A pretty-printer quietly printed the wrong shape. The fix was not "trust the compiler harder." It was an exhaustive grep of the old reader literal with a disposition table.

Another OCaml entry involved `[@@deriving sexp]`. A field rename propagated into `.expected` cram fixtures because the derived serializer prints field names. A source grep for `.field_name` did not see `(field_name value)` in expected output. The hidden consumers were not type errors. They were text.

The pattern generalizes. Serializers, printers, generated docs, UI labels, CLIs, markdown examples, and golden fixtures often become consumers of names that look internal. The compiler sees the code. It does not see every place the code's representation has become text.

This is a good example of why the ledger should not become prompt doctrine. "The type checker is not the whole audit" is true, but too broad. It helps only when the coder recognizes the shape: I am moving a field across a structural boundary; I am renaming a derived field; I am changing a semantic accessor that also feeds display. Then the entry becomes useful.

Memory is not only content. It is timing.

## A small catalogue of paid mistakes

One reason I trust the ledger is that many entries are small. They do not flatter the system. They are the sort of thing an experienced engineer reads and thinks: yes, obviously. Then the entry explains the round where it was not obvious enough.

Some entries are about the direction of a verb. "Issue is updated" means the GitHub issue changed — a comment, body edit, label, or closure — not that a repository document now contains a link pointing at the issue. The side named by the verb is the side that must visibly change. The same pattern appears in live-configuration work: updating repo templates can satisfy lints and fresh-install paths, while the running harness still reads the deployed state-repo config. If the AC is world-level, the world is the surface.

Some are about constants becoming their own false oracle. If an AC says a remedy string must contain `` `~/<repo>` ``, then `expect(result.remedy).toBe(REMEDY_CONST)` is circular. It proves the code returns the constant, not that the constant contains the required token. The constant is both the system under test and the oracle. The fix is embarrassingly small: keep the equality if useful, but also assert the literal the AC names.

Some are about lexical probes pretending to be semantic probes. A heading-literal exact-count grep counts intra-doc cross-links that quote the same heading. A basename grep for `MEMORY.md` passes even when the worked example points at the wrong directory. A greedy regex over a markdown table extracts the last `#123` on the line, not the issue number in column one. The failures are funny because the command is technically doing exactly what was asked. The mistake was asking a string search to prove a structural property.

The AC-rigor reference is full of these forensic shapes. A path-safety test that only expects a throw can pass because the file was missing, not because traversal was blocked. The non-vacuous test seeds a real sibling decoy file, runs the malicious input, and asserts byte identity afterwards. Even the malicious-input set can lie: bare `..` looked path-traversal-shaped, but the guard's regex accepted dots, so the test was not in the rejected set at all. The lesson is not "write more tests." It is: understand the language of the guard before claiming to test it.

Some entries are pure tool and language scar tissue. `git rm` pre-stages deletions; if you run it early and then selectively commit unrelated files, the deletion can ride along and make an intermediate commit non-buildable. `rg -rn` is not `grep -rn`; ripgrep reads `-r` as `--replace`, so the occurrence list can quietly turn every match into the literal `n`. Dune cram failures print `diff --git` blocks, not necessarily the word `FAILED` or `differ`, so grepping the log for familiar failure words while ignoring the exit code is a good way to convince yourself a red run was green. A body-top guard can also lose to the language: default-parameter expressions run before the function body, so a `mainBranch = defaultMainBranch(projectDir)` default can call Git before the guard that was supposed to reject a missing checkout. The fix is to make the parameter optional and resolve it after the guard.

Some are about time. A sweep AC must choose whether it is talking about audit-time state or post-execution state. If the task closes six of eleven issues, then a live query for open issues after the task is no longer the same universe as the table written before the task. Pin completeness to a frozen audit-time set, and test the world-state mutation separately. The same temporal honesty appears in operational ACs: if an acceptance criterion requires SSH to a live node or deployed federation state the worktree cannot reach, do not mark it "pending" and hope. Split the scope formally, copy the operational ACs verbatim into the follow-up, and record the carve-out in the proposal.

Some are about source control and iteration hazards. Stashing the whole tree around a command that may hang is a trap: if the command never returns, the `stash pop` never runs and the uncommitted work disappears from the visible tree until recovered by hand. A single-file stash-prod mutation is fine because it is fast and bounded. A baseline check around an unbounded command belongs in a separate worktree. Similarly, an incremental test runner's cached green is not proof that the test just ran under the current tree. If the claim is specific, force the specific target.

Some entries come from hidden consumers. A `[@@deriving sexp]` field rename leaks into `.expected` cram fixtures because the serializer prints field names. A `%expect` block that captures an exception backtrace bakes source file and line numbers into the golden output, so unrelated edits shift the expected text. A semantic accessor made more faithful can flood display surfaces with reserved values; the fix is not to lie in the accessor again, but to filter at the display layer. These are all the same warning in different clothes: once representation becomes text, consumers multiply outside the compiler's field of view.

Some are about model-friendly but false simplifications. A shared helper extracted across branches may hide opposite ordering invariants; if flipping the global order makes one test pass and another fail, the invariant is branch-specific and belongs in a parameter. A feature that "already works downstream" may still be blocked by a gatekeeper validator the plan did not inspect. A pass over a heterogeneous body needs a fixture where the kinds co-occur, not only one test per kind in isolation. These are not new laws. They are recognition cues for the moment a tidy abstraction starts erasing the distinction that made the original code correct.

And some are about foreign or generated execution. Metal shader code can compile and still segfault at dispatch. A compiler pass can emit the right operation tree and compute the wrong values. A DSL can be too clever to produce the low-level IR shape a backend regression needs. The ledger answer is practical: probe the real runtime before committing to the design; run the transformed program when the pass changes values; build direct low-level fixtures when the surface language optimizes away the case you need.

These examples are too specific to deserve universal prompt space. They are also too expensive to forget. That is the ledger's niche: not a law book, not a checklist, but a cabinet of paid-for recognitions. When a future task has the same shape, the old wound has a name.

## Agents are processes, not text boxes

Some entries are not about testing code. They are about running agents.

As long as an AI agent is imagined as a chat box, lifecycle can remain informal. You send a prompt. It works. Eventually it replies. Maybe it is done, maybe it is stuck, maybe you nudge it.

That model fails when agents become workers in an orchestration system.

Ludics had to distinguish settled from hung. A settled agent is ready for the next prompt. Its read loop is open. Pasted input lands. A hung agent is alive but not ready. The spinner moves, pane bytes change, but no substantive progress happens and pasted input will not reach the read loop. Those states need different detectors and different recovery shapes.

This is mundane distributed-systems engineering, which is why it matters. Once agents are workers, "looks done" is not a state. "Spinner moving" is not a state. "Pane changed" is not a state. The system needs a physiology: lifecycle fields, turn identity, stale-signal windows, stop hooks, timeouts, recovery ladders, artifact validation.

This is also where Ludics' vibe-coded nature matters. The system is not a polished product with clean abstractions discovered by a committee. It is a living, overgrown, partially obsolete, TypeScript-heavy apparatus built through a particular generation of agent tools. It has scars from tmux, t3code, Claude Code, Codex, Bun, Dune, OCaml, GitHub, and my own habits. Its documents are not timeless doctrine. They are the fossil record of a moment in agentic development.

That does not make them less interesting. It makes them more interesting.

They show what it felt like to make these systems work before the platforms fully absorbed the patterns. They show the edge where intelligent workers met deterministic rails, where model competence was high enough to do real work and unreliable enough to require institutions.

## The bureaucracy that learns

There is an obvious objection to all of this: it is bureaucracy.

Retrospectives generate suggestions. Suggestions are classified. Some become tasks. Some become issues. Some become textbook entries. Some are skipped with reasons. The textbook has idempotency checks. The feedback digest has response contracts. The orchestration patterns document has entry standards. The AC-rigor reference has thematic families.

This is bureaucracy.

The question is whether it is bounded, useful bureaucracy.

Every system that learns from failure risks becoming a museum of old wounds. Every postmortem wants to become a checklist. Every checklist wants to become policy. Every policy wants to become unconditional. Eventually the organization is not safer, just slower and more theatrical.

In Ludics, this pressure has a specifically agentic source. The natural move is to make the future target less ambiguous by adding another prompt instruction. The impulse is understandable: turn judgment into doctrine, and doctrine into execution.

The competent-SWE filter is an anti-bureaucratic device. It prevents every plausible lesson from becoming a prompt line. The pattern-reference bar is another anti-bureaucratic device: if a new pattern cannot name the concern, state the principle, explain why it exists, show an example, and describe when not to apply, it is not a pattern. It belongs in a lint, a runtime assertion, a one-off task, or nowhere.

That last category matters: nowhere.

A mature memory system must be allowed to forget. Not every failure deserves preservation. Not every preserved lesson deserves promotion. Not every promoted lesson deserves prompt space. Not every prompt line deserves permanence.

The SWE Textbook works because it is not the top of the hierarchy. It is a holding area, a compression layer, a publication seed, a place for recognition-shaped knowledge. It lets the system say: this was real; this was too general for always-loaded prompts; this may still be useful later.

The ledger is not a rulebook. A rulebook says: obey these. A ledger says: these are the mistakes we paid for; decide carefully which ones still matter.

## The ledger

The first Furnace article was about capacity: I could sustain one thread, maybe two, and needed infrastructure to widen the pipe. The second was about the layer above issue tracking and agent execution: the human-facing orchestration layer that decides what deserves attention when many things could be delegated.

This third article is about what the furnace produces after it has been running long enough to accumulate mistakes.

Not only code. Not only tasks. Not only prompts.

A ledger.

The agents did not spontaneously write their own culture. I asked for retrospectives. Reviewers caught failures. Mag and worker skills routed suggestions. I decided prompt bloat needed an outlet. The agents wrote many of the entries, but the culture is produced by the loop: human intention, agent work, agent review, deterministic routing, selective memory, human compression.

That is more interesting than saying "AI wrote documentation." It is also more honest.

The ledger records a transitional period: agents powerful enough to do work, articulate enough to diagnose failures, eager enough to over-prescribe prompt additions, and unreliable enough to need review. It records the engineering law that forms around that instability.

The deepest lesson is not any particular testing trick. It is not mutation evidence, PATH shims, config gates, structural payload assertions, or typechecker blind spots. Those matter, but they are examples.

The deeper lesson is this:

The bottleneck is not the agents' ability to learn lessons. The bottleneck is the system's ability to place those lessons correctly.

A bad system forgets.

A worse system remembers everything in the prompt.

A better system routes memory.

A mature system compresses it into culture.

Ludics is not mature. It is an awkward, useful, overbuilt, partially time-bound system running in the fog of a fast-moving tool generation. But in the ledger I can see the outline of something real: a process that turns mistakes into doctrine without letting doctrine consume the process.

The agents were too helpful.

So I gave their helpfulness somewhere else to go.

And now, after enough failures, the furnace has a ledger.
