---
title: "Programmer: A Memoir"
subtitle: "The languages I learned on paper, built, taught, declined, and now only follow"
author: "Łukasz Stafiniak and Claude (Anthropic)"
date: 2026-11-16
header-includes:
  - |
    <style>
    .katex-display { overflow-x: auto; overflow-y: hidden; padding: 0.3em 0; }
    .katex-display > .katex { width: max-content; min-width: 100%; }
    article table { display: block; max-width: 100%; overflow-x: auto; }
    </style>
---

The first computer I saw was drawing ellipses. I was between five and seven, on a family visit, and an 8-bit machine was laying one ellipse over another until together they filled out a circle.

After that, computers reached me through my cousins. They were three brothers, one of them an academic with a doctorate in electrical engineering. They had an Amstrad first and then PCs, an XT and later an AT. A neighbour had a Commodore 64, and he and I wrote BASIC on it. A machine of that kind answered whoever switched it on with a prompt, and the prompt was a programming language. I think those were the best years there have been for learning to program.

I have a poor memory for my own life. Much of what follows I had forgotten until November 2026, when I went through an old Dropbox folder, a few SourceForge projects and the Wayback Machine's copy of my university wiki. Several things I thought I remembered turned out to be wrong. Where a year is a guess I say so, and nearly every year before 2003 is a guess.

Figure 1 lays the languages out by year. Some I used and some I taught. Others I knew only from reading, or follow from a distance, or passed over.

![Figure 1. The languages by year. A blue bar is a stretch in which I used a language and an orange bar one in which I taught it. A hatched bar marks a language I knew only from reading, a dotted line one I follow without writing, and a cross the year a language appeared that I did not take up. Years in the shaded part are estimates; from 2003 they rest on dated files.](images/programmer-memoir-timeline.svg)

## The Amiga

My father bought an Amiga. We lived in the countryside, the internet had not reached us, and I had very little software. The Amiga did not greet its owner with a prompt, and the BASIC that came with it was no language for a child, so it took me some time to find AMOS. AMOS was a BASIC made for writing games. It had commands for sprites and for sound, and a direct mode in which a line ran as soon as it was typed, on the same screen as the graphics. Today that would be called a REPL. For years I programmed in little else.

I remember four games. The first was a spaceship shooter for two players, seen from above. The second was for one player: a paddle as in Pong, except that it also fired at enemy ships. The ships' behaviour was scripted in AMAL, a small animation language that runs alongside an AMOS program, and the levels had backgrounds that the program composed from maps I drew by hand. The third was the scaffolding of an open world seen in the first person, with plains, forests and creatures. I worked out the formulas for scaling and parallax myself, and the view moved in steps, like a slide show. I never got to the gameplay, so all one could do was wander. The fourth was noughts-and-crosses on a four-dimensional board.

There were other programs. I wrote a simulation of a universe with one dimension of space, in which particles interacted. I wrote Conway's Life, seeded from pictures. I wrote a line editor, a couple of demos, one of which I think drew an image on a floating square, and experiments with the Amiga's speech synthesizer.

I also learned 68000 assembly, and could do nothing useful with it. It was above the ceiling of what I could manage at that age with nobody to ask. So there were two kinds of scarcity, of software and of people who knew more than I did, and the second was the one that stopped me.

None of the AMOS code survives, and none of the graphics I drew for the games. I am sorry to have lost them.

## On paper

At the beginning of 1996 Seymour Papert's *Mindstorms* came out in Polish. It is a book about children who learn mathematics by programming a turtle in LOGO, and I learned LOGO from it. I had no LOGO to run, then or later.

LOGO was the first of several languages I knew from reading before I could run them, or without ever running them.

Around 1996 or 1997, in what I think was my second year of high school, I moved from the Amiga to a PC running DOS and Windows, and I took up Object Pascal because my cousins used it. One of the first things I wrote was a text-mode windowed interface shared by a few toy programs. I also wrote a short text adventure in DOS batch files. At school, unusually, the lab had Macintoshes with HyperCard, and I wrote some HyperTalk there.

