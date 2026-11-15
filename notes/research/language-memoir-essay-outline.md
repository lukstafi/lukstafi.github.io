# Outline: a memoir of programming languages

Status: outline of 15 November 2026. **First draft written the same day as `notes/programmer-a-memoir.md`** (about 4,400 words), with the lightly edited prompts page `notes/programmer-a-memoir.prompts.md` and Figure 1 from `scripts/figures/programmer_a_memoir.py`. Uncommitted, no index entry. The outside facts listed under "Before drafting" were checked on 15 November and the draft follows the check. The draft uses several of the readings below in the author's voice; they still need his adoption (see the essay-queue memory for the list). It replaces the 6 November idea of an essay comparing Rust and OCaml and asking for the best possible general-purpose language (see "Superseded" at the end). Sections carry no word budgets; length follows content. Sample sentences show register only.

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

Working title, the author's: *Programmer: A Memoir*. He found Claude's three candidates unconvincing (*The Languages That Reached Me*, *On Paper First*, *Learned, Used, Taught, Declined*) and prefers a bland title, while staying open to other suggestions. Alternatives in the same register, offered 15 November: *A Programmer's Memoir*; *Programs and Languages: A Memoir*; *Forty Years of Programs*.

The title widens the subject from languages to the programs and the life around them, which matches the material gathered. Languages stay as the thread through it, and the subtitle can carry them.

Subtitle (Substack), to be tightened: "The languages I learned on paper, built, taught, declined, and now only follow."

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
- **The breaker (listing dated 28 January 2006).** Assembly for an ST6263 microcontroller, 1,072 lines with Polish comments, for the author's father's circuit monitor and breaker. The firmware is the joint work of the author and his father, Piotr Stafiniak, and is published with both as copyright holders at <https://github.com/lukstafi/early-work/tree/main/bzu>. Said. It decides whether a current level has changed by a quantile or median test, or by voting with a quorum, with hysteresis and a latch kept in EEPROM across power loss. Record. It was a product; the author's parents made it by hand for a couple of years; a patent application was refused over prior art registered in India. Said.
- **Speagram (author's commits August–October 2006).** Told at length (user decision). Facts in `speagram-history-2026-11-15.md`:
  - Łukasz Kaiser's project, written in Nemerle from May 2004. Kaiser had collaborated on Nemerle, Michał Moskal's language. Said, and the essay says no more than that about Kaiser and Nemerle (user decision).
  - The author made the case for MetaOCaml to Kaiser before the switch. Said. To be phrased as the author's recollection; the record shows only the dates.
  - Summer 2005: Michał Ryszard Wójcik works on Speagram for Summer of Code, and the code moves to OCaml. Record. His design was "a CFG parser with unification". Said. He is the Michał Wójcik whose monastery dialogue the blog answered. Said.
  - 2006: the author's design note "Speagram with Subtyping and Labels" (27 July) and 62 commits. Types with kinds, variances and labelled rows; a constraint solver. Record. The design used "failure shortcuts via maintaining the lattice solutions (a bit Datalog-style)". Said.
  - Rows were half the reason for choosing OCaml; here the author builds on them. The note is an ancestor of the PhD. Readings.
- **A dance tour (est. 2006).** Said: the author began dancing at 22, with contemporary dance, and took up ballet a year later; about three years after that he went on a dance tour, "woefully unprepared", and with that money bought "the first computer I earned myself". The estimate puts it in the same year as the firmware and Speagram's type system. Background, a clause at most: two years before dance he began physical training, about nine months of Kung-Fu (Long Fist and White Crane) and about two years of Aikido, the second year overlapping with dance. Said. Earlier computers were not bought with his own money; do not place this in high school (Claude's first guess, corrected).
- **Luasteer (2007).** Hand-written Lua bindings for OpenSteer in C++, with Lua scripts for boids and soccer teams. Record. The author did not remember why; the record answers it:
  - It was made for a course on intelligent agents. The author's old wiki has a group "Agents" ("Sztuczna Inteligencja: inteligentni agenci") with a reading list, a page of project proposals that asks students to program formations of boids in OpenSteer, and a page of install instructions for `luasteer.tar.gz`. So Lua was the language in which students would script agents. Record (Wayback Machine, capture of 22 March 2009); the last step is a reading.
  - On 14 March 2007 the author announced the bindings on the OpenSteer forum and offered them to the project. Craig Reynolds answered the same day and again on 23 March, saying a policy on language bindings was being discussed. On 2 January 2010 Reynolds added: "This effort by Lukasz is another example of a contribution to OpenSteer which I never followed up on." Record: <https://sourceforge.net/p/opensteer/discussion/264792/thread/e9110c6f/>. The author had forgotten the exchange.
  - In that thread, 18 March 2007: "My opinion is that 'C++ templates suck' and 'SML / OCaml functors rulez', but take no offence please :)". Record. Compare the Pascal lecture's two-sided verdict on templates (§6).
  - Said: the author was "sympathetic to Lua, unlike Python at the time".
  - The dates overlap the pmwiki-mode releases: the mode was being rewritten while it was used to write these wiki pages. Reading.
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
  - Speagram did not end in 2007. A 2012 commit reads "New Speagram step 4: removing the distinction between terms and types". Said, correcting Claude: bringing Speagram into Toss was Kaiser's idea; it was never integrated as he intended and stayed its own thing; Toss proper is separate from its Speagram subdirectory, which continues the original project. Do not write that Speagram's ideas "moved into" Toss.
  - Keep it to what bears on languages; the research itself is not retold.
