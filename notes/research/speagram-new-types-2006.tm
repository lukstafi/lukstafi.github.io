<TeXmacs|1.0.6>

<style|<tuple|article|speagram>>

<\body>
  <doc-data|<doc-title|Speagram with Subtyping and
  Labels>|<doc-date|<date>>|<doc-date|07.27.2006>>

  <\table-of-contents|toc>
    <vspace*|1fn><with|font-series|bold|math-font-series|bold|Table of
    contents> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-1><vspace|0.5fn>

    <vspace*|1fn><with|font-series|bold|math-font-series|bold|1<space|2spc>Types
    Logic> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-2><vspace|0.5fn>

    <with|par-left|1.5fn|1.1<space|2spc>Informal Introduction
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-3>>

    <with|par-left|1.5fn|1.2<space|2spc>Type Algebra
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-4>>

    <with|par-left|1.5fn|1.3<space|2spc>Type Logic: Constraints
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-5>>

    <with|par-left|3fn|1.3.1<space|2spc>Logical Interpretation
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-6>>

    <with|par-left|1.5fn|1.4<space|2spc>Checking Satisfiability of
    Constraints <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-7>>

    <with|par-left|3fn|1.4.1<space|2spc>Closing Constraints
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-8>>

    <with|par-left|3fn|1.4.2<space|2spc>The Algorithm
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-9>>

    <with|par-left|1.5fn|1.5<space|2spc>Differences with ``A Constraint-Based
    Presentation and Generalization of Rows'' by Francois Pottier
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-10>>

    <vspace*|1fn><with|font-series|bold|math-font-series|bold|2<space|2spc>Terms
    and Types> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-11><vspace|0.5fn>

    <with|par-left|1.5fn|2.1<space|2spc>Preliminaries
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-12>>

    <with|par-left|3fn|2.1.1<space|2spc>Untyped Terms
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-13>>

    <with|par-left|3fn|2.1.2<space|2spc>Typing Judgements
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-14>>

    <with|par-left|3fn|2.1.3<space|2spc>Term Algebra
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-15>>

    <with|par-left|1.5fn|2.2<space|2spc>The Type System
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-16>>

    <with|par-left|3fn|2.2.1<space|2spc>Typing Judgement Reconstruction
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-17>>

    <with|par-left|1.5fn|2.3<space|2spc>The Speagram Language
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-18>>

    <with|par-left|3fn|2.3.1<space|2spc>Type Definitions
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-19>>

    <with|par-left|3fn|2.3.2<space|2spc>Closing Type Schemes
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-20>>

    <with|par-left|3fn|2.3.3<space|2spc>Rewrite Rule Definitions
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-21>>

    <with|par-left|3fn|2.3.4<space|2spc>Differences with ``Syntactic
    Properties of Polymorphic Subtyping'' by Henglein
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-22>>

    <vspace*|1fn><with|font-series|bold|math-font-series|bold|3<space|2spc>Constraint-Based
    Rule Selection Grammars> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-23><vspace|0.5fn>

    <with|par-left|1.5fn|3.1<space|2spc>Rule-Based Grammars
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-24>>

    <with|par-left|3fn|3.1.1<space|2spc>Typability-Based Rule Selection
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-25>>

    <with|par-left|1.5fn|3.2<space|2spc>Syntax Definitions
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-26>>

    <with|par-left|3fn|3.2.1<space|2spc>Variable Syntax Definitions
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-27>>

    <with|par-left|3fn|3.2.2<space|2spc>Constructor and Function Syntax
    Definitions <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-28>>

    <with|par-left|1.5fn|3.3<space|2spc>Parsing as Derivation
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-29>>

    <vspace*|1fn><with|font-series|bold|math-font-series|bold|4<space|2spc>Implementation
    Decisions> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-30><vspace|0.5fn>
  </table-of-contents>

  <section|Types Logic>

  <subsection|Informal Introduction>

  Things, objects, or whatever in the world, is only recongnized when we can
  categorize it. The category of an entity is its \Rcanonical'' description,
  which allows it to enter into relation with other entities in our
  perception. The same is true for a language: its entities, words, have
  their categories, their roles. But the case of a language, or words, is
  specific: they not only \Rstand for themselves'', they (or their ensembles)
  often refer to other beings in the world. In Speagram, types are used to
  convey categories: both language categories of the words, and (the way to
  construct) categories for their referents. Words are actually assigned type
  schemes: descriptions that allow to reason about the categories. An entity
  can have many types (that is, it can have many descriptions), but we will
  assume, that it will always have a <em|principal type scheme>, from which
  all of its types follow.

  <subsection|Type Algebra>

  <\definition>
    Let <with|mode|math|\<cal-K\>>, such that
    <with|mode|math|type\<in\>\<cal-K\>>, be a finite set of <em|kinds>. For
    every kind <with|mode|math|\<kappa\>\<in\>\<cal-K\>\\{type}>, let
    <with|mode|math|\<cal-S\><rsub|\<kappa\>>> be a finite lattice of
    <em|symbols>, with operations <with|mode|math|\<bot\><rsub|\<kappa\>>,\<top\><rsub|\<kappa\>>,\<leq\><rsub|\<kappa\>>,\<sqcup\><rsub|\<kappa\>>,\<sqcap\><rsub|\<kappa\>>>
    with the usual meaning. Let <with|mode|math|\<cal-P\>={\<oplus\>,\<ominus\>}>
    denote <em|variances>, where <with|mode|math|\<oplus\>> is read
    <em|covariant>, <with|mode|math|\<ominus\>> -- <em|contravariant>. We
    write <with|mode|math|\<cal-S\>> for the set of all symbols (that is,
    <with|mode|math|\<cal-S\>=<big|cup><rsub|\<kappa\>\<in\>\<cal-K\>\\{type}>\<cal-S\><rsub|\<kappa\>>>).
    Let <with|mode|math|\<cal-L\>> be a countable set of <em|labels>. With
    every label <with|mode|math|l\<in\>\<cal-L\>>, associate a kind, written
    <with|mode|math|kind(l)>, and a variance, written
    <with|mode|math|var(l)>.
  </definition>

  <\example>
    Let <with|mode|math|\<cal-K\>> be <with|mode|math|{class,type}>. Let
    <with|mode|math|\<cal-S\><rsub|class>={\<bot\><rsub|class>,bool,int,real,list,\<top\><rsub|class>}>.
    Let the relation <with|mode|math|\<leq\><rsub|class>> only hold on
    <with|mode|math|\<cal-S\>\\{\<bot\><rsub|class>,\<top\><rsub|class>}> for
    <with|mode|math|int\<leq\><rsub|class>real>. Let
    <with|mode|math|\<cal-L\>={arg<rsub|1>,arg<rsub|2>,\<ldots\>,imag,cat,elements}>.
    Let <with|mode|math|kind(arg<rsub|i>)=kind(imag)=kind(elements)=type> and
    <with|mode|math|kind(cat)=class>. Let
    <with|mode|math|var(imag)=var(cat)=var(elements)=\<oplus\>> and
    <with|mode|math|var(arg<rsub|i>)=\<ominus\>>.
  </example>

  <\definition>
    The type model <with|mode|math|\<bbb-T\>=\<cal-S\><rsub|type>> is the
    greatest solution to the following equation:

    <\equation*>
      \<cal-S\><rsub|type>={(<wide|t<rsub|l>|\<bar\>>):\<forall\>l\<in\>\<cal-L\>,
      t<rsub|l>\<in\>\<cal-S\><rsub|kind(l)>}\<cup\>{\<bot\><rsub|type>,\<top\><rsub|type>}
    </equation*>

    where <with|mode|math|(<wide|t<rsub|l>|\<bar\>>)> are mappings
    <with|mode|math|\<cal-L\>\<rightarrow\>\<cal-S\>>, and
    <with|mode|math|t<rsub|l>> denotes a value of a mapping at point
    <with|mode|math|l>.
  </definition>

  <\definition>
    Let <with|mode|math|t\<leq\><rsub|\<kappa\>><rsup|\<oplus\>>t<rprime|'>>
    stand for <with|mode|math|t\<leq\><rsub|\<kappa\>>t<rprime|'>> and
    <with|mode|math|t\<leq\><rsub|\<kappa\>><rsup|\<ominus\>>t<rprime|'>>
    stand for <with|mode|math|t<rprime|'>\<leq\><rsub|\<kappa\>>t>. The
    relation <with|mode|math|\<leq\><rsub|type>> is the greatest solution to
    the following equivalence:

    <\equation*>
      (<wide|t<rsub|l>|\<bar\>>)\<leq\><rsub|type>(<wide|t<rprime|'><rsub|l>|\<bar\>>)\<Longleftrightarrow\>\<forall\>l\<in\>\<cal-L\>,t<rsub|l>\<leq\><rsub|kind(l)><rsup|var(l)>t<rprime|'><rsub|l>
    </equation*>
  </definition>

  <\theorem>
    <with|mode|math|(\<cal-S\><rsub|type>,\<leq\><rsub|type>)> forms a
    lattice.
  </theorem>

  We simply write <with|mode|math|\<leq\>> for
  <with|mode|math|\<leq\><rsub|\<kappa\>>> when the kind
  <with|mode|math|\<kappa\>> is evident from context.

  <subsection|Type Logic: Constraints>

  For every kind <with|mode|math|\<kappa\>>, let
  <with|mode|math|\<cal-V\><rsub|\<kappa\>>> be a distinct denumerable set of
  <em|variables>. Let <with|mode|math|\<alpha\>> range over variables. Let a
  <em|filter> <with|mode|math|L> be a finite or cofinite subset of
  <with|mode|math|\<cal-L\>> and let <with|mode|math|l> range over
  <with|mode|math|\<cal-L\>>. Let <with|mode|math|s> range over
  <with|mode|math|\<cal-S\>>. The <em|type terms> (or <em|type expressions>)
  and <em|formulas> (or <em|constraints>) are given by the following syntax:

  <\eqnarray*>
    <tformat|<table|<row|<cell|\<tau\>>|<cell|:\<assign\>>|<cell|\<alpha\>\|s\|{l\<sim\>\<tau\>,\<ldots\>,l\<sim\>\<tau\>}>>|<row|<cell|C>|<cell|:\<assign\>>|<cell|\<exists\>\<alpha\>.C\|C\<wedge\>C\|<with|math-font-series|bold|true>\|<with|math-font-series|bold|false>>>|<row|<cell|>|<cell|>|<cell|\|\<tau\>\<leq\>\<tau\>>>|<row|<cell|>|<cell|>|<cell|\|L:\<tau\>\<leq\>\<tau\>>>|<row|<cell|>|<cell|>|<cell|\|s\<leq\>\<tau\>\<wedge\>\<ldots\>\<wedge\>s\<leq\>\<tau\>?\<tau\>\<leq\>\<tau\>>>|<row|<cell|>|<cell|>|<cell|\|s\<leq\>\<tau\>\<wedge\>\<ldots\>\<wedge\>s\<leq\>\<tau\>?L:\<tau\>\<leq\>\<tau\>>>>>
  </eqnarray*>

  We denote the set of type terms by <with|mode|math|T<rsub|\<tau\>>> and the
  set of constraints by <with|mode|math|\<cal-C\>>. The type term
  <with|mode|math|{l\<sim\>\<tau\>,\<ldots\>,l\<sim\>\<tau\>}> is called a
  <em|feature set> and is interpreted in the type algebra
  <with|mode|math|\<bbb-T\>> as assigning to the unspecified labels the
  respective top symbols <with|mode|math|\<top\><rsub|\<kappa\>>> for
  covariant labels and bottom symbols <with|mode|math|\<bot\><rsub|\<kappa\>>>
  for contravariant labels; it is called <em|row expression>. Lets call the
  constraint <with|mode|math|L:\<tau\>\<leq\>\<tau\>> <em|filter constraint>.

  <\definition>
    <with|mode|math|s\<in\>\<cal-S\><rsub|\<kappa\>>> is <em|prime> iff for
    any finite subset <with|mode|math|S\<subset\>\<cal-S\><rsub|\<kappa\>>>

    <\equation*>
      s\<leq\><rsub|\<kappa\>>(\<sqcup\><rsub|\<kappa\>>S)\<Longrightarrow\>\<exists\>s<rprime|'>\<in\>S,s\<leq\><rsub|\<kappa\>>s<rprime|'>.
    </equation*>
  </definition>

  <\definition>
    Well-kinded type terms and constraints.

    The judgement <with|mode|math|\<vdash\>\<tau\>:\<kappa\>> means that the
    type term <with|mode|math|\<tau\>> <em|has kind>
    <with|mode|math|\<kappa\>>, and <with|mode|math|\<vdash\><rsub|OK>C>
    means that constraint <with|mode|math|C> is <em|well kinded>. Let
    <with|mode|math|L> range over filters. The judgements are defined as
    follows:

    <\equation*>
      <tabular|<tformat|<table|<row|<cell|<tabular*|<tformat|<table|<row|<cell|<frac|\<alpha\>\<in\>\<cal-V\><rsub|\<kappa\>>|\<vdash\>\<alpha\>:\<kappa\>>>|<cell|>|<cell|<frac|s\<in\>\<cal-S\><rsub|\<kappa\>>|\<vdash\>s:\<kappa\>>>|<cell|>|<cell|<frac|<tabular*|<tformat|<table|<row|<cell|kind(l<rsub|1>)=\<kappa\><rsub|1>
      \<ldots\> kind(l<rsub|n>)=\<kappa\><rsub|n>>>|<row|<cell|<tabular|<tformat|<table|<row|<cell|\<vdash\>\<tau\><rsub|1>:\<kappa\><rsub|1>>|<cell|\<ldots\>>|<cell|\<vdash\>\<tau\><rsub|n>:\<kappa\><rsub|n>>>>>>>>>>>|\<vdash\>{l<rsub|1>\<sim\>\<tau\><rsub|1>,\<ldots\>,l<rsub|n>\<sim\>\<tau\><rsub|n>}:type>>>>>>>>|<row|<cell|>>|<row|<cell|<tabular|<tformat|<table|<row|<cell|<frac|<tabular|<tformat|<table|<row|<cell|\<vdash\>\<tau\><rsub|1>:\<kappa\>>|<cell|>|<cell|\<vdash\>\<tau\><rsub|2>:\<kappa\>>>>>>|<tabular*|<tformat|<table|<row|<cell|\<vdash\><rsub|OK>\<tau\><rsub|1>\<leq\>\<tau\><rsub|2>>>|<row|<cell|\<vdash\><rsub|OK>L:\<tau\><rsub|1>\<leq\>\<tau\><rsub|2>>>>>>>>|<cell|>|<cell|<frac|\<vdash\><rsub|OK>C|\<vdash\><rsub|OK>\<exists\>\<alpha\>.C>>|<cell|>|<cell|<frac|<tabular|<tformat|<table|<row|<cell|\<vdash\><rsub|OK>C<rsub|1>>|<cell|>|<cell|\<vdash\><rsub|OK>C<rsub|2>>>>>>|\<vdash\><rsub|OK>C<rsub|1>\<wedge\>C<rsub|2>>>>>>>>>|<row|<cell|>>|<row|<cell|<tabular|<tformat|<table|<row|<cell|\<vdash\><rsub|OK><with|math-font-series|bold|true>>|<cell|>|<cell|\<vdash\><rsub|OK><with|math-font-series|bold|false>>|<cell|>|<cell|<frac|<tabular*|<tformat|<table|<row|<cell|s<rsub|i><with|mode|text|
      is a prime element of >\<cal-S\><rsub|\<kappa\><rsub|i>>>>|<row|<cell|<tabular|<tformat|<table|<row|<cell|\<vdash\><rsub|OK>s<rsub|1>\<leq\>\<tau\><rsub|1>>|<cell|\<ldots\>>|<cell|\<vdash\><rsub|OK>s<rsub|n>\<leq\>\<tau\><rsub|n>>|<cell|>|<cell|\<vdash\><rsub|OK>\<tau\>\<leq\>\<tau\><rprime|'>>>>>>>>>>>|<tabular*|<tformat|<table|<row|<cell|\<vdash\><rsub|OK>s<rsub|1>\<leq\>\<tau\><rsub|1>\<wedge\>\<ldots\>\<wedge\>s<rsub|n>\<leq\>\<tau\><rsub|n>?\<tau\>\<leq\>\<tau\><rprime|'>>>|<row|<cell|\<vdash\><rsub|OK>s<rsub|1>\<leq\>\<tau\><rsub|1>\<wedge\>\<ldots\>\<wedge\>s<rsub|n>\<leq\>\<tau\><rsub|n>?L:\<tau\>\<leq\>\<tau\><rprime|'>>>>>>>>>>>>>>>>>
    </equation*>

    \;
  </definition>

  TODO: how relevant is the severe ``prime'' restriction? Can it be weakened
  to any symbol, or even removed? (So that any type term can appear to the
  left of premise inequalities.)

  <subsubsection|Logical Interpretation>

  <\definition>
    A <em|ground assignment> <with|mode|math|\<phi\>> is a total
    kind-preserving mapping from the variables into the model, that is, a
    total mapping from every <with|mode|math|\<cal-V\><rsub|\<kappa\>>> into
    <with|mode|math|\<cal-S\><rsub|\<kappa\>>>.
  </definition>

  <\definition>
    Ground assignments are extended to type terms by

    <\equation*>
      \<phi\>({l<rsub|1>\<sim\>\<tau\><rsub|1>,\<ldots\>,l<rsub|n>\<sim\>\<tau\><rsub|n>})=(<wide|t<rsub|l>|\<bar\>>)
    </equation*>

    where <with|mode|math|t<rsub|l<rsub|i>>=\<phi\>(\<tau\><rsub|i>)> and
    <with|mode|math|t<rsub|l>=\<top\><rsub|\<kappa\>>> for each covariant
    <with|mode|math|l\<nin\>{l<rsub|1>,\<ldots\>,l<rsub|n>}>
    (<with|mode|math|var(l)=\<oplus\>>), <with|mode|math|t<rsub|l>=\<bot\><rsub|\<kappa\>>>
    for each contravariant <with|mode|math|l\<nin\>{l<rsub|1>,\<ldots\>,l<rsub|n>}>
    (<with|mode|math|var(l)=\<ominus\>>), and
    <with|mode|math|\<kappa\>=kind(l)>.
  </definition>

  <\definition>
    The judgement <with|mode|math|\<phi\>\<vdash\>C> (read:
    <with|mode|math|\<phi\>> <em|satisfies> <with|mode|math|C>) is defined by
    the following rules:

    <\equation*>
      <tabular*|<tformat|<table|<row|<cell|<tabular|<tformat|<table|<row|<cell|<frac|\<phi\>[\<alpha\>\<mapsto\>t]\<vdash\>C|\<phi\>\<vdash\>\<exists\>\<alpha\>.C>>|<cell|>|<cell|<frac|<tabular|<tformat|<table|<row|<cell|\<phi\>\<vdash\>C<rsub|1>>|<cell|>|<cell|\<phi\>\<vdash\>C<rsub|2>>>>>>|\<phi\>\<vdash\>C<rsub|1>\<wedge\>C<rsub|2>>>|<cell|\<phi\>\<vdash\><with|math-font-series|bold|true>>>>>>>>|<row|<cell|>>|<row|<cell|<tabular|<tformat|<table|<row|<cell|<frac|\<phi\>(\<tau\><rsub|1>)\<leq\>\<phi\>(\<tau\><rsub|2>)|\<phi\>\<vdash\>\<tau\><rsub|1>\<leq\>\<tau\><rsub|2>>>|<cell|>|<cell|<frac|\<forall\>l\<in\>L,
      \<phi\>(\<tau\><rsub|1>).l\<leq\>\<phi\>(\<tau\><rsub|2>).l|\<phi\>\<vdash\>L:\<tau\><rsub|1>\<leq\>\<tau\><rsub|2>>>>>>>>>|<row|<cell|>>|<row|<cell|<frac|<tabular|<tformat|<table|<row|<cell|s<rsub|1>\<leq\>\<phi\>(\<tau\><rsub|1>)\<wedge\>>|<cell|\<ldots\>>|<cell|\<wedge\>s<rsub|n>\<leq\>\<phi\>(\<tau\><rsub|n>)>|<cell|\<Rightarrow\>>|<cell|\<phi\>(\<tau\>)\<leq\>\<phi\>(\<tau\><rprime|'>)>>>>>|\<phi\>\<vdash\>s<rsub|1>\<leq\>\<tau\><rsub|1>\<wedge\>\<ldots\>\<wedge\>s<rsub|n>\<leq\>\<tau\><rsub|n>?\<tau\>\<leq\>\<tau\><rprime|'>>>>|<row|<cell|>>|<row|<cell|<frac|<tabular|<tformat|<table|<row|<cell|s<rsub|1>\<leq\>\<phi\>(\<tau\><rsub|1>)\<wedge\>>|<cell|\<ldots\>>|<cell|\<wedge\>s<rsub|n>\<leq\>\<phi\>(\<tau\><rsub|n>)>|<cell|\<Rightarrow\>>|<cell|\<forall\>l\<in\>L,\<phi\>(\<tau\>).l\<leq\>\<phi\>(\<tau\><rprime|'>).l>>>>>|\<phi\>\<vdash\>s<rsub|1>\<leq\>\<tau\><rsub|1>\<wedge\>\<ldots\>\<wedge\>s<rsub|n>\<leq\>\<tau\><rsub|n>?L:\<tau\>\<leq\>\<tau\><rprime|'>>>>>>>
    </equation*>

    The assertion <with|mode|math|C<rsub|1>\<Vdash\>C<rsub|2>> (read:
    <with|mode|math|C<rsub|1>> <em|entails> <with|mode|math|C<rsub|2>>) holds
    if and only if, for every ground assignment <with|mode|math|\<phi\>>,
    <with|mode|math|\<phi\>\<vdash\>C<rsub|1>> implies
    <with|mode|math|\<phi\>\<vdash\>C<rsub|2>>. Two constraints are
    <em|logically equivalent> if and only if they entail each other.
  </definition>

  <subsection|Checking Satisfiability of Constraints>

  Thanks to <with|mode|math|\<alpha\>>-convertibility and scope extrusion of
  existential quantification, the properties of conjunction operator and of
  filter constraints, we can represent constraints as mappings from
  <em|edges> to <em|weights>, where edges are pairs of type terms
  <with|mode|math|\<tau\><rsub|1>\<leq\>\<tau\><rsub|2>>, tuples of type
  terms <with|mode|math|s\<leq\>\<tau\>\<wedge\>\<ldots\>\<wedge\>s\<leq\>\<tau\>?\<tau\>\<leq\>\<tau\>>,<with|mode|math|>
  or a special edge <with|mode|math|<with|math-font-series|bold|false>> (the
  weight must be 0 or 1). Weights are <with|mode|math|0, 1> or any filter
  <with|mode|math|L>.

  <subsubsection|Closing Constraints>

  To determine whether a constraint is satisfiable, we check if it implies
  <with|mode|math|<with|math-font-series|bold|false>>, by generating all its
  consequences.

  <\definition>
    Let <with|mode|math|\<top\><rsup|\<oplus\>><rsub|\<kappa\>>\<assign\>\<top\><rsub|\<kappa\>>,\<top\><rsup|\<ominus\>><rsub|\<kappa\>>\<assign\>\<bot\><rsub|\<kappa\>>,\<bot\><rsup|\<oplus\>><rsub|\<kappa\>>\<assign\>\<bot\><rsub|\<kappa\>>,\<bot\><rsup|\<ominus\>><rsub|\<kappa\>>\<assign\>\<top\><rsub|\<kappa\>>>.
  </definition>

  <\definition>
    Constraint resolution: closure computation.

    The rules should be read as follows: if the left hand side matches an
    element of the constraint set, then add the right hand side to the
    constraint set. TODO: FIXME: multi-premise conditionals must check all
    premises!!!

    <\description>
      <item*|TRANS>

      <\equation*>
        \<tau\><rsub|1>\<leq\>\<alpha\>\<wedge\>\<alpha\>\<leq\>\<tau\><rsub|2>\<longrightarrow\>\<tau\><rsub|1>\<leq\>\<tau\><rsub|2>
      </equation*>

      <item*|PROP-TYPE>If <with|mode|math|\<vdash\>\<tau\><rsub|1>:type> and
      <with|mode|math|\<vdash\>\<tau\><rsub|2>:type>

      <\equation*>
        \<tau\><rsub|1>\<leq\>\<tau\><rsub|2>\<longrightarrow\>\<cal-L\>:\<tau\><rsub|1>\<leq\>\<tau\><rsub|2>
      </equation*>

      <item*|PROP-FAIL>If <with|mode|math|s<rsub|1>\<nleq\><rsub|\<kappa\>>s<rsub|2>>

      <\equation*>
        s<rsub|1>\<leq\>s<rsub|2>\<longrightarrow\><with|math-font-series|bold|false>
      </equation*>

      <item*|PROP-FILTER>If <with|mode|math|l<rsub|i>=l<rsub|j>\<in\>L>

      <\equation*>
        L:{l<rsub|1>\<sim\>\<tau\><rsub|1>,\<ldots\>,l<rsub|n>\<sim\>\<tau\><rsub|n>}\<leq\>{l<rprime|'><rsub|1>\<sim\>\<tau\><rprime|'><rsub|1>,\<ldots\>,l<rprime|'><rsub|m>\<sim\>\<tau\><rprime|'><rsub|m>}\<longrightarrow\>\<tau\><rsub|i>\<leq\><rsup|var(l<rsub|i>)>\<tau\><rprime|'><rsub|j>
      </equation*>

      <item*|PROP-LEFT>If <with|mode|math|l<rsub|i><rprime|'>\<in\>L\<wedge\>\<forall\>j=1,\<ldots\>,n:l<rsub|i><rprime|'>\<neq\>l<rsub|j>>

      <\equation*>
        L:{l<rsub|1>\<sim\>\<tau\><rsub|1>,\<ldots\>,l<rsub|n>\<sim\>\<tau\><rsub|n>}\<leq\>{l<rprime|'><rsub|1>\<sim\>\<tau\><rprime|'><rsub|1>,\<ldots\>,l<rprime|'><rsub|m>\<sim\>\<tau\><rprime|'><rsub|m>}\<longrightarrow\>\<top\><rsub|kind(l<rsub|i><rprime|'>)><rsup|var(l<rsub|i><rprime|'>)>\<leq\><rsup|var(l<rsub|i><rprime|'>)>\<tau\><rprime|'><rsub|i>
      </equation*>

      <item*|TRANS-FILTER>

      <\equation*>
        L<rsub|1>:\<tau\><rsub|1>\<leq\>\<alpha\>\<wedge\>L<rsub|2>:\<alpha\>\<leq\>\<tau\><rsub|2>\<longrightarrow\>L<rsub|1>\<cap\>L<rsub|2>:\<tau\><rsub|1>\<leq\>\<tau\><rsub|2>
      </equation*>

      <item*|TRANS-COND>

      <\equation*>
        s<rsub|1>\<leq\>\<tau\><rsub|1>,\<ldots\>,s<rsub|n>\<leq\>\<alpha\>?\<tau\>\<leq\>\<tau\><rprime|'>\<wedge\>\<tau\><rsub|n>\<leq\>\<alpha\>\<longrightarrow\>s<rsub|1>\<leq\>\<tau\><rsub|1>,\<ldots\>,s<rsub|n>\<leq\>\<tau\><rsub|n>?\<tau\>\<leq\>\<tau\><rprime|'>
      </equation*>

      <item*|TRANS-COND-FILTER>

      <\equation*>
        s<rsub|1>\<leq\>\<tau\><rsub|1>,\<ldots\>,s<rsub|n>\<leq\>\<alpha\>?L:\<tau\>\<leq\>\<tau\><rprime|'>\<wedge\>\<tau\><rsub|n>\<leq\>\<alpha\>\<longrightarrow\>s<rsub|1>\<leq\>\<tau\><rsub|1>,\<ldots\>,s<rsub|n>\<leq\>\<tau\><rsub|n>?L:\<tau\>\<leq\>\<tau\><rprime|'>
      </equation*>

      <item*|FIRE>If <with|mode|math|s<rsub|n>\<leq\>s>

      <\equation*>
        s<rsub|1>\<leq\>\<tau\><rsub|1>,\<ldots\>,s<rsub|n-1>\<leq\>\<tau\><rsub|n-1>,s<rsub|n>\<leq\>s?\<tau\>\<leq\>\<tau\><rprime|'>\<wedge\>\<tau\><rsub|n>\<leq\>\<alpha\>\<longrightarrow\>s<rsub|1>\<leq\>\<tau\><rsub|1>,\<ldots\>,s<rsub|n-1>\<leq\>\<tau\><rsub|n-1>?\<tau\>\<leq\>\<tau\><rprime|'>
      </equation*>

      <item*|FIRE-FILTER>If <with|mode|math|s<rsub|n>\<leq\>s>

      <\equation*>
        s<rsub|1>\<leq\>\<tau\><rsub|1>,\<ldots\>,s<rsub|n-1>\<leq\>\<tau\><rsub|n-1>,s<rsub|n>\<leq\>s?L:\<tau\>\<leq\>\<tau\><rprime|'>\<wedge\>\<tau\><rsub|n>\<leq\>\<alpha\>\<longrightarrow\>s<rsub|1>\<leq\>\<tau\><rsub|1>,\<ldots\>,s<rsub|n-1>\<leq\>\<tau\><rsub|n-1>?L:\<tau\>\<leq\>\<tau\><rprime|'>
      </equation*>

      <item*|PROP-FIRE>

      <\equation*>
        \<varnothing\>?\<tau\>\<leq\>\<tau\><rprime|'>\<longrightarrow\>\<tau\>\<leq\>\<tau\><rprime|'>
      </equation*>

      <item*|PROP-FIRE-FILTER>

      <\equation*>
        \<varnothing\>?L:\<tau\>\<leq\>\<tau\><rprime|'>\<longrightarrow\>L:\<tau\>\<leq\>\<tau\><rprime|'>
      </equation*>
    </description>
  </definition>

  <\remark>
    The closure rules defined above do not compute all consequences: they do
    not add consequences with feature sets nor conditionals with premises set
    that is not a strict subset of those already present.
  </remark>

  <subsubsection|The Algorithm>

  We now describe an algorithm that, given a constraint
  <with|mode|math|C<rsub|0>>, fails if it is unsatisfiable, and computes its
  closure otherwise. The algorithm uses an unordered <em|queue>
  <with|mode|math|Q> of pending elementary constraints. It also maintains a
  <em|current constraint> <with|mode|math|C>, represented as a mapping from
  edges to weights. The mapping is implemented in such a way, that
  non-<with|mode|math|0> non-<with|mode|math|\<varnothing\>> weight co-images
  can be obtained for edges with fixed type terms in selected positions.

  <\definition>
    Algorithm <with|mode|math|Closure(C<rsub|0>)>. TODO: FIXME: multi-premise
    conditionals must check all premises!!!

    <FUNDEF|Insert|c|<\IF|<with|mode|math|c> is <with|mode|math|e> and
    <with|mode|math|C(e)=0>>
      <\STATE>
        <with|mode|math|C(e)\<leftarrow\>1>
      </STATE>

      <\STATE>
        <with|mode|math|Q\<leftarrow\>Q,c>
      </STATE>
    <|IF>
      <\IF-NO-ELSE|<with|mode|math|c> is <with|mode|math|L:e> or c is
      <with|mode|math|s<rsub|1>\<leq\>\<tau\><rsub|1>\<wedge\>\<ldots\>\<wedge\>s<rsub|n>\<leq\>\<tau\><rsub|n>?L:e<rprime|'>>>
        <\STATE>
          <with|mode|math|L<rsub|1>\<assign\>L\\C(e)>
        </STATE>

        <\IF-NO-ELSE|<with|mode|math|L<rsub|1>\<neq\>\<varnothing\>>>
          <\STATE>
            <with|mode|math|C(e)\<leftarrow\>L\<cup\>C(e)>
          </STATE>

          <\STATE>
            <with|mode|math|Q\<leftarrow\>Q,L<rsub|1>:e>
          </STATE>
        </IF-NO-ELSE>
      </IF-NO-ELSE>

      <htab|5mm>
    </IF>>

    <\FUNDEF|Process|<with|mode|math|\<tau\><rsub|1>\<leq\>\<alpha\>>>
      <\FORALL>
        <\STATE>
          <with|mode|math|Insert(\<tau\><rsub|1>\<leq\>\<tau\><rsub|2>)>
        </STATE>
      </FORALL|<with|mode|math|\<tau\><rsub|2>:C(\<alpha\>\<leq\>\<tau\><rsub|2>)=1>>

      <\FORALL>
        <\STATE>
          <with|mode|math|Insert(L<rsub|2>:\<tau\><rsub|1>\<leq\>\<tau\><rsub|2>)>
        </STATE>
      </FORALL|<with|mode|math|\<tau\><rsub|2>:C(\<alpha\>\<leq\>\<tau\><rsub|2>)=L<rsub|2>\<neq\>\<varnothing\>>>

      <\FORALL>
        <\STATE>
          <with|mode|math|Insert(s<rsub|1>\<leq\>\<tau\><rsub|1>\<wedge\>\<ldots\>\<wedge\>s<rsub|n-1>\<leq\>\<tau\><rsub|n-1><rprime|'>\<wedge\>s<rsub|n>\<leq\>\<tau\><rsub|1>?\<tau\>\<leq\>\<tau\><rprime|'>)>
        </STATE>
      </FORALL|<with|mode|math|C(s<rsub|1>\<leq\>\<tau\><rsub|1><rprime|'>,\<ldots\>,s<rsub|n-1>\<leq\>\<tau\><rsub|n-1><rprime|'>\<wedge\>s<rsub|n>\<leq\>\<alpha\>?\<tau\>\<leq\>\<tau\><rprime|'>)=\<b-1\>>>

      <\FORALL>
        <\STATE>
          <with|mode|math|Insert(s<rsub|1>\<leq\>\<tau\><rsub|1>\<wedge\>\<ldots\>\<wedge\>s<rsub|n-1>\<leq\>\<tau\><rsub|n-1><rprime|'>\<wedge\>s<rsub|n>\<leq\>\<tau\><rsub|1>?L:\<tau\>\<leq\>\<tau\><rprime|'>)>
        </STATE>
      </FORALL|<with|mode|math|C(s<rsub|1>\<leq\>\<tau\><rsub|1><rprime|'>,\<ldots\>,s<rsub|n-1>\<leq\>\<tau\><rsub|n-1><rprime|'>\<wedge\>s<rsub|n>\<leq\>\<alpha\>?\<tau\>\<leq\>\<tau\><rprime|'>)=L<rsub|2>\<neq\>\<varnothing\>>>
    </FUNDEF>

    <\FUNDEF|Process|<with|mode|math|\<alpha\>\<leq\>\<tau\><rsub|2>>>
      <\FORALL>
        <\STATE>
          <with|mode|math|Insert(\<tau\><rsub|1>\<leq\>\<tau\><rsub|2>)>
        </STATE>
      </FORALL|<with|mode|math|\<tau\><rsub|1>:C(\<tau\><rsub|1>\<leq\>\<alpha\>)=1>>

      <\FORALL>
        <\STATE>
          <with|mode|math|Insert(L<rsub|1>:\<tau\><rsub|1>\<leq\>\<tau\><rsub|2>)>
        </STATE>
      </FORALL|<with|mode|math|\<tau\><rsub|1>:C(\<tau\><rsub|1>\<leq\>\<alpha\>)=L<rsub|1>\<neq\>\<varnothing\>>>
    </FUNDEF>

    <\FUNDEF|Process|<with|mode|math|L<rsub|1>:\<tau\><rsub|1>\<leq\>\<alpha\>>>
      <\FORALL>
        <\STATE>
          <with|mode|math|Insert(L<rsub|1>\<cap\>L<rsub|2>:\<tau\><rsub|1>\<leq\>\<tau\><rsub|2>)>
        </STATE>
      </FORALL|<with|mode|math|\<tau\><rsub|2>:C(\<alpha\>\<leq\>\<tau\><rsub|2>)=L<rsub|2>\<neq\>\<varnothing\>>>
    </FUNDEF>

    <\FUNDEF|Process|<with|mode|math|L<rsub|2>:\<alpha\>\<leq\>\<tau\><rsub|2>>>
      <\FORALL>
        <\STATE>
          <with|mode|math|Insert(L<rsub|1>\<cap\>L<rsub|2>:\<tau\><rsub|1>\<leq\>\<tau\><rsub|2>)>
        </STATE>
      </FORALL|<with|mode|math|\<tau\><rsub|1>:C(\<tau\><rsub|1>\<leq\>\<alpha\>)=L<rsub|1>\<neq\>\<varnothing\>>>
    </FUNDEF>

    <FUNDEF|Process|<with|mode|math|s<rsub|1>\<leq\>s<rsub|2>>|<\IF-NO-ELSE|<with|mode|math|s<rsub|1>\<nleq\>s<rsub|2>>>
      <\STATE>
        fail
      </STATE>
    </IF-NO-ELSE>>

    <\FUNDEF|Process|<with|mode|math|L:{l<rsub|1>\<sim\>\<tau\><rsub|1>,\<ldots\>,l<rsub|n>\<sim\>\<tau\><rsub|n>}\<leq\>{l<rprime|'><rsub|1>\<sim\>\<tau\><rprime|'><rsub|1>,\<ldots\>,l<rprime|'><rsub|m>\<sim\>\<tau\><rprime|'><rsub|m>}>>
      <\FORALL>
        <\STATE>
          <with|mode|math|Insert(\<tau\><rsub|i>\<leq\><rsup|var(l)>\<tau\><rprime|'><rsub|j>)>
        </STATE>
      </FORALL|<with|mode|math|l=l<rsub|i>=l<rprime|'><rsub|j>\<in\>L\<cap\>{l<rsub|1>,\<ldots\>,l<rsub|n>}\<cap\>{l<rprime|'><rsub|1>,\<ldots\>,l<rprime|'><rsub|m>}>>

      <\FORALL>
        <\STATE>
          <with|mode|math|Insert(\<top\><rsup|var(l)><rsub|kind(l)>\<leq\><rsup|var(l)>\<tau\><rprime|'><rsub|j>)>
        </STATE>
      </FORALL|<with|mode|math|l=l<rprime|'><rsub|j>\<in\>(L\<cap\>{l<rprime|'><rsub|1>,\<ldots\>,l<rprime|'><rsub|m>})\\{l<rsub|1>,\<ldots\>,l<rsub|n>}>>
    </FUNDEF>

    <\FUNDEF|Process|<with|mode|math|s<rsub|1>\<leq\>\<tau\><rsub|1>,\<ldots\>,s<rsub|n>\<leq\>\<alpha\>?\<tau\>\<leq\>\<tau\><rprime|'>>>
      <\FORALL>
        <\STATE>
          <with|mode|math|Insert(s<rsub|1>\<leq\>\<tau\><rsub|1>,\<ldots\>,s<rsub|n>\<leq\>\<tau\><rsub|n>?\<tau\>\<leq\>\<tau\><rprime|'>)>
        </STATE>
      </FORALL|<with|mode|math|\<tau\><rsub|n>:C(\<tau\><rsub|n>\<leq\>\<alpha\>)=1>>
    </FUNDEF>

    <\FUNDEF|Process|<with|mode|math|s<rsub|1>\<leq\>\<tau\><rsub|1>,\<ldots\>,s<rsub|n>\<leq\>\<alpha\>?L:\<tau\>\<leq\>\<tau\><rprime|'>>>
      <\FORALL>
        <\STATE>
          <with|mode|math|Insert(s<rsub|1>\<leq\>\<tau\><rsub|1>,\<ldots\>,s<rsub|n>\<leq\>\<tau\><rsub|n>?L:\<tau\>\<leq\>\<tau\><rprime|'>)>
        </STATE>
      </FORALL|<with|mode|math|\<tau\><rsub|n>:C(\<tau\><rsub|n>\<leq\>\<alpha\>)=1>>
    </FUNDEF>

    <\FUNDEF|Process|<with|mode|math|s<rsub|1>\<leq\>\<tau\><rsub|1>,\<ldots\>,s<rsub|n>\<leq\>s<rprime|'>?\<tau\>\<leq\>\<tau\><rprime|'>>>
      <\STATE>
        <\IF-NO-ELSE|<with|mode|math|s<rsub|n>\<leq\>s<rprime|'>>>
          <\IF|<with|mode|math|n=1>>
            <\STATE>
              <with|mode|math|Insert(\<tau\>\<leq\>\<tau\><rprime|'>)>
            </STATE>
          <|IF>
            <\STATE>
              <with|mode|math|Insert(s<rsub|1>\<leq\>\<tau\><rsub|1>\<wedge\>\<ldots\>\<wedge\>s<rsub|n-1)>\<leq\>\<tau\><rsub|n-1>?\<tau\>\<leq\>\<tau\><rprime|'>)>
            </STATE>
          </IF>
        </IF-NO-ELSE>
      </STATE>

      \;
    </FUNDEF>

    <\FUNDEF|Process|<with|mode|math|s<rsub|1>\<leq\>\<tau\><rsub|1>,\<ldots\>,s<rsub|n>\<leq\>s<rprime|'>?L:\<tau\>\<leq\>\<tau\><rprime|'>>>
      <\STATE>
        <\IF-NO-ELSE|<with|mode|math|s<rsub|n>\<leq\>s<rprime|'>>>
          <\IF|<with|mode|math|n=1>>
            <\STATE>
              <with|mode|math|Insert(L:\<tau\>\<leq\>\<tau\><rprime|'>)>
            </STATE>
          <|IF>
            <\STATE>
              <with|mode|math|Insert(s<rsub|1>\<leq\>\<tau\><rsub|1>\<wedge\>\<ldots\>\<wedge\>s<rsub|n-1)>\<leq\>\<tau\><rsub|n-1>?L:\<tau\>\<leq\>\<tau\><rprime|'>)>
            </STATE>
          </IF>
        </IF-NO-ELSE>
      </STATE>

      \;
    </FUNDEF>

    <\FUNDEF|Closure|<with|mode|math|C<rsub|0>>>
      <\STATE>
        <with|mode|math|C\<leftarrow\><with|math-font-series|bold|true>>
      </STATE>

      <\STATE>
        <with|mode|math|Q\<leftarrow\>\<varnothing\>>
      </STATE>

      <FORALL|<\IF|<with|mode|math|c=<with|math-font-series|bold|false>>>
        <\STATE>
          fail
        </STATE>
      <|IF>
        <\STATE>
          <with|mode|math|Insert(c)>
        </STATE>
      </IF>|<with|mode|math|c\<in\>C<rsub|0>>>

      <\WHILE>
        <\STATE>
          extract <with|mode|math|c> out of <with|mode|math|Q>
        </STATE>

        <\STATE>
          <with|mode|math|Process(c)>
        </STATE>
      </WHILE|<with|mode|math|Q\<neq\>\<varnothing\>>>
    </FUNDEF>
  </definition>

  <subsection|Differences with ``A Constraint-Based Presentation and
  Generalization of Rows'' by Francois Pottier>

  The type system is based on the one presented in the mentioned article, but
  with major modifications. All types are based on rows (the sorts of types
  and of rows are identified, or merged). Rows are not used to type records,
  they are used to construct so called ``feature structures'', that is,
  flexible, extendable polymorphic types.

  Instead of a row constructor <with|mode|math|\<partial\>\<tau\>>, which
  assigns the value <with|mode|math|\<tau\>> to all labels, we introduce a
  constructor <with|mode|math|{l<rsub|1>\<sim\>\<tau\><rsub|1>,\<ldots\>,l<rsub|n>\<sim\>\<tau\><rsub|n>}>
  which assigns given values to given labels, and respectively top or bottom
  to all other labels. This is driven by the philosophy that we cannot even
  predict what labels there will be in the end, not to mention their kinds
  (domains of their values). It is also the standard way to define object
  types in some other languages.

  Because we merge rows with types, we have variances for row labels (the
  original paper has variances for type labels only).

  Because of resigning from <with|mode|math|\<partial\>> constructor, we had
  to modify conditional types. We extend them with multiple premises, for
  expressivity. In future versions, if it proves to be necessary for
  applications, we will further generalize the shape of conditionals.

  <section|Terms and Types>

  <subsection|Preliminaries>

  <subsubsection|Untyped Terms>

  Let <with|mode|math|\<Sigma\><rsub|c>> be a finite set of <em|constructors>
  and let <with|mode|math|\<Sigma\><rsub|f>> be a finite set of <em|function
  symbols>. Elements of <with|mode|math|\<Sigma\>=\<Sigma\><rsub|c>\<cup\>\<Sigma\><rsub|f>>
  are called <em|term symbols> and let <with|mode|math|c> and
  <with|mode|math|f> range over <with|mode|math|\<Sigma\><rsub|c>> and
  <with|mode|math|\<Sigma\><rsub|f>> respectively. Let <with|mode|math|V> be
  a countably infinite set of <em|term variables> and let
  <with|mode|math|x,y,z> range over <with|mode|math|V>. Let <em|untyped
  terms> <with|mode|math|E> be the set of rooted ordered finite trees with
  nodes labelled by elements of <with|mode|math|\<Sigma\>\<cup\>V>. Let
  <em|untyped ground terms> <with|mode|math|E<rsub|g>> be the set of rooted
  ordered finite trees with nodes labelled by elements of
  <with|mode|math|\<Sigma\><rsub|c>>.

  <subsubsection|Typing Judgements>

  A polymorphic type can be instantiated to different concrete types. We
  introduce <em|type schemes> with the following syntax:

  <\eqnarray*>
    <tformat|<table|<row|<cell|\<sigma\>>|<cell|:\<assign\>>|<cell|\<forall\>\<alpha\>\<ldots\>\<alpha\>:C.\<tau\><htab|5mm>>>>>
  </eqnarray*>

  We denote the set of type schemes by <with|mode|math|T<rsub|\<sigma\>>>.
  Informally, type scheme <with|mode|math|\<forall\>\<alpha\><rsub|1>\<ldots\>\<alpha\><rsub|n>:C.\<tau\>>
  stands for any type <with|mode|math|\<tau\><rprime|'>=\<tau\>[\<alpha\><rsub|1>/\<tau\><rsub|1>;\<ldots\>;\<alpha\><rsub|n>/\<tau\><rsub|n>]>
  such that <with|mode|math|C[\<alpha\><rsub|1>/\<tau\><rsub|1>;\<ldots\>;\<alpha\><rsub|n>/\<tau\><rsub|n>]>
  holds. Let <em|typing environment> <with|mode|math|\<b-Gamma\><rsub|\<Sigma\>>>
  be a mapping from symbols <with|mode|math|\<Sigma\>> into type schemes
  <with|mode|math|T<rsub|\<sigma\>>> and <em|typing context>
  <with|mode|math|\<b-Gamma\><rsub|V>> be a mapping from variables
  <with|mode|math|V> into types <with|mode|math|T<rsub|\<tau\>>>. Let
  <em|typing judgement> relation be a relation in
  <with|mode|math|\<cal-C\>\<times\>(T<rsub|\<sigma\>><rsup|\<Sigma\>>\<cup\>T<rsub|\<tau\>><rsup|V>)\<times\>E\<times\>T<rsub|\<tau\>>>
  written as <with|mode|math|C,\<b-Gamma\><rsub|\<Sigma\>>\<cup\>\<b-Gamma\><rsub|V>\<vdash\>e:\<tau\>>.
  The type judgement relation of Speagram will be defined in the subchapter
  ``The Type System''. Sometimes we will use <em|extended typing judgement>
  <with|mode|math|C,\<b-Gamma\><rsub|\<Sigma\>>\<cup\>\<b-Gamma\><rsub|V>\<vdash\>e:\<sigma\>>.
  We can extend the subtype relation to type schemes by:

  <\eqnarray*>
    <tformat|<table|<row|<cell|\<phi\>\<vdash\>\<tau\><rsub|1>\<leq\><rsub|type>\<tau\><rsub|2>>|<cell|\<Longrightarrow\>>|<cell|\<phi\>\<vdash\>\<tau\><rsub|1>\<leq\><rsub|\<sigma\>>\<tau\><rsub|2>>>|<row|<cell|C,\<b-Gamma\><rsub|\<Sigma\>>\<cup\>{f:\<sigma\>}\<vdash\>f:\<tau\>>|<cell|\<Longrightarrow\>>|<cell|C\<Vdash\>\<sigma\>\<leq\><rsub|\<sigma\>>\<tau\>>>|<row|<cell|FTV(\<sigma\>)\<subset\>FTV(C,\<sigma\><rprime|'>)\<wedge\>\<forall\>D,\<tau\>:(D\<Vdash\>C\<wedge\>D\<Vdash\>\<sigma\><rprime|'>\<leq\>\<tau\>)\<Rightarrow\>D\<Vdash\>\<sigma\>\<leq\>\<tau\>>|<cell|\<Longrightarrow\>>|<cell|C\<Vdash\>\<sigma\>\<leq\><rsub|\<sigma\>>\<sigma\><rprime|'>>>>>
  </eqnarray*>

  Observe, that the more general type scheme is the subtype of the less
  general type scheme.

  <subsubsection|Term Algebra>

  Let <em|typed ground terms> be the set <with|mode|math|\<bbb-E\>={e\<in\>E<rsub|g>:\<exists\>\<tau\>
  <with|math-font-series|bold|true>,\<b-Gamma\><rsub|\<Sigma\>>\<vdash\>e:\<tau\>}>.
  Let <em|term algebra> be an algebra with carrier <with|mode|math|\<bbb-E\>>
  and operation symbols <with|mode|math|\<Sigma\><rsub|f>>, where each
  operation <with|mode|math|f\<in\>\<Sigma\><rsub|f>> is interpreted as a
  partial function in <with|mode|math|\<bbb-E\><rsup|\<bbb-E\><rsup|\<ast\>>>>
  (this includes nullary functions, that is constants), such that whenever
  <with|mode|math|(e<rsub|1>,\<ldots\>,e<rsub|n>)\<in\>Dom(f)>, and the value
  of operation <with|mode|math|f> on <with|mode|math|(e<rsub|1>,\<ldots\>,e<rsub|n>)>
  is <with|mode|math|e>, then <with|mode|math|\<exists\>\<tau\>
  <with|math-font-series|bold|true>,\<b-Gamma\><rsub|\<Sigma\>>\<vdash\>f(e<rsub|1>,\<ldots\>,e<rsub|n>):\<tau\>\<wedge\><with|math-font-series|bold|true>,\<b-Gamma\><rsub|\<Sigma\>>\<vdash\>e:\<tau\>>.

  <subsection|The Type System>

  <\definition>
    First we define the typing judgement for terms:

    <\eqnarray*>
      <tformat|<table|<row|<cell|[INST]>|<cell|C,\<b-Gamma\>\<cup\>{f:\<forall\><wide|\<alpha\>|\<vect\>>:C<rprime|'>.\<tau\>}\<vdash\>f:\<tau\>[<wide|\<tau\>|\<vect\>>/<wide|\<alpha\>|\<vect\>>]>|<cell|C\<Vdash\>C<rprime|'>[<wide|\<tau\>|\<vect\>>/<wide|\<alpha\>|\<vect\>>]>>|<row|<cell|>|<cell|>|<cell|>>|<row|<cell|[VAR]>|<cell|<frac||C,\<b-Gamma\>\<cup\>{x:\<tau\>}\<vdash\>x:\<tau\>>>|<cell|>>|<row|<cell|>|<cell|>|<cell|>>|<row|<cell|[APP]>|<cell|<frac|<tabular|<tformat|<table|<row|<cell|C,\<b-Gamma\>\<vdash\>e<rsub|1>:\<tau\><rsub|1>>|<cell|\<ldots\>>|<cell|C,\<b-Gamma\>\<vdash\>e<rsub|n>:\<tau\><rsub|n>>|<cell|C,\<b-Gamma\>\<vdash\>f:\<tau\><rsub|f>>>>>>|C,\<b-Gamma\>\<vdash\>f(e<rsub|1>,\<ldots\>,e<rsub|n>):\<tau\>>>|<cell|C\<Vdash\>\<tau\><rsub|f>\<leq\>{arg<rsub|1>\<sim\>\<tau\><rsub|1>,\<ldots\>,arg<rsub|n>\<sim\>\<tau\><rsub|n>,imag\<sim\>\<tau\>}>>|<row|<cell|>|<cell|>|<cell|\<wedge\>{arg<rsub|n+1>}:{arg<rsub|n+1>\<sim\>\<bot\><rsub|type>}\<leq\>\<tau\><rsub|f>>>|<row|<cell|>|<cell|>|<cell|>>|<row|<cell|[SUB]>|<cell|<frac|C,\<b-Gamma\>\<vdash\>e:\<tau\>|C,\<b-Gamma\>\<vdash\>e:\<tau\><rprime|'>>>|<cell|C\<Vdash\>\<tau\>\<leq\>\<tau\><rprime|'>>>>>
    </eqnarray*>

    and the extended typing judgement:

    <\eqnarray*>
      <tformat|<table|<row|<cell|[BASE]>|<cell|<frac||C,\<b-Gamma\>\<cup\>{f:\<sigma\>}\<vdash\>f:\<sigma\>>>|<cell|>>|<row|<cell|>|<cell|>|<cell|>>|<row|<cell|[GEN]>|<cell|<frac|C\<wedge\>C<rprime|'>,\<b-Gamma\>\<vdash\>e:\<tau\>|C,\<b-Gamma\>\<vdash\>e:\<forall\><wide|\<alpha\>|\<vect\>>:C<rprime|'>.\<tau\>>>|<cell|<wide|\<alpha\>|\<bar\>>\<cap\>FTV(C<rprime|'>,\<b-Gamma\>)=\<varnothing\>>>>>
    </eqnarray*>
  </definition>

  We will also use the following derived rule:

  <\eqnarray*>
    <tformat|<table|<row|<cell|[GEN<rprime|'>]>|<cell|<frac|C\<wedge\>C<rprime|'>,\<b-Gamma\>\<vdash\>e:\<forall\><wide|\<beta\>|\<vect\>>:C<rprime|''>.\<tau\>|C,\<b-Gamma\>\<vdash\>e:\<forall\><wide|\<alpha\>|\<vect\>><wide|\<beta\>|\<vect\>>:C<rprime|'>\<wedge\>C<rprime|''>.\<tau\>>>|<cell|<wide|\<alpha\>|\<bar\>>\<cap\>FTV(C<rprime|'>,\<b-Gamma\>)=\<varnothing\>>>>>
  </eqnarray*>

  <subsubsection|Typing Judgement Reconstruction>

  Following Henglein's ``Syntactic Properties of Polymorphic Subtyping'', our
  algorithm will compute a typing judgement for a given term and typing
  environment and context. Then, the issue of typability will be resolved by
  checking, whether the generated constraint (the premise in the type
  judgement) is satisfiable.

  <\definition>
    <\eqnarray*>
      <tformat|<table|<row|<cell|W(\<b-Gamma\>,f)>|<cell|=>|<cell|<IF|(f:\<forall\><wide|\<alpha\>|\<vect\>>:C.\<tau\>)\<in\>\<b-Gamma\>|C[<wide|\<beta\>|\<vect\>>/<wide|\<alpha\>|\<vect\>>],\<b-Gamma\>\<vdash\>f:\<tau\>[<wide|\<beta\>|\<vect\>>/<wide|\<alpha\>|\<vect\>>]<with|mode|text|
      with ><wide|\<beta\>|\<vect\>><with|mode|text|
      fresh>|<with|math-font-series|bold|fail>>>>|<row|<cell|>|<cell|>|<cell|>>|<row|<cell|W(\<b-Gamma\>,x)>|<cell|=>|<cell|<IF|(x:\<tau\>)\<in\>\<b-Gamma\>|<with|math-font-series|bold|true>,\<b-Gamma\>\<vdash\>x:\<tau\>|<with|math-font-series|bold|fail>>>>|<row|<cell|>|<cell|>|<cell|>>|<row|<cell|W(\<b-Gamma\>,f(e<rsub|1>,\<ldots\>,e<rsub|n>))>|<cell|=>|<cell|C<rsub|0>\<wedge\>C<rsub|1>\<wedge\>\<ldots\>\<wedge\>C<rsub|n>\<wedge\>
      {arg<rsub|n+1>}:{arg<rsub|n+1>\<sim\>\<bot\><rsub|type>}\<leq\>\<tau\>\<wedge\>>>|<row|<cell|>|<cell|>|<cell|\<tau\>\<leq\>{arg<rsub|1>\<sim\>\<tau\><rsub|1>,\<ldots\>,arg<rsub|n>\<sim\>\<tau\><rsub|n>,imag\<sim\>\<alpha\>},\<b-Gamma\>\<vdash\>f(e<rsub|1>,\<ldots\>,e<rsub|n>):\<alpha\>>>|<row|<cell|<with|mode|text|where>>|<cell|>|<cell|(C<rsub|0>,\<b-Gamma\><rsub|0>\<vdash\>f:\<tau\>)=W(\<b-Gamma\>,f)>>|<row|<cell|>|<cell|>|<cell|(C<rsub|1>,\<b-Gamma\><rsub|1>\<vdash\>e<rsub|1>:\<tau\><rsub|1>)=W(\<b-Gamma\><rsub|0>,e<rsub|1>)>>|<row|<cell|>|<cell|>|<cell|\<ldots\>>>|<row|<cell|>|<cell|>|<cell|(C<rsub|n>,\<b-Gamma\><rsub|n>\<vdash\>e<rsub|n>:\<tau\><rsub|n>)=W(\<b-Gamma\><rsub|n-1>,e<rsub|n>)>>|<row|<cell|>|<cell|>|<cell|\<alpha\><with|mode|text|
      fresh>>>>>
    </eqnarray*>
  </definition>

  TODO: the environment/context (<with|mode|math|\<b-Gamma\>>) is not changed
  by the algorithm <with|mode|math|(W)>. Unless it will, we can keep in the
  result the name given as argument.

  \;

  <subsection|The Speagram Language>

  Speagram programming is split into <em|sessions>. Sessions are separated by
  the command ``Close context''. A session is composed of <em|type
  definitions>, <em|constructor definitions>, <em|function type
  declarations>, <em|variable declarations> and <em|rewrite rule>
  definitions. <em|Term computations> are not a part of a session: the
  context is closed just before them and reopened after them. During a
  session, the following elements are maintained:

  <\description-dash>
    <item*|type environment <with|mode|math|\<b-Gamma\><rsub|\<Sigma\>>>>it
    is extended by constructor definitions and function type declarations

    <item*|type context <with|mode|math|\<b-Gamma\><rsub|V>>>it is extended
    by variable declarations

    <item*|context constraint <with|mode|math|C<rsub|c>>>it is extended by
    rewrite rule definitions
  </description-dash>

  Between sessions, only the type environment
  <with|mode|math|\<b-Gamma\><rsub|\<Sigma\>>> is transferred.

  Speagram relies on the user to give type declarations, but can support the
  user with type inference by means of free type variables: if a free, that
  is non-polymorphic, type variable occurs in a type declaration, then the
  constraints on it are lifted from <with|mode|math|C<rsub|c>> during context
  closing into the type scheme of defined function. Type declarations are not
  a caveat, they are an important part of Speagram powerful flexibility.

  <\remark>
    The type inference feature is currently experimental in that the inferred
    types and constraints are currently not simplified and thus tend to be
    too lengthy to be useful.
  </remark>

  <subsubsection|Type Definitions>

  Currently, Speagram comes with two kinds besides the <with|mode|math|type>
  kind: <em|classes> and <em|integers>. Integers are equipped with the
  standard lattice structure: <with|mode|math|\<bot\><rsub|int>\<leq\><rsub|int>\<ldots\>\<leq\><rsub|int>-3\<leq\><rsub|int>-2\<leq\><rsub|int>-1\<leq\><rsub|int>0\<leq\><rsub|int>1\<leq\><rsub|int>2\<leq\><rsub|int>3\<leq\><rsub|int>\<ldots\>\<leq\><rsub|int>\<top\><rsub|int>>.
  Classes are a user extendable kind, with user extendable subtyping
  relation. User has to define labels before use (syntactical restriction).

  <subsubsection|Closing Type Schemes>

  Let <with|mode|math|\<sigma\>=\<forall\><wide|\<alpha\>|\<vect\>>:C.\<tau\>>.
  The closure of <with|mode|math|\<sigma\>> with respect to the constraint
  <with|mode|math|C<rsub|c>> is defined as:

  <\equation*>
    Close(C<rsub|c>,\<forall\><wide|\<alpha\>|\<vect\>>:C.\<tau\>)=\<forall\><wide|\<beta\>|\<vect\>><wide|\<alpha\>|\<vect\>>.C<rprime|'>\<wedge\>C.\<tau\>
  </equation*>

  where <with|mode|math|<wide|\<beta\>|\<vect\>>=FTV(C,\<tau\>)\\<wide|\<alpha\>|\<vect\>>>
  and <with|mode|math|C<rprime|'>={c\<in\>C<rsub|c>:FTV(c)\<cap\><wide|\<beta\>|\<vect\>>\<neq\>\<varnothing\>}>.

  When the context is closed, all type schemes introduced by the session into
  <with|mode|math|\<b-Gamma\><rsub|\<Sigma\>>> are closed.

  <subsubsection|Rewrite Rule Definitions>

  The rewrite rule definition <with|mode|math|(e<rsub|1>,e<rsub|2>)> extends
  the context constraint as follows:

  <\eqnarray*>
    <tformat|<table|<row|<cell|C<rsub|c>>|<cell|\<assign\>>|<cell|C<rsub|c>\<wedge\>C<rsub|1>\<wedge\>C<rsub|2>\<wedge\>\<tau\><rsub|2>\<leq\>\<tau\><rsub|1>>>|<row|<cell|<with|mode|text|where>>|<cell|>|<cell|>>|<row|<cell|C<rsub|1>,\<b-Gamma\><rsub|1>\<vdash\>e<rsub|1>:\<tau\><rsub|1>>|<cell|\<assign\>>|<cell|W(\<b-Gamma\><rsub|\<Sigma\>>\<cup\>\<b-Gamma\><rsub|V>,e<rsub|1>)>>|<row|<cell|C<rsub|1>,\<b-Gamma\><rsub|2>\<vdash\>e<rsub|2>:\<tau\><rsub|2>>|<cell|\<assign\>>|<cell|W(\<b-Gamma\><rsub|1>,e<rsub|2>)>>>>
  </eqnarray*>

  The right-hand-side (RHS) type must be a subtype of the left-hand-side
  (LHS) type, because RHS replaces LHS when a rule is applied.

  <subsubsection|Novelties and Differences with ``Syntactic Properties of
  Polymorphic Subtyping'' by Henglein>

  The ``surface'' differences come from the difference between Speagram and
  core ML (that is, typed <with|mode|math|\<lambda\>>-calculus with
  let-polymorphism).

  One of major novelties is the fact that rows do not have an inherent notion
  of arity. Since we do want the ability to fix arity, we use a trick: we
  mark the end of argument string by a bottom type. All actual arguments
  strings have to be of the same length, because otherwise typings would
  contradict for the argument position right after the end of shorter string
  arguments.

  TODO: write this paragraph.

  <section|Constraint-Based Rule Selection Grammars>

  We start by observing, that the well-known Unification Grammars can be seen
  as unification based rule selection grammars, with typability-based rule
  selection, where the type of an expression is the parameterized
  nonterminal, from which it is generated. Our situation differs in that the
  constraint solver is not based on unification, so the name ``Unification
  Grammar'' has no basis.

  <subsection|Rule-Based Grammars>

  A rule based grammar consists of a set of rules, or rule schemes. Rules are
  written as

  <\equation*>
    (R) \<phi\>\<vdash\>e\<Rightarrow\>e<rsub|1>\<ldots\>e<rsub|k>
  </equation*>

  or

  <\equation*>
    (R) <frac|e<rsub|1>\<ldots\>e<rsub|k>|e> \<phi\>
  </equation*>

  which means, that whenever condition <with|mode|math|\<phi\>> holds, the
  rule <with|mode|math|(R)> can be applied to replace the sequence
  <with|mode|math|e<rsub|1>\<ldots\>e<rsub|k>> with <with|mode|math|e>, or to
  generate it from <with|mode|math|e>. We call the ``pieces''
  <with|mode|math|e> <em|syntax elements>.
  <with|mode|math|e<rsub|1>\<ldots\>e<rsub|k>> can contain
  <em|metavariables>, which match against the actual structure of syntax
  elements when the rule applies, and are used in the condition
  <with|mode|math|\<phi\>>. The <with|mode|math|\<phi\>> in rule (scheme)
  will sometimes have ``fresh variable'' requirements, which means that for
  each application, a fresh set of selected variables should be used.

  <subsubsection|Typability-Based Rule Selection>

  In typability based rule selection grammars, the rule expresses the fact,
  that the sequence <with|mode|math|e<rsub|1>\<ldots\>e<rsub|k>> represents
  an expression of type represented by <with|mode|math|e>. Thus, the parsing
  process embeds the process of type checking or inference. Terminals
  represent input substrings, and nonterminals represesent types. In our
  case, nonterminal syntax elements will carry a type constraint
  <with|mode|math|C> and a type term <with|mode|math|\<tau\>> which together
  express their type. The condition <with|mode|math|\<phi\>> will bind
  constraints and types occurring in the rule, and the rule will apply if
  <with|mode|math|<with|math-font-series|bold|false>\<nin\>Closure(C<rsub|c>\<wedge\>\<phi\>)>.
  The syntax element <with|mode|math|e> will carry on the constraint
  <with|mode|math|\<phi\>>.

  <subsection|Syntax Definitions>

  Syntax definitions define grammar rules and at the same time introduce
  symbols and variables to the term (and type) language. There are thus the
  following kinds

  <\itemize>
    <item>type syntax definitions: class introduction, class ordering
    extension, label definition

    <item>constructor syntax definitions

    <item>function syntax definitions

    <item>variable syntax definitions
  </itemize>

  In this subchapter, we describe actions taken when a syntax definition is
  introduced. To keep the greatest flexibility, rule preselection treats all
  nonterminals as ``wildcards''.

  <subsubsection|Variable Syntax Definitions>

  The syntax definition consists of a constraint <with|mode|math|C> (if
  <with|mode|math|C> is not given, it is assumed
  <with|mode|math|<with|math-font-series|bold|true>>), a nonempty sequence
  <with|mode|math|e<rsub|1>\<ldots\>e<rsub|k>> of either terminals or types
  and of a type <with|mode|math|\<tau\>>. If all the elements are terminals:

  <\itemize>
    <item><with|mode|math|\<b-Gamma\><rsub|V>\<assign\>\<b-Gamma\><rsub|V>\<cup\>{name(e<rsub|1>\<ldots\>e<rsub|k>):\<tau\>}>

    <item><with|mode|math|C<rsub|c>\<assign\>C<rsub|c>\<wedge\>C>

    <item>the following grammar rule is created:

    <\equation*>
      <frac|e<rsub|1>\<ldots\>e<rsub|k>|(<with|math-font-series|bold|true>,\<tau\>)>
      <with|math-font-series|bold|true>
    </equation*>
  </itemize>

  When <with|mode|math|e<rsub|\<pi\>(1)>,\<ldots\>,e<rsub|\<pi\>(l)>> are
  types, <with|mode|math|e<rsub|\<pi\>(i)>=\<tau\><rsub|i>>, then:

  <\itemize>
    <item>a fresh type variable <with|mode|math|\<alpha\>> is picked, a
    keyword <with|mode|math|<with|math-font-series|bold|this>> refers to it
    in <with|mode|math|C>

    <item><with|mode|math|\<b-Gamma\><rsub|V>\<assign\>\<b-Gamma\><rsub|V>\<cup\>{name(e<rsub|1>\<ldots\>e<rsub|k>):\<alpha\>}>

    <item><with|mode|math|C<rsub|c>\<assign\>C<rsub|c>\<wedge\>{arg<rsub|1>,\<ldots\>,arg<rsub|l+1>,imag}:{arg<rsub|1>\<sim\>\<tau\><rsub|1>,\<ldots\>,arg<rsub|l>\<sim\>\<tau\><rsub|l>,imag\<sim\>\<tau\>}\<leq\>\<alpha\>>
    (actually, the system may introduce some more labels for secondary
    reasons)

    <item>the following grammar rule is created
    (<with|mode|math|\<cal-C\><rsub|1>\<ldots\>\<cal-C\><rsub|l>> and
    <with|mode|math|\<alpha\><rsub|1>\<ldots\>\<alpha\><rsub|l>> are
    metavariables):

    <\equation*>
      <frac|e<rsub|1>\<ldots\>(\<cal-C\><rsub|i>,\<alpha\><rsub|i>)<rsub|^\<pi\>(i)>\<ldots\>e<rsub|k>|(<wide|\<cal-C\>|\<vect\>>\<wedge\>(\<alpha\>\<leq\>{arg<rsub|1>\<sim\>\<alpha\><rsub|1>,\<ldots\>,arg<rsub|l>\<sim\>\<alpha\><rsub|l>}),\<tau\>)>
      C<rsub|c>\<wedge\><wide|\<cal-C\>|\<vect\>>\<wedge\>\<alpha\>\<leq\>{arg<rsub|1>\<sim\>\<alpha\><rsub|1>,\<ldots\>,arg<rsub|l>\<sim\>\<alpha\><rsub|l>}
    </equation*>
  </itemize>

  <subsubsection|Constructor and Function Syntax Definitions>

  The syntax definition consists of a list of variables
  <with|mode|math|\<beta\><rsub|1>\<ldots\>\<beta\><rsub|n>>, a constraint
  <with|mode|math|C>, a nonempty sequence
  <with|mode|math|e<rsub|1>\<ldots\>e<rsub|k>> of either terminals or types
  and of a type <with|mode|math|\<tau\>>. (It corresponds to a type scheme
  <with|mode|math|\<forall\><wide|\<beta\>|\<vect\>>:C.\<tau\>> or
  <with|mode|math|\<forall\><wide|\<beta\>|\<vect\>>\<alpha\>:C\<wedge\>\<alpha\>\<leq\>{arg<rsub|1>\<sim\>e<rsub|\<pi\>(1)>,\<ldots\>,arg<rsub|1>\<sim\>e<rsub|\<pi\>(l)>,arg<rsub|l+1>\<sim\>\<top\><rsub|type>,imag\<sim\>\<tau\>}.\<alpha\>>.)
  In the following, let <with|mode|math|name<rsub|D>> denote
  <with|mode|math|name<rsub|funct>> if it is function syntax definition and
  <with|mode|math|name<rsub|constr>> if it is constructor syntax definition.
  If all the elements are terminals:

  <\itemize>
    <item><with|mode|math|\<b-Gamma\><rsub|\<Sigma\>>\<assign\>\<b-Gamma\><rsub|\<Sigma\>>\<cup\>{name<rsub|D>(e<rsub|1>\<ldots\>e<rsub|k>):<with|mode|text|<with|mode|math|\<forall\><wide|\<beta\>|\<vect\>>:C.\<tau\>>>}>

    <item>the following grammar rule is created:

    <\equation*>
      <frac|e<rsub|1>\<ldots\>e<rsub|k>|(C[<wide|\<beta\><rprime|'>|\<vect\>>/<wide|\<beta\>|\<vect\>>],\<tau\>[<wide|\<beta\><rprime|'>|\<vect\>>/<wide|\<beta\>|\<vect\>>])>
      C<rsub|c>\<wedge\>C[<wide|\<beta\><rprime|'>|\<vect\>>/<wide|\<beta\>|\<vect\>>]<with|mode|text|
      where >\<beta\><rsub|1><rprime|'>,\<ldots\>,\<beta\><rsub|n><rprime|'><with|mode|text|
      are fresh>
    </equation*>
  </itemize>

  When <with|mode|math|e<rsub|\<pi\>(1)>,\<ldots\>,e<rsub|\<pi\>(l)>> are
  types, <with|mode|math|e<rsub|\<pi\>(i)>=\<tau\><rsub|i>>, then:

  <\itemize>
    <item>a fresh type variable <with|mode|math|\<alpha\>> is picked, a
    keyword <with|mode|math|<with|math-font-series|bold|this>> refers to it
    in <with|mode|math|C>

    <item><with|mode|math|\<b-Gamma\><rsub|\<Sigma\>>\<assign\>\<b-Gamma\><rsub|\<Sigma\>>\<cup\>{name<rsub|D>(e<rsub|1>\<ldots\>e<rsub|k>):\<forall\><wide|\<beta\>|\<vect\>>\<alpha\>:C<rprime|'>.\<alpha\>}>
    (actually, the system may introduce some more labels for secondary
    reasons)

    <item>the following grammar rule is created
    (<with|mode|math|\<cal-C\><rsub|1>\<ldots\>\<cal-C\><rsub|l>> and
    <with|mode|math|\<alpha\><rsub|1>\<ldots\>\<alpha\><rsub|l>> are
    metavariables):

    <\equation*>
      <frac|e<rsub|1>\<ldots\>(\<cal-C\><rsub|i>,\<alpha\><rsub|i>)<rsub|^\<pi\>(i)>\<ldots\>e<rsub|k>|(<wide|\<cal-C\>|\<vect\>>\<wedge\>C<rprime|'>[<wide|\<beta\><rprime|'>|\<vect\>>/<wide|\<beta\>|\<vect\>>,\<alpha\><rprime|'>/\<alpha\>]\<wedge\>(\<alpha\><rprime|'>\<leq\>{arg<rsub|1>\<sim\>\<alpha\><rsub|1>,\<ldots\>,arg<rsub|l>\<sim\>\<alpha\><rsub|l>}),\<tau\>[<wide|\<beta\><rprime|'>|\<vect\>>/<wide|\<beta\>|\<vect\>>])>
      \<phi\>
    </equation*>

    <with|mode|math|\<phi\>\<equiv\> C<rsub|c>\<wedge\><wide|\<cal-C\>|\<vect\>>\<wedge\>C<rprime|'>[<wide|\<beta\><rprime|'>|\<vect\>>/<wide|\<beta\>|\<vect\>>,\<alpha\><rprime|'>/\<alpha\>]\<wedge\>(\<alpha\><rprime|'>\<leq\>{arg<rsub|1>\<sim\>\<alpha\><rsub|1>,\<ldots\>,arg<rsub|l>\<sim\>\<alpha\><rsub|l>})<with|mode|text|
    where >\<alpha\><rprime|'>,\<beta\><rsub|1><rprime|'>,\<ldots\>,\<beta\><rsub|n><rprime|'><with|mode|text|
    are fresh>>
  </itemize>

  where <with|mode|math|C<rprime|'>=C\<wedge\>{arg<rsub|1>,\<ldots\>,arg<rsub|l+1>,imag}:{arg<rsub|1>\<sim\>\<tau\><rsub|1>,\<ldots\>,arg<rsub|1>\<sim\>\<tau\><rsub|l>,imag\<sim\>\<tau\>}\<leq\>\<alpha\>>.

  <subsection|Parsing as Derivation>

  Syntax rules as we introduced them perform type inference by themselves:
  type inference is done ``on-line'', during parsing. In the syntax system,
  some conditions are imposed by syntax and not types (namely arity), so the
  tentative proposition:

  <\proposition>
    If the type environment <with|mode|math|\<b-Gamma\><rsub|\<Sigma\>>> and
    type context <with|mode|math|\<b-Gamma\><rsub|V>> were defined by
    introducing the set of rules <with|mode|math|\<cal-R\>>, then every
    derivation tree under <with|mode|math|\<cal-R\>> with root
    <with|mode|math|(C,\<tau\>)> is isomorphic to a term <with|mode|math|e>
    such that <with|mode|math|W(\<b-Gamma\><rsub|\<Sigma\>>\<cup\>\<b-Gamma\><rsub|V>,e)=C,\<b-Gamma\><rsub|\<Sigma\>>\<cup\>\<b-Gamma\><rsub|V>\<vdash\>e:\<tau\>>
    (modulo renaming of type variables not occurring in
    <with|mode|math|\<b-Gamma\><rsub|\<Sigma\>>\<cup\>\<b-Gamma\><rsub|V>>),
    and for every term <with|mode|math|e> for which
    <with|mode|math|W(\<b-Gamma\><rsub|\<Sigma\>>\<cup\>\<b-Gamma\><rsub|V>,e)=C,\<b-Gamma\><rsub|\<Sigma\>>\<cup\>\<b-Gamma\><rsub|V>\<vdash\>e:\<tau\>>
    there is a derivation tree under <with|mode|math|\<cal-R\>> with root
    <with|mode|math|(C,\<tau\>)>.
  </proposition>

  is actually false, although not far from truth.

  <subsection|Bottom-Up Chart-Based Parsing>

  In bottom-up chart-based parsing, the rule application is done
  incrementally, by means of so called <em|active edges>, which set out
  requirements (still required syntax elements), to be fulfilled one by one.
  We could ``fire'' the rule constraints when an active edge is closed into
  <em|passive edge>, which has all requirements fulfilled, but this would be
  a tremendous loss of efficiency, since we cannot distinguish between
  nonterminals (they represent types, and we can only relate types by solving
  constraints). Fortunately, the system fits well into incremental solving,
  we can check functional type arguments one by one (like in ``curried'' type
  systems).

  Lets have a look at the two actions used by the parsing algorithm,
  <em|Predict> and <em|Combine>. Predict (assume, that <with|mode|math|A> is
  a nonterminal, the more difficult case):

  <\eqnarray*>
    <tformat|<table|<row|<cell|<frac|<left|langle>j,k:A<right|rangle>|<left|langle>j,k:B/<wide|\<beta\>|\<vect\>><right|rangle>>>|<cell|>|<cell|B\<rightarrow\>A<wide|\<beta\>|\<vect\>>>>>>
  </eqnarray*>

  means that from a passive edge spanning from <with|mode|math|j> to
  <with|mode|math|k> (denoting a substring parsed as nonterminal
  <with|mode|math|A>), given the grammar rule
  <with|mode|math|B\<rightarrow\>A<wide|\<beta\>|\<vect\>>>, we can derive an
  active edge spanning from <with|mode|math|j> to <with|mode|math|k> and
  still expecting syntax elements <with|mode|math|<wide|\<beta\>|\<vect\>>>.
  At this point, we check the following constraint:

  <\equation*>
    \<phi\>\<equiv\> C<rsub|c>\<wedge\>\<cal-C\><rsub|1>\<wedge\>C<rprime|'>[<wide|\<beta\><rprime|'>|\<vect\>>/<wide|\<beta\>|\<vect\>>,\<alpha\><rprime|'>/\<alpha\>]\<wedge\>(\<alpha\><rprime|'>\<leq\>{arg<rsub|1>\<sim\>\<alpha\><rsub|1>})<with|mode|text|
    where >\<alpha\><rprime|'>,\<beta\><rsub|1><rprime|'>,\<ldots\>,\<beta\><rsub|n><rprime|'><with|mode|text|
    are fresh>
  </equation*>

  with notations as introduced before, that is, here we have
  <with|mode|math|(\<cal-C\><rsub|1>,\<alpha\><rsub|1>)> matched against
  <with|mode|math|A>.

  The Combine action (again assume, that <with|mode|math|A> is a
  nonterminal):

  <\equation*>
    <frac|<tabular|<tformat|<table|<row|<cell|<left|langle>i,j:B/A<wide|\<beta\>|\<vect\>><right|rangle>>|<cell|>|<cell|<left|langle>j,k:A<right|rangle>>>>>>|<left|langle>i,k:B/<wide|\<beta\>|\<vect\>><right|rangle>>
  </equation*>

  means that we can extend an active edge when it resides by a passive edge
  with a matching nonterminal. Let <with|mode|math|A> correspond to the
  <with|mode|math|n>-th argument of the functional type that introduced
  <with|mode|math|B> at node <with|mode|math|i>. We check the following
  constraint:

  <\equation*>
    \<phi\>\<equiv\> \<phi\><rsub|0>\<wedge\>\<cal-C\><rsub|n>\<wedge\>(\<alpha\><rprime|'>\<leq\>{arg<rsub|n>\<sim\>\<alpha\><rsub|n>})
  </equation*>

  where <with|mode|math|\<phi\><rsub|0>> is the constraint introduced (and
  checked) when the <with|mode|math|i,j>-th edge was created,
  <with|mode|math|\<alpha\><rprime|'>> is the then-introduced variable, and
  <with|mode|math|(\<cal-C\><rsub|n>,\<alpha\><rsub|n>)> is matched against
  <with|mode|math|A>.

  <subsection|Approximating by Context-Free Grammars>

  The grammars we have defined can be approximated by over-ambiguous
  (complete, although not correct) context free grammars (CFGs) (that is,
  there are false parse trees, even bad sentences can be parseable, but all
  good sentences are parseable for sure). The amount of ambiguity the CFG
  introduces should be minimised. We look for an automatic way to generate a
  CFG corresponding to our grammar, with relatively low ambiguity. This is
  not possible in general.

  <\definition>
    A <em|context-free approximation> with respect to a label
    <with|mode|math|l> with <with|mode|math|kind(l)\<neq\>type>, is a
    grammar, which has all symbols of <with|mode|math|kind(l)> as
    nonterminals, for all <with|mode|math|s<rsub|1>\<leq\><rsub|kind(l)>s<rsub|2>>
    has productions <with|mode|math|s<rsub|2>\<rightarrow\>s<rsub|1>>, and
    for each syntax definition with a constraint <with|mode|math|C>, syntax
    elements <with|mode|math|e<rsub|1>\<ldots\>e<rsub|k>> and type
    <with|mode|math|\<tau\>>, the production
    <with|mode|math|s<rsub|\<tau\>>\<rightarrow\>A<rsub|1>\<ldots\>A<rsub|k>>
    is introduced, where for <with|mode|math|e<rsub|i>> terminal
    <with|mode|math|A<rsub|i>=e<rsub|i>>, and for
    <with|mode|math|e<rsub|i>=\<tau\><rsub|i>>,
    <with|mode|math|A<rsub|i>=s<rsub|i>>, where <with|mode|math|s<rsub|i>> is
    the smallest symbol for which <with|mode|math|C\<Vdash\>\<tau\><rsub|i>\<leq\>s<rsub|i>>,
    and <with|mode|math|s<rsub|\<tau\>>> is the largest symbol for which
    <with|mode|math|C\<Vdash\>s<rsub|\<tau\>>\<leq\>\<tau\>>.
  </definition>

  <section|Implementation Decisions>

  <\enumerate>
    <item>Kinds are not distinguished for top, bottom and variables. But
    label arguments are kind-checked during parsing, so ``runtime''
    (constraint-solving time) kind mismatches should be rare.

    <item>Constraint set is represented as a triple of mappings -- a pair of
    cascade mappings from variables to mappings from types (or type tuples
    for conditionals) to weights -- first mapping is for variables on left
    hand side of inequalities, second for right hand side variables; and a
    mapping from inequalities to weights, when neither side is a variable.

    <item>Label sets (e.g. weights and filters) and label maps (e.g. row
    expressions) are implemented as ordered lists.

    <item>Weight <with|mode|math|1> constraints are treated as equivalent to
    weight <with|mode|math|\<cal-L\>> constraints (and weight
    <with|mode|math|0> to weight <with|mode|math|\<varnothing\>>), so that no
    conversion is needed. Weights are factorized out of constraint variants,
    giving the language implemented:

    <\eqnarray*>
      <tformat|<table|<row|<cell|\<tau\>>|<cell|:\<assign\>>|<cell|\<alpha\>\|s<rsub|class>\|s<rsub|int>\|{l\<sim\>\<tau\>,\<ldots\>,l\<sim\>\<tau\>}>>|<row|<cell|C>|<cell|:\<assign\>>|<cell|C\<wedge\>C\|<with|math-font-series|bold|true>\|<with|math-font-series|bold|false>>>|<row|<cell|>|<cell|>|<cell|\|W:\<tau\>\<leq\>\<tau\>>>|<row|<cell|>|<cell|>|<cell|\|s\<leq\>\<tau\>\<wedge\>\<ldots\>\<wedge\>s\<leq\>\<tau\>?W:\<tau\>\<leq\>\<tau\>>>|<row|<cell|W>|<cell|:\<assign\>>|<cell|L\|Compl(L)>>>>
    </eqnarray*>

    <item>As the closure is not closed w.r.t. feature sets, we can altogether
    resign from keeping them in the constraint set.

    <item>The closure algorithm simplifies:

    <\definition>
      Algorithm <with|mode|math|Closure(C<rsub|0>)> (as implemented). TODO:
      FIXME: multi-premise conditionals must check all premises!!!

      <\FUNDEF|Insert|<with|mode|math|c> is <with|mode|math|L:e> or c is
      <with|mode|math|s<rsub|1>\<leq\>\<tau\><rsub|1>\<wedge\>\<ldots\>\<wedge\>s<rsub|n>\<leq\>\<tau\><rsub|n>?L:e<rprime|'>>>
        <\STATE>
          <with|mode|math|L<rsub|1>\<assign\>L\\C(e)>
        </STATE>

        <\IF-NO-ELSE|<with|mode|math|L<rsub|1>\<neq\>\<varnothing\>>>
          <\STATE>
            <with|mode|math|C(e)\<leftarrow\>L\<cup\>C(e)>
          </STATE>

          <\STATE>
            <with|mode|math|Q\<leftarrow\>Q,L<rsub|1>:e>
          </STATE>
        </IF-NO-ELSE>

        <htab|5mm>
      </FUNDEF>

      <\FUNDEF|Process|<with|mode|math|L<rsub|1>:\<tau\><rsub|1>\<leq\>\<alpha\>>>
        <\FORALL>
          <\STATE>
            <with|mode|math|Insert(L<rsub|1>\<cap\>L<rsub|2>:\<tau\><rsub|1>\<leq\>\<tau\><rsub|2>)>
          </STATE>
        </FORALL|<with|mode|math|\<tau\><rsub|2>:C(\<alpha\>\<leq\>\<tau\><rsub|2>)=L<rsub|2>\<neq\>\<varnothing\>>>

        <\FORALL>
          <\STATE>
            <with|mode|math|Insert(s<rsub|1>\<leq\>\<tau\><rsub|1><rprime|'>\<wedge\>\<ldots\>\<wedge\>s<rsub|n-1>\<leq\>\<tau\><rsub|n-1><rprime|'>\<wedge\>s<rsub|n>\<leq\>\<tau\><rsub|1>?L:\<tau\>\<leq\>\<tau\><rprime|'>)>
          </STATE>
        </FORALL|<with|mode|math|C(s<rsub|1>\<leq\>\<tau\><rsub|1><rprime|'>,\<ldots\>,s<rsub|n-1>\<leq\>\<tau\><rsub|n-1><rprime|'>\<wedge\>s<rsub|n>\<leq\>\<alpha\>?\<tau\>\<leq\>\<tau\><rprime|'>)=L<rsub|2>\<neq\>\<varnothing\>>>
      </FUNDEF>

      <\FUNDEF|Process|<with|mode|math|L<rsub|2>:\<alpha\>\<leq\>\<tau\><rsub|2>>>
        <\FORALL>
          <\STATE>
            <with|mode|math|Insert(L<rsub|1>\<cap\>L<rsub|2>:\<tau\><rsub|1>\<leq\>\<tau\><rsub|2>)>
          </STATE>
        </FORALL|<with|mode|math|\<tau\><rsub|1>:C(\<tau\><rsub|1>\<leq\>\<alpha\>)=L<rsub|1>\<neq\>\<varnothing\>>>
      </FUNDEF>

      <\FUNDEF|Process|<with|mode|math|\<b-1\>:s<rsub|1>\<leq\>s<rsub|2>>>
        <\IF-NO-ELSE|<with|mode|math|s<rsub|1>\<nleq\>s<rsub|2>>>
          <\STATE>
            fail
          </STATE>
        </IF-NO-ELSE>

        <\IF-NO-ELSE|<with|mode|math|s<rsub|1>\<in\>\<cal-S\><rsub|\<kappa\>>,s<rsub|2>\<in\>\<cal-S\><rsub|\<kappa\><rprime|'>>,\<kappa\>\<neq\>\<kappa\><rprime|'>>>
          <\STATE>
            fail (kind mismatch)
          </STATE>
        </IF-NO-ELSE>

        \;
      </FUNDEF>

      <\FUNDEF|Process|<with|mode|math|L:s<rsub|1>\<leq\>s<rsub|2>> where
      <with|mode|math|L\<neq\>\<b-1\>>>
        <\STATE>
          fail (kind mismatch)
        </STATE>
      </FUNDEF>

      <\FUNDEF|Process|<with|mode|math|L:{l<rsub|1>\<sim\>\<tau\><rsub|1>,\<ldots\>,l<rsub|n>\<sim\>\<tau\><rsub|n>}\<leq\>{l<rprime|'><rsub|1>\<sim\>\<tau\><rprime|'><rsub|1>,\<ldots\>,l<rprime|'><rsub|m>\<sim\>\<tau\><rprime|'><rsub|m>}>>
        <\FORALL>
          <\STATE>
            <with|mode|math|Insert(\<tau\><rsub|i>\<leq\><rsup|var(l)>\<tau\><rprime|'><rsub|j>)>
          </STATE>
        </FORALL|<with|mode|math|l=l<rsub|i>=l<rprime|'><rsub|j>\<in\>L\<cap\>{l<rsub|1>,\<ldots\>,l<rsub|n>}\<cap\>{l<rprime|'><rsub|1>,\<ldots\>,l<rprime|'><rsub|m>}>>

        <\FORALL>
          <\STATE>
            <with|mode|math|Insert(\<top\><rsup|var(l)><rsub|kind(l)>\<leq\><rsup|var(l)>\<tau\><rprime|'><rsub|j>)>
          </STATE>
        </FORALL|<with|mode|math|l=l<rprime|'><rsub|j>\<in\>(L\<cap\>{l<rprime|'><rsub|1>,\<ldots\>,l<rprime|'><rsub|m>})\\{l<rsub|1>,\<ldots\>,l<rsub|n>}>>
      </FUNDEF>

      <\FUNDEF|Process|<with|mode|math|s<rsub|1>\<leq\>\<tau\><rsub|1>,\<ldots\>,s<rsub|n>\<leq\>\<alpha\>?L:\<tau\>\<leq\>\<tau\><rprime|'>>>
        <\FORALL>
          <\STATE>
            <with|mode|math|Insert(s<rsub|1>\<leq\>\<tau\><rsub|1>,\<ldots\>,s<rsub|n>\<leq\>\<tau\><rsub|n>?L:\<tau\>\<leq\>\<tau\><rprime|'>)>
          </STATE>
        </FORALL|<with|mode|math|\<tau\><rsub|n>:C(\<tau\><rsub|n>\<leq\>\<alpha\>)=1>>
      </FUNDEF>

      <\FUNDEF|Process|<with|mode|math|s<rsub|1>\<leq\>\<tau\><rsub|1>,\<ldots\>,s<rsub|n>\<leq\>s<rprime|'>?L:\<tau\>\<leq\>\<tau\><rprime|'>>>
        <\STATE>
          <\IF-NO-ELSE|<with|mode|math|s<rsub|n>\<leq\>s<rprime|'>>>
            <\IF|<with|mode|math|n=1>>
              <\STATE>
                <with|mode|math|Insert(L:\<tau\>\<leq\>\<tau\><rprime|'>)>
              </STATE>
            <|IF>
              <\STATE>
                <with|mode|math|Insert(s<rsub|1>\<leq\>\<tau\><rsub|1>\<wedge\>\<ldots\>\<wedge\>s<rsub|n-1>\<leq\>\<tau\><rsub|n-1>?L:\<tau\>\<leq\>\<tau\><rprime|'>)>
              </STATE>
            </IF>
          </IF-NO-ELSE>
        </STATE>

        \;
      </FUNDEF>

      <\FUNDEF|Closure|<with|mode|math|C<rsub|0>>>
        <\STATE>
          <with|mode|math|C\<leftarrow\><with|math-font-series|bold|true>>
        </STATE>

        <\STATE>
          <with|mode|math|Q\<leftarrow\>\<varnothing\>>
        </STATE>

        <FORALL|<\IF|<with|mode|math|c=<with|math-font-series|bold|false>>>
          <\STATE>
            fail
          </STATE>
        <|IF>
          <\STATE>
            <with|mode|math|Insert(c)>
          </STATE>
        </IF>|<with|mode|math|c\<in\>C<rsub|0>>>

        <\WHILE>
          <\STATE>
            extract <with|mode|math|c> out of <with|mode|math|Q>
          </STATE>

          <\STATE>
            <with|mode|math|Process(c)>
          </STATE>
        </WHILE|<with|mode|math|Q\<neq\>\<varnothing\>>>
      </FUNDEF>
    </definition>

    <htab|5mm>
  </enumerate>
</body>

<\initial>
  <\collection>
    <associate|language|english>
    <associate|page-medium|papyrus>
  </collection>
</initial>

<\references>
  <\collection>
    <associate|auto-1|<tuple|<uninit>|1>>
    <associate|auto-10|<tuple|1.5|6>>
    <associate|auto-11|<tuple|2|7>>
    <associate|auto-12|<tuple|2.1|7>>
    <associate|auto-13|<tuple|2.1.1|7>>
    <associate|auto-14|<tuple|2.1.2|7>>
    <associate|auto-15|<tuple|2.1.3|7>>
    <associate|auto-16|<tuple|2.2|7>>
    <associate|auto-17|<tuple|2.2.1|8>>
    <associate|auto-18|<tuple|2.3|8>>
    <associate|auto-19|<tuple|2.3.1|9>>
    <associate|auto-2|<tuple|1|1>>
    <associate|auto-20|<tuple|2.3.2|9>>
    <associate|auto-21|<tuple|2.3.3|9>>
    <associate|auto-22|<tuple|2.3.4|9>>
    <associate|auto-23|<tuple|3|9>>
    <associate|auto-24|<tuple|3.1|9>>
    <associate|auto-25|<tuple|3.1.1|10>>
    <associate|auto-26|<tuple|3.2|10>>
    <associate|auto-27|<tuple|3.2.1|10>>
    <associate|auto-28|<tuple|3.2.2|11>>
    <associate|auto-29|<tuple|3.3|11>>
    <associate|auto-3|<tuple|1.1|1>>
    <associate|auto-30|<tuple|3.4|11>>
    <associate|auto-31|<tuple|3.5|12>>
    <associate|auto-32|<tuple|4|12>>
    <associate|auto-4|<tuple|1.2|2>>
    <associate|auto-5|<tuple|1.3|2>>
    <associate|auto-6|<tuple|1.3.1|3>>
    <associate|auto-7|<tuple|1.4|3>>
    <associate|auto-8|<tuple|1.4.1|4>>
    <associate|auto-9|<tuple|1.4.2|4>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|Table
      of contents> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-1><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|1<space|2spc>Types
      Logic> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-2><vspace|0.5fn>

      <with|par-left|<quote|1.5fn>|1.1<space|2spc>Informal Introduction
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-3>>

      <with|par-left|<quote|1.5fn>|1.2<space|2spc>Type Algebra
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-4>>

      <with|par-left|<quote|1.5fn>|1.3<space|2spc>Type Logic: Constraints
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-5>>

      <with|par-left|<quote|3fn>|1.3.1<space|2spc>Logical Interpretation
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-6>>

      <with|par-left|<quote|1.5fn>|1.4<space|2spc>Checking Satisfiability of
      Constraints <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-7>>

      <with|par-left|<quote|3fn>|1.4.1<space|2spc>Closing Constraints
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-8>>

      <with|par-left|<quote|3fn>|1.4.2<space|2spc>The Algorithm
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-9>>

      <with|par-left|<quote|1.5fn>|1.5<space|2spc>Differences with ``A
      Constraint-Based Presentation and Generalization of Rows'' by Francois
      Pottier <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-10>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|2<space|2spc>Terms
      and Types> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-11><vspace|0.5fn>

      <with|par-left|<quote|1.5fn>|2.1<space|2spc>Preliminaries
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-12>>

      <with|par-left|<quote|3fn>|2.1.1<space|2spc>Untyped Terms
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-13>>

      <with|par-left|<quote|3fn>|2.1.2<space|2spc>Typing Judgements
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-14>>

      <with|par-left|<quote|3fn>|2.1.3<space|2spc>Term Algebra
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-15>>

      <with|par-left|<quote|1.5fn>|2.2<space|2spc>The Type System
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-16>>

      <with|par-left|<quote|3fn>|2.2.1<space|2spc>Typing Judgement
      Reconstruction <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-17>>

      <with|par-left|<quote|1.5fn>|2.3<space|2spc>The Speagram Language
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-18>>

      <with|par-left|<quote|3fn>|2.3.1<space|2spc>Type Definitions
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-19>>

      <with|par-left|<quote|3fn>|2.3.2<space|2spc>Closing Type Schemes
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-20>>

      <with|par-left|<quote|3fn>|2.3.3<space|2spc>Rewrite Rule Definitions
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-21>>

      <with|par-left|<quote|3fn>|2.3.4<space|2spc>Novelties and Differences
      with ``Syntactic Properties of Polymorphic Subtyping'' by Henglein
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-22>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|3<space|2spc>Constraint-Based
      Rule Selection Grammars> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-23><vspace|0.5fn>

      <with|par-left|<quote|1.5fn>|3.1<space|2spc>Rule-Based Grammars
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-24>>

      <with|par-left|<quote|3fn>|3.1.1<space|2spc>Typability-Based Rule
      Selection <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-25>>

      <with|par-left|<quote|1.5fn>|3.2<space|2spc>Syntax Definitions
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-26>>

      <with|par-left|<quote|3fn>|3.2.1<space|2spc>Variable Syntax Definitions
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-27>>

      <with|par-left|<quote|3fn>|3.2.2<space|2spc>Constructor and Function
      Syntax Definitions <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-28>>

      <with|par-left|<quote|1.5fn>|3.3<space|2spc>Parsing as Derivation
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-29>>

      <with|par-left|<quote|1.5fn>|3.4<space|2spc>Bottom-Up Chart-Based
      Parsing <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-30>>

      <with|par-left|<quote|1.5fn>|3.5<space|2spc>Approximating by
      Context-Free Grammars <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-31>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|4<space|2spc>Implementation
      Decisions> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-32><vspace|0.5fn>
    </associate>
  </collection>
</auxiliary>