Then I chose a language for the first time. Borland's Pascal had shown me objects, I wanted more of them, and Bjarne Stroustrup writes well. I learned C++ thoroughly. From Stroustrup I also picked up a little of an older object-oriented language, I think Simula, from which C++ took its classes. I never ran it.

Prolog I knew from reading as well. At the end of high school I designed a language of my own around it, which I called Object Prolog. It was built on hierarchical stores of facts, and its classes held the clauses. I implemented it in C++, because that was the only way I was going to get a Prolog to run. The implementation had two kinds of bug. One was in unification, when it recursed through the same relations. The other was crashes from unsafe use of memory.

## Libraries

I began university at the turn of the century. Early on I wrote a Rubik's cube in four dimensions, in C++, with animated wireframe graphics that folded and unfolded the cube between a projection of four-dimensional space and a three-dimensional layout. Nothing of it survives either.

At some point I wrote a program for my mother, for bookkeeping at a large bakery where she worked for a while. I cannot date it. It was in Pascal or in C++, I do not remember which, so it was probably before I had OCaml.

I switched from Windows to Linux. My first editor there was one I wrote myself in Tcl/Tk. I had forgotten that it existed until I was working out the order of these years for this essay, and I do not remember the barest thing about Tcl.

Then I learned Emacs, and found two bugs in its built-in calculator. One was in the two-dimensional display of matrices. The other was in an algorithm, I no longer know which, and I could fix it only because I recognized the algorithm from an old Soviet book I had borrowed from the technical university's library. The Free Software Foundation mailed me stickers and a form assigning them the copyright. I mailed the form back. It never arrived, and the fixes were never merged.

Libraries were where I found languages too. I read a book about Lisp, probably John Allen's *Anatomy of LISP*. I used Lisp in Emacs and in the computer algebra system Maxima, and later read the Lisp source of the cognitive architecture ACT-R.

I found ML by way of interactive theorem provers, probably NuPRL, in which ML is the language one writes proof tactics in. Between the two MLs I picked OCaml over Standard ML for its richer type system: it had objects and polymorphic variants. Soon afterwards the department's functional programming course arrived at the same language. The course alternated between Standard ML and OCaml by year, and I had sat in on some of the Standard ML year before taking the OCaml one. Much later, another course had us prove theorems about unification in HOL Light, a prover one drives from the OCaml prompt.

The objects were half my reason for choosing OCaml, and I have never used them. I still think they are a sound part of the language's design. Polymorphic variants have earned their place in my code.

In July 2003 I wrote to the Caml mailing list for the first time. I was doing genetic programming with typed terms, a subject I have come back to in [*What Should a Program Inherit?*](what-should-a-program-inherit.html), and I wanted to run the evolved programs on OCaml's bytecode machine. Xavier Leroy answered. The second of his two suggestions was MetaOCaml. Three days after my question I was asking the list whether there would ever be a Dependent OCaml, and the day after that I wrote back:

> I've reflected types in terms in OCaml. It shows that I need to learn a lot before I can reasonably speak about type theory.

A month later I asked about polymorphic recursion. Jacques Garrigue explained the error the next day, found that the type checker was stricter than it needed to be, and wrote again that day to say it was fixed.

The earliest program of mine that survives is from these years. It is the four-dimensional noughts-and-crosses, rewritten in OCaml, in a file dated March 2003. Each cell of the board is a slice of a circle, so that the fourth dimension is folded into a pie chart. There are sliders for the size of the board, a computer opponent, and two modes called First Blood and Mortal Combat. I revived it in 2007 and added a comment at the top:

```ocaml
(* Comment 2007: I've returned this old baby to life, but I don't
   remember how it works. ;-) *)
```

## Three years

The folder I recovered is densest between 2005 and 2008.