- Labs run for other people's courses: neural networks (Matlab, then Octave), data mining (R and Octave, taught side by side in paired columns), evolutionary algorithms (Matlab), and a Haskell lab. Said and record.
- The Haskell lab, 2008 and 2009 (`progTWI`; lecture slides dated March and April 2008, an assignment page headed "Programming 2009"). The author's own part: reference solvers for puzzle assignments (KNetWalk, arrows, nonograms, "Miodowe"), each a few hundred lines. A shell script in the folder ran every submission against tests with a time limit; the author is not sure whether he wrote it or inherited it, so the essay does not mention it. The class also wrote compilers. Record. This is six years before the internship, not the three or four the author first recalled.
- Courses owned end to end, design, lectures and labs. Said:
  - Java, winter 2011–12, in English, three or four foreign students. `Lec6.java` teaches overriding by a soundness counterexample. Record. The course's running example looks to be a Settlers-style simulation, the package `settlers`: thirteen classes and about 1,100 lines, with castles, warehouses, flags, roads, carriers and a scheduler, set up from a text file, saved by serialization, and with a Swing interface begun; three successive jars from November 2011. Record; that it is the author's own is to be confirmed. The Settlers was an Amiga game. Reading.
  - OCaml, lectures written February 2012 to March 2013, in English, as few students. The lectures became *Curious OCaml*.
  - Pascal, est. 2012–13 by the Free Pascal versions it cites: "a real, big hall course", taken on as an emergency for a lecturer on health leave. Said. The first lecture's Good, Meh and Bad list: parameter modes `const`/`out`/`var` and subrange types good; "the programmer must decide about memory management" meh; no `val` and no closures bad. Record. A childhood language re-read by an OCaml programmer. Reading.
- Also in 2012, as a student again: Stanford's online course on probabilistic graphical models, in Octave. Record. The first language to arrive over the internet as a course. Reading.
- The comparative habit: Pascal against Java, OCaml against Haskell, Octave against R. Reading.

### §7 Haskell, then Google (2014–2021)

