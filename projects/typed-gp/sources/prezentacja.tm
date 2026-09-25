<TeXmacs|1.0.5.4>

<style|seminar>

<\body>
  <doc-data|<doc-title|Programowanie Genetyczne w j¦zykach
  typizowanych>|<doc-subtitle|Jak jest mo»liwe?>|<doc-author-data|<author-name|Šukasz
  Stafiniak>|<\author-address>
    promotor dr Zdzisªaw Spªawski
  </author-address>>>

  <\table-of-contents|toc>
    <vspace*|1fn><with|font-series|bold|math-font-series|bold|Spis tre±ci>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-1><vspace|0.5fn>

    <vspace*|1fn><with|font-series|bold|math-font-series|bold|Programowanie
    genetyczne> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-2><vspace|0.5fn>

    <with|par-left|1.5fn|Technologia algorytmów genetycznych
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-3>>

    <with|par-left|1.5fn|Zastosowania poza PG
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-4>>

    <vspace*|1fn><with|font-series|bold|math-font-series|bold|Generowanie
    termów> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-5><vspace|0.5fn>

    <with|par-left|1.5fn|Struktura przestrzeni przeszukiwa«
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-6>>

    <with|par-left|1.5fn|Systemy typów z wi¦zami lub/i rekurencj¡
    polimorficzn¡ <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-7>>

    <with|par-left|3fn|Techniki inferencji typu
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-8>>

    <with|par-left|3fn|Specyfikacja systemów typów generuj¡ca wi¦zy
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-9>>

    <with|par-left|6fn|<with|mode|math|HM(X)>.
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-10><vspace|0.15fn>>

    <with|par-left|6fn|<with|mode|math|HMG<rsub|nr>(X)>.
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-11><vspace|0.15fn>>

    <with|par-left|6fn|MM. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-12><vspace|0.15fn>>

    <with|par-left|6fn|<with|mode|math|HMG<rsub|r>(X)>.
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-13><vspace|0.15fn>>

    <with|par-left|1.5fn|Semi-unifikacja <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-14>>

    <with|par-left|3fn|Algorytm semi-unifikacji
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-15>>

    <vspace*|1fn><with|font-series|bold|math-font-series|bold|Bibliografia>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-16><vspace|0.5fn>
  </table-of-contents>

  <new-page>

  \;

  <section|Programowanie genetyczne>

  Inspiracje biologiczne:

  <\enumerate>
    <item>Ewolucja poprzez selekcj¦ dostosowanych osobników.

    <item>Eksploracja przez drobne przypadkowe mutacje.

    <item>Rekombinacja mo»e prowadzi¢ do selekcji na poziomie jednostek
    funkcjonalnych -- genów.
  </enumerate>

  \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ <block*|<tformat|<table|<row|<cell|osobnik
  = program>>>>>

  \;

  Problemy techniczne:

  <\enumerate>
    <item>Operatory genetyczne powinny tworzy¢ poprawne programy, które mo»na
    podda¢ ocenie.

    <item>Koszt oceny mo»e by¢ wysoki, dlatego nale»y wyeliminowa¢
    konstrukcje nierozs¡dne.

    <item>Rekombinacja powinna zachowywa¢ wspólny kontekst wymienianych
    fragmentów <with|font-base-size|7|aby prowadzi¢ do emergencji genów.>
  </enumerate>

  Rozwi¡zania:

  <\enumerate>
    <item>Generowa¢ programy poprawnie otypowane.

    <item>System typów zapewniaj¡cy zachodzenie warunków z dziedziny
    problemu.

    <item>Oprze¢ rekombinacj¦ na generalizacji.
  </enumerate>

  <new-page>

  \;

  <subsection|Technologia algorytmów genetycznych>

  Zbiór mo»liwych rozwi¡za«: <with|mode|math|X>

  Funkcja dostosowania: <with|mode|math|f:X\<rightarrow\>[0,\<infty\>)>

  Populacja: proces stochastyczny <with|mode|math|\<cal-P\><rsub|t>>

  <\equation*>
    \<cal-P\><rsub|t>(\<omega\>)\<subset\>X,t\<in\>\<cal-N\>
  </equation*>

  Operatory genetyczne:

  <\enumerate>
    <item>Operator kreacji: zmienna losowa <with|mode|math|\<cal-C\>> o
    warto±ciach w <with|mode|math|X>

    <\equation*>
      \<cal-P\><rsub|0>=\<cal-C\><rsup|n>
    </equation*>

    <item>Operator mutacji: 1-argumentowa funkcja losowa <with|mode|math|M>,
    operator przeszukiwania lokalnego

    <\eqnarray*>
      <tformat|<table|<row|<cell|>|<cell|(\<forall\>p,p<rsub|1>,p<rsub|2>\<in\>X)d(p,p<rsub|1>)\<less\>d(p,p<rsub|2>)>|<cell|>>|<row|<cell|>|<cell|<with|mode|text|<with|mode|math|\<Rightarrow\>P(M(p)=p<rsub|1>)\<gtr\>P(M(p)=p<rsub|2>)>>>|<cell|>>>>
    </eqnarray*>

    <item>Operator rekombinacji: 2-argumentowa funkcja losowa
    <with|mode|math|R:X<rsup|2>\<rightarrow\>X>
  </enumerate>

  Strategia algorytmu genetycznego to (losowa b¡d¹ nie) funkcja przej±cia
  <with|mode|math|G<rsub|t>:\<cal-P\><rsub|t+1>=G<rsub|t>(\<cal-P\><rsub|t>)>

  <\equation*>
    G<rsub|t>(P)=(M(\<cal-F\><rsub|<rsub|M>t,P>))<rsup|k<rsub|t>>\<cup\>(R(\<cal-F\><rsub|<rsub|R>t,P><rsup|2>))<rsup|l<rsub|t>>\<cup\>(\<cal-F\><rsub|<rsub|E>t,P>)<rsup|m<rsub|t>>
  </equation*>

  gdzie <with|mode|math|\<cal-F\><rsub|<rsub|M>t,P>,\<cal-F\><rsub|<rsub|R>t,P>,\<cal-F\><rsub|<rsub|E>t,P>>
  s¡ zmiennymi losowymi na <with|mode|math|P> takimi, »e
  <with|mode|math|\<forall\>p<rsub|1>,p<rsub|2>\<in\>P>

  <\equation*>
    f(p<rsub|1>)\<less\>f(p<rsub|2>)\<Rightarrow\>P(\<cal-F\><rsub|<rsub|\<ast\>>P>=p<rsub|1>)\<leqslant\>P(\<cal-F\><rsub|<rsub|\<ast\>>P>=p<rsub|2>)
  </equation*>

  <with|font-base-size|7|Dla dowolnej zmiennej losowej
  <with|mode|math|\<cal-F\>>, <with|mode|math|\<cal-F\><rsup|n>> oznacza
  <with|mode|math|n> niezale»nych kopii <with|mode|math|\<cal-F\>>, tzn.
  <with|mode|math|n> niezale»nych zmiennych losowych o rozkªadach równych
  rozkªadowi <with|mode|math|\<cal-F\>>.><new-page>

  \;

  <subsection|Zastosowania poza PG>

  <\enumerate>
    <item>Mechanizm generowania termów pozwoli na zastosowanie równie» innych
    ni» PG strategii przeszukiwa« (metaheurystyk).

    <item>Rozwi¡zanie problemu generowania termu wymaga rozwi¡zania problemu
    inferencji typu; w pracy wyniknie zadanie badawcze o du»ym znaczeniu dla
    j¦zyków programowania.

    <item>Techniki generalizacji maj¡ szerokie spektrum zastosowa« w
    indukcyjnym wnioskowaniu i syntezie indukcyjnej (i ogólnie w sztucznej
    inteligencji).
  </enumerate>

  <new-page>

  \;

  <section|Generowanie termów>

  <subsection|Struktura przestrzeni przeszukiwa«>

  <with|font-series|bold|Przestrzeni¡ przeszukiwa«>
  <with|mode|math|\<Omega\>> nazwiemy okre±lon¡ syntaktycznie klas¦ termów
  nad j¦zykiem problemu poszerzonym o meta-zmienne, z porz¡dkiem subsumpcji
  -- podstawienia pod meta-zmienne:

  <\eqnarray*>
    <tformat|<table|<row|<cell|\<omega\><rsub|1>\<leqslant\>\<omega\><rsub|2>>|<cell|\<equiv\>>|<cell|(\<exists\>R)R\<omega\><rsub|1>=\<omega\><rsub|2>,>>>>
  </eqnarray*>

  modulo przemianowanie zmiennych, <with|font-base-size|7|tzn.
  <with|mode|math|\<Omega\>> zawiera klasy abstrakcji.> Elementy
  <with|mode|math|\<Omega\>> nazywamy <with|font-series|bold|metatermami>.

  <with|font-series|bold|Drzewem przeszukiwa«> nazwiemy podzbiór
  <with|mode|math|D\<subset\>\<Omega\>> o wªasno±ci:

  <\equation*>
    (\<forall\>\<omega\>\<in\>\<Omega\>)(\<exists\>\<omega\><rprime|'>\<in\>D)\<omega\>\<leqslant\>\<omega\><rprime|'>\<Rightarrow\>\<omega\>\<in\>D
  </equation*>

  Ustalmy pewien system typów na bazie ML <with|font-base-size|7|(patrz
  nast¦pny podrozdziaª)>.

  <with|font-series|bold|Problemem generowania termu> (albo problemem
  <with|font-series|bold|niepusto±ci typu>) nazywamy par¦
  <with|mode|math|\<Gamma\>,\<sigma\>>, gdzie <with|mode|math|\<Gamma\>> jest
  ±rodowiskiem (przypisaniem typów, zbiorem par zmienna - schemat typu),
  <with|mode|math|\<sigma\>> -- schematem typu, <with|mode|math|C> -- wi¦zem,
  oraz zadanie znalezienia programu <with|mode|math|e> i wyprowadzenia dla
  <with|mode|math|\<Gamma\>\<vdash\>e:\<sigma\>>, <with|font-base-size|7|albo
  dla odpowiadaj¡cego mu s¡du typizuj¡cego zawieraj¡cego typ zamiast schematu
  typu>.

  <with|font-series|bold|Drzewem problemu
  <with|mode|math|\<Gamma\>,\<sigma\>>> nazywamy: drzewo przeszukiwa«,
  którego li±ciami b¦d¡cymi elementami maksymalnymi w
  <with|mode|math|\<Omega\>> s¡ rozwi¡zania problemu
  <with|mode|math|\<Gamma\>,\<sigma\>>; wraz z dodatkow¡ informacj¡
  pozwalaj¡c¡ odtworzy¢ wyprowadzenie.

  \;

  <with|font-series|bold|Zadanie badawcze 1>. W badanych systemach typów, dla
  jakich elementów <with|mode|math|\<Omega\>> mo»na okre±li¢, »e nie ma nad
  nimi rozwi¡za« problemu generowania termu, bez ekstensywnego
  przeszukiwania? Tzw. <with|font-series|bold|sprzeczne metatermy>.<new-page>

  \;

  <subsection|Systemy typów z wi¦zami lub/i rekurencj¡ polimorficzn¡>

  Niech <with|mode|math|X> b¦dzie j¦zykiem (dziedzin¡) wi¦zów. Rozwa»ymy
  systemy typów:

  <\enumerate>
    <item><with|mode|math|HM(X)> (patrz <cite|sulzmann99>): system bez
    rekurencji z wi¦zami

    <item><with|mode|math|HMG<rsub|nr>(X)> (patrz
    <cite|simonet03constraintbased>): system bez rekurencji z GADT

    <item>MM (patrz <cite|henglein93type>): system z rekurencj¡ polimorficzn¡
    bez wi¦zów

    <item><with|mode|math|HMG<rsub|r>(X)>: system <with|mode|math|HMG(X)> (z
    GADT i rekurencj¡ polimorficzn¡) bez annotacji typu def. rekurencyjnej
  </enumerate>

  Dobrana dla danego problemu dziedzina wi¦zów razem ze struktur¡ funkcyjn¡
  oraz (w przypadku GADT) typami algebraicznymi pozwala na wyra»anie warunków
  z dziedziny problemu: dla problemu <with|mode|math|\<Gamma\>,\<sigma\>>,
  <with|mode|math|\<Gamma\>> specyfikuje warunki lokalne, a
  <with|mode|math|\<sigma\>> wyra»a specyfikacj¦ celu. Bez GADT mo»na
  warunkowa¢ tylko struktur¦ programu, z GADT równie» \Rzachowanie''
  programu.<new-page>

  <subsubsection|Techniki inferencji typu>

  <\enumerate>
    <item>W stylu algorytmu <with|mode|math|\<cal-W\>>: algorytm generuj¡c
    wi¦zy na bie»¡co je normalizuje (tzn. rozwi¡zuje na ile to mo»liwe) i
    uzyskane podstawienie aplikuje przed dalszymi wywoªaniami rekurencyjnymi

    <item>W stylu bazuj¡cym na wi¦zach: algorytm redukuje problem inferencji
    w caªo±ci do problemu rozstrzygania wi¦zów (nie normalizuje ani nie
    oblicza rozwi¡za« cz¡stkowych)
  </enumerate>

  Algorytmy w stylu bazuj¡cym na wi¦zach s¡ bardziej eleganckie -- uwypuklaj¡
  struktur¦ logiczn¡ problemu. Ale my potrzebujemy rozwi¡zania
  inkrementacyjnie buduj¡cego otypowanie, aby dokonywa¢ nawrotów w drzewie
  przeszukiwa« (i to mo»liwie wcze±nie).

  <with|font-series|bold|Zadanie badawcze 2>. Opracowa¢ inkrementacyjne
  \Rconstraint solvery'' dla potrzebnych dziedzin wi¦zów.

  <subsubsection|Specyfikacja systemów typów generuj¡ca wi¦zy>

  Ogólny \Rlogiczny'' system typów sprowadza si¦ do systemu sterowanego
  skªadni¡ (równowa»no±¢ pokazuje si¦ przez normalizacj¦
  wyprowadze«-dowodów). Odpowiednio \Rpreparuj¡c'' taki zbiór regóª uzyskuje
  si¦ sformuªowanie algorytmu w stylu <with|mode|math|\<cal-W\>> (patrz
  <cite|sulzmann99>). Je±li wyraziªo si¦ zale»no±ci typów w j¦zyku wi¦zów,
  bardzo ªatwo przeksztaªci¢ go w algorytm redukuj¡cy do wi¦zu.

  <paragraph|<with|mode|math|HM(X)>.>Algorytm podany w <cite|sulzmann99> jest
  w stylu <with|mode|math|\<cal-W\>>.

  <paragraph|<with|mode|math|HMG<rsub|nr>(X)>.>Przedstawimy uproszczon¡
  wersj¦ algorytmu, przez rezygnacj¦ z gª¦bokich wzorców, zb¦dnych w
  przypadku PG, i zast¡pienie ich konstrukcj¡ <with|mode|math|case>
  (abstrakcja wraca do standardowej postaci).
  <with|mode|math|\<preccurlyeq\>> jest relacj¡ podtypowania wbudowan¡ w
  <with|mode|math|X> (mo»e np. by¢ zwykª¡ syntaktyczn¡ równo±ci¡).

  <\with|font-base-size|7>
    \;

    <\eqnarray*>
      <tformat|<table|<row|<cell|\<langle\>\<Gamma\>\<vdash\>x:\<tau\>\<rangle\>>|<cell|=>|<cell|\<Gamma\>(x)\<preccurlyeq\>\<tau\>>>|<row|<cell|\<langle\>\<Gamma\>\<vdash\>\<lambda\>x.e:\<tau\>\<rangle\>>|<cell|=>|<cell|\<exists\>\<alpha\><rsub|1>\<alpha\><rsub|2>.(\<langle\>\<Gamma\>{x:\<alpha\><rsub|1>}\<vdash\>e:\<alpha\><rsub|2>\<rangle\>\<wedge\>\<alpha\><rsub|1>\<rightarrow\>\<alpha\><rsub|2>\<preccurlyeq\>\<tau\>)>>|<row|<cell|\<langle\>\<Gamma\>\<vdash\>e<rsub|1>
      e<rsub|2>:\<tau\>\<rangle\>>|<cell|=>|<cell|\<exists\>\<alpha\>.(\<langle\>\<Gamma\>\<vdash\>e<rsub|1>:\<alpha\>\<rightarrow\>\<tau\>\<rangle\>\<wedge\>\<langle\>\<Gamma\>\<vdash\>e<rsub|2>:\<alpha\>\<rangle\>)>>|<row|<cell|\<langle\>\<Gamma\>\<vdash\>K
      e<rsub|1>\<ldots\>e<rsub|n>:\<tau\>\<rangle\>>|<cell|=>|<cell|\<exists\><wide|\<alpha\>|\<vect\>><wide|\<beta\>|\<vect\>>.(\<wedge\><rsub|i>\<langle\>\<Gamma\>\<vdash\>e<rsub|i>:\<tau\><rsub|i>\<rangle\>\<wedge\>D\<wedge\>\<varepsilon\>(<wide|\<alpha\>|\<vect\>>)\<preccurlyeq\>\<tau\>)<with|mode|text|
      gdzie >K::\<forall\><wide|\<alpha\>|\<vect\>><wide|\<beta\>|\<vect\>>[D].(\<tau\><rsub|i>)<rsub|1><rsup|n>\<rightarrow\>\<varepsilon\>(<wide|\<alpha\>|\<vect\>>)>>|<row|<cell|\<langle\>\<Gamma\>\<vdash\>e:\<forall\><wide|\<gamma\>|\<vect\>>[C].\<tau\>\<rangle\>>|<cell|=>|<cell|\<forall\><wide|\<gamma\>|\<vect\>>.C\<Rightarrow\>\<langle\>\<Gamma\>\<vdash\>e:\<tau\>\<rangle\>>>|<row|<cell|\<langle\>\<Gamma\>\<vdash\>let
      x=e<rsub|1> in e<rsub|2>:\<tau\>\<rangle\>>|<cell|=>|<cell|\<langle\>\<Gamma\>{\<forall\>\<alpha\>[C].\<alpha\>}\<vdash\>e<rsub|2>:\<tau\>\<rangle\>\<wedge\>\<exists\>\<alpha\>.C<with|mode|text|
      gdzie >C<with|mode|text| jest >\<langle\>\<Gamma\>\<vdash\>e<rsub|1>:\<alpha\>\<rangle\>>>|<row|<cell|\<langle\>\<Gamma\>\<vdash\>case
      e<rsub|0> of {K<rsub|1>\<Rightarrow\>e<rsub|1>\|\<ldots\>\|K<rsub|n>\<Rightarrow\>e<rsub|n>}:\<tau\>\<rangle\>>|<cell|=>|<cell|\<exists\><wide|\<alpha\>|\<vect\>>\<gamma\>(\<delta\><rsub|i>)<rsub|1><rsup|n>.(\<varepsilon\>(<wide|\<alpha\>|\<vect\>>)\<preccurlyeq\>\<gamma\>\<wedge\>\<langle\>\<Gamma\>\<vdash\>e<rsub|0>:\<gamma\>\<rangle\>\<wedge\><rsub|i>\<forall\><wide|\<beta\>|\<vect\>><rsub|i>.D<rsub|i>\<Rightarrow\>\<langle\>\<Gamma\>\<vdash\>e<rsub|i>:\<delta\><rsub|i>\<rangle\>\<wedge\>\<delta\><rsub|i>\<preccurlyeq\><wide|\<tau\>|\<vect\>><rsub|i>\<rightarrow\>\<varepsilon\>(<wide|\<alpha\>|\<vect\>>))<with|mode|text|
      gdzie >K<rsub|i>::\<forall\><wide|\<alpha\>|\<vect\>><wide|\<beta\>|\<vect\>><rsub|i>[D].<wide|\<tau\>|\<vect\>><rsub|i>\<rightarrow\>\<varepsilon\>(<wide|\<alpha\>|\<vect\>>)>>>>
    </eqnarray*>
  </with>

  <new-page>

  \;

  <paragraph|MM.>Przedstawimy system typów pierwszego rz¦du \Rgeneruj¡cy''
  wi¦zy.

  <\eqnarray*>
    <tformat|<table|<row|<cell|(TAU)>|<cell|<frac||A{x:\<tau\>},<wide|\<tau\>|\<vect\>>\<vdash\>x:\<tau\><rprime|'>>>|<cell|(\<tau\>,<wide|\<tau\>|\<vect\>>)\<leq\>(\<tau\><rprime|'>,<wide|\<tau\>|\<vect\>>)>>|<row|<cell|>|<cell|>|<cell|>>|<row|<cell|(ABS)>|<cell|<frac|A{x:\<tau\><rsub|x>},(<wide|\<tau\>|\<vect\>>,\<tau\><rsub|x>)\<vdash\>e:\<tau\>|A,<wide|\<tau\>|\<vect\>>\<vdash\>\<lambda\>x.e:\<tau\><rprime|'>>>|<cell|\<tau\><rprime|'>=\<tau\><rsub|x>\<rightarrow\>\<tau\>>>|<row|<cell|>|<cell|>|<cell|>>|<row|<cell|(APP)>|<cell|<frac|A,<wide|\<tau\>|\<vect\>>\<vdash\>e:\<tau\><space|0.6spc>A,<wide|\<tau\>|\<vect\>>\<vdash\>e<rprime|'>:\<tau\><rprime|'>|A,<wide|\<tau\>|\<vect\>>\<vdash\>e
    e<rprime|'>:\<tau\><rprime|''>>>|<cell|\<tau\>=\<tau\><rprime|'>\<rightarrow\>\<tau\><rprime|''>>>|<row|<cell|>|<cell|>|<cell|>>|<row|<cell|(LET)>|<cell|<frac|A,<wide|\<tau\>|\<vect\>>\<vdash\>e:\<tau\><space|0.6spc>A{x:\<tau\><rsub|x>},<wide|\<tau\>|\<vect\>>\<vdash\>e<rprime|'>:\<tau\><rprime|'>|A,<wide|\<tau\>|\<vect\>>\<vdash\>let
    x=e in e<rprime|'>:\<tau\><rprime|''>>>|<cell|\<tau\>=\<tau\><rsub|x>,\<tau\><rprime|'>=\<tau\><rprime|''>>>|<row|<cell|>|<cell|>|<cell|>>|<row|<cell|(FIX)>|<cell|<frac|A{x:\<tau\><rsub|x>},<wide|\<tau\>|\<vect\>>\<vdash\>e:\<tau\>|A,<wide|\<tau\>|\<vect\>>\<vdash\>fix
    x.e:\<tau\><rprime|'>>>|<cell|\<tau\><rsub|x>=\<tau\>,(\<tau\>,<wide|\<tau\>|\<vect\>>)\<leq\>(\<tau\><rprime|'>,<wide|\<tau\>|\<vect\>>)>>>>
  </eqnarray*>

  <with|mode|math|\<tau\>\<leq\>\<tau\><rprime|'>> oznacza
  <with|mode|math|(\<exists\>R)R\<tau\>=\<tau\><rprime|'>>. Šatwo
  przeksztaªci¢ ten zbiór regóª w algorytm redukuj¡cy do semi-unifikacji.

  <paragraph|<with|mode|math|HMG<rsub|r>(X)>.>Nie opracowano dot¡d algorytmu
  peªnej inferencji typu dla GADT. Wydaje si¦ on osi¡galny przez poª¡czenie
  algorytmu dla <with|mode|math|HMG<rsub|nr>(X)> oraz dla MM.

  <with|font-series|bold|Zadanie badawcze 3>. Opracowa¢ algorytm redukcji
  problemu inferencji <with|mode|math|HMG<rsub|r>(X)> do problemu
  rozstrzygania wi¦zów nad <with|mode|math|X> z semi-unifikacj¡.<new-page>

  \;

  <subsection|Semi-unifikacja>

  Problem inferencji typu w systemie Milnera-Mycrofta z rekurencj¡
  polimorficzn¡ redukuje si¦ do semi-unifikacji. Semi-unifikacja jest
  problemem nierozstrzygalnym, jednak jak argumentuje Henglein w
  <cite|henglein93type>, dla praktycznych zada« odpowiedni poprawny algorytm
  ko«czy prac¦ (w rozs¡dnym czasie). W przypadku PG, gdy rozwi¡zywanie
  semi-unifikacji b¦dzie si¦ przedªu»a¢, b¦dziemy przerywa¢ z odpowiedzi¡
  negatywn¡: ''±cie»ka o zbyt skomplikowanym typie''.

  Maj¡c dany system równa« i nierówno±ci:

  <\equation*>
    \<cal-I\>={M<rsub|01><above|=|?>N<rsub|01>,\<ldots\>,M<rsub|0l><above|=|?>N<rsub|0l>,M<rsub|1><above|\<leq\>|?>N<rsub|1>,\<ldots\>,M<rsub|k><above|\<leq\>|?>N<rsub|k>}
  </equation*>

  podstawienie <with|mode|math|S> jest <with|font-series|bold|semi-unifikatorem>
  <with|mode|math|\<cal-I\>>, je±li istniej¡ podstawienia
  <with|mode|math|R<rsub|1>,\<ldots\>,R<rsub|k>>, »e

  <\with|font-base-size|7>
    <\equation*>
      S(M<rsub|01>)=S(N<rsub|01>),\<ldots\>,S(M<rsub|0l>)=S(N<rsub|0l>),R<rsub|1>(S(M<rsub|1>))=S(N<rsub|1>),\<ldots\>,R<rsub|k>(S(M<rsub|k>))=S(N<rsub|k>)
    </equation*>

    \;
  </with>

  <new-page>

  \;

  <subsubsection|Algorytm semi-unifikacji>

  Algorytm rozszerza standardowy algorytm Martelliego i Montanariego. Ka»d¡
  nierówno±¢ podproblemu semi-unifikacji oznaczamy innym kolorem (indeksem).
  Do reguª dla równo±ci dochodz¡ przypadki:

  <\enumerate>
    <item><with|mode|math|f(M<rsub|1>,\<ldots\>,M<rsub|k>)\<leq\><rsup|(i)>f(N<rsub|1>,\<ldots\>,N<rsub|k>)>:

    zamie« przez <with|mode|math|M<rsub|1>\<leq\><rsup|(i)>N<rsub|1>,\<ldots\>,M<rsub|k>\<leq\><rsup|(i)>N<rsub|k>>

    <item><with|mode|math|x\<leq\><rsup|(i)>M> i
    <with|mode|math|x\<leq\><rsup|(i)>N>:

    usu« jedn¡ z nierówno±ci i dodaj <with|mode|math|M=N>

    <item><with|mode|math|f(M<rsub|1>,\<ldots\>,M<rsub|k>)\<leq\><rsup|(i<rsub|0>)>x>
    oraz istnieje ci¡g nierówno±ci <with|mode|math|x\<leq\><rsup|(i<rsub|1>)>x<rsub|1>\<leq\>\<ldots\>\<leq\><rsup|(i<rsub|n>)>x<rsub|n>>
    oraz <with|mode|math|x<rsub|n>> nale»y do <with|mode|math|M<rsub|i>> dla
    pewnego <with|mode|math|i>: nie istnieje semi-unifikator

    <item><with|mode|math|f(M<rsub|1>,\<ldots\>,M<rsub|k>)\<leq\><rsup|(i<rsub|0>)>x>
    i nie zachodzi punkt 3:

    dodaj równanie <with|mode|math|x=f(x<rsub|1><rprime|'>,\<ldots\>,x<rsub|k><rprime|'>)>
    gdzie <with|mode|math|x<rsub|1><rprime|'>,\<ldots\>,x<rsub|k><rprime|'>>
    s¡ ±wie»ymi zmiennymi
  </enumerate>

  <with|font-series|bold|Zadanie badawcze 4>. Rozszerzy¢ algorytm
  semi-unifikacji o obsªug¦ implikacji.<new-page>

  \;

  <\bibliography|bib|plain|/home/luki/praca/biblio.bib>
    <\bib-list|1>
      <bibitem*|1><label|bib-henglein93type>Fritz Henglein. <newblock>Type
      inference with polymorphic recursion.
      <newblock><with|font-shape|italic|ACM Transactions on Programming
      Languages and Systems>, 15(2):253--289, April 1993.

      <bibitem*|2><label|bib-sulzmann99>Martin Odersky, Martin Sulzmann, and
      Martin Wehr. <newblock>Type inference with constrained types.
      <newblock><with|font-shape|italic|Theory and Practice of Object
      Systems>, 5(1):35--55, 1999.

      <bibitem*|3><label|bib-simonet03constraintbased>V.<nbsp>Simonet and
      F.<nbsp>Pottier. <newblock>Constraint-based type inference for guarded
      algebraic data types. <newblock>Research Report 5462, INRIA, January
      2005.
    </bib-list>
  </bibliography>
