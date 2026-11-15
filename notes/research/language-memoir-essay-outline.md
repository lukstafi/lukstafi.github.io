# Outline: a memoir of programming languages

Status: outline for review, 15 November 2026. It replaces the 6 November idea of an essay comparing Rust and OCaml and asking for the best possible general-purpose language (see "Superseded" at the end). Sections carry no word budgets; length follows content. Sample sentences show register only.

Three kinds of statement appear below and the draft must keep them apart:

- **Said**: the user's own account, given on 15 November. Quoted where the wording matters.
- **Record**: what surviving files show. Sources are listed under "Evidence".
- **Reading**: Claude's interpretation, not confirmed by the user. Each is marked.

Dates marked "est." are derived from the user's birth date (28 May 1980) and two fixed points (Google internship in summer 2014, Google from October 2015), and are not confirmed.

## Form

- **One essay, a memoir.** User decision: no closing section on the best possible language. The essay judges languages only as the author met them.
- **It opens on the Amiga** (user decision).
- **Organised by time, with the relation to each language as the thing told.** The user's own distinction between *learned* and *used* is kept exactly, and the history adds further relations: built, taught, declined, followed.
- **Agent-written code is outside the history.** Said: "I don't count the code that agents write as languages I use."
- **Covers Lean 4 and Bend at the end** (user decision), as languages the author follows. Koka is out (user decision).
- **The record carries the memoir.** Said: "I have poor autobiographic memory." Much of the dating comes from files recovered on 15 November, and the essay can say so. Reading.
- **Figure (wanted by the author):** one timeline, a row per language, the bar's style showing the relation (on paper, used, taught, declined, followed). matplotlib SVG with a generated dark variant, as in *Every Layer a Store*.
- **Excerpts (proposal):** three or four short ones from surviving files: the Polish header of the breaker firmware in translation, the vector literal from `pa_ode.ml`, the verdict list from the first Pascal lecture, the soundness example `Lec6.java`.

## Title candidates

1. *The Languages That Reached Me* (Claude's pick: it carries the scarcity of the early years and leaves room for the two languages the author chose).
2. *On Paper First*
3. *Learned, Used, Taught, Declined*

Subtitle (Substack), to be tightened: "A memoir of programming languages: the ones I learned on paper, built, taught, declined, and now only follow."

## What the essay shows

A reader should come away with four things, none stated as a thesis up front.

1. **Scarcity shaped what was learned, and abundance has ended "use".** In a village before the internet, a language could be known without being runnable. In 2026 every language is a command away and an agent writes it.
2. **Two languages were chosen and the rest were given.** C++ and OCaml were the author's own choices, each for a stated reason. Pascal came from cousins, HyperCard from school, six languages from teaching, three from an employer. This applies the 6 November test (set aside whatever social whim conditions) to the author's own history. Reading.
3. **The author kept building the language he wanted inside the one he had.** A Prolog of his own design in high school, a type system for Speagram, InvarGenT, OCANNL's syntax and code generators. Reading.
4. **The languages not learned have one thing in common.** Nemerle, Scala, Swift and Rust each carry ML's ideas to a platform or a cost the author did not need. Reading.

## Sections

### §1 The Amiga (est. late 1980s to mid 1990s)

- The first sight of a computer, at five to seven (so 1985–87), on a family visit: an 8-bit machine "rendering ellipses in the envelope of a circle". Said. A candidate first image for the essay.
- Then the cousins, three brothers, one of them an academic with a doctorate in electrical engineering. They had an Amstrad first, then PCs, an XT and an AT. Said. These are the cousins whose Object Pascal comes in §2.
- Before the Amiga: Commodore 64 BASIC with a neighbour, on the neighbour's machine. Said.
- The author's father bought the Amiga. The countryside, before the internet reached it: "very software-starved". Said.
- AMOS BASIC, and three games remembered. Said:
  1. a top-view two-player spaceship shooter;
  2. a single-player game with a pong paddle that also shoots, enemy ships scripted in AMAL, several levels with backgrounds composed by program from hand-made maps;
  3. the scaffolding of a first-person open world with plains, forests and creatures, with scaling and parallax from formulas derived by hand, moving in slideshow steps. Only wandering worked.
- A fourth: noughts-and-crosses in four dimensions, with a plain interface. Said. It is the one AMOS program with a surviving descendant (§4).
- Other AMOS programs. Said: a couple of demos with very basic 3D elements, perhaps an image rendered on a floating square, though not general 3D routines; a simulation of a one-dimensional universe, plus time, with interacting particles; Conway's Life seeded from pictures; a line editor; experiments with the Amiga's voice synthesis library.
- Two of these return in the blog's later subjects: Life is the running example planned for the structural-realism essay, and the one-dimensional universe is a child's version of the physics essays. Reading; use lightly.
- AMAL as the first language inside a language. Reading.
- Motorola assembly: learned, and "above my un-mentored age-capped skill ceiling". Said. A second scarcity, of mentors and not of software. Reading.
- LOGO: learned "in the abstract", never run, and the first of the languages met on paper. Said. The source was Seymour Papert's *Mindstorms*, read in Polish. Said (the author first called it "the accessible Brainstorms book"). The Polish edition came out at the beginning of 1996 and the author probably had it that year, at fifteen or sixteen. Said. So LOGO comes at the end of the Amiga years, after AMOS: the first language met on paper, not the first language. The Polish title (*Burze mózgów*, from Claude's memory) is to be checked.
- The loss: the AMOS code and the graphics are gone. Said: "I'm sad to have lost my resources". The surviving record starts in 2005.