- Summer 2014, Google internship, all in Haskell: "we used kind polymorphism over algebraic data types". Said. OCaml cannot express that directly; the Rocq-to-Lean essay already says so.
- The cost: "Laziness was a pain because it caused hard to fix bugs in an FFI I needed to write, and also a couple times easier infinite loop bugs." Said. The boundary with foreign code is where the author has worked since 2005. Reading.
- May 2015 to March 2016: the fork `lukstafi/subte`, a Python and GTK editor for transit timetable data. About 45 commits: KML and JSON export of stops, routes and timetables, a small web interface in JavaScript on Google Maps, calendars and exceptions, and a Polish localisation with a Polish manual. Record. So Python and JavaScript were written by hand before Google. Said: it was for a small town or municipality near where the author grew up. The data entry and the generation of static pages were used; the map part was not, because the town's IT technician could not set up a Google Maps provider or an OpenStreetMap server.
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
- **The breaker.** The author's father agreed on 15 November to the firmware being published, and it is credited to both of them. That agreement covers the code. The family story around it, the product and the refused patent, is still the author's to judge for the essay.
- **The communion detail** was given only to date the Amiga. The author's call whether it appears.
- **The Haskell lab folder** (`progTWI`) holds about 180 student submissions under the students' names, with grade files and notes on plagiarism. None of that is quoted, named or published; only the author's own solvers and scripts are described.
- **The Coq library and exercises** are not the author's. His old homepage lists the talk with "exemplary exercises from the Warsaw University Institute of Informatics". Credit only the slides to him.
- **Attribution.** Readings marked above are Claude's. They go into the essay only as the author's own if he adopts them.

## Evidence

- `notes/research/speagram-history-2026-11-15.md`, with the commit log and the 2006 design note beside it.
- **The author's old university wiki, in the Wayback Machine** (found 15 November): `http://web.archive.org/web/2009*/ii.uni.wroc.pl/~lukstafi/pmwiki/*`, captures from 2007 to 2022. Groups: Agents (with AGI, BeliefLogics, DecisionAndControl, JADE, MarketMechanisms, NLU, OpenSteer, TouringMachines, VR, project proposals), AGI (with GGP), AGT, Animation, DataMining, EAs, Emacs (Fastfiles, Pmwiki-mode, Sndring, Texmacs-highlight), Functional, Infer (with Synthesis), Java, Linux. The home page lists slide decks: the two Coq talks, "Some ideas on Evolutionary Algorithms", "Agents, Cognitive Architectures and Artificial General Intelligence Projects", "Multiagent Reinforcement Learning", "Dependency Parsing and beyond". Only the home page, the Agents overview, the OpenSteer page and the project proposals have been read. Pages named "Punkty" hold students' points and are not to be read or used.
- SourceForge: `pmwiki-mode`, releases under <https://sourceforge.net/projects/pmwiki-mode/files/pmwiki-mode/> (read 15 November; the repository there stops in 2005, so the 2007 work exists only as release archives).
- GitHub: `Pascal-course` (lecture 1 in English), `curious-ocaml`, `invargent`, `ocannl`, the bindings, `navi-parens`, `deep-schema` (2013, ACT-R).
- Old resources the author fetched into `~/Downloads/` on 15 November, with no durable home yet: `bzu` (firmware), `matlab-BNT`, `BayesNets`, `EA`, `kurs_DM`, `HD_DM`, `luasteer`, `ocamlode`, `hol_seminar`, `IntProv`, `JavaCourse` (code and slides), `PGM`, `ox4d`. A suggestion on which go to GitHub is in the session of 15 November and in the essay-queue memory.
- Published essays to link, not retell: *Dependent Types from Rocq to Lean 4*; *How LLMs Could Place Explicit Memories* (the 2021 reading group); *The Bookmaker Is a Learner* (teaching at Wrocław); the monastery essay (Wójcik).

## Open questions for the author