In the autumn of 2005 I wrote OCamlODE, a set of OCaml bindings for the Open Dynamics Engine, a physics library for rigid bodies. It came with a syntax extension, so that `{|a; b; c|}` in a program stood for a vector, and with a patch to the engine's C++ source, adding hooks so that the engine and OCaml's garbage collector could keep track of each other's objects. My wiki from those years has a page planning a system for posing and animating several characters at once, to be written in OCaml. It calls the system "a looong overdue project". I never built it.

That winter my father and I wrote the firmware for a device of his, a monitor and breaker for electrical safety circuits. It runs on an ST6263, an 8-bit microcontroller, and it is about a thousand lines of assembly with comments in Polish. The assembler's listing is dated 28 January 2006. The device measures a current and shows its level on a row of lights. While all is well it holds a relay closed, and when the current stays at the fault level for long enough it releases the relay. A fault can be latched in memory that survives a loss of power. The source can be assembled with any of three ways of deciding that the level has really changed, and its header describes the first of them in the language of statistics. In translation:

> (0) quantile test (hypothesis: the level has changed; a quantile test of order INERTIA/PERIOD; a median test when PERIOD = 2*INERTIA)

My parents built the devices by hand and sold them for a couple of years. My father applied for a patent, which was refused over prior art registered in India. With his agreement the firmware is now [public](https://github.com/lukstafi/early-work/tree/main/bzu), under both our names.

I had started dancing at twenty-two, first contemporary dance and a year later ballet. About three years after that, which puts it close to the firmware, I went on a dance tour, woefully unprepared. With the money I bought the first computer I had earned myself.

At the start of 2007 I took over an Emacs mode for editing pages of a PmWiki wiki, written by Christian Ridderström, and rewrote much of it so that I could write my homepage from Emacs. I released it five times in seven weeks, and the main file grew from about 1,200 lines to about 3,900. I learned some PHP on the way, since PmWiki is written in it.

In March 2007 I wrote Lua bindings for OpenSteer, Craig Reynolds's library of steering behaviours, the descendant of his boids. I could not remember why until I found the wiki pages. They belong to a course on intelligent agents whose projects had students arrange boids into formations, and with the bindings a student could write an agent's behaviour as a Lua script and leave the C++ alone. I liked Lua then, as I did not like Python. I announced the bindings on the OpenSteer forum and offered them to the project. In the same thread I gave my view of how the library was put together:

> My opinion is that "C++ templates suck" and "SML / OCaml functors rulez", but take no offence please :).

Reynolds replied twice, kindly. The second time he said the project was working out its policy on language bindings. I had forgotten the whole exchange.

In February 2008, at an offsite for students and faculty in the mountains, I gave a talk called "Coq as a Tutor in Formal Reasoning". It was about the mistakes students make in proofs, and about an assistant inside the prover that proposes the next step. I had learned Coq and played with it. I never built anything in it.

## Speagram

Speagram was Łukasz Kaiser's project, and it took up the summer of 2006 for me. It was a language whose syntax its users defined as they went, so that a program could read like sentences in a notation of one's own.

Its repository begins in May 2004, in Nemerle, a language for .NET that had come out of our own institute and to which Kaiser had contributed. As I remember it, I argued for OCaml, and he liked MetaOCaml, which I had pointed out to him and in which a program can build and run typed code for a later stage. In the summer of 2005 Speagram moved to OCaml. Michał Ryszard Wójcik worked on it that summer, for Google's Summer of Code, and his parser was a context-free one with unification. Readers of this blog have met him: he is the Michał Wójcik whose dialogue I answered in [*Is the Monastery Minded?*](is-the-monastery-minded.html).

My part came a year later. I wrote a design note, dated 27 July 2006, called "Speagram with Subtyping and Labels", and between August and October I made some sixty commits putting it into the code.

In the note, a type is a record of labelled components. Each label has a kind, and each kind has a finite lattice of symbols, so that for instance `int` lies below `real`. A label is also covariant or contravariant. One type is a subtype of another when their components compare label by label, each in the direction its label's variance says. A type term may leave labels out, and an omitted label counts as the top of its lattice if it is covariant and the bottom if it is contravariant:

$$\tau ::= \alpha \mid s \mid \{l_1 \sim \tau_1, \ldots, l_n \sim \tau_n\}$$

Constraints are inequalities between type terms. An inequality may be restricted to a set $L$ of labels, and it may be conditional, holding only if given symbols lie below given terms:

$$C ::= \tau \le \tau \;\mid\; L\colon \tau \le \tau \;\mid\; s_1 \le \tau_1 \wedge \cdots \wedge s_n \le \tau_n \;?\; \tau \le \tau \;\mid\; C \wedge C \;\mid\; \exists \alpha.\, C \;\mid\; \mathbf{true} \;\mid\; \mathbf{false}$$

To decide whether a constraint can be satisfied, the solver computes its closure. It adds every consequence that a dozen rules allow, transitivity among them, and the constraint is unsatisfiable exactly when $\mathbf{false}$ turns up.

The closure is what the parser runs on. Every piece of syntax a user defines becomes a grammar rule that carries a type and a constraint, and a rule may be applied only if adding its constraint to the context leaves the closure free of $\mathbf{false}$. Type inference therefore happens during parsing, and a reading of a sentence that cannot be typed is dropped at the word where it fails. Where the earlier parser unified, mine kept the solutions in the lattice up to date as it went, and cut a reading short as soon as it failed.

The note has a section on how the system differs from François Pottier's rows and another on Fritz Henglein's polymorphic subtyping. It states a proposition relating parse trees to typing derivations and then says of it:

> is actually false, although not far from truth.

Rows were what had drawn me to OCaml, where they lie under both objects and polymorphic variants. Here I was building a type system on them, and solving constraints to infer types, which is what my doctoral thesis did later.

I had pitched the idea of the thesis when I applied for the doctorate, and I stayed with it until it worked. I began in 2005. For the first years I was busy with other things, studying among them, and the earliest version of the thesis software that I still have is from 2007 and 2008. It is called HMG(arith): type inference for generalized algebraic data types, with arithmetic on natural numbers where Speagram had lattices. It is nearly ten thousand lines of OCaml, and its list of plans includes a "domain of lattices".

## Toss

Speagram did not stop there. It was Kaiser's idea to bring it into Toss, his next system. It was never integrated in the way he intended. It stayed its own thing, in a directory of the Toss repository that continues the original project, and a commit of mine there from 2012 still reads "New Speagram step 4: removing the distinction between terms and types".

I worked on Toss itself from August 2009 to May 2013. It was a program for defining and playing games. A game was a relational structure, a move was a rule that rewrote the structure, and positions were judged by formulas of first-order logic with counting. Kaiser and I wrote three papers about it. The first, in 2010, was on playing such games. The second, at AAAI in 2011, was on that logic as a basis for general game playing. The third, in the same year, described translating the Game Description Language, a variant of Datalog in which such games are usually specified, into Toss.

My first commit to Toss is titled "Initial rewrite of Mso.py into OCaml": I began by carrying a Python program into OCaml. The translation of the Game Description Language was the third thing I had built around a logic language, after Object Prolog and the solver in Speagram.

## The languages I taught

My doctoral years went in about equal parts to the thesis, to the work with Kaiser, and to teaching, which was one of a doctoral student's obligations. The thesis and the collaboration were in OCaml. The teaching was in almost everything else.

For other lecturers' courses I ran laboratories. The neural networks lab was in Matlab, and the files are signed 2005 and 2006. The data mining lab was in R and Octave, and I wrote slides that set the two side by side, command by command. R was my choice there. The lecturer used Java, with the Weka toolkit. The evolutionary algorithms lab was in Matlab again. In 2008 and 2009 I ran a lab in Haskell, for which I wrote reference solvers for puzzle assignments. I also ran a Linux lab, and wrote its ten sheets of shell exercises.

Three courses were mine entirely: the design, the lectures and the laboratory.