### §2 The PC, the cousins, the school (est. 1996–99)

- The move to a DOS/Windows PC around the second year of high school, give or take a year. Said.- Object Pascal, because the cousins used it. Said. Borland Pascal as the first exposure to objects.
- One of the first things written on the PC in Pascal: a text-mode interface shared by a few toy programs, what would now be called a TUI. Said.
- A short text adventure in DOS batch files. Said.
- School had Macs with HyperCard, "rather unusually"; some HyperTalk for the school lab. Said.
- C++, the first language nobody handed over. Said: learned "quite extensively because I was interested in object-oriented programming starting from my exposure via Borland Pascal, and Bjarne Stroustrup's writing is good". Simula, probably, learned on paper through Stroustrup.
- Languages reaching a reader through prose: LOGO, Simula, Prolog, and Lisp from a book, no later than early university. Reading, on the author's account of each.

### §3 Object Prolog (est. 1998–99)

- Prolog known only from the page; the implementation "is how I got one". Said.
- "Object Prolog was my own idea and design": "a system I designed from scratch built around hierarchical fact stores". Said. So the first language implemented was also the first designed.
- Written in C++. The bugs: "recursive unification of the same relations" and "memory unsafety crashes". Said.
- The second bug is the cost a garbage collector later removed. Reading.
- How objects and logic met: "classes held the clauses". Said.

### §4 Finding ML (est. from 1999)