</body>

<\initial>
  <\collection>
    <associate|language|polish>
    <associate|page-even|20mm>
    <associate|page-medium|paper>
    <associate|page-odd|20mm>
    <associate|page-orientation|landscape>
  </collection>
</initial>

<\references>
  <\collection>
    <associate|auto-1|<tuple|<uninit>|2>>
    <associate|auto-10|<tuple|2.2.2.1|12>>
    <associate|auto-11|<tuple|2.2.2.2|12>>
    <associate|auto-12|<tuple|2.2.2.3|13>>
    <associate|auto-13|<tuple|2.2.2.4|14>>
    <associate|auto-14|<tuple|2.3|15>>
    <associate|auto-15|<tuple|2.3.1|16>>
    <associate|auto-16|<tuple|4|17>>
    <associate|auto-2|<tuple|1|3>>
    <associate|auto-3|<tuple|1.1|5>>
    <associate|auto-4|<tuple|1.2|7>>
    <associate|auto-5|<tuple|2|8>>
    <associate|auto-6|<tuple|2.1|8>>
    <associate|auto-7|<tuple|2.2|10>>
    <associate|auto-8|<tuple|2.2.1|11>>
    <associate|auto-9|<tuple|2.2.2|11>>
    <associate|bib-henglein93type|<tuple|1|17>>
    <associate|bib-simonet03constraintbased|<tuple|3|17>>
    <associate|bib-sulzmann99|<tuple|2|17>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|bib>
      sulzmann99

      simonet03constraintbased

      henglein93type

      sulzmann99

      sulzmann99

      henglein93type
    </associate>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|Spis
      tre±ci> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-1><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|Programowanie
      genetyczne> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-2><vspace|0.5fn>

      <with|par-left|<quote|1.5fn>|Technologia algorytmów genetycznych
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-3>>

      <with|par-left|<quote|1.5fn>|Zastosowania poza PG
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-4>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|Generowanie
      termów> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-5><vspace|0.5fn>

      <with|par-left|<quote|1.5fn>|Struktura przestrzeni przeszukiwa«
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-6>>

      <with|par-left|<quote|1.5fn>|Systemy typów z wi¦zami lub/i rekurencj¡
      polimorficzn¡ <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-7>>

      <with|par-left|<quote|3fn>|Techniki inferencji typu
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-8>>

      <with|par-left|<quote|3fn>|Specyfikacja systemów typów generuj¡ca wi¦zy
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-9>>

      <with|par-left|<quote|6fn>|<with|mode|<quote|math>|HM(X)>.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-10><vspace|0.15fn>>

      <with|par-left|<quote|6fn>|<with|mode|<quote|math>|HMG<rsub|nr>(X)>.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-11><vspace|0.15fn>>

      <with|par-left|<quote|6fn>|MM. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-12><vspace|0.15fn>>

      <with|par-left|<quote|6fn>|<with|mode|<quote|math>|HMG<rsub|r>(X)>.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-13><vspace|0.15fn>>

      <with|par-left|<quote|1.5fn>|Semi-unifikacja
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-14>>

      <with|par-left|<quote|3fn>|Algorytm semi-unifikacji
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-15>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|Bibliografia>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-16><vspace|0.5fn>
    </associate>
  </collection>
</auxiliary>