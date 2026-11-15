# Speagram's history on SourceForge

Checked 15 November 2026, for the planned memoir essay on programming languages. Everything below comes from the public SourceForge project unless marked as a recollection or a reading.

## Sources

- Project page: <https://sourceforge.net/projects/speagram>, registered 18 May 2004, listed language OCaml, BSD licence.
- Repository: <https://svn.code.sf.net/p/speagram/code-0/trunk/speagram/>. It holds 1,106 revisions, from 18 May 2004 to 7 February 2007. The first revisions were converted from CVS by cvs2svn in February 2006.
- Files saved beside this note:
  - [speagram-svn-log-2026-11-15.tsv](speagram-svn-log-2026-11-15.tsv): every revision with its date, author, number of paths changed, and message.
  - [speagram-new-types-2006.pdf](speagram-new-types-2006.pdf) and its TeXmacs source [speagram-new-types-2006.tm](speagram-new-types-2006.tm): the design note "Speagram with Subtyping and Labels", dated 27 July 2006, from `doc/new_types.pdf` in the repository.

To fetch again: any file in the repository can be read with a plain HTTP GET under the repository URL above. `rsync -a svn.code.sf.net::p/speagram/code-0/ <dir>/` mirrors the whole repository; revision properties are plain text under `db/revprops/`. The CVS rsync endpoint refused connections on the day.

## Timeline

| Date | Event | Evidence |
|---|---|---|
| 2003 | Kaiser's copyright starts | "Copyright (C) 2003-2005 Lukasz Kaiser", r845 |
| 18 May 2004 | Project registered on SourceForge | project metadata |
| 19 May 2004 | First import of sources, in Nemerle | r4–r6; r10 "Made project ready to use new Nemerle syntax" |
| 2004 – mid 2005 | Development in Nemerle, following its releases | r112 "Update to Nemerle 0.1.4", r264 "Jump to Nemerle 0.2", r473, r586, r631 |
| 15 Jun 2005 | Release 0.1 | NEWS, ChangeLog |
| Jun – Sep 2005 | "Michal Wojcik works on Speagram for Summer of Code" | NEWS |
| 6 Jul 2005 | "Initial import of OCaml code" | r746, Kaiser |
| 30 Aug 2005 | "Speagram binary in ocaml parses two basic spg library files" | r823, Kaiser |
| 8 Sep 2005 | "Cleaning up nemerle code, only corrected ocaml version left" | r846, Kaiser |
| 29 Oct 2005 | Makefiles updated "to compile with metaocaml" | r852, Kaiser |
| 23 Dec 2005 | Release 0.2 | NEWS |
| 28 Apr 2006 | Release 0.3 | NEWS |
| 28 Jul – 1 Aug 2006 | Kaiser prepares the type representation for the change | r1023 "preparing to change them for Lukasz", r1025 "the one agreed upon with Lukasz" |
| 3 Aug 2006 | Stafiniak's first commit: "New Type System with subtyping and rows" | r1027, adds the design note |
| 16 Aug 2006 | "Subtyping with rows (multidimensional types), term heads identified by symbols, major Speagram overhaul, NOT MEANT TO BE RUN" | r1028 |
| 11 Oct 2006 | Last commit of the main run | r1104 |
| 28 Jan 2007 | One more commit, unfinished "attribute labels language" work | r1105 |
| 7 Feb 2007 | Last commit in the repository | r1106, Kaiser |

## Who committed

| Account | Commits | Active | Name |
|---|---|---|---|
| lukaszkaiser | 570 | May 2004 – Feb 2007 | Łukasz Kaiser |
| mrwparser | 201 | Dec 2004, Feb – Sep 2005 | Michał Ryszard Wójcik |
| rzyjontko | 149 | May – Nov 2004 | not named on the developer list |
| awasylkowski | 119 | May 2004 – Mar 2005 | Andrzej Wasylkowski |
| lukstafi | 62 | Aug – Oct 2006, Jan 2007 | Łukasz Stafiniak |