- At the start of university, before OCaml: a Rubik's cube in four dimensions, "with an animation of folding and unfolding between 4D space projection and 3D layout". Written in C++ with animated wireframe 3D graphics; nothing of it survives. Said.
- The four-dimensional noughts-and-crosses rewritten in OCaml, `ox4d.ml`: 444 lines with a LablTk interface, board sizes and winning length chosen on sliders, a computer opponent, undo, and two modes named "First Blood" and "Mortal Combat". Each cell is a slice of a circle, so the fourth dimension is "folded into a piechart". Said and record. Its style is early: arrays, references, exceptions for control flow. Reading. A comment dated 2007 reads "I've returned this old baby to life, but I don't remember how it works." File dates from the author's Dropbox: `ox4d_v2.ml` March 2003, an autosave January 2005, `ox4d.ml` May 2007. Said. So the author was writing OCaml by March 2003 at the latest, and this is the earliest dated program of his that survives.
- Around early university: a program for the author's mother, for bookkeeping-style work at a large bakery where she worked briefly. Said. In Pascal or C++; the author does not remember which. With the breaker (§5) and the transit editor (§7) it makes a small thread of programs written for someone else's need. Reading.
- The switch from Windows to Linux, in early university. Then an editor of the author's own, written in Tcl/Tk, before he took up Emacs. Said: "Wow, I forgot about that." Tcl is one more language used, and one wholly forgotten: "I don't remember the barest thing about Tcl." Said. A relation of its own, used and lost. Reading.
- Editors recur: the line editor in AMOS, this one, then Emacs and its Lisp, and the VS Code extensions of 2022. And Tk returns as LablTk in `ox4d`. Readings.
- The first Emacs Lisp came some time later, once Emacs was learned, possibly still before OCaml. Said: two fixes to Emacs's built-in calculator, one to its two-dimensional rendering of matrices, one to an algorithm the author no longer remembers. The second was possible "only because it turned out to be the same algorithm as in an old Soviet book I borrowed from the technical university's library". The FSF mailed stickers and a copyright assignment form; the returned form never arrived, so the changes were not merged. Said.
- The Linux switch is also the ground for declining Nemerle later (§8). Reading.
- "I found out ML from scavenging libraries at the university, via interactive theorem provers", probably NuPRL. Said. ML began as a prover's metalanguage, so this retraces its origin. Reading; check the history before stating it.
- OCaml over SML "because of the richer type system (objects and polymorphic variants)". Said. The functional programming course came soon after, alternating OCaml and SML by year; the author had sat in on some of the SML year. Said.
- A course where students proved theorems in HOL Light, which runs in the OCaml toplevel. The author filled in the assignment proofs, about unification. Said and record.
- What became of the reason for choosing OCaml: polymorphic variants earned their place "somewhat"; objects are "a valid design part of OCaml, but I never used them", except perhaps briefly through Pottier's visitors. Said.

### §5 2005–2008: bindings, firmware, a type system

The densest stretch of the record. Four things from three years.

- **OCamlODE (August–November 2005).** OCaml bindings to the Open Dynamics Engine, about 6,000 lines with C stubs. A camlp4 syntax extension for vector and matrix literals. A patch to the engine's C++ source adding hooks for memory management. Record. Earliest surviving case of both the bindings and the syntax extensions that run to OCANNL. Reading.
- **The breaker (listing dated 28 January 2006).** Assembly for an ST6263 microcontroller, 1,072 lines with Polish comments, for the author's father's circuit monitor and breaker. It decides whether a current level has changed by a quantile or median test, or by voting with a quorum, with hysteresis and a latch kept in EEPROM across power loss. Record. It was a product; the author's parents made it by hand for a couple of years; a patent application was refused over prior art registered in India. Said.
- **Speagram (author's commits August–October 2006).** Told at length (user decision). Facts in `speagram-history-2026-11-15.md`:
  - Łukasz Kaiser's project, written in Nemerle from May 2004. Kaiser had collaborated on Nemerle, Michał Moskal's language. Said, and the essay says no more than that about Kaiser and Nemerle (user decision).
  - The author made the case for MetaOCaml to Kaiser before the switch. Said. To be phrased as the author's recollection; the record shows only the dates.
  - Summer 2005: Michał Ryszard Wójcik works on Speagram for Summer of Code, and the code moves to OCaml. Record. His design was "a CFG parser with unification". Said. He is the Michał Wójcik whose monastery dialogue the blog answered. Said.
  - 2006: the author's design note "Speagram with Subtyping and Labels" (27 July) and 62 commits. Types with kinds, variances and labelled rows; a constraint solver. Record. The design used "failure shortcuts via maintaining the lattice solutions (a bit Datalog-style)". Said.
  - Rows were half the reason for choosing OCaml; here the author builds on them. The note is an ancestor of the PhD. Readings.
- **A dance tour (est. 2006).** Said: the author began dancing at 22, with contemporary dance, and took up ballet a year later; about three years after that he went on a dance tour, "woefully unprepared", and with that money bought "the first computer I earned myself". The estimate puts it in the same year as the firmware and Speagram's type system. Background, a clause at most: two years before dance he began physical training, about nine months of Kung-Fu (Long Fist and White Crane) and about two years of Aikido, the second year overlapping with dance. Said. Earlier computers were not bought with his own money; do not place this in high school (Claude's first guess, corrected).
- **Luasteer (2007).** Hand-written Lua bindings for OpenSteer in C++, with Lua scripts for boids and soccer teams. Record.
- **A talk on Coq (early February 2008).** "Coq as a Tutor in Formal Reasoning", given at a students-and-faculty offsite in the mountains of southwest Poland: a prover that guides a learner and suggests the next step. Said and record. Coq was "learned and played with", not used. Said.
- **pmwiki-mode (January–March 2007).** Emacs Lisp. Christian Ridderström wrote the mode in 2003; its header says "Lukasz Stafiniak took over maintenace in 2007 and has partially rewritten `pmwiki-mode' to work on articles on his homepage". Five releases in seven weeks, from 0.3 to 0.5rc2, the main file growing from 1,163 to 3,872 lines: LaTeX preview and code-block submodes, a table of contents and site map, password rules, merging on update clashes, browsing history, a tool bar. Record. The author's homepage and course pages were a PmWiki edited from Emacs. Reading, from the wiki markup in the Java course's reference list.
- PHP, learned because the author was using PmWiki. Said.
- The rest of Lisp: Lisp for Maxima in the second half of the undergraduate years, though not the last; the ACT-R implementation read "sometime later but not long after" (the `deep-schema` notes are from 2013). Said. Both therefore belong before this stretch, in §4.
- Lisp was also studied for itself. Said: "Lisp is bigger than the systems behind it, I also read up on it, no later than early university, from some possibly academic book about it." The author leans toward John Allen's *Anatomy of LISP* (1978) as the book, unconfirmed; no Polish translation was found on 15 November, so it would have been read in English. So it belongs first with the languages met on paper (§2, §4), and the systems came later. Do not present Lisp as only the language of systems the author wanted; that was Claude's reading and the author corrected it.