1. Title: *Programmer: A Memoir* unless a better one turns up. Closing: the candidates above.
2. (Answered: in Object Prolog, classes held the clauses.)
3. (Answered: Haskell lab 2008–09; Maxima in the later undergraduate years; ACT-R soon after.) Corrections to any "est." date still welcome.
4. (Answered: §5 on Speagram's type system "can be technical with details shown".)
5. (Answered: the timeline figure is wanted.) The short excerpts from surviving files are still a proposal.
6. (Answered: ignore the word "slow". The essay states the durations and the three-way split of time, with no judgment on them.)
7. (Answered: Toss gets its own passage in §6, limited to what bears on languages.) Which venue published the GDL translation paper, and is the split of credit to be stated or left as coauthorship?
8. (Answered: `ox4d` existed in OCaml by March 2003.)
9. (Answered: the transit editor was for a municipality near the author's home town, and was used in part.)

## Before drafting

- Check outside facts the readings lean on: Swift's pattern matching today; Rust 1.0's date; Nemerle's authors and origin at Wrocław; ML as LCF's metalanguage and NuPRL's use of it; that HOL Light runs in the OCaml toplevel; AMAL; the state of modular explicits in OCaml; Lean 4's metaprogramming; Bend as described on 6 November (it had changed since Bend 1).
- (Done: the old resources that could be published are at <https://github.com/lukstafi/early-work>, public since 15 November. The Speagram files are committed.)

## Ideas after the first draft (author, 15 November)

The author withdrew "final" from the editorial pass and raised three additions. None is written yet.

1. **A golden age for learning to program.** Said: "One faced the computer, in the 8-bit era, responding with a programming prompt. And a language like AMOS was very kid-friendly." Said further: what made AMOS friendly was "the direct mode (nowadays called REPL but with graphics integrated), commands for sprites and sound"; the Amiga itself had "no prompt", and "the distributed Basic was not kids friendly, so it took some time until I discovered AMOS". Written into the draft the same day, in the opening and the Amiga section. Fits the opening and the Amiga section. It sits beside the scarcity told there and does not contradict it: there was little software, and the machine itself invited programming.
2. **More colour on the early OCaml community.** Searched 15 November with the author's go-ahead. Found so far, on mail-archive.com (`caml-list@yquem.inria.fr` and `caml-list@inria.fr`), 39 posts by the author from July 2008 to March 2012, among them:
   - Aug 2008, "Why is this coercion necessary?": "OCaml doesn't have inference for subtyping, using unification with row variables gives the intersection behavior", then "just write a syntax extension in camlp4".
   - Apr 2009, "OCaml and Boehm", a thread he started: whether OCaml's runtime can run alongside the Boehm collector, so as to call OCaml from a C++ program collected by Boehm.
   - Oct 2009, "forbidden construct as right hand side of let rec": a question of his answered by Xavier Leroy.
   - Nov 2009, "Unboxed float tuples": suggests a syntax extension turning `(| a, b, c |)` into a record, the device of his 2005 `pa_ode.ml`.
   - Sep 2010, replying to "MetaOCaml lives!": asks how native-code BER MetaOCaml is going.
   - Dec 2010, "GADT constructor syntax": six posts in Jacques Le Normand's discussion of the syntax for OCaml's GADT branch, arguing that a type variable local to a constructor should be quantified explicitly.
   - Mar 2012: threads on association lists (after Xavier Leroy), covariant immutable arrays, and mutable or inline records in variants.
   Posts before mid-2008 are not on that site. INRIA's own archive lists authors only in its thread indexes, which survive in the Wayback Machine; September 2005 shows a thread he started, "Existential types". Fetched later the same day from the Wayback Machine (`web.archive.org/web/2021id_/https://caml.inria.fr/pub/ml-archives/caml-list/YYYY/MM/threads.en.html`; message bodies are live at `caml.inria.fr/pub/ml-archives/caml-list/YYYY/MM/<hash>.xml`). The archive throttles, so these months are still missing: December 2004 to July 2005, February 2006 to November 2007, May to July 2008. Found in the months held:
   - 21 Jul 2003, the author's first post: proposes a binary interface between Caml and Emacs Lisp.
   - 23 Jul 2003, "Caml Machine and GP": "I work on genetic programming with typed terms. I would like to use OCaml bytecode-system to run my programs." Xavier Leroy replies on 25 July with two approaches, the second being MetaOCaml.
   - 26–27 Jul 2003, "Dependent OCaml": asks whether there will ever be one, then "I need more polymorphism: type arguments", then "I've reflected types in terms in OCaml. It shows that I need to learn a lot before I can reasonably speak about type theory."
   - 24–25 Aug 2003, "Polymorphic recursion": Jacques Garrigue explains the error, finds the type checker "overly restrictive", and writes the same day that it is fixed in CVS.
   - 1 Sep 2003, "Let-in vs beta-redex": replies from Michał Moskal and John Gerard Malecki. Sep 2003: "Polymorphic class recursion", answered by Garrigue.
   - Aug–Nov 2005, while writing OCamlODE: threads he started on a local `open` (reply from Richard Jones), lablGL, "Porting libraries to OCaml", "Existential types" (Garrigue), "Registering global roots", "Records misbehaviour" (Rossberg, Garrigue), the typing of `;`; and a reply in a thread on custom blocks with Damien Doligez.
   - Jan and Mar 2008: posts in "Why is ocaml so big?" and in the "Batteries included" discussion.
   Said by the author, 15 November: "I think Rudi Grinberg was fond of my GADT related work, and more recently (a couple years ago) he noted my activity around Dune." Not in the draft; it is a recollection about another person's regard.
   Written into the draft: one passage on July–August 2003 in "Libraries".
3. **The OCaml community and LLMs.** Said: "The general community is between skeptical and hostile, while the companies like my sponsor Ahrefs and especially JaneStreet are embracing them." Fits "What I write now". It makes claims about other people and about the author's sponsor, so it needs sources, and it should stay with what the author has seen first-hand. The author supplied four forum threads, read 15 November:
   - "Rejecting AI-generated code" (15 Jul 2026, 34 posts): asks whether OCaml will join the projects that reject such code. Replies are civil and mostly wary: one maintainer has no plans to use LLMs; a compiler maintainer does not use them and will not support a ban, and points to the compiler's `AI.md`; others object on copyright and environmental grounds. The author labelled it "rather negative".
   - "Opam repository package contributors should have a human behind them" (21 Aug 2026): new guidance that pull requests may come from bots but need a human contact, and that machine-generated comments be marked. "Neutral".
   - "Is ocaml.org slop now?" (30 Sep 2026, 24 posts): a tutorial carries a note that it was written with AI assistance; the site's team says 12 to 15 per cent of it is generated and reviewed; the most liked reply is an "emphatic NO" to LLMs as writers. "Negative".
   - "OCaml Compiler Implemented in C++" (1 Oct 2026, 12 posts): an AI-assisted reimplementation offered for double-compiling; met with technical interest. "More positive".
   The author posted in none of them. None contains a statement by Ahrefs or Jane Street, so "the companies have taken the tools up" rests on the author's own knowledge. For Jane Street the author then supplied a source, read 15 November: *Signals and Threads* episode 31, "The Changing Craft of Programming", 16 October 2026, Ron Minsky with John Crepezzi (<https://signalsandthreads.com/the-changing-craft-of-programming/>). Its blurb speaks of "a firmwide platform for agentic coding"; Crepezzi says "It's something like 45% of the total released features, PRs that get made at the firm start with this flow, this kind of asynchronous flow involving an LLM"; Minsky says "the whole existence of AI agents has kind of broken the social contract around code review". Ahrefs still rests on the author's knowledge. Written into the draft as one paragraph in "What I write now", linking the first and third threads and naming no participant.

Also confirmed: the author ran the Linux lab and "prepared the exercises fully myself". Restored to the draft as one sentence.

## The prompts file

Author's instruction, 15 November: the prompts file for this essay is "lightly edited for overly personal info". The other essays' prompts files give the prompts as written; this one is the exception, because the prompts carry much more of the author's life than the essay will.

Claude's proposal for what the light edit removes or softens, for the author to confirm when the file is written:

- The birth date and the church detail, both given only for dating.
- What was said about other people's feelings, health or skill: Kaiser and Nemerle, the lecturer on leave, the town's technician.
- Family particulars beyond what the essay itself uses: the patent, the bakery.
- The author's remarks on his own career that he then withdrew.
- Anything about the student submissions.

Everything else stays in the author's words, including corrections of Claude and the false starts.

## Superseded

From the 6 November plan, no longer part of this essay: the Rust and OCaml comparison as the frame; the question of the best possible general-purpose language; the roster as a design survey (Koka dropped, Haskell no longer a foil but a language the author worked in); the candidate spine on how pure semantics and in-place mutation meet; the idea of an original measurement. The 6 November test survives in one use only, applied to the author's own choices.