The AUTHORS file credits Kaiser as creator and lists Jacek Sliwerski, Andrzej Wasylkowski and Michal Ryszard Wojcik as contributors. It was last changed on 18 January 2006 (r888), before Stafiniak joined, and does not list him; the SourceForge developer list does. That `rzyjontko` is Jacek Sliwerski is an inference by elimination.

## The source language over time

File changes per half-year, by extension. `.n` is Nemerle source; `.ml` and `.mli` are OCaml; `.spg` is Speagram's own library format.

| Period | `.n` | `.ml` + `.mli` | `.spg` |
|---|---|---|---|
| 2004 H1 | 297 | 0 | 35 |
| 2004 H2 | 1340 | few (timing tests) | 246 |
| 2005 H1 | 567 | few | 319 |
| 2005 H2 | 55 | 254 | 112 |
| 2006 H1 | 0 | 151 | 45 |
| 2006 H2 | 0 | 357 | 76 |

## Stafiniak's work, August – October 2006

The design note's table of contents:

1. Types Logic: informal introduction; type algebra; constraints and their logical interpretation; checking satisfiability by closure; differences with Pottier's "A Constraint-Based Presentation and Generalization of Rows".
2. Terms and Types: typing judgements; the type system and reconstruction; the Speagram language (type definitions, closing type schemes, rewrite rule definitions); differences with Henglein's "Syntactic Properties of Polymorphic Subtyping".
3. Constraint-Based Rule Selection Grammars: rule-based grammars; typability-based rule selection; syntax definitions; parsing as derivation.
4. Implementation Decisions.

The type algebra has kinds, each with a finite lattice of symbols, and labels that carry a kind and a variance. Types are mappings from labels to symbols, ordered by subtyping label by label. Constraints include inequalities, inequalities restricted to a filter (a finite or cofinite set of labels), and conditional inequalities guarded by symbols. Satisfiability is decided by computing a closure under rules named TRANS, PROP-FILTER, FIRE and so on, and failing when `false` is derived.

The commits follow the note:

- r1027–r1036 (3–21 Aug): the note, the overhaul, the `Type` and `Term` modules with tests, first solver tests.
- r1037–r1049 (22–29 Aug): parsing brought back up; minimising type sums; reporting all constraint failures on a failed parse; occurs check; "Multivariance and function type constructor added"; nonjoinability checking.
- r1055–r1071 (31 Aug – 16 Sep): debug traces for the parser and the solver; left-hand-side occurs check; "Full variable span calculation".
- r1080–r1087 (18–22 Sep): Windows build fixes; "Speagram embedded" launchers in C for Linux and Windows; generic term printing.
- r1093–r1104 (1–11 Oct): "WengoPhone integration and first tests of new type system functionality"; solver fixes; "Complete rewrite of occurs check to use variable span".

The files touched most often: `src/Type.ml` (38 commits), `src/System.ml` (30), `src/SyntaxDef.ml` (26), `src/Term.ml` (24), `src/BuiltinLang.ml` (24).

## Against the author's recollections of 15 November 2026

- **"Speagram was always on OCaml."** The record says it was written in Nemerle until summer 2005. It was in OCaml for the whole of Stafiniak's involvement.
- **"Mine was the second rewrite, the first was by MRW that LK hired for a summer."** The record agrees on the order. The summer was 2005, the NEWS file calls it Summer of Code, and the work coincides with the port from Nemerle to OCaml. Kaiser made the initial OCaml import and much of the port himself.
- **"I think I convinced Łukasz Kaiser to use OCaml, in particular he liked MetaOCaml."** The record neither confirms nor contradicts this. The OCaml import (July 2005) and the MetaOCaml build (October 2005) both predate Stafiniak's first commit by about a year, and no commit message says who proposed the switch.
- **"I implemented a new, more efficient formalism."** The record shows a new type system with subtyping and rows, a constraint solver for it, and grammars that select rules by typability. Whether it was more efficient is not something the commit messages establish.

## Readings, not established by the record

- The design note is the earliest surviving type system of Stafiniak's, and it infers types by solving constraints, as InvarGenT later did.
- Rows were half the reason he gave for choosing OCaml over SML (objects and polymorphic variants). The note builds a type system on rows and positions itself against Pottier's work on them.