### §6 The languages teaching gave (est. 2005–2013)

- The PhD years in the author's words: time split about a third each among the thesis, preparing teaching, and the collaboration with Kaiser on Speagram and Toss. Said. The essay does not call these years slow (the author withdrew the word).
- **Toss (author's commits August 2009 – May 2013).** The collaboration third of the PhD years, and the longest OCaml project before OCANNL. Kaiser's system for general game playing and hybrid modelling: games as relational structures, moves as rewriting rules, positions judged by logical formulas. Record, from the project's SourceForge repository (1,937 revisions, 2004–2016): the author's commits run from 27 August 2009 to 24 May 2013. Counts of each contributor's commits and lines are kept privately and are not for the essay. Two papers with Kaiser in 2011: "First-Order Logic with Counting for General Game Playing" (AAAI) and "Translating the Game Description Language to Toss". Said: an equal coauthor on both, for implementation and, in the author's judgment, for concepts. What it adds to a memoir of languages, each a reading on the record:
  - His first commit is "Initial rewrite of Mso.py into OCaml": a Python program carried into OCaml, as tinygrad is now.
  - The 2011 work translates the Game Description Language, a logic-programming language, into Toss's formalism. It continues the line from Object Prolog and the Datalog-style lattice in Speagram.
  - Speagram did not end in 2007. A 2012 commit reads "New Speagram step 4: removing the distinction between terms and types"; its ideas moved into Toss's term module.
  - Keep it to what bears on languages; the research itself is not retold.
- Labs run for other people's courses: neural networks (Matlab, then Octave), data mining (R and Octave, taught side by side in paired columns), evolutionary algorithms (Matlab), and a Haskell lab. Said and record.
- The Haskell lab, 2008 and 2009 (`progTWI`; lecture slides dated March and April 2008, an assignment page headed "Programming 2009"). The author's own part: reference solvers for puzzle assignments (KNetWalk, arrows, nonograms, "Miodowe"), each a few hundred lines, and a shell script that ran every submission against tests with a time limit. The class also wrote compilers. Record. This is six years before the internship, not the three or four the author first recalled.
- Courses owned end to end, design, lectures and labs. Said:
  - Java, winter 2011–12, in English, three or four foreign students. `Lec6.java` teaches overriding by a soundness counterexample. Record.
  - OCaml, lectures written February 2012 to March 2013, in English, as few students. The lectures became *Curious OCaml*.
  - Pascal, est. 2012–13 by the Free Pascal versions it cites: "a real, big hall course", taken on as an emergency for a lecturer on health leave. Said. The first lecture's Good, Meh and Bad list: parameter modes `const`/`out`/`var` and subrange types good; "the programmer must decide about memory management" meh; no `val` and no closures bad. Record. A childhood language re-read by an OCaml programmer. Reading.
- Also in 2012, as a student again: Stanford's online course on probabilistic graphical models, in Octave. Record. The first language to arrive over the internet as a course. Reading.
- The comparative habit: Pascal against Java, OCaml against Haskell, Octave against R. Reading.

### §7 Haskell, then Google (2014–2021)

- Summer 2014, Google internship, all in Haskell: "we used kind polymorphism over algebraic data types". Said. OCaml cannot express that directly; the Rocq-to-Lean essay already says so.
- The cost: "Laziness was a pain because it caused hard to fix bugs in an FFI I needed to write, and also a couple times easier infinite loop bugs." Said. The boundary with foreign code is where the author has worked since 2005. Reading.
- May 2015 to March 2016: the fork `lukstafi/subte`, a Python and GTK editor for transit timetable data. About 45 commits: KML and JSON export of stops, routes and timetables, a small web interface in JavaScript on Google Maps, calendars and exceptions, and a Polish localisation with a Polish manual. Record. So Python and JavaScript were written by hand before Google. For whom it was made is not yet known.
- October 2015: the PhD defence (InvarGenT), then Google.
- C++ for knowledge representation and semantic parsing. What it taught: RAII, and "an interesting LRU cache mechanism for efficiency with safety guarantees". Said. OCaml has no counterpart to RAII. Reading.
- The last year and a half, at Google Brain on reinforcement learning infrastructure: Python, "exclusively and somewhat extensively". Said.

### §8 The languages I did not learn

- Nemerle: "I didn't see the point, being a Linux user and OCaml programmer." Said.
- Scala: never learned. Said. The lectures only cite it.
- Swift: "very disappointed that Swift doesn't have full-fledged pattern matching", after being led to believe it was close to functional programming. Said. What exactly Swift's patterns lack must be checked.
- Rust: "I bounced off Rust but I haven't had any significant incentive to try harder"; "I guess Rust's syntax felt bloated? Not sure." Said. The essay keeps the uncertainty.
- Two readings to offer the author: RAII, the thing valued most in C++, is what Rust enforces; and the fast code in OCANNL is generated, so the host language never needed to do without a garbage collector.

### §9 OCaml again (2022 onward)

- TypeScript for VS Code extensions (`navi-parens`, 2022). OCANNL, sponsored by Ahrefs since April 2024, with bindings for gccjit, CUDA, Metal and HIP, and `ppx_minidebug`.
- What is missed: "type-aware metaprogramming for DSLs". Said. A thread from the MetaOCaml case in 2005 through `pa_ode.ml` to `ppx_minidebug`, which logs type-annotated values because a syntax extension cannot see inferred types. Reading.
- Modular explicits: once thought missing, "but I was overcomplicating the design". Said.

### §10 Agents, and the languages I follow

- Agent-written code is not a language used. Said. The megabytes of Python and shell in the author's recent repositories are therefore outside the history, and "use" has stopped describing how the software gets written. Reading.
- "Even at the very beginning of 2025 agents were very proficient in OCaml, more than they thought." Said.
- "Both agents and humans benefit from strictness and exhaustiveness checks." Said. The same standard that Swift failed. Reading.
- Lean 4, followed for autoformalization and other agentic use. Said. In 2021 the author followed the early work on language models in proof assistants. Said. It joins the 2008 talk and the route into ML through provers. Reading.
- Bend, followed because its author is active, its uses overlap agentic programming, and its ideas connect to what the author studied, such as Girard's linear logic. Said.
- "I'm very curious about formalization that goes beyond this level of guarantees, but not necessarily convinced." Said. A candidate last note.

### Closing

No verdict on a best language (user decision). Candidates, for the author to pick:

1. The lost AMOS disks against the Dropbox archive: what survives of thirty-five years of programs.
2. The sentence on formalization quoted above.
3. Return to the third AMOS game: a world built, with the gameplay never reached.

## Guards

- **Kaiser.** Name him; tell the Speagram history; say he had collaborated on Nemerle. Nothing about his feelings toward Nemerle or Moskal (user decision).
- **The MetaOCaml case.** The author's recollection, phrased as such.
- **Wójcik.** May be named, with the link to the monastery essay.
- **The Haskell fragment** (`EnrichByFraserFreq.hs`) is internship code. Describe the work; do not quote the file.
- **The breaker.** A family story with a refused patent in it. The author has not asked his father and considers it far enough in the past; a word beforehand would be a courtesy.
- **The communion detail** was given only to date the Amiga. The author's call whether it appears.
- **The Haskell lab folder** (`progTWI`) holds about 180 student submissions under the students' names, with grade files and notes on plagiarism. None of that is quoted, named or published; only the author's own solvers and scripts are described.
- **The Coq library and exercises** may be the Papuq authors'. Credit the slides to the author and nothing more unless confirmed.
- **Attribution.** Readings marked above are Claude's. They go into the essay only as the author's own if he adopts them.

## Evidence

- `notes/research/speagram-history-2026-11-15.md`, with the commit log and the 2006 design note beside it.
- SourceForge: `pmwiki-mode`, releases under <https://sourceforge.net/projects/pmwiki-mode/files/pmwiki-mode/> (read 15 November; the repository there stops in 2005, so the 2007 work exists only as release archives).
- GitHub: `Pascal-course` (lecture 1 in English), `curious-ocaml`, `invargent`, `ocannl`, the bindings, `navi-parens`, `deep-schema` (2013, ACT-R).
- Old resources the author fetched into `~/Downloads/` on 15 November, with no durable home yet: `bzu` (firmware), `matlab-BNT`, `BayesNets`, `EA`, `kurs_DM`, `HD_DM`, `luasteer`, `ocamlode`, `hol_seminar`, `IntProv`, `JavaCourse` (code and slides), `PGM`, `ox4d`. A suggestion on which go to GitHub is in the session of 15 November and in the essay-queue memory.
- Published essays to link, not retell: *Dependent Types from Rocq to Lean 4*; *How LLMs Could Place Explicit Memories* (the 2021 reading group); *The Bookmaker Is a Learner* (teaching at Wrocław); the monastery essay (Wójcik).

## Open questions for the author

1. Title and closing: the candidates above.
2. (Answered: in Object Prolog, classes held the clauses.)
3. (Answered: Haskell lab 2008–09; Maxima in the later undergraduate years; ACT-R soon after.) Corrections to any "est." date still welcome.
4. (Answered: §5 on Speagram's type system "can be technical with details shown".)
5. (Answered: the timeline figure is wanted.) The short excerpts from surviving files are still a proposal.
6. (Answered: ignore the word "slow". The essay states the durations and the three-way split of time, with no judgment on them.)
7. (Answered: Toss gets its own passage in §6, limited to what bears on languages.) Which venue published the GDL translation paper, and is the split of credit to be stated or left as coauthorship?
8. (Answered: `ox4d` existed in OCaml by March 2003.)
9. The transit editor: for whom, and was it used?

## Before drafting

- Check outside facts the readings lean on: Swift's pattern matching today; Rust 1.0's date; Nemerle's authors and origin at Wrocław; ML as LCF's metalanguage and NuPRL's use of it; that HOL Light runs in the OCaml toplevel; AMAL; the state of modular explicits in OCaml; Lean 4's metaprogramming; Bend as described on 6 November (it had changed since Bend 1).
- Give the old resources a durable home, at least the ones the essay links.
- Commit the Speagram files in `notes/research/`.

## Superseded

From the 6 November plan, no longer part of this essay: the Rust and OCaml comparison as the frame; the question of the best possible general-purpose language; the roster as a design survey (Koka dropped, Haskell no longer a foil but a language the author worked in); the candidate spine on how pure semantics and in-place mutation meet; the idea of an original measurement. The 6 November test survives in one use only, applied to the author's own choices.