The first was Java, in the winter of 2011–12, in English, for three or four foreign students. I had learned Java in order to teach it and used it for nothing else. The lectures followed books. What I wrote myself was the exercises, a few examples, and a running project: a simulation in the manner of *The Settlers*, with castles, warehouses, flags and roads, carriers who move goods along the roads, and a scheduler that drives them. One example shows why a method that overrides another may not widen its result. A `Farmer` promises an `Apple`, and a `Gardener` who extends `Farmer` tries to hand back any `Fruit`. Condensed:

```java
class Farmer   { public Apple foo () { return new Apple(); } }
class Gardener extends Farmer {
                 public Fruit foo () { return new Fruit(); } }

static void bar (Farmer a) { Apple y = a.foo (); y.bite (); }
```

The second was functional programming in OCaml, in 2012 and 2013, also in English and to as few students, with translations into F#. Those lectures are now the book [*Curious OCaml*](https://lukstafi.github.io/curious-ocaml/new_book.html).

The third was [Pascal](https://github.com/lukstafi/Pascal-course). It was the only one in a big lecture hall, and I took it on at short notice, in place of a colleague on leave. I was back in the language my cousins had shown me fifteen years before, as someone who had since lived in OCaml. The first lecture sorts Free Pascal's features into the good, the meh, and the bad and ugly. Under good I put the parameter modes, `const`, `out` and `var`, subrange types, and nested functions with lexical scope. Under meh I put this:

> The programmer must decide about memory management: whether to create a record/object on the stack or on the heap, whether to use reference counting or free memory themselves.

Templates "like in C++" appear under both good and meh. Under bad I put the lack of a way to name a value that cannot be reassigned, and the lack of closures, with the comment "Well, Pascal is an imperative language, not 'expression-oriented'."

In the spring of 2012 I was a student again, in Stanford's online course on probabilistic graphical models, and did its assignments in Octave.

So teaching gave me Java, Haskell, Matlab, Octave and R, and gave me Pascal a second time. Most of them were chosen for me. It also left me with a habit. In those slides one language is always set against another: Pascal against Java, OCaml against Haskell, Octave against R.

## Haskell, C++, Python

In the summer of 2014 I was an intern at Google, and all the work I did there was in Haskell. We used kind polymorphism over algebraic data types, which OCaml cannot express directly, as I note in [*Dependent Types from Rocq to Lean 4*](dependent-types-from-rocq-to-lean.html). The cost was laziness. I had to write an interface to foreign code, and laziness caused bugs in it that were hard to fix. A couple of times it also gave me infinite loops, which were easier.

In 2015 I wrote Python and JavaScript for a small town near where I grew up. It was a fork of an editor for public transport timetables, to which I added exports, a Polish translation, and a small website with a map. The town used the data entry and the generated pages. The map needed a map service, and nobody there could set one up.

In October 2015 I defended my thesis, on inferring invariants of programs as types, and started at Google. For most of the next six years I wrote C++, on knowledge representation and semantic parsing. What it taught me was RAII, the idiom in which a resource is acquired when an object is created and released when the object goes out of scope. I used it to build a cache that evicted its least recently used entries, which was efficient and came with guarantees of safety. I have no equivalent in OCaml, where the garbage collector releases things when it chooses. For my last year and a half the team was moved to Google Brain to build infrastructure for reinforcement learning, and there I wrote only Python.

## The languages I did not learn

I did not learn Nemerle, although it came from my own institute. I saw no point, being a Linux user and an OCaml programmer. I never learned Scala, though my lectures cite it.

Swift disappointed me. I had been led to believe it was close to functional programming, and it does not have full pattern matching. Its patterns take apart enumerations and tuples. They cannot take apart a struct by its fields or a list by its shape.

I bounced off Rust, and nothing has given me a strong reason to try again. I think the syntax felt bloated. I am not sure.

The four have something in common. Each carries ideas from ML, which I already had at their source, to a place I was not: .NET, the Java virtual machine, Apple's platforms, programs that must run without a garbage collector. Rust is the one I can least dismiss. Its ownership is RAII checked by the compiler, and RAII is what I valued most in C++. My excuse is that the fast code in my current project is generated, so the language I write in can afford its collector.

## OCaml again

From 2022 I wrote TypeScript for editor extensions, and OCaml for nearly everything else. My main project is [OCANNL](https://github.com/ahrefs/ocannl), a framework for deep learning that compiles tensor code to C, CUDA and Metal, which Ahrefs has sponsored since April 2024. Around it I wrote bindings again, to libgccjit and CUDA, and a syntax extension for debugging.

That extension shows what I miss. It logs values together with their types, but only where the programmer has written the types down, because a syntax extension in OCaml runs before type inference and cannot see what will be inferred. I would like metaprogramming that knows the types, for building small languages inside the language. It is a wish I have had since 2003, when Xavier Leroy pointed me to MetaOCaml.

For a while I thought I missed modular explicits, which have since arrived. I was overcomplicating my design.

## What I write now

Until the end of 2024 I wrote and debugged all my code myself. Cursor went onto my laptop in February 2025. For a month I used only its tab completion, and the first code that an agent wrote for me on its own was committed that March. In April the bindings to Apple's Metal were written entirely by agents, from context that I prepared with care. The first commits in OCANNL written by an AI are from the same month, attempts at a Metal backend that my own commit messages call "temporary AI slop". The last large piece that I designed by hand, and partly wrote by hand, was the concatenation of tensors in OCANNL, in December 2025.

For a few months now, agents have written all of the code on my projects. I hesitate over the word "my", since I am glad to share the ownership with them. They write OCaml, and also Python, shell, whatever suits the job. Those others I do not count as languages I use.

Agents were good at OCaml early. At the very beginning of 2025 they were already proficient in it, more than they themselves believed. I think agents and people benefit from the same things: strictness, and a compiler that checks every case is covered.

I am curious about guarantees beyond that level, and not yet convinced. Two languages I follow without writing them are on that road. One is Lean 4, for autoformalization and for what agents can do with a proof assistant. I have followed the use of language models in provers since 2021, when I was attending the reading group I describe in [*How LLMs Could Place Explicit Memories*](how-llms-could-place-explicit-memories.html), and a prover that proposes the next step is what my talk in the mountains was about. The other is Bend, which in its second version checks proofs, with the stated aim of blocking the mistakes of code written by AI. Its author is active, its uses overlap with programming by agents, and its ideas go back to things I studied, such as Girard's linear logic.

The OCaml community is divided over the use of LLMs. On its forum this year one thread asked whether OCaml should join the projects that [reject AI-generated code](https://discuss.ocaml.org/t/rejecting-ai-generated-code/18360), and another asked whether [ocaml.org was slop now](https://discuss.ocaml.org/t/is-ocaml-org-slop-now/18568), after a tutorial appeared there with a note that it was written with AI assistance. The replies run from wary to hostile. The companies that build on OCaml have gone the other way. My sponsor Ahrefs has taken the tools up, and Jane Street most of all. On Jane Street's podcast in October, an engineer who builds its AI tooling [said](https://signalsandthreads.com/the-changing-craft-of-programming/) that something like 45 per cent of the features released at the firm now begin in a workflow that involves an LLM. The two sides share a phrase. The most liked reply about ocaml.org says that LLMs as writers undermine the social contract of technical writing, and the podcast says that agents have broken the social contract around code review.

## What survives

Everything I wrote before 2003 is gone, apart from one game that I carried into another language. What I have from before then is what I remember, and writing this has shown me how little I can trust that.

What survives from later is now [in one place](https://github.com/lukstafi/early-work). The Speagram and Toss repositories are still on SourceForge.

Some things were lost after they left my hands. The copyright form went missing in the post, and the calculator fixes with it. The Lua bindings were never taken into OpenSteer. In January 2010, nearly three years after my last post in that forum thread, Craig Reynolds came back to it and wrote:

> This effort by Lukasz is another example of a contribution to OpenSteer which I never followed up on.

I read it in November 2026, while writing this.
