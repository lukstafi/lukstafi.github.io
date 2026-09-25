<TeXmacs|1.0.5.4>

<style|book>

<\body>
  <\doc-data|<doc-title|Programowanie genetyczne<with|font-size|1.41|> w
  j¦zykach typizowanych>|<doc-author-data|<author-name|Šukasz
  Stafiniak>|<\author-address>
    Politechnika Wrocªawska, WPPT
  </author-address>|<author-email|lukstafi@wp.pl>>|<doc-subtitle|Praca
  Magisterska>|<doc-author-data|<author-name|promotor dr \ Zdzisªaw
  Spªawski>>|<doc-date|15 czerwca 2005>>
    \;
  </doc-data>

  <\table-of-contents|toc>
    <vspace*|1fn><with|font-series|bold|math-font-series|bold|Spis tre±ci>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-1><vspace|0.5fn>

    <vspace*|1fn><with|font-series|bold|math-font-series|bold|1<space|2spc>Wprowadzenie>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-2><vspace|0.5fn>

    1.1<space|2spc>Wst¦p. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-3>

    1.2<space|2spc>Zagadnienia. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-4>

    <with|par-left|1.5fn|1.2.1<space|2spc>GP i geny.
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-5>>

    <with|par-left|1.5fn|1.2.2<space|2spc>Zalety wprowadzenia typizacji:
    programowanie dedukcyjne. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-6>>

    <with|par-left|1.5fn|1.2.3<space|2spc>Automatyczne programowanie --
    synteza programów: synteza dedukcyjna i synteza indukcyjna.
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-7>>

    <with|par-left|1.5fn|1.2.4<space|2spc>Operatory genetyczne i generowanie
    termów. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-8>>

    <with|par-left|1.5fn|1.2.5<space|2spc>Generowanie termów i ``answer
    substitution''. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-9>>

    <with|par-left|1.5fn|1.2.6<space|2spc>Zacie±nianie odpowiednio±ci mi¦dzy
    ci¡giem wyborów a poprawnie typowanymi termami; przeszukiwanie.
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-10>>

    <with|par-left|3fn|1.2.6.1<space|2spc>Generowanie termów jako
    przeszukiwanie przestrzeni programów.
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-11>>

    <with|par-left|3fn|1.2.6.2<space|2spc>O potrzebie inferencji typu.
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-12>>

    <with|par-left|3fn|1.2.6.3<space|2spc>Algorytm ``head-driven''.
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-13>>

    <with|par-left|3fn|1.2.6.4<space|2spc>Rozstrzygalno±¢ problemu
    niepusto±ci typu w ML. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-14>>

    <with|par-left|1.5fn|1.2.7<space|2spc>Definicje rekurencyjne i definicje
    lokalne. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-15>>

    <with|par-left|1.5fn|1.2.8<space|2spc>Rekombinacja i homomorfizm
    typizowa«. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-16>>

    <with|par-left|1.5fn|1.2.9<space|2spc>Rekombinacja przez anty-unifikacj¦.
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-17>>

    <with|par-left|3fn|1.2.9.1<space|2spc>Generalizacja i GP.
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-18>>

    <with|par-left|3fn|1.2.9.2<space|2spc>Rekombinacja zgodna z mutacj¡ i
    anty-unifikacja drugiego rz¦du. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-19>>

    <with|par-left|1.5fn|1.2.10<space|2spc>Systemy typów z wi¦zami.
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-20>>

    <with|par-left|3fn|1.2.10.1<space|2spc>Nierozstrzygalno±¢ inferencji typu
    dla rekurencji polimorficznej. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-21>>

    <with|par-left|3fn|1.2.10.2<space|2spc>Wªasno±¢ stopu zapewniona przez
    system typów. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-22>>

    <with|par-left|1.5fn|1.2.11<space|2spc>Dalej w pracy.
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-23>>

    <with|par-left|3fn|1.2.11.1<space|2spc>Rozdziaª 2 -- Generowanie termów.
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-24>>

    <with|par-left|3fn|1.2.11.2<space|2spc>Rozdziaª 3 -- Generalizacja.
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-25>>

    <with|par-left|3fn|1.2.11.3<space|2spc>Rozdziaª 4 -- Zako«czenie.
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-26>>

    <vspace*|1fn><with|font-series|bold|math-font-series|bold|2<space|2spc>Generowanie
    termów.> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-27><vspace|0.5fn>

    2.1<space|2spc>System typów prostych a intuicjonistyczny rachunek zda«.
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-28>

    <with|par-left|1.5fn|2.1.1<space|2spc>System dedukcji naturalnej i
    typizowany <with|mode|math|\<lambda\>>-rachunek.
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-29>>

    <with|par-left|6fn|System dedukcji naturalnej.
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-30><vspace|0.15fn>>

    <with|par-left|6fn|Przypisanie typu do <with|mode|math|\<lambda\>>-termu.
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-31><vspace|0.15fn>>

    <with|par-left|6fn|Izomorfizm Curry'ego-Howarda.
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-32><vspace|0.15fn>>

    <with|par-left|1.5fn|2.1.2<space|2spc>Dowody w postaci normalnej.
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-33>>

    <with|par-left|6fn|Beta redukcja. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-34><vspace|0.15fn>>

    <with|par-left|6fn|Twierdzenie o normalizacji.
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-35><vspace|0.15fn>>

    <with|par-left|1.5fn|2.1.3<space|2spc>Poszukiwanie dowodów.
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-36>>

    <with|par-left|6fn|Rachunek sekwentów <with|mode|math|N
    J<rsub|\<beta\>>>. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-37><vspace|0.15fn>>

    <with|par-left|6fn|Drzewo dedukcyjne.
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-38><vspace|0.15fn>>

    <with|par-left|1.5fn|2.1.4<space|2spc>Algorytm generuj¡cy
    <with|mode|math|\<lambda\>>-termy. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-39>>

    2.2<space|2spc>System Damasa-Milnera: inferencja typu i generowanie
    termu. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-40>

    <with|par-left|1.5fn|2.2.1<space|2spc>Algorytm inferencji typu
    <with|mode|math|\<cal-W\>> i algorytm generowania termu
    <with|mode|math|\<cal-C\>>. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-41>>

    <with|par-left|3fn|2.2.1.1<space|2spc>Poprawno±¢.
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-42>>

    <with|par-left|3fn|2.2.1.2<space|2spc>Peªno±¢.
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-43>>

    <with|par-left|1.5fn|2.2.2<space|2spc>Rozszerzenie j¦zyka o konstrukcj¦
    <with|mode|math|case>. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-44>>

    <with|par-left|3fn|2.2.2.1<space|2spc>Poprawno±¢ z <with|mode|math|case>.
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-45>>

    <with|par-left|3fn|2.2.2.2<space|2spc>Peªno±¢ z <with|mode|math|case>.
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-46>>

    <with|par-left|3fn|2.2.2.3<space|2spc>Zagadnienia praktyczne: CASE
    sterowane u»yciem. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-47>>

    2.3<space|2spc>Monotoniczno±¢ i wªasno±¢ stopu.
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-48>

    <with|par-left|1.5fn|2.3.1<space|2spc>System typów i algorytm
    <with|mode|math|\<cal-C\>>. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-49>>

    <with|par-left|3fn|2.3.1.1<space|2spc>Unifikacja z podtypowaniem
    <with|mode|math|\<b-U\><rsub|\<sqsubseteq\>>>.
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-50>>

    2.4<space|2spc>Generowanie: mechanizmy do zastosowania.
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-51>

    <with|par-left|1.5fn|2.4.1<space|2spc>System typów z typami indukcyjnymi
    z wi¦zami unifikacyjnymi. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-52>>

    <with|par-left|3fn|2.4.1.1<space|2spc>Generowanie
    <with|mode|math|\<eta\>>-dªugich <with|mode|math|\<beta\>>-normalnych
    polimorficznych <with|mode|math|\<lambda\>>-termów: Prolog.
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-53>>

    <with|par-left|3fn|2.4.1.2<space|2spc>W stron¦ peªnego
    <with|mode|math|HMG(X)>. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-54>>

    <with|par-left|1.5fn|2.4.2<space|2spc>Programy bez nieu»ytecznych
    definicji lokalnych. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-55>>

    <vspace*|1fn><with|font-series|bold|math-font-series|bold|3<space|2spc>Rekombinacja
    i generalizacja> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-56><vspace|0.5fn>

    3.1<space|2spc>Rekombinacja swobodna.
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-57>

    3.2<space|2spc>Anty-unifikacja drugiego rz<group|>¦du -- prosty
    przypadek. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-58>

    <with|par-left|1.5fn|3.2.1<space|2spc>Definicja.
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-59>>

    <with|par-left|1.5fn|3.2.2<space|2spc>Wªasno±¢: maksymalnie specyficzna
    generalizacja. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-60>>

    <with|par-left|1.5fn|3.2.3<space|2spc>Zgodno±¢ rekombinacji z systemem
    typów. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-61>>

    <with|par-left|1.5fn|3.2.4<space|2spc>Zwi¡zek z algorytmami z prac
    [<write|bib|pfenning91unification><reference|bib-pfenning91unification>]
    i [<write|bib|lu-generalization><reference|bib-lu-generalization>].
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-62>>

    3.3<space|2spc>Generalizacja drugiego rz¦du i ogólne struktury.
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-63>

    <with|par-left|1.5fn|3.3.1<space|2spc>Generalizacje rekombinatorowe z
    pracy [<write|bib|hasker95><reference|bib-hasker95>].
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-64>>

    <with|par-left|3fn|3.3.1.1<space|2spc>Definicje ogólne i algorytm dla
    termów monadycznych. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-65>>

    <with|par-left|3fn|3.3.1.2<space|2spc>Relewantne kombinatory i algorytm
    dla termów poliadycznych. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-66>>

    <with|par-left|3fn|3.3.1.3<space|2spc>Praktyczny algorytm uwzgl¦dniaj¡cy
    rozmiar generalizacji. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-67>>

    <with|par-left|1.5fn|3.3.2<space|2spc>Algorytm rekonstrukcji
    generalizacji z relewantnymi <with|mode|math|\<lambda\>>-abstrakcjami.
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-68>>

    <with|par-left|1.5fn|3.3.3<space|2spc>Generalizacja przez znajdowanie
    maksymalnych wspólnych podstruktur. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-69>>

    <with|par-left|6fn|Zagadnienia praktyczne.
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-70><vspace|0.15fn>>

    <with|par-left|6fn|Uwaga natury teoretycznej.
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-71><vspace|0.15fn>>

    <with|par-left|3fn|3.3.3.1<space|2spc>Znajdowanie maksymalnych
    izomorficznych podsystemów. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-72>>

    <with|par-left|3fn|3.3.3.2<space|2spc>Rozszerzanie generalizacji na
    <with|mode|math|\<lambda\>>-termy z definicjami lokalnymi i
    rekurencyjnymi. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-73>>

    <with|par-left|3fn|3.3.3.3<space|2spc>Zgodno±¢ z systemem typów.
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-74>>

    <vspace*|1fn><with|font-series|bold|math-font-series|bold|4<space|2spc>Zako«czenie>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-75><vspace|0.5fn>

    4.1<space|2spc>Wkªad pracy. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-76>

    4.2<space|2spc>Postawione zadania. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-77>

    <vspace*|1fn><with|font-series|bold|math-font-series|bold|Bibliografia>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-78><vspace|0.5fn>
  </table-of-contents>

  <chapter|Wprowadzenie>

  <section|Wst¦p.>

  Praca bada mo»liwo±ci stosowania bogatszych systemów typów dla programów
  generowanych przez programowanie genetyczne (ang. genetic programming, GP).
  GP jest zastosowaniem programowania ewolucyjnego (algorytmów genetycznych w
  szerokim sensie) do przeszukiwania przestrzeni programów. Wymaga to
  opracowania operatorów genetycznych dla programów: 0-argumentowego
  operatora kreacji (generowanie przypadkowego programu), 1-argumentowego
  operatora mutacji (drobna przypadkowa modyfikacja programu),
  2-argumentowego operatora rekombinacji (wymiana fragmentów mi¦dzy dwoma
  programami). Generowanie termu obejmuje inferencj¦ typu. Praca uzasadnia
  stosowanie systemów polimorficznych (implicit polymorphism), oraz oparcie
  rekombinacji na anty-unifikacji. Wybór pada na systemy z wi¦zami ze wzgl¦du
  na ªatwo±¢ wyra»ania w nich wªasno±ci programów. Opracowanie operatorów
  ge<with|language|polish|>netycznych sprowadza si¦ do zada« generowania
  termu dla zadanego typu oraz znajdowania podtermów o typizacjach
  ''homomorficznych''. Praca ilustruje kluczowe wªasno±ci rozwi¡za«:
  poprawno±¢ i peªno±¢ algorytmu gen<with|language|polish|>erowania termów,
  poprawno±¢ algorytmu rekombinacji termów, dowodami dla mo»liwie
  najprostszych przypadków. Przedstawione jest nowe spojrzenie na
  anty-unifikacj¦ drugiego rz¦du. Opracowanie praktycznych algorytmów dla
  systemów typów z wi¦zami wymaga dalszych bada«, które niniejsza praca
  jedynie zapocz¡tkowuje.<new-page>

  \;

  <section|Zagadnienia.>

  Programowanie genetyczne (ang. genetic programming, GP) to metaheurystyka
  (czyli metoda) rozwi¡zywania problemów poprzez automatyczn¡ konstrukcj¦
  programów, wykorzystuj¡ca wiedz¦ o dziedzinie problemu poprzez funkcj¦
  oceniaj¡c¡, jak dobrze dany program radzi sobie z problemem (funkcj¦
  dostosowania, ang. fitness function). Ogólno±¢ metody GP polega na tym, »e
  nie jest potrzebna analiza semantyczna programów, a w wyniku nie jest
  potrzebna dogª¦bna analiza problemu, poniewa» programy zazwyczaj ocenia si¦
  uruchamiaj¡c je (np. w symulowanym ±rodowisku). GP jest przykªadem
  programowania ewolucyjnego czy te» szeroko rozumianych algorytmów
  genetycznych, czyli metaheurystyk stochastycznych przetwarzaj¡cych zbiór
  rozwi¡za« (populacj¦), konstruuj¡cych nowe rozwi¡zania z jednego lub wi¦cej
  starych, wybranych z uwzgl¦dnieniem funkcji dostosowania (lepsze
  rozwi¡zania maj¡ wi¦ksz¡ szans¦ wyboru). Wprowadzenie do metod ewolucyjnych
  zawiera <cite|goldberg>. Termin ``Programowanie genetyczne'' i
  zapocz¡tkowanie dziedziny zawdzi¦czamy Johnowi Kozie <cite|koza92>.

  <subsection|GP i geny.>

  Wyró»nikiem GP w±ród innych zastosowa« programowania ewolucyjnego jest
  (istotna) niesko«czono±¢ zbioru rozwi¡za«; nie mo»na nawet w przybli»eniu
  reprezentowa¢ programów przez wektory cech o ustalonej dªugo±ci. Je±li mamy
  tak¡ reprezentacj¦, cechy te nazywa si¦ genami. Odpowiednikiem hipotezy
  bloków buduj¡cych jest w przypadku GP hipoteza, »e GP prowadzi do
  automatycznej identyfikacji przydatnych, funkcjonalnych podprogramów, które
  rozprzestrzeniaj¡ si¦ w populacji i s¡ doskonalone w ró»nych kontekstach.
  Odpowiednikiem tej hipotezy w dziedzinie ewolucji naturalnej (biologicznej)
  jest wprowadzona przez Dawkinsa koncepcja jednostki selekcji
  <cite|dawkins>. Sugeruje to my±lenie o puli genów w przypadku GP jako o
  bycie zmiennym, który sam podlega ewolucji. Geny to fragmenty programów,
  które maj¡ du»¡ szans¦ by¢ przekazane w caªo±ci w wielokrotnym zastosowaniu
  rekombinacji. Opisuje to np. <cite|altenberg94evolvability>.

  <subsection|Zalety wprowadzenia typizacji: programowanie dedukcyjne.>

  Bogatsze systemy typów s¡ inn¡ (ni» funkcja dostosowania) metod¡
  uwzgl¦dnienia wiedzy o problemie, dost¦pn¡ gdy wiedz¦ t¡ mo»na wyrazi¢ w
  postaci reguª logicznych. Ograniczaj¡ one przestrze« rozpatrywanych
  programów, eliminuj¡c konstrukcje nierozs¡dne (nietypizowalne) oraz
  pozwalaj¡c na zadanie specyfikacji, wymaganych od rozwi¡za«. Szczególnie
  istotne jest uwzgl¦dnienie jak najwi¦kszej wiedzy na etapie konstrukcji
  rozwi¡zania, gdy ocena rozwi¡zania jest kosztowna (np. funkcj¦ nale»y
  sprawdzi¢ na wielu przypadkach, albo potrzeba symulowa¢ skomplikowane
  ±rodowisko dla programu steruj¡cego robotem). Cel, który speªni¢ ma
  rozwi¡zanie, okre±la si¦ jako typ zadany (generowane b¦d¡ programy tego
  typu), warunki lokalne zadaje si¦ jako typy konstrukcji pierwotnych (np.
  funkcji wbudowanych).

  <subsection|Automatyczne programowanie -- synteza programów: synteza
  dedukcyjna i synteza indukcyjna.>

  Hasªo ``automatyczne programowanie'' obejmuje ró»ne techniki komputerowego
  wspierania programowania. Przegl¡d zagadnie« zawiera np.
  <cite|ute-inductive>. Synteza programów oznacza automatyczne (lub
  póªautomatyczne, interaktywne) generowanie programów. Synteza dedukcyjna
  oznacza syntez¦ programu na podstawie jego peªnej specyfikacji w pewnym
  systemie formalnym. Systemy syntezy dedukcyjnej dzielimy na teorio-dowodowe
  i transformacyjne. W tych pierwszych specyfikacja jest pewn¡ formuª¡
  logiczn¡, dowód której odpowiada znalezieniu programu: w logikach
  konstruktywnych dowód istnienia oznacza podanie odpowiedniego obiektu,
  specyfikacja stwierdza istnienie szukanych obiektów. Systemy
  transformacyjne przeksztaªcaj¡ specyfikacj¦ przy pomocy zbioru reguª, i gdy
  nie ma ju» reguª do zastosowania, wynik transformacji jest szukanym
  programem. Systemy teorio-dowodowe podzieliªbym dalej na systemy reguªowe i
  systemy teorio-typowe. Pierwsze przeksztaªcaj¡ formuª¦ przy pomocy zbioru
  reguª logicznych, otrzymuj¡c w wyniku formuª¦ (formuªy) wyra»aj¡c¡
  odpowied¹; fragment tej formuªy jest szukanym programem. Np. formuª¡
  wej±ciow¡ jest tautologia <with|mode|math|P(?x)\<Rightarrow\>P(?x)>, gdzie
  <with|mode|math|?x> jest zmienn¡ egzystencjaln¡, <with|mode|math|P> jest
  specyfikacj¡; reguªy logiczne zachowuj¡ prawdziwo±¢; formuª¡ wynikow¡ jest
  <with|mode|math|P(t)>, gdzie <with|mode|math|t> jest szukanym programem.
  Drugie konstruuj¡ dowód w postaci drzewa (w¦zªy drzewa identyfikuj¡
  stosowane reguªy); na mocy izomorfizmu Curry'ego-Howarda, dowód jest
  szukanym programem.

  Synteza indukcyjna oznacza generowanie programu na podstawie niepeªnej
  wiedzy wyra»aj¡cej nasze oczekiwania; wiedzy ``sªabo ustrukturowanej'',
  tzn. nie daj¡cej wskazówek co do struktury programu. Mamy do dyspozycji
  mi¦dzy innymi: albo ustalone pary wej±cie-wyj±cie (uczenie si¦ z
  nauczycielem, program dla zadanych wej±¢ ma zwraca¢ okre±lone wyj±cia),
  albo metod¦ zwracaj¡c¡ poprawne wyj±cia dla danych wej±¢ (uczenie si¦ z
  wyroczni¡, program ma by¢ prostsz¡ metod¡ aproksymuj¡c¡ wyroczni¦), albo
  metod¦ okre±laj¡c¡ jako±¢ danego wyj±cia dla danego wej±cia (uczenie si¦ ze
  wzmocnieniem przez eksperymentowanie), albo sposób oceny jako±ci caªego
  programu (uczenie si¦ ze wzmocnieniem; nazwa pochodzi st¡d, »e mo»emy
  oceni¢, czy modyfikacja rozwi¡zania polepsza go czy pogarsza). Uczenie si¦
  ze wzmocnieniem daje u»ytkownikowi najwi¦ksz¡ swobod¦ co do informacji
  u»ytej w ocenie programów, ale najmniej wskazówek systemowi co do struktury
  programu. Z kolei mo»emy podzieli¢ systemy indukcyjnego uczenia si¦ na
  lokalne i globalne (nielokalne). Metody lokalne rozpatruj¡ atrakcyjno±¢
  pojedynczego rozwi¡zania (np. metody optymalizacji gradientowej). Metody
  globalne (nielokalne) rozpatruj¡ hipotez¦ opisuj¡c¡ atrakcyjne obszary
  przestrzeni rozwi¡za« (np. metody optymalizacji dziel-i-rz¡d¹).

  Programowanie genetyczne to metoda syntezy indukcyjnej programów b¦d¡ca
  nielokalnym uczeniem si¦ ze wzmocnieniem. Generowanie programów w j¦zykach
  typizowanych to teorio-dowodowa, teorio-typowa metoda syntezy dedukcjyjnej.
  Podsumowuj¡c:

  <\enumerate>
    <item>Synteza dedukcyjna

    <\enumerate>
      <item>transformacyjna

      <item>teorio-dowodowa

      <\enumerate>
        <item>reguªowa

        <item><with|font-series|bold|teorio-typowa>
      </enumerate>
    </enumerate>

    <item>Synteza indukcyjna

    <\enumerate>
      <item>uczenie si¦ z nauczycielem

      <item>uczenie si¦ z wyroczni¡

      <item>uczenie si¦ ze wzmocnieniem przez eksperymentowanie

      <item>uczenie si¦ ze wzmocnieniem

      <\enumerate>
        <item>lokalne

        <item><with|font-series|bold|globalne (nielokalne)>
      </enumerate>
    </enumerate>
  </enumerate>

  Praca proponuje poª¡czenie metod syntezy dedukcyjnej i indukcyjnej, aby
  najpeªniej wykorzysta¢ wiedz¦ o problemie. T¡ cz¦±¢ specyfikacji, która ma
  charakter ``logiczny`` i jest na tyle prosta, »e pozwala na efektywn¡
  dedukcj¦ programów, zawiera si¦ w systemie typów i typie zadanym. Pozostaª¡
  cz¦±¢ wiedzy o problemie zawiera si¦ w funkcji oceniaj¡cej programy.

  Algorytmy genetyczne w szerokim sensie mo»na nazwa¢ uczeniem si¦ ``co
  prawda bez nauczyciela, ale z systemem edukacyjnym''. Operatory
  rekombinacji próbuje si¦ tworzy¢ tak, aby, je±li rodzice (argumenty
  operatora) maj¡ ten sam wynik dla danego wej±cia, to potomek (rezultat
  operatora) te» miaª ten wynik dla tego wej±cia -- rodzice s¡ nauczycielami
  potomka. Niestety, w GP stworzenie takiego operatora rekombinacji jest zbyt
  trudne.

  <subsection|Operatory genetyczne i generowanie termów.>

  Aby algorytm genetyczny (ewolucyjny) mógª rozpocz¡¢ prac¦, potrzebuje co
  najmniej trzech operatorów genetycznych: 0-argumentowego operatora kreacji
  (dla budowy populacji pocz¡tkowej), 1-argumentowego operatora mutacji (dla
  przeszukiwania lokalnego), 2-argumentowego operatora rekombinacji (dla
  przeszukiwania nielokalnego). Podstaw¡ operatorów kreacji i mutacji jest
  algorytm generowania termów. Rozdzielamy zagadnienia przeszukiwania i
  konstrukcji, redukuj¡c generowanie termów do przeszukiwania drzew. Algorytm
  konstrukcji termu <with|mode|math|\<b-C\>(E,\<tau\>,<wide|w|\<vect\>>)> dla
  pewnych ci¡gów wyborów <with|mode|math|<wide|w|\<vect\>>> (ci¡gów liczb
  naturalnych okre±laj¡cych pojedyncz¡ ±cie»k¦ wykonania algorytmu
  niedeterministycznego) zwraca term <with|mode|math|e> o typie
  <with|mode|math|\<tau\>> w ±rodowisku <with|mode|math|E>; dla pozostaªych
  <with|mode|math|<wide|w|\<vect\>>> zawodzi (zgªasza niemo»no±¢ zbudowania
  termu). Nale»y wtedy podj¡¢ prób¦ dla innego ci¡gu
  <with|mode|math|<wide|w|\<vect\>><rprime|'>>, np. zachowuj¡c mo»liwie wiele
  z wcze±niejszej pracy algorytmu dzi¦ki mechanizmowi nawrotów (kontynuacji)
  -- jest to cz¦±¢ zagadnienia przeszukiwania. Operator kreacji zwraca
  <with|mode|math|\<b-C\>(E<rsub|0>,\<tau\><rsub|0>,<wide|w|\<vect\>>)>,
  gdzie <with|mode|math|E<rsub|0>> jest ±rodowiskiem pocz¡tkowym
  (±rodowiskiem konstrukcji pierwotnych), a <with|mode|math|\<tau\><rsub|0>>
  jest typem zadanym -- specyfikacj¡ problemu, a
  <with|mode|math|<wide|w|\<vect\>>> odpowiednim (znalezionym) ci¡giem
  wyborów. Operator mutacji (mutacja podtermu) polega na zamianie w termie
  <with|mode|math|e> podtermu <with|mode|math|e<rsub|1>> na inny. Wiemy, »e
  zachodzi s¡d typizuj¡cy <with|mode|math|E<rsub|0>\<vdash\>e:\<tau\><rsub|0>>;
  niech podterm <with|mode|math|e<rsub|1>> b¦dzie wprowadzony do termu
  <with|mode|math|e> w wyprowadzeniu tego s¡du typizuj¡cego z przesªanki
  <with|mode|math|E<rsub|1>\<vdash\>e<rsub|1>:\<tau\><rsub|1>>. Wtedy
  operator mutacji podstawia pod <with|mode|math|e<rsub|1>> wynik
  <with|mode|math|\<b-C\>(E<rsub|1>,\<tau\><rsub|1>,<wide|w|\<vect\>>)> dla
  odpowiedniego ci¡gu wyborów <with|mode|math|<wide|w|\<vect\>>>. Informacj¦
  o typie podtermów i ±rodowisku jego wyprowadzenia mo»na przechowywa¢ w tych
  samych strukturach, które wykorzystuje mechanizm nawrotów.

  <subsection|Generowanie termów i ``answer substitution''.>

  Nawet, je±li b¦dziemy zadowoleni z algorytmu zwracaj¡cego term dokªadnie
  typu <with|mode|math|\<tau\>>, to w jego implementacji b¦dzie potrzebny
  algorytm pozwalaj¡cy na konkretyzacj¦ typu zadanego. Nie musimy, a wewn¡trz
  algorytmu generuj¡cego cz¦sto nie mo»emy, wiedzie¢ wszystko o typie termu,
  którego szukamy. Niech wi¦c <with|mode|math|\<b-C\>(E,\<tau\>,<wide|w|\<vect\>>)>
  znajduje term <with|mode|math|e> i podstawienie <with|mode|math|T> takie,
  »e <with|mode|math|T*E\<vdash\>e:T\<tau\>>. Porównaj podrozdziaª 3.4
  ``Proof-search in Logical Frameworks'' artykuªu
  <cite|galmiche00proofsearch>, czy te» wprowadzenie do SLD-rezolucji w
  <cite|nilsson95prolog>. Zmienne wolne pozostawiamy w
  <with|mode|math|\<tau\>> jako niewiadome, które ma znale¹¢ algorytm.

  Gdy rozpatrujemy operator mutacji, nale»y pami¦ta¢, aby zablokowa¢
  mo»liwo±¢ podstawiania pod zmienne, które w nadtermie typu zostaj¡
  zgeneralizowane (traktuj¡c je jak staªe). Nast¦pnie modyfikujemy
  wyprowadzenie typu dla caªego programu, stosuj¡c odpowiednio podstawienie
  zwrócone przez wygenerowanie nowego podtermu. Wad¡ takiego stosowania
  mutacji jest nadokre±lenie typu programu (jest bardziej skonkretyzowany ni»
  to wynika z termu), dlatego mo»na retypizowa¢ caªy program po zastosowaniu
  mutacji.

  <subsection|Zacie±nianie odpowiednio±ci mi¦dzy ci¡giem wyborów a poprawnie
  typowanymi termami; przeszukiwanie.>

  Ci¡g wyborów wyra»a niedeterminizm, czy te» stochastyczno±¢ algorytmu
  <with|mode|math|\<b-C\>>. Idealnie byªoby, gdyby dla ka»dego ci¡gu wyborów
  algorytm zwracaª term poprawnie typowany, a wyliczeniu ci¡gów wyborów
  odpowiadaªoby wyliczenie termów zamieszkuj¡cych zadany typ. Jednak algorytm
  wykorzystuje ci¡g wyborów do generowania termu, i wyliczeniu ci¡gów wyborów
  odpowiada wyliczenie wszystkich termów odpowiedniej klasy zadanej
  syntaktycznie.

  <subsubsection|Generowanie termów jako przeszukiwanie przestrzeni
  programów.>

  Rzeczywisty algorytm uzyskujemy wi¦c z <with|mode|math|\<b-C\>> dzi¦ki
  zastosowaniu przeszukiwania grafów (tutaj zasadniczo drzew). Oczywi±cie,
  ªatwiej przeszukiwa¢ w gª¡b, ale lepiej przeszukiwa¢ wszerz: krótsze termy
  maj¡ wi¦ksz¡ szans¦ by¢ lepszymi programami, <with|mode|math|\<b-C\>> z
  przeszukiwaniem wszerz daje rekurencyjn¡ przeliczalno±¢ problemu
  znajdowania mieszka«ca zadanego typu. Dla operatorów genetycznych
  zadaj¡cych ci¡g wyborów losowo i oczekuj¡cych odpowiedzi, zwracamy term
  najbli»szy wskazanemu w¦zªowi (w sensie obranej strategii przeszukiwania)
  (lub odpowiadamy, »e taki nie istnieje, je±li wyczerpali±my przestrze«).
  Mo»emy równie» zwraca¢ rzeczywisty ci¡g wyborów, dla ewentualnego
  wznowienia przeszukiwania (przestrzeni programów). W praktycznej
  implementacji pami¦tamy o wymuszaniu stopu, gdy przeszukiwanie trwa zbyt
  dªugo; zawodzi wtedy próba zastosowania operatora genetycznego.

  <subsubsection|O potrzebie inferencji typu.>

  Generowanie termu obejmuje inferencj¦ typu: wyprowadzamy termy typizowane.
  Je±li nie mamy mechanizmów inferencji (typizacja bazuje na annotacjach
  termów typami), zastosowanie przeszukiwania grafów de facto rozwi¡zuje
  zadanie inferencji typu dla wygenerowanego termu. W ten sposób struktura
  przeszukiwa« zostaje zdominowana przez problem inferencji typu, podczas gdy
  chcemy, aby wyra»aªa semantyk¦ operacyjn¡ programów (jak dziaªaj¡). Dlatego
  konieczne jest odizolowanie termów i typów, nawet niewyszukany algorytm
  inferencji dla systemów nierozstrzygalnych (z konieczno±ci algorytm bez
  wªasno±ci stopu, w praktyce za± ze stopem wymuszonym, czyli algorytm
  niepeªny) b¦dzie lepszy od naiwnej enumeracji wszystkich mo»liwych
  typizowa«. Mo»emy przywróci¢ ``przeliczaln¡ peªno±¢'' dodaj¡c w momencie
  stopowania typizacji jej kontynuacj¦ jako (odªo»ony na pó¹niej) w¦zeª
  struktury przeszukiwa«.

  <subsubsection|Algorytm ``head-driven''.>

  Ju» w latach trzydziestych wiadomo byªo, »e intuicjonistyczny rachunek zda«
  jest rozstrzygalny. W interpretacji w lambda-rachunku oznacza to, »e dla
  ka»dego typu z systemu typów prostych mo»emy znale¹¢ term tego typu, albo
  pokaza¢, »e takich termów nie ma. Wykorzystamy standardowy algorytm
  znajdowania takiego termu, opisany np. w pracy <cite|nagano-proof>. Idea
  polega na wykorzystaniu wªasno±ci ``cut elimination'', czyli w terminologii
  <with|mode|math|\<lambda\>>-rachunku faktu, »e je±li istnieje term danego
  typu, to istnieje term bez <with|mode|math|\<beta\>>-redeksów, równie» tego
  typu. Mo»na wi¦c szuka¢ termu w±ród termów normalnych (bez
  <with|mode|math|\<beta\>>-redeksów), a pomijaj¡c zap¦tlenia w
  wyprowadzeniach, jest wtedy tylko sko«czenie wiele ±cie»ek do sprawdzenia,
  ko«cz¡cych si¦ zadanym typem. Oczywi±cie, mo»emy zastosowa¢ ten mechanizm
  dla poszukiwania programów funkcyjnych, poniewa»
  <with|mode|math|\<beta\>>-redukcja zachowuje wtedy sens programu. Dla
  systemu typów prostych mamy wi¦c algorytm generowania, zatrzymuj¡cy si¦ dla
  ka»dego zadanego typu, z termem tego typu lub stwierdzeniem pusto±ci typu.

  <subsubsection|Rozstrzygalno±¢ problemu niepusto±ci typu w
  ML.><label|rozstrzyg>

  Dla ML bez algebraicznych typów danych, czyli dla ML bez dopasowywania
  wzorca (lub innych mechanizmów typu CASE), ªatwo znale¹¢ algorytm
  zwracaj¡cy term zadanego typu z odpowiadaj¡cym programem z wªasno±ci¡
  stopu, lub odpowiadaj¡cy, »e je±li typ zamieszkuj¡ jakie± termy, to
  odpowiadaj¡ce im programy nie zatrzymuj¡ si¦ dla »adnego argumentu. Mo»na
  przeprowadzi¢ eliminacj¦ definicji rekurencyjnych i lokalnych i nast¦pnie
  zastosowa¢ argument taki sam, jak dla systemu typów prostych. (Je±li
  program zatrzymuje si¦ dla pewnych danych, to musi istnie¢ gaª¡¹ programu
  licz¡ca wynik bez wywoªania rekurencyjnego.) Eliminacja zmienia sens
  programu, ale nie zmienia typu programu. Peªny ML wydaje si¦ nie by¢
  rozstrzygalny w tym sensie, ale nie potrafi¦ tego pokaza¢. Oczywi±cie,
  rozstrzygalno±¢ ogólnego problemu niepusto±ci typu (czy istnieje term
  danego typu) jest równowa»na (przez izomorfizm Curry'ego-Howarda)
  rozstrzygalno±ci odpowiadaj¡cej systemowi logiki. Pozytywne wyniki wi¡»¡
  si¦ z peªno±ci¡ programowania w Prologu.

  Algorytm generuj¡cy <with|mode|math|\<beta\>>-normalne polimorficzne
  <with|mode|math|\<lambda\>>-termy (wykorzystuj¡c mechanizm unifikacji)
  odpowiada strategii SLD-rezolucji. Rozszerzamy go o pozostaªe konstrukcje
  ML (czy obszerniejszych systemów). Generowanie (wyliczanie) termów zgodnie
  z tym algorytmem jest równowa»ne strategii ewaluacji u»ytej w Prologu.

  <subsection|Definicje rekurencyjne i definicje lokalne.>

  Zasygnalizowane w <reference|rozstrzyg> problemy teoretyczne maj¡ swój
  praktyczny odpowiednik w zagadnieniu u»yteczno±ci definicji rekurencyjnych
  i definicji lokalnych. Definicje rekurencyjne s¡ u»yteczne, je±li
  odpowiadaj¡ce im funkcje przynajmniej czasami si¦ zatrzymuj¡ (nie b¦d¦ si¦
  zajmowaª korekurencj¡). Zapewnienie mocniejszego warunku u»yteczno±ci jest
  opisane w <reference|wlasnstopu>. Natomiast definicje lokalne s¡ u»yteczne,
  je±li przynajmniej raz s¡ u»yte w zakresie defi\Licji, s¡ ce\Lowe, je±li s¡
  u»yte wi¦cej ni» raz. Sk¡d jednak wiedzie¢, jakie definicje b¦d¡ przydatne
  w budowanym podtermie? Nast¦puj¡ce rozwi¡zanie wydaje si¦ optymalne:
  dopuszczaj, aby ka»dy wygenerowany podterm byª mo»liw¡ definicj¡ lokaln¡, o
  zakresie b¦d¡cym najszerszym kontekstem zawieraj¡cym zmienne lokalne
  podtermu. Je±li definicja b¦dzie u»yta (poza miejscem podtermu
  definiuj¡cego), to rzeczywi±cie j¡ wprowadzamy. W przeciwnym wypadku
  pozostawiamy podterm ``na miejscu'', nie wprowadzaj¡c definicji. To
  rozwi¡zanie ma jednak wad¦, je±li stosuje si¦ je dla termów bez
  <with|mode|math|\<beta\>>-redeksów: wprowadza tylko definicje lokalne o
  typach, które s¡ podtermami typów ze ±rodowiska lub typu zadanego
  (wªa±ciwie, generalizacje tych typów). (Podobny problem pojawia si¦ dla
  definicji rekurencyjnych.) Ogólnie, chcemy, aby definicje lokalne mogªy
  tworzy¢ po zredukowaniu <with|mode|math|\<beta\>>-redeksy, ale nie chcemy
  wprowadza¢ bezu»ytecznych <with|mode|math|\<lambda\>>-abstrakcji, których
  zmienne nie b¦d¡ nast¦pnie wykorzystane. Rozwi¡»emy to, ``patternizuj¡c''
  wygenerowany podterm (o ile ma stanowi¢ definicj¦ lokan¡), czyli wycinaj¡c
  podtermy tego podtermu i formuj¡c <with|mode|math|\<beta\>>-redeksy,
  nast¦pnie aplikacje zostawiaj¡c w zakresie definicji, a
  <with|mode|math|\<lambda\>>-abstrakcje w ciele definicji.

  Pojawia si¦ jeszcze jeden problem techniczny. Dla definicji lokalnej nale»y
  wyznaczy¢ najogólniejszy typ. Ale tworzona jest ona w innym ±rodowisku, ni»
  ostatecznie ±rodowisko jej zakresu.

  <subsection|Rekombinacja i homomorfizm typizowa«.>

  Rekombinacja polega najogólniej na zast¡pieniu podtermu
  <with|mode|math|e<rsub|1>> danego programu <with|mode|math|e<rsub|0>> przez
  podterm <with|mode|math|e<rsub|2>> pochodz¡cy z innego programu; w j¦zykach
  typizowanych wymaga to, aby podterm zast¦puj¡cy byª typu w jakim± sensie
  konkretyzuj¡cego typ podtermu zast¦powanego. Po zast¡pieniu nale»y
  zrekonstruowa¢ typ uzyskanego termu; rekombinacja wymaga wi¦c znalezienia
  pary podtermów <with|mode|math|e<rsub|1>,e<rsub|2>> takich, »e
  rekonstrukcja jest mo»liwa. W prostych systemach z podtypowaniem
  zadowalaj¡cy jest warunek, aby typ podtermu zast¦puj¡cego byª podtypem typu
  podtermu zast¦powanego. W systemach z polimorfizmem parametrycznym, gdzie
  parametry typu mog¡ ±ci±le wi¡za¢ si¦ z wªasno±ciami termu i kontekstu jego
  wyst¡pienia, nale»y zbudowa¢ odpowiednio±¢ mi¦dzy s¡dami typizuj¡cymi
  <with|mode|math|E<rsub|1>\<vdash\>e<rsub|1>:\<tau\><rsub|1>> oraz
  <with|mode|math|E<rsub|2>\<vdash\>e<rsub|2>:\<tau\><rsub|2>>
  uwzgl¦dniaj¡c¡, »e <with|mode|math|e<rsub|1>> wyst¦puje w derywacji typu
  dla termu macierzystego. Mo»emy przyj¡¢, »e dziedzina ±rodowisk derywacji
  obu programów macierzystych jest wspólna, ale typy mog¡ by¢ skonkretyzowane
  przez ró»ne \Ranswer substitutions''. Te podstawienia musz¡ by¢ zgodne
  (unifikowalne), ±rodowisko <with|mode|math|E<rsub|2>> musi da¢ si¦
  odwzorowa¢ na <with|mode|math|E<rsub|1>>,
  <with|mode|math|h:Dome(E<rsub|2>)\<rightarrow\>Dom(E<rsub|1>)>, z
  zachowaniem zmiennych z <with|mode|math|Dom(E<rsub|0>)> (przemianowanie
  zmiennych wolnych). Je±li rekonstrukcj¦ typizowania oprzemy na danym
  <with|mode|math|E<rsub|2>\<vdash\>e<rsub|2>:\<tau\><rsub|2>>, to
  przemianowanie musi by¢ zgodne z typami:
  <with|mode|math|H<rsub|L>*E<rsub|1>(x)=E<rsub|2>(h(x))>, oraz typ
  <with|mode|math|H<rsub|R>\<tau\><rsub|2>=\<tau\><rsub|1>>, przy czym
  <with|mode|math|H<rsub|R>> nie podstawia pod zmienne wyst¦puj¡ce w
  <with|mode|math|E<rsub|2>> (<with|mode|math|Dom(H<rsub|R>)\<cap\>\<b-F\>(E<rsub|2>)=
  \<varnothing\>>). Trójk¦ <with|mode|math|h,H<rsub|L>,H<rsub|R>> nazwiemy
  <with|mode|math|E<rsub|0>>-homomorfizmem typizowa«
  <with|mode|math|E<rsub|1>\<vdash\>e<rsub|1>:\<tau\><rsub|1>> oraz
  <with|mode|math|E<rsub|2>\<vdash\>e<rsub|2>:\<tau\><rsub|2>>.

  \ <subsection|Rekombinacja przez anty-unifikacj¦.>

  Jak widzimy, rekombinacja w przypadku bogatszych systemów typów jest
  zªo»onym problemem znajdowania analogii (mi¦dzy podtermami). Wielu autorów
  argumentuje, »e podstawowym narz¦dziem znajdowania, czy te» konstrukcji,
  analogii jest generalizacja (jako znajdowanie kategorii zawieraj¡cej
  wskazane obiekty) (np. <cite|hasker95>). U»yjemy generalizacji programów
  dla znajdowania analogicznych pozycji podtermów. Mechanizmem syntaktycznej
  generalizacji termów jest anty-unifikacja. W kracie termów z porz¡dkiem
  danym przez podstawienia (je±li <with|mode|math|(\<exists\>T)
  T*e<rsub|1>\<equiv\>e<rsub|2>>, to <with|mode|math|e<rsub|1>\<geqslant\>e<rsub|2>>,
  gdzie <with|mode|math|T> jest podstawieniem) unifikacja jest operacj¡
  infimum, a anty-unifikacja operacj¡ supremum dwu termów. Jednak przy
  pewnych naturalnych definicjach równowa»no±ci i podstawie« anty-unifikacja
  nie jest dobrze okre±lona (supremum nie istnieje). Artykuªy dotycz¡ce
  anty-unifikacji: <cite|pfenning91unification>, <cite|hasker95>,
  <cite|lu-generalization>. Ogólnie pomysª stosowania anty-unifikacji do
  rekombinacji termów polega na krzy»owaniu (ang. crossing-over) podstawie«.
  Dla termów <with|mode|math|e<rsub|1>> i <with|mode|math|e<rsub|2>> wynikiem
  anty-unifikacji jest term <with|mode|math|e> i podstawienia
  <with|mode|math|A<rsub|1>,A<rsub|2>> t. »e
  <with|mode|math|e<rsub|1>=A<rsub|1>e> i
  <with|mode|math|e<rsub|2>=A<rsub|2>e>. Je±li
  <with|mode|math|A<rsub|i>=[e<rsub|i,1>/x<rsub|1>;\<ldots\>;e<rsub|i,n>/x<rsub|n>]>,
  rekombinacj¡ <with|mode|math|e<rsub|1>,e<rsub|2>> b¦dzie
  <with|mode|math|><with|mode|math|[e<rsub|w<rsub|1>,1>/x<rsub|1>;\<ldots\>;e<rsub|w<rsub|n>,n>/x<rsub|n>]e>,
  gdzie <with|mode|math|<wide|w|\<vect\>>> jest dowolnym ci¡giem
  jedynkowo-dwójkowym. Jednak w bogatszych systemach typów jedne podstawienia
  determinuj¡ typ dla innych podstawie« i rekombinacja wymaga dostosowania
  tej techniki (ograniczenia dopuszczalnych ci¡gów
  <with|mode|math|<wide|w|\<vect\>>> tak, by rekombinant byª typizowalny).

  <subsubsection|Generalizacja i GP.>

  Jak podpowiada rozs¡dek, wspólne cechy obiecuj¡cych rodziców nale»y
  zachowa¢ u potomstwa. Oznacza to, »e rekombinacja powinna respektowa¢
  maksymalnie wiele wspólnych cech; cz¦sto nie mo»e respektowa¢ (zachowywa¢)
  wszystkich (porównaj analizy w <cite|radcliffe92algebra>), w podanej wy»ej
  formalizacji oznacza to, »e supremum zawiera wiele termów. Artykuª
  <cite|dhaeseleer94context> pokazuje u»yteczno±¢ rekombinacji zachowuj¡cej
  generalizacje pierwszego rz¦du (nie jest to rekombinacja krzy»uj¡ca
  podstawienia anty-unifikatora, zachowuje si¦ ona bardziej ``swobodnie'')
  u»ywanej ª¡cznie z rekombinacj¡ swobodn¡. Ograniczanie si¦ do rekombinacji
  zachowuj¡cej kontekst wymienianych podtermów (jak rekombinacja krzy»uj¡ca
  anty-unifikatory) ma oczywiste wady, gdy system GP nie ma wsparcia dla
  duplikacji kodu i wykorzystywania podprogramów (code reuse). Jednak
  proponowany w niniejszej pracy system wspiera te mechanizmy ewolucji dzi¦ki
  obsªudze definicji lokalnych: mutacja mo»e wprowadzi¢ wykorzystanie w danym
  miejscu dowolnego podtermu, który w razie potrzeby zostanie ``podniesiony''
  do definicji lokalnej; odpowiedni operator genetyczny zajmuje si¦
  rozwijaniem definicji. Rekombinacja zachowuj¡ca kontekst ma du»e znaczenie
  w kontekscie teori ``samolubnego genu'' nadaj¡c to»samo±¢ jednostkom
  selecji: wymieniany podterm nie trafi w przypadkowe miejsce programu,
  pozostanie w tej samej pozycji anty-unifikatora. W ten sposób selekcja
  b¦dzie nast¦powaªa ze wzgl¦du na speªnianie funkcji wyznaczonej przez
  anty-unifikator dla poszczególnych pozycji. Rekombinacja swobodna
  (dodatkowo dla j¦zyków nietypizowanych, gdzie jest ona rzeczywi±cie
  swobodna) powoduje nabywanie przez programy du»ych partii ''niekoduj¡cych''
  -- nigdy nie wykonywanych; problem ten jest nazywany ``code bloat''. Jest
  to mechanizm obronny zmniejszaj¡cy prawdopodobie«stwo przecinania przez
  rekombinacj¦ cennych fragmentów koduj¡cych, co zazwyczaj zaburzy ich
  funkcj¦ (patrz m. in. <cite|blickle94genetic> znakomicie pokazuj¡cy, »e co
  jest dobre dla genów, nie musi by¢ dobre dla szybko±ci ewolucji).

  <subsubsection|Rekombinacja zgodna z mutacj¡ i anty-unifikacja drugiego
  rz¦du.>

  Najpierw przedstawimy techniczne poj¦cie kompatybilnych mutacji próbkowych,
  »eby nast¦pnie poda¢ obrazowe poj¦cie rekombinacji zgodnej z mutacj¡,
  dodatkowo uzasadniaj¡ce oparcie rekombinacji programów na anty-unifikacji.

  Pozycja podtermu obejmuje pozycje podtermów tego podtermu. Pozycje w termie
  nazywamy rozdzielonymi, je±li »aden ich podzbiór nie obejmuje wspólnie
  wszystkich pozycji obejmowanych przez pewn¡ pozycj¦ obejmuj¡c¡ te pozycje,
  oprócz tej pozycji. Tzn. nie istnieje pozycja, obejmuj¡ca pozycje z tego
  podzbioru, i nie obejmuj¡ca »adnej pozycji nie obejmowanej przez pozycje z
  podzbioru poza sam¡ sob¡. Zdefiniujmy zbiór kompatybilnych mutacji
  próbkowych dla programu <with|mode|math|E<rsub|0>\<vdash\>e:\<tau\><rsub|0>>
  (odpowiednio dobranego). Mówimy, »e zastosowano mutacj¦
  <with|mode|math|p<rsub|i>,<wide|w|\<vect\>><rsub|i>>, je±li dany program
  <with|mode|math|E<rsub|0>\<vdash\>e<rsub|0>:\<tau\><rsub|0>> ma w pozycji
  <with|mode|math|p<rsub|i>> podterm z typizacj¡
  <with|mode|math|E<rsub|i>\<vdash\>e<rsub|i>:\<tau\><rsub|i>>, a wynikowy
  program ma dla <with|mode|math|T<rsub|i>,e<rsub|i><rprime|'>=\<b-C\>(E<rsub|i>,\<tau\><rsub|i>,<wide|w|\<vect\>><rsub|i>)>
  posta¢ <with|mode|math|T<rsub|i>*E<rsub|0>\<vdash\>[e<rsub|i><rprime|'>/p]e<rsub|0>:T<rsub|i>\<tau\><rsub|0>>.
  Mutacja jest próbkowa, je±li <with|mode|math|FV(e<rsub|1><rprime|'>)\<subset\>Dom(E<rsub|0>)>
  oraz »adna zmienna ani staªa <with|mode|math|e<rsub|i><rprime|'>> nie
  wyst¦puje w <with|mode|math|e<rsub|0>>. Mutacje próbkowe s¡ kompatybilne,
  je±li pozycje <with|mode|math|p<rsub|i>> s¡ rozdzielone,
  <with|mode|math|T<rsub|i>,e<rsub|i><rprime|'>=\<b-C\>(T<rsub|\<pi\>(1)>\<ldots\>T<rsub|\<pi\>(k)>E<rsub|i>,T<rsub|\<pi\>(1)>\<ldots\>T<rsub|\<pi\>(k)>\<tau\><rsub|i>,<wide|w|\<vect\>><rsub|i>)>
  dla dowolnego wyboru indeksów <with|mode|math|\<pi\>> nie zawieraj¡cego
  <with|mode|math|i>.

  Mówimy, »e operator rekombinacji jest zgodny z operatorem mutacji, je±li
  dla dowolnego zbioru <with|mode|math|M> kompatybilnych mutacji próbkowych
  dowolnego odpowiedniego programu <with|mode|math|e>, dla programu
  <with|mode|math|><with|mode|math|e<rsub|K>> powstaªego z zastosowania
  mutacji <with|mode|math|K\<subseteq\>M> i programu
  <with|mode|math|><with|mode|math|e<rsub|L>> powstaªego z zastosowania
  mutacji <with|mode|math|L\<subseteq\>M>, zbiór wszystkich rekombinacji
  <with|mode|math|e<rsub|K>,e<rsub|L>> skªada si¦ z wszystkich programów
  powstaªych przez zastosowanie mutacji <with|mode|math|N\<subseteq\>M>,
  gdzie <with|mode|math|K\<cap\>L\<subseteq\>N\<subseteq\>K\<cup\>L>.
  Porównaj warunki ``respect'' i ``assortment'' z pracy
  <cite|radcliffe92algebra>.

  Definicja pozycji rozdzielonych zostaªa dobrana tak, aby zgodny z mutacj¡
  operator rekombinacji mógª wogóle istnie¢. Gdyby pozycje nie byªy
  rozdzielone, rekombinacja nie potrafiªaby okre±li¢, ile wªa±ciwie mutacji
  zastosowano. Sprawd¹my, co wymusza powy»szy warunek na operatorze
  rekombinacji. Rekombinacja musi okre±li¢ pozycje, w których mutacj¦
  zastosowano tylko w jednym z rodziców. W pierwszym kroku oznaczmy pozycje,
  minimalne w odlegªo±ci od korzenia, o ró»nych etykietach (w grafie termu) u
  obu rodziców. W kolejnych krokach oznaczajmy pozycje, których wszyscy
  potomkowie s¡ ju» oznaczeni. Na koniec wybierzmy minimalne w odlegªo±ci od
  korzenia pozycje oznaczone. Rekombinacja polega¢ b¦dzie na wymianie
  podtermów rodziców na tych pozycjach. Je±li podstawimy zmienne w miejscu
  wybranych pozycji, uzyskamy maksymalnie szczegóªow¡ anty-instancj¦ drugiego
  rz¦du wzgl¦dem porz¡dku danego przez podstawienia ograniczone do podtermów
  anty-unifikowanych programów. Jest to najprostsza posta¢ anty-unifikacji
  drugiego rz¦du. Du»o mocniejsz¡ posta¢ anty-unifikacji drugiego rz¦du
  podaje <cite|hasker95>. Odpowiada ona operatorowi rekombinacji zgodnemu z
  mutacjami: mutacj¡ podtermu, insercj¡ (a wi¦c i delecj¡) oraz permutacj¡
  podtermów, przy odpowiednio okre±lonej niezale»no±ci mutacji. Podrozdziaª
  <reference|antyunif2rz> opisuje wªasno±ci anty-unifikacji Haskera i wy»ej
  opisanej. W bogatszych systemach typów, okre±lenie anty-unifikacji, a
  szczególnie rekombinacji, mo»e by¢ trudne.

  <subsection|Systemy typów z wi¦zami.>

  Kluczowym dla naszej sprawy artykuªem jest wedªug mnie
  <cite|simonet03constraintbased>. Jak wcze±niej pisaªem, potrzebujemy
  mo»liwie sprawnej metody inferencji typów dla systemu pozwalaj¡cego wyra»a¢
  logiczne wªasno±ci programów. Systemy z ``Guarded Algebraic Data Types'',
  czyli typami indukcyjnymi zawieraj¡cymi charakterystyk¦ logiczn¡
  poszczególnych przypadków, s¡ pod tym wzgl¦dem bardzo wygodne, co pokazuje
  chocia»by sukces systemu Coq, stosuj¡cego system typów Calculus of
  Inductive Constructions, rozszerzaj¡cy system CC o wªa±nie ``Guarded
  Algebraic Data Types'' (GADT). Artykuª Simoneta i Pottiera podaje
  ``minimalne'' rozszerzenie systemu ML pozwalaj¡ce na wygodne posªugiwanie
  si¦ GADT -- sparametryzowany j¦zykiem wyra»ania wi¦zów <with|mode|math|X>
  system <with|mode|math|HMG(X)>. Jednocze±nie podaje sprawny algorytm
  inferencji typu. (Dla potrzeb syntezy programów mo»na rzeczy dodatkowo
  upro±ci¢ rezygnuj¡c z peªnego mechanizmu ``pattern matching'' na rzecz
  prostszej analizy przez przypadki.) Jedyne annotacje, jakich potrzebuje
  system <with|mode|math|HMG(X)>, to typy dla funkcji rekurencyjnych.
  Potrzebuje ich dlatego, »e aby wykorzysta¢ mo»liwo±ci GADT potrzebujemy
  rekurencji polimorficznej, a problem inferencji typu dla rekurencji
  polimorficznej jest nierozstrzygalny.

  <subsubsection|Nierozstrzygalno±¢ inferencji typu dla rekurencji
  polimorficznej.>

  Do inferencji typu dla j¦zyka ML rozszerzonego o rekurencj¦ polimorficzn¡
  (tzw. j¦zyk ML+, albo system Milnera-Mycrofta) proponowano wiele podej±¢.
  Wa»n¡ prac¡ jest <cite|henglein93type>, pokazuj¡ca redukcj¦ do problemu
  semi-unifikacji, oraz podaj¡ca u»yteczny algorytm semi-unifikacji, pomimo
  nierozstrzygalno±ci samego problemu. Aktualnie prace nad u»yteczno±ci¡
  inferencji typu dla rekurencji polimorficznej prowadzone s¡ np. w ramach
  projektu badawczego [Research Project: ``SEMI-UNIFICATION and Periodicity
  of Turing Machines`` Carlos Camarao, Lucilia Figueiredo, Luigi Laporte,
  http://www.dcc.ufmg.br/~camarao/SUP/]. Przeprowadzenie inferencji typu dla
  rekurencji polimorficznej w systemie <with|mode|math|HMG(X)> jest
  oczywi±cie trudniejsze, ale wydaje si¦ nie mniej osi¡galne ni» w przypadku
  systemu ML+.

  <subsubsection|Wªasno±¢ stopu zapewniona przez system
  typów.><label|wlasnstopu>

  Kluczowym zagadnieniem poprawno±ci programu jest posiadanie przez niego
  wªasno±ci stopu. Autorka pracy <cite|tinayu99> stosuje iteratory (czy te»
  rekursory) jako funkcje pierwotne do manipulacji indukcyjnymi typami
  danych, nie pozwalaj¡c na rekurencj¦ bezpo±redni¡. Przypomina to sytuacj¦ w
  systemie Coq (przed wprowadzeniem konstrukcji <with|mode|math|Fix>), gdzie
  przy definicji typu indukcyjnego system od razu generuje odpowiednie
  rekursory (funkcje realizuj¡ce schematy rekursji). Jednak
  najodpowiedniejszy schemat rekursji dla danego problemu mo»e by¢ bardzo
  ró»ny od ogólnego schematu rekursji dla danego typu danych -- warto
  pozwoli¢ systemowi zrekonstruowa¢ odpowiedni schemat rekursji. Mo»na
  wymusi¢ wªasno±¢ stopu przy pomocy systemu typów. Bardzo prostym, a
  jednocze±nie ekspresyjnym systemem jest
  <with|mode|math|\<lambda\><wide||^>> przedstawiony w
  <cite|barthe-typebased>. Hongwei Xi konstruuje bardziej ekspresyjny system
  na bazie swojego j¦zyka <with|mode|math|DML(X)> (<with|mode|math|DML(X)>
  jest obejmowany przez <with|mode|math|HMG(X)>) <cite|xi01dependent>. Pisz¡c
  funkcj¦ rekurencyjn¡, w prosty sposób wprowadza si¦ metryk¦, wzgl¦dem
  której kolejne wywoªania rekurencyjne maj¡ male¢. (Metryki dopuszczaj¡ m.
  in. rekurencj¦ wzgl¦dem wielu zmiennych.)

  <subsection|Dalej w pracy.>

  <subsubsection|Rozdziaª 2 -- Generowanie termów.>

  Najpierw przedstawiony jest algorytm generowania termów dla systemu typów
  prostych, dla postaci normalnych (odpowiadaj¡cy dowodzeniu twierdze«
  intuicjonistycznego rachunku zda«). Nast¦pnie przedstawione s¡ algorytmy
  inferencji typów i generowania termów dla systemu Damasa-Milnera (ML),
  bazuj¡ce na ``operacyjnej'' interpretacji reguª systemu i wykorzystaniu
  unifikacji; podane s¡ wªasno±ci tych algorytmów, z dowodami. Zaprezentowany
  jest system <with|mode|math|\<lambda\><wide||^>> z pracy
  <cite|barthe-typebased>, w postaci oryginalnej i dostosowanej
  (zwi¦kszaj¡cej operacyjno±¢ reguª), i algorytmy generowania termów dla
  niego, na podstawie algorytmów dla ML. Umówiony jest zwi¡zek generowania
  termów <with|mode|math|\<beta\>>-normalnych z SLD-rezolucj¡. Na koniec,
  przedyskutowany jest problem optymalnego wprowadzania definicji lokalnych.

  <subsubsection|Rozdziaª 3 -- Generalizacja.>

  Zaprezentowany jest algorytm anty-unifikacji drugiego rz¦du wzgl¦dem
  podstawie« ograniczonych do podtermów unifikowanych termów, pokazana jest
  maksymalno±¢ generalizacji oraz poprawno±¢ (warunki poprawno±ci) opartej na
  niej rekombinacji w systemie Damasa-Milnera. Nast¦pnie omówione jest
  rozwi¡zanie zagadnienia generalizacji z pracy <cite|hasker95> i wskazane
  jest niedopatrzenie: zbyt optymistycznie deklarowana wªasno±¢ podanego
  praktycznego mechanizmu znajdowania generalizacji. Przedstawiony jest
  algorytm konstrukcji generalizacji na bazie wspomnianego mechanizmu. Podany
  jest z uzasadnieniem mechanizm znajdowania najbardziej szczegóªowej
  generalizacji.

  <subsubsection|Rozdziaª 4 -- Zako«czenie.>

  Rozdziaª prezentuje rezultaty pracy i zadania postawione do rozwi¡zania
  przez prac¦. W pierwszej cz¦±ci zebrane s¡ aspekty nowatorskie pracy. W
  drugiej cz¦±ci wskazane s¡ dalsze prace, jakie nale»y podj¡¢, na drodze do
  praktycznej implementacji systemu programowania genetycznego w j¦zykach z
  bogatszymi systemami typów.

  <chapter|Generowanie termów.><label|generowanie>

  <section|System typów prostych a intuicjonistyczny rachunek zda«.>

  W tym podrozdziale zaprezentuj¦ wyniki z pracy <cite|nagano-proof>.
  Stanowi¡ one dobre wprowadzenie w problem genrowania termów, w dobrze
  zbadanym usytuowaniu intuicjonistycznego rachunku zda«.

  <subsection|System dedukcji naturalnej i typizowany
  <with|mode|math|\<lambda\>>-rachunek.>

  <paragraph|System dedukcji naturalnej.>Dla uproszczenia, ograniczamy si¦ do
  implikacyjnego fragmentu logiki intuicjonistycznej.

  <\definition>
    Zbiór formuª (implikacyjnego rachunku zda«) jest okre±lony reguªami:

    <\enumerate>
      <item>Je±li <with|mode|math|A> jest formuª¡ atomow¡, to
      <with|mode|math|A> jest formuª¡.

      <item>Je±li <with|mode|math|X,Y> s¡ formuªami, to
      <with|mode|math|X\<rightarrow\>Y> jest formuª¡.
    </enumerate>
  </definition>

  W tym podrozdziale u»ywamy zamiennie poj¦¢ formuªa i typ.

  Dªugo±¢ formuªy <with|mode|math|\|A\|> definiujemy

  <\eqnarray*>
    <tformat|<table|<row|<cell|\|A\|>|<cell|=>|<cell|<choice|<tformat|<table|<row|<cell|1>|<cell|<with|mode|text|je±li
    >A<with|mode|text| jest atomowa>>>|<row|<cell|\|B\|+\|C\|+1>|<cell|<with|mode|text|je±li
    >A=B\<rightarrow\>C>>>>>>>>>
  </eqnarray*>

  <\definition>
    System dedukcji naturalnej <with|mode|math|\<b-N\>\<b-J\>> jest okre±lony
    nast¦puj¡cymi reguªami:

    <\enumerate>
      <item>(Aksjomat) Brak.

      <item>(I)

      <\equation*>
        <frac|B|A\<rightarrow\>B>
      </equation*>

      <item>(E) Modus ponens

      <\equation*>
        <frac|A\<rightarrow\>B<space|2fn>A|B>
      </equation*>
    </enumerate>
  </definition>

  <\definition>
    Niech <with|mode|math|\<Phi\>> b¦dzie sko«czonym zbiorem formuª i
    <with|mode|math|\<alpha\>> b¦dzie formuª¡. Piszemy
    <with|mode|math|\<Phi\>\<vdash\><rsub|N J>\<alpha\>> je±li istnieje dowód
    <with|mode|math|\<alpha\>> którego zbiorem niezdj¦tych (undischarged)
    zaªo»e« jest <with|mode|math|\<Phi\>>.
  </definition>

  <paragraph|Przypisanie typu do <with|mode|math|\<lambda\>>-termu.>

  <\definition>
    <with|mode|math|\<lambda\>>-term jest zdefiniowany jako:

    <\enumerate>
      <item>Zmienne <with|mode|math|x<rsub|1>,x<rsub|2>,\<ldots\>> s¡
      <with|mode|math|\<lambda\>>-termami.

      <item>Je±li <with|mode|math|M,N> s¡
      <with|mode|math|\<lambda\>>-termami, to <with|mode|math|(M N)> jest
      <with|mode|math|\<lambda\>>-termem.

      <item>Je±li <with|mode|math|M> jest <with|mode|math|\<lambda\>>-termem
      i <with|mode|math|x> jest zmienn¡, to <with|mode|math|(\<lambda\>x.M)>
      jest <with|mode|math|\<lambda\>>-termem.
    </enumerate>
  </definition>

  <with|mode|math|(M N)> jest nazywany aplikacj¡, a
  <with|mode|math|(\<lambda\>x.M)> abstrakcj¡.

  <\definition>
    Zbiór zmiennych wolnych <with|mode|math|\<b-F\>(M)> jest okre±lony przez:

    <\enumerate>
      <item><with|mode|math|\<b-F\>(x)={x}>

      <item><with|mode|math|\<b-F\>(M N)=\<b-F\>(M)\<cup\>\<b-F\>(N)>

      <item><with|mode|math|\<b-F\>(\<lambda\>x.M)=\<b-F\>(M)<mid|\\>{x}>
    </enumerate>
  </definition>

  <\definition>
    Je±li <with|mode|math|M> jest <with|mode|math|\<lambda\>>-termem i
    <with|mode|math|\<alpha\>> jest typem, to opis
    <with|mode|math|M:\<alpha\>> jest nazywany przypisaniem typu.
  </definition>

  <\definition>
    Zaªo»enie jest przypisaniem typu <with|mode|math|x:\<alpha\>> zmiennej
    <with|mode|math|x>. Zbiorem zaªo»e« nazywamy zbiór
    <with|mode|math|\<Phi\>={x<rsub|1>:\<alpha\><rsub|1>,\<ldots\>,x<rsub|n>:\<alpha\><rsub|n>}>
    taki, »e <with|mode|math|x<rsub|i>\<neq\>x<rsub|j>> dla
    <with|mode|math|i\<neq\>j>.
  </definition>

  <\definition>
    System typów <with|mode|math|T A<rsub|\<lambda\>>> jest okre±lony przez
    reguªy:

    <\enumerate>
      <item>(Aksjomat)

      <\equation*>
        \<Phi\>\<vdash\><rsub|\<lambda\>>x:\<alpha\><space|2fn>(x:\<alpha\>\<in\>\<Gamma\>)
      </equation*>

      <item>

      <\equation*>
        <frac|\<Phi\>\<vdash\><rsub|\<lambda\>>M:\<alpha\>\<rightarrow\>\<beta\><space|2fn>\<Phi\>\<vdash\><rsub|\<lambda\>>N:\<alpha\>|\<Phi\>\<vdash\><rsub|\<lambda\>>M
        N:\<beta\>>
      </equation*>

      <item>

      <\equation*>
        <frac|\<Phi\>\<vdash\><rsub|\<lambda\>>M:\<beta\>|\<Phi\><mid|\\>{x:\<alpha\>}\<vdash\><rsub|\<lambda\>>\<lambda\>x.M:\<alpha\>\<rightarrow\>\<beta\>>
      </equation*>
    </enumerate>
  </definition>

  <paragraph|Izomorfizm Curry'ego-Howarda.>

  <\theorem>
    \;

    <\eqnarray*>
      <tformat|<table|<row|<cell|>|<cell|>|<cell|\<exists\>M:\<lambda\><with|mode|text|-term
      taki, »e>>>|<row|<cell|\<Phi\>\<vdash\><rsub|N
      J>\<alpha\>>|<cell|\<Longleftrightarrow\>>|<cell|{x<rsub|1>:\<alpha\><rsub|1>,\<ldots\>,x<rsub|n>:\<alpha\><rsub|n>}\<vdash\><rsub|\<lambda\>>M:\<alpha\>>>|<row|<cell|>|<cell|>|<cell|<with|mode|text|oraz
      >\<b-F\>(M)\<subseteq\>{x<rsub|1>,\<ldots\>,x<rsub|n>}>>>>
    </eqnarray*>
  </theorem>

  <\theorem>
    <with|mode|math|\<vdash\><rsub|N J>\<alpha\>\<Longleftrightarrow\>\<exists\>M:<with|mode|text|domkni¦ty
    (bez zmiennych wolnych) >\<lambda\><with|mode|text|-term taki, »e
    >\<vdash\>M:\<alpha\>>.
  </theorem>

  <subsection|Dowody w postaci normalnej.>

  <paragraph|Beta redukcja.>

  <\definition>
    (Beta redukcja) Niech <with|mode|math|M> i <with|mode|math|N> b¦d¡
    <with|mode|math|\<lambda\>>-termami i <with|mode|math|x> b¦dzie zmienn¡.
    <with|mode|math|\<lambda\>>-term otrzymany z <with|mode|math|M> przez
    zast¡pienie wszystkich wyst¡pie« <with|mode|math|x> przez
    <with|mode|math|N> oznaczamy <with|mode|math|[N/x]M>.
    <with|mode|math|\<beta\>>-redukcja jest rekurencyjnie okre±lona przez:

    <\enumerate>
      <item><with|mode|math|M\<longrightarrow\><rsub|\<beta\>>M>.

      <item><with|mode|math|(\<lambda\>x.M)N\<longrightarrow\><rsub|\<beta\>>[N/x]M>.

      <item>Je±li <with|mode|math|M\<longrightarrow\><rsub|\<beta\>>N>, wtedy
      <with|mode|math|\<lambda\>x.M\<longrightarrow\><rsub|\<beta\>>\<lambda\>x.N>,
      <with|mode|math|M P\<longrightarrow\><rsub|\<beta\>>N P> oraz
      <with|mode|math|P M\<longrightarrow\><rsub|\<beta\>>P N>.

      <item>Je±li <with|mode|math|L\<longrightarrow\><rsub|\<beta\>>M> oraz
      <with|mode|math|M\<longrightarrow\><rsub|\<beta\>>N>, to
      <with|mode|math|L\<longrightarrow\><rsub|\<beta\>>N>.
    </enumerate>

    <with|mode|math|\<lambda\>>-term postaci
    <with|mode|math|(\<lambda\>x.M)N> jest nazywany
    <with|mode|math|\<beta\>>-redeksem.
  </definition>

  <\definition>
    (Posta¢ beta normalna) Je±li <with|mode|math|\<lambda\>>-term
    <with|mode|math|M> nie zawiera <with|mode|math|\<beta\>>-redeksów, wtedy
    <with|mode|math|M> jest w postaci <with|mode|math|\<beta\>>-normalnej.
    Zbiór wszystkich <with|mode|math|\<lambda\>>-termów w postaci normalnej
    jest oznaczany przez <with|mode|math|\<beta\>nf>. Mówimy, »e term
    <with|mode|math|M> ma posta¢ <with|mode|math|\<beta\>>-normaln¡ N wtw.
    gdy <with|mode|math|M\<longrightarrow\><rsub|\<beta\>>N> i
    <with|mode|math|N\<in\>\<beta\>nf>.
  </definition>

  <\theorem>
    (Twierdzenie ``subject reduction'') Je±li
    <with|mode|math|\<Phi\>\<vdash\>M:\<alpha\>> i
    <with|mode|math|M\<longrightarrow\><rsub|\<beta\>>N>, to
    <with|mode|math|\<Phi\>\<vdash\>N:\<alpha\>>.
  </theorem>

  <paragraph|Twierdzenie o normalizacji.>

  <\theorem>
    (Twierdzenie o normalizacji) Je±li <with|mode|math|\<Phi\>\<vdash\>M:\<alpha\>>,
    to <with|mode|math|\<Phi\>\<vdash\>N:\<alpha\>> dla pewnego
    <with|mode|math|\<lambda\>>-termu <with|mode|math|N\<in\>\<beta\>nf>
    takiego, »e <with|mode|math|M\<longrightarrow\><rsub|\<beta\>>N>.
  </theorem>

  <subsection|Poszukiwanie dowodów.>

  <paragraph|Rachunek sekwentów <with|mode|math|N J<rsub|\<beta\>>>.>Kolejne
  zastosowania reguªy (I) daj¡

  <\equation*>
    <frac|<tree|A<rsub|1>\<ldots\>A<rsub|n>|B>|A<rsub|1>\<rightarrow\>\<ldots\>\<rightarrow\>A<rsub|n>\<rightarrow\>B><space|2fn><with|mode|text|I*>
  </equation*>

  Kolejne zastosowania reguªy (E) daj¡

  <\equation*>
    <frac|A<rsub|1>\<rightarrow\>\<ldots\>\<rightarrow\>A<rsub|n>\<rightarrow\>B<space|2fn>A<rsub|1><space|2fn>\<ldots\><space|2fn>A<rsub|n>|B><space|2fn><with|mode|text|E*>
  </equation*>

  W szczególno±ci, <with|mode|math|B> staje si¦ formuª¡ atomow¡ w (I*) oraz
  (E*). Kiedy »adna inferencja nie pojawia si¦ powy»ej
  <with|mode|math|A<rsub|1>\<rightarrow\>\<ldots\>\<rightarrow\>A<rsub|n>\<rightarrow\>B>
  w (E*), jest ona w zbiorze <with|mode|math|\<Gamma\>> zaªo»e«. Kiedy
  <with|mode|math|A<rsub|i>> nie jest atomowa, mamy nast¦puj¡cy dowód ponad
  <with|mode|math|A<rsub|i>>:

  <\equation*>
    <frac|<tree|A<rsub|i<rsub|1>>\<ldots\>A<rsub|i<rsub|<rsub|k>>>|A<rsub|i<rsub|0>>>|A<rsub|i<rsub|1>>\<rightarrow\>\<ldots\>\<rightarrow\>A<rsub|i<rsub|k>>\<rightarrow\>A<rsub|i<rsub|0>>><space|2fn><with|mode|text|I*>
  </equation*>

  Zdefiniujemy rachunek sekwentów <with|mode|math|N J<rsub|\<beta\>>>.
  Intuicyjnie, dowód w <with|mode|math|N J<rsub|\<beta\>>> otrzymuje si¦
  przez koncentracj¦ wyst¡pie« formuª atomowych jak <with|mode|math|B> i
  <with|mode|math|A<rsub|i<rsub|0>>>. Dowód w <with|mode|math|N
  J<rsub|\<beta\>>> odpowiada ``dªugiej postaci normalnej'' (ang. long normal
  form) w <with|mode|math|\<lambda\>>-rachunku z systemem typów prostych oraz
  ``rozszerzonej postaci normalnej'' (ang. expanded normal form) Systemu
  Dedukcji Naturalnej Prawitza. (Zamiast oznacze« <with|mode|math|H> oraz
  <with|mode|math|T> z pracy <cite|nagano-proof> u»yj¦ oznacze«
  <with|mode|math|B> jak ``body`` oraz <with|mode|math|H> jak ''head''.)

  <\definition>
    Maj¡c dan¡ formuª¦ <with|mode|math|X=A<rsub|1>\<rightarrow\>\<ldots\>\<rightarrow\>A<rsub|n>\<rightarrow\>A>
    z atomow¡ <with|mode|math|A>, definiujemy
    <with|mode|math|B(X)={A<rsub|1>,\<ldots\>,A<rsub|n>}> oraz
    <with|mode|math|H(X)=A>. Je±li <with|mode|math|n=0>, to
    <with|mode|math|H(X)= \<varnothing\>>.
  </definition>

  U»ywamy liter greckich <with|mode|math|\<Phi\>,\<Delta\>> etc. na
  oznaczenie zbiorów formuª. <with|mode|math|\<Phi\>,\<Delta\>> oznacza sum¦
  zbiorów <with|mode|math|\<Phi\>> i <with|mode|math|\<Delta\>>.

  <\definition>
    System dedukcji naturalnej <with|mode|math|N J<rsub|\<beta\>>> jest
    zdefiniowany nast¦puj¡cymi reguªami:

    <\enumerate>
      <item>(Aksjomat)

      <\equation*>
        \<Phi\>\<vdash\>A,<space|2fn><with|mode|text|je±li
        >A\<in\>\<Phi\><with|mode|text| i >A<with|mode|text| jest atomowa>
      </equation*>

      <item>(Inferencja)

      <\equation*>
        <frac|B(A<rsub|1>),\<Phi\>\<vdash\>H(A<rsub|1>)<space|2fn>\<ldots\><space|2fn>B(A<rsub|n>),\<Phi\>\<vdash\>H(A<rsub|n>)|\<Phi\>\<vdash\>A>
      </equation*>

      je±li <with|mode|math|A<rsub|1>\<rightarrow\>\<ldots\>\<rightarrow\>A<rsub|n>\<rightarrow\>A>
      nale»y do <with|mode|math|\<Phi\>> oraz <with|mode|math|A> jest
      atomowa.
    </enumerate>
  </definition>

  <\theorem>
    <label|cutelim>Niech <with|mode|math|\<Phi\>> b¦dzie zbiorem formuª i
    <with|mode|math|>A formuª¡.

    <\eqnarray*>
      <tformat|<table|<row|<cell|\<Phi\>\<vdash\><rsub|N
      J>A>|<cell|\<Longleftrightarrow\>>|<cell|\<Phi\>\<vdash\><rsub|N
      J<rsub|\<beta\>>>A>>>>
    </eqnarray*>
  </theorem>

  <paragraph|Drzewo dedukcyjne.>Szukamy dowodu sekwentu
  <with|mode|math|\<Phi\>\<vdash\>A> (dowód formuªy <with|mode|math|A> dany
  jest przy <with|mode|math|\<Phi\>= \<varnothing\>>). Algorytm
  <with|mode|math|Search> bierze jako wej±cie sekwent
  <with|mode|math|\<Phi\>\<vdash\>A> z atomow¡ <with|mode|math|A> oraz list¦
  <with|mode|math|\<xi\>> sekwentów ±ledz¡c¡ ±cie»k¦ dowodu, aby wykry¢
  zap¦tlenie. Algorytm zwraca drzewo sekwentów których wnioskami s¡ formuªy
  atomowe. Li±cie drzewa maj¡ trzy rodzaje etykiet: ``aksjomat'', ``p¦tla'',
  ``stop''. Nazywamy je drzewem dedukcyjnym. Drzewem dowodowym albo dowodem
  nazywamy drzewo, w którym w¦zeª powstaje przez zastosowanie reguªy
  inferencji systemu dedukcyjnego do jego synów, a li±cie powstaj¡ przez
  zastosowanie reguªy ``aksjomat''.

  <\definition>
    <with|mode|math|Search(\<Phi\>\<vdash\>A;\<xi\>)>:

    <\enumerate>
      <item><with|mode|math|A\<in\>\<Phi\>>. Zwró¢ w¦zeª
      <with|mode|math|A\<in\>\<Phi\>> z etykiet¡ ``aksjomat''.

      <item><with|mode|math|A\<nin\>\<Phi\>>.

      <\enumerate>
        <item><with|mode|math|\<Phi\>\<vdash\>A\<in\>\<xi\>>. Zwró¢ w¦zeª
        <with|mode|math|\<Phi\>\<vdash\>A> z etykiet¡ ``p¦tla''.

        <item><with|mode|math|\<Phi\>\<vdash\>A\<nin\>\<xi\>>.

        <\enumerate>
          <item><with|mode|math|\<Phi\>> nie zawiera »adnej
          <with|mode|math|A<rsub|i>> takiej, »e
          <with|mode|math|T(A<rsub|i>)=A>. Zwró¢ w¦zeª
          <with|mode|math|\<Phi\>\<vdash\>A> z etykiet¡ ``stop''.

          <item><with|mode|math|\<Phi\>> zawiera <with|mode|math|A<rsub|i>>
          takie, »e <with|mode|math|T(A<rsub|i>)=A>. Niech
          <with|mode|math|A<rsub|1>,\<ldots\>,A<rsub|m>> b¦d¡ wszystkimi
          takimi formuªami oraz <with|mode|math|A<rsub|i>=B<rsup|i><rsub|1>\<rightarrow\>\<ldots\>\<rightarrow\>B<rsup|i><rsub|n<rsub|i>>\<rightarrow\>A<space|0.6spc>(i=1,\<ldots\>,m)>.
          Mamy <with|mode|math|H(A<rsub|i>)={B<rsub|1><rsup|i>,\<ldots\>,B<rsub|n<rsub|i>><rsup|i>}>.
          Stosuj¡c algorytm rekurencyjnie, mamy

          <\equation*>
            u<rsub|j><rsup|i>=Search((B(B<rsup|i><rsub|j>),\<Phi\>)\<vdash\>H(B<rsub|j><rsup|i>);(\<Phi\>\<vdash\>A)+\<xi\>)
          </equation*>

          dla <with|mode|math|i=1,\<ldots\>,m> oraz
          <with|mode|math|j=1,\<ldots\>,n<rsub|i>>.

          <\enumerate>
            <item>Dla pewnych (niedeterminizm)
            <with|mode|math|1\<leqslant\>i\<leqslant\>m>, wszystkie
            <with|mode|math|u<rsub|1><rsup|i>,\<ldots\>,u<rsub|n<rsub|i>><rsup|i>>
            s¡ dowodami. Zwró¢ dowód postaci

            <\equation*>
              <frac|u<rsub|1><rsup|i><space|2fn>\<ldots\><space|2fn>u<rsub|n<rsub|i>><rsup|i>|\<Phi\>\<vdash\>A>
            </equation*>

            <item>Dla ka»dego <with|mode|math|i=1,\<ldots\>,m>, pewne
            (niedeterminizm) drzewo <with|mode|math|u<rsub|j<rsub|i>><rsup|i>>
            nie jest dowodem <with|mode|math|(1\<leqslant\>j<rsub|i>\<leqslant\>n<rsub|i>)>.
            Zwró¢ drzewo, którego korzeniem jest
            <with|mode|math|\<Phi\>\<vdash\>A> a synami korzenia s¡
            <with|mode|math|u<rsup|1><rsub|j<rsub|1>>,\<ldots\>,u<rsup|m><rsub|j<rsub|m>>>.
          </enumerate>
        </enumerate>
      </enumerate>
    </enumerate>
  </definition>

  Niedeterminizm algorytmu nie dotyczy rodzaju odpowiedzi: dowód czy
  obalenie, a jedynie tego, który konkretnie dowód (które obalenie) zostanie
  zwrócony. <with|mode|math|\<epsilon\>> oznacza ci¡g pusty.

  <\theorem>
    Niech <with|mode|math|A> b¦dzie formuª¡ i
    <with|mode|math|t=Search(\<varnothing\>\<vdash\>A;\<epsilon\>)>. Je±li
    <with|mode|math|A> jest dowodliwa w logice intuicjonistycznej, to
    wszystkie li±cie <with|mode|math|t> s¡ etykietowane przez ``aksjomat'' i
    drzewo jest dowodem <with|mode|math|A>.
  </theorem>

  <\definition>
    Je±li drzewo zawiera etykiet¦ ``stop'' albo ``p¦tla'', nazywamy je
    drzewem obalenia.
  </definition>

  <\theorem>
    (Zatrzymywanie si¦ poszukiwania) Dla ka»dego sekwentu
    <with|mode|math|\<Phi\>\<vdash\>A>, algorytm <with|mode|math|Search>
    zatrzymuje si¦ (ko«czy prac¦).
  </theorem>

  <\theorem>
    Niech <with|mode|math|A> b¦dzie formuª¡,
    <with|mode|math|t=Search(\<varnothing\>\<vdash\>A;\<epsilon\>)>. Je±li
    <with|mode|math|A> nie jest dowodliwa w logice intuicjonistycznej, to
    <with|mode|math|t> jest drzewem obalenia.
  </theorem>

  Drzewo obalenia pozwala wtedy ªatwo skonstruowa¢ kontr-model.

  <subsection|Algorytm generuj¡cy <with|mode|math|\<lambda\>>-termy.>

  <with|mode|math|\<lambda\>>-termy w dªugiej postaci normalnej (ang.
  <with|mode|math|\<eta\>>-long <with|mode|math|\<beta\>>-normal form) s¡
  podstaw¡ dziaªania algorytmu <with|mode|math|Search>: izomorfizm
  Curry'ego-Howarda wykorzystuje si¦ w dowodzie twierdzenia
  <reference|cutelim>. Oto wersja zwracaj¡ca termy; nie potrzebujemy wtedy
  drzewa obalenia. Niech <with|mode|math|\<Phi\>> b¦dzie zbiorem zaªo»e«, a
  <with|mode|math|A> typem. Wtedy <with|mode|math|Search(\<Phi\>,A;\<xi\>)>:

  <\enumerate>
    <item><with|mode|math|x:A\<in\>\<Phi\>>. Zwró¢ <with|mode|math|x.>

    <item><with|mode|math|A\<nin\>\<Phi\>>.

    <\enumerate>
      <item><with|mode|math|\<Phi\>\<vdash\>A\<in\>\<xi\>>. Wywoªaj wyj¡tek
      ``p¦tla''.

      <item><with|mode|math|\<Phi\>\<vdash\>A\<nin\>\<xi\>>.

      <\enumerate>
        <item><with|mode|math|\<Phi\>> nie zawiera »adnego
        <with|mode|math|x:A<rsub|i>> takiego, »e
        <with|mode|math|T(A<rsub|i>)=A>. Wywoªaj wyj¡tek ``stop''.

        <item><with|mode|math|\<Phi\>> zawiera
        <with|mode|math|x<rsub|i>:A<rsub|i>> takie, »e
        <with|mode|math|T(A<rsub|i>)=A>. Niech
        <with|mode|math|x<rsub|1>:A<rsub|1>,\<ldots\>,x<rsub|m>:A<rsub|m>>
        b¦d¡ wszystkimi takimi przypisaniami typu oraz
        <with|mode|math|A<rsub|i>=B<rsup|i><rsub|1>\<rightarrow\>\<ldots\>\<rightarrow\>B<rsup|i><rsub|n<rsub|i>>\<rightarrow\>A<space|0.6spc>(i=1,\<ldots\>,m)>.
        Mamy <with|mode|math|H(A<rsub|i>)={B<rsub|1><rsup|i>,\<ldots\>,B<rsub|n<rsub|i>><rsup|i>}>.
        Niech <with|mode|math|B(B<rsup|i><rsub|j>)={B<rsub|j><rsup|i,1>,\<ldots\>,B<rsub|j><rsup|i,k<rsub|i,j>>}>.
        Niech <with|mode|math|x<rsup|i,k><rsub|j>> b¦d¡ nowymi zmiennymi.
        <with|mode|math|>Stosuj¡c algorytm rekurencyjnie, mamy

        <\equation*>
          u<rsub|j><rsup|i>=Search(({x<rsub|j><rsup|i,1>:B<rsub|j><rsup|i,1>,\<ldots\>,x<rsub|j><rsup|i,k<rsub|i,j>>:B<rsub|j><rsup|i,k<rsub|i,j>>},\<Phi\>),H(B<rsub|j><rsup|i>);(\<Phi\>\<vdash\>A)+\<xi\>)
        </equation*>

        dla <with|mode|math|i=1,\<ldots\>,m> oraz
        <with|mode|math|j=1,\<ldots\>,n<rsub|i>>.

        <\enumerate>
          <item>Dla pewnych (niedeterminizm)
          <with|mode|math|1\<leqslant\>i\<leqslant\>m>, wszystkie
          <with|mode|math|u<rsub|1><rsup|i>,\<ldots\>,u<rsub|n<rsub|i>><rsup|i>>
          s¡ obliczone. Zwró¢ term postaci

          <\equation*>
            (\<ldots\>(x<rsub|i> (\<lambda\>x<rsub|1><rsup|i,1>\<ldots\>\<lambda\>x<rsub|1><rsup|i,k<rsub|i,1>>.u<rsub|1><rsup|i>))<space|2fn>\<ldots\><space|2fn>(\<lambda\>x<rsub|1><rsup|i,1>\<ldots\>\<lambda\>x<rsub|1><rsup|i,k<rsub|i,1>>.u<rsub|n<rsub|i>><rsup|i>))
          </equation*>

          <item>Dla ka»dego <with|mode|math|i=1,\<ldots\>,m>, pewne
          <with|mode|math|u<rsub|j<rsub|i>><rsup|i>> nie jest obliczone
          (wywoªano wyj¡tek) <with|mode|math|(1\<leqslant\>j<rsub|i>\<leqslant\>n<rsub|i>)>.
          Wywoªaj wyj¡tek.
        </enumerate>
      </enumerate>
    </enumerate>
  </enumerate>

  <new-page>

  \;

  <section|System Damasa-Milnera: inferencja typu i generowanie
  termu.><label|DamasMilner>

  Generowanie termu dla danego typu jest ''odwrotno±ci¡'' inferencji typu dla
  danego termu. Obie operacje s¡ dowodzeniem, w pierwszym przypadku, »e typ
  jest zamieszkaªy, w drugim, »e term jest poprawnie typowany (ang.
  well-typed). Reguªami dowodzenia s¡ reguªy obranego systemu typów, które
  ª¡cz¡ termy i typy. W tym rozdziale opieram si¦ na ksi¡»ce
  <cite|leroy92polymorphic>, rozdziaª 1. ''A polymorphic applicative
  language''.

  Wprowad¹my oznaczenia:

  <\definition>
    Generalizacja

    <\eqnarray*>
      <tformat|<table|<row|<cell|\<b-G\>(\<tau\>,E)>|<cell|=>|<cell|\<forall\>\<alpha\><rsub|1>,\<ldots\>,\<alpha\><rsub|n>.\<tau\>>>>>
    </eqnarray*>

    gdzie <with|mode|math|\<alpha\><rsub|1>,\<ldots\>\<alpha\><rsub|n>> s¡
    dokªadnie tymi zmiennymi wolnymi w <with|mode|math|\<tau\>>, które nie
    wyst¦puj¡ w <with|mode|math|E>.

    Je±li <with|mode|math|E=[x<rsub|1>:\<tau\><rsub|1>;x<rsub|2>:\<tau\><rsub|2>;\<ldots\>;x<rsub|k>:\<tau\><rsub|k>]>,
    oraz <with|mode|math|1\<leqslant\>n\<leqslant\>k> to oznaczamy
    <with|mode|math|E(n)=x<rsub|n>:\<tau\><rsub|n>> oraz
    <with|mode|math|E(x<rsub|n>)=\<tau\><rsub|n>>. Dªugo±¢ oznaczamy
    <with|mode|math|<wide|E|\<bar\>>=k>.
  </definition>

  <\definition>
    Konkretyzacja typu zmiennej ze ±rodowiska: <with|mode|math|\<tau\> > jest
    konkretyzacj¡ typu zmiennej <with|mode|math|x> ze ±rodowiska
    <with|mode|math|E>

    <\eqnarray*>
      <tformat|<table|<row|<cell|\<tau\>\<leqslant\>E(x)>|<cell|\<equiv\>>|<cell|E=\<ldots\>;x:\<forall\>\<alpha\><rsub|1>\<ldots\>\<alpha\><rsub|n>.\<sigma\>;\<ldots\><with|mode|text|
      i >\<tau\>=[\<tau\><rsub|1>/\<alpha\><rsub|1>;\<ldots\>;\<tau\><rsub|n>/\<alpha\><rsub|n>]\<sigma\>>>>>
    </eqnarray*>

    dla pewnych <with|mode|math|\<tau\><rsub|1>,\<ldots\>,\<tau\><rsub|n>>.
    Typ <with|mode|math|\<sigma\>> jest bardziej ogólny ni»
    <with|mode|math|\<tau\>>

    <\eqnarray*>
      <tformat|<table|<row|<cell|\<tau\>\<leqslant\>\<sigma\>>|<cell|\<equiv\>>|<cell|\<tau\>=\<forall\>\<gamma\><rsub|1>\<ldots\>\<gamma\><rsub|m>.\<tau\><rprime|'>\<wedge\>\<sigma\>=\<forall\>\<alpha\><rsub|1>\<ldots\>\<alpha\><rsub|n>.\<sigma\><rprime|'>\<wedge\>\<tau\><rprime|'>=[\<tau\><rsub|1>/\<alpha\><rsub|1>;\<ldots\>;\<tau\><rsub|n>/\<alpha\><rsub|n>]\<sigma\><rprime|'>>>>>
    </eqnarray*>

    dla pewnych <with|mode|math|\<tau\><rsub|1>,\<ldots\>\<tau\><rsub|n>>.
    Podstawienie <with|mode|math|T=[\<tau\><rsub|1>/\<alpha\><rsub|1>;\<ldots\>;\<tau\><rsub|n>/\<alpha\><rsub|n>]>
    oznacza zast¡pienie wolnych wyst¡pie« zmiennych
    <with|mode|math|\<alpha\><rsub|i>> przez odpowiedni typ
    <with|mode|math|\<tau\><rsub|i>>.
  </definition>

  <\definition>
    \ Reguªy typowania j¦zyka Mini-ML:

    <\enumerate>
      <item>VAR: Variables.

      <\equation*>
        <frac|\<tau\>\<leqslant\>E(x)|E\<vdash\>x:\<tau\>>
      </equation*>

      <item>FIX: Functions.

      <\equation*>
        <frac|E.f:\<sigma\>\<rightarrow\>\<tau\>.x:\<sigma\>\<vdash\>e:\<tau\>|E\<vdash\>(fix
        f x.e):\<sigma\>\<rightarrow\>\<tau\>>
      </equation*>

      <item>APP: Applications.

      <\equation*>
        <frac|E\<vdash\>e:\<sigma\>\<rightarrow\>\<tau\><space|2fn>E\<vdash\>e<rprime|'>:\<sigma\>|E\<vdash\>e
        e<rprime|'>:\<tau\>>
      </equation*>

      <item>LET: Local bindings.

      <\equation*>
        <frac|E\<vdash\>e<rprime|'>:\<sigma\><space|2fn>E.x:\<b-G\>(\<sigma\>,E)\<vdash\>e:\<tau\>|E\<vdash\>(let
        x=e<rprime|'> in e):\<tau\>>
      </equation*>
    </enumerate>
  </definition>

  Dopuszczam <with|mode|math|n>-arne konstruktory typów, np. nularny
  <with|mode|math|int>, unarny <with|mode|math|list \<alpha\>>, binarny
  <with|mode|math|pair(\<alpha\>,\<beta\>)>. O staªych mo»na zaªo»y¢, »e s¡
  zmiennymi pocz¡tkowego ±rodowiska. Za [Leroy92] pomijam konstrukcj¦
  <with|mode|math|\<lambda\>>-abstrakcji ABS

  <\equation*>
    <frac|E.x:\<sigma\>\<vdash\>e:\<tau\>|E\<vdash\>\<lambda\>x.e:\<sigma\>\<rightarrow\>\<tau\>>
  </equation*>

  poniewa» jest ona równowa»na FIX dla nowej nazwy <with|mode|math|f> nie
  wyst¦puj¡cej w <with|mode|math|e>. W rozwa»anych w tym rozdziale systemach
  typów (systemie Mini-ML, rozszerzonym nast¦pnie o indukcyjne typy danych)
  kwantyfikator wyst¦puje tylko na zewn¡trz, tzn. ka»dy typ ma posta¢
  <with|mode|math|\<forall\>\<alpha\><rsub|1>\<ldots\>\<alpha\><rsub|n>.\<tau\>>
  (lub <with|mode|math|\<tau\>> dla <with|mode|math|n=0>) oraz
  <with|mode|math|\<forall\>> nie wyst¦puje w <with|mode|math|\<tau\>>. Je±li
  typ zadany dla generowanego termu ma tak¡ posta¢, to do algorytmu
  generuj¡cego przekazujemy <with|mode|math|[d<rsub|1>/\<alpha\><rsub|1>;\<ldots\>;d<rsub|n>/\<alpha\><rsub|n>]\<tau\>>,
  gdzie <with|mode|math|d<rsub|i>> s¡ nowymi staªymi typu (nularnymi
  konstruktorami typu). W algorytmach zakªadamy, »e kwantyfikator nie
  wyst¦puje w zadanym typie.

  <\lemma>
    Je±li <with|mode|math|E\<vdash\>\<tau\>> oraz staªe typu
    <with|mode|math|d<rsub|1>,\<ldots\>,d<rsub|n>> nie wyst¦puj¡ w
    <with|mode|math|E>, to

    <\equation*>
      E\<vdash\>\<forall\>\<alpha\><rsub|1>\<ldots\>\<alpha\><rsub|n>.[\<alpha\><rsub|1>/d<rsub|1>;\<ldots\>;\<alpha\><rsub|n>/d<rsub|n>]\<tau\>
    </equation*>
  </lemma>

  <subsection|Algorytm inferencji typu <with|mode|math|\<cal-W\>> i algorytm
  generowania termu <with|mode|math|\<cal-C\>>.>

  Przyjrzyjmy si¦ algorytmowi <with|mode|math|\<cal-W\>> tak jak jest on
  podany w <cite|leroy92polymorphic>. Kolejne kroki algorytmu odpowiadaj¡
  kolejnym konstrukcjom j¦zyka. Je±li <with|mode|math|E> jest zbiorem zaªo»e«
  (±rodowiskiem), <with|mode|math|e> wyra»eniem, <with|mode|math|V> zbiorem
  nowych zmiennych typu i <with|mode|math|\<cal-W\>> ko«czy z powodzeniem, to
  <with|mode|math|\<cal-W\>(E,e,V)=(T,\<tau\>,V<rprime|'>)>, gdzie
  <with|mode|math|\<tau\>> jest najogólniejszym typem <with|mode|math|e>,
  <with|mode|math|T> takie »e <with|mode|math|T E> jest odpowiednim
  podstawieniem pod zmienne w <with|mode|math|E>,
  <with|mode|math|V<rprime|'>> s¡ pozostaªymi zmiennymi.
  <with|mode|math|U=\<b-U\>(\<tau\>,\<sigma\>)> jest (najogólniejszym)
  unifikatorem typów <with|mode|math|\<tau\>,\<sigma\>>.

  <\definition>
    <with|mode|math|\<cal-W\>(E,e,V)=(T,\<tau\>,V<rprime|'>)>, gdzie dopasuj
    <with|mode|math|e>:

    <\enumerate>
      <item><with|mode|math|e=x> (VAR: Variables). <with|mode|math|T=
      \<varnothing\>> i dla <with|mode|math|x:\<forall\>\<alpha\><rsub|1>\<ldots\>\<alpha\><rsub|n>.\<sigma\>\<in\>E>
      niech

      <\eqnarray*>
        <tformat|<table|<row|<cell|\<tau\>>|<cell|=>|<cell|[<wide|\<beta\>|\<vect\>>/<wide|\<alpha\>|\<vect\>>]\<sigma\>>>|<row|<cell|V<rprime|'>>|<cell|=>|<cell|V<rprime|'>\<smallsetminus\><wide|\<beta\>|\<vect\>>>>|<row|<cell|T>|<cell|=>|<cell|\<varnothing\>>>>>
      </eqnarray*>

      <item><with|mode|math|e=fix f x.e<rsub|1>> (FIX: Functions). Niech

      <\eqnarray*>
        <tformat|<table|<row|<cell|V>|<cell|=>|<cell|{\<beta\>,\<beta\><rsub|1>}<wide|\<cup\>|\<dot\>>V<rprime|''>>>|<row|<cell|(R,\<rho\>,V<rprime|'>)>|<cell|=>|<cell|\<cal-W\>(E.f:\<beta\><rsub|1>\<rightarrow\>\<beta\>.x:\<beta\><rsub|1>,e<rsub|1>,V<rprime|''>)>>|<row|<cell|U>|<cell|=>|<cell|\<b-U\>(R\<beta\>,\<rho\>)>>|<row|<cell|T>|<cell|=>|<cell|U*R>>|<row|<cell|\<tau\>>|<cell|=>|<cell|U*R*(\<beta\><rsub|1>\<rightarrow\>\<beta\>)>>>>
      </eqnarray*>

      <item><with|mode|math|e=f*g> (APP: Applications). Niech

      <\eqnarray*>
        <tformat|<table|<row|<cell|(R,\<rho\>,V<rsub|1>)>|<cell|=>|<cell|\<cal-W\>(E,f,V)>>|<row|<cell|(S,\<sigma\>,V<rsub|2>)>|<cell|=>|<cell|\<cal-W\>(R*E,g,V<rsub|1>)>>|<row|<cell|U>|<cell|=>|<cell|\<b-U\>(S\<rho\>,\<sigma\>\<rightarrow\>\<beta\>)>>|<row|<cell|V<rprime|'>>|<cell|=>|<cell|V<rsub|2>\<setminus\>{\<beta\>}>>|<row|<cell|T>|<cell|=>|<cell|U*S*R>>|<row|<cell|\<tau\>>|<cell|=>|<cell|U\<beta\>>>>>
      </eqnarray*>

      <item><with|mode|math|e=let x=f in g> (LET: Local bindings). Niech

      <\eqnarray*>
        <tformat|<table|<row|<cell|(R,\<rho\>,V<rsub|1>)>|<cell|=>|<cell|\<cal-W\>(E,f,V)>>|<row|<cell|(S,\<sigma\>,V<rprime|'>)>|<cell|=>|<cell|\<cal-W\>(R*E.x:\<b-G\>(\<rho\>,R*E),g,V<rsub|1>)>>|<row|<cell|T>|<cell|=>|<cell|S*R>>|<row|<cell|\<tau\>>|<cell|=>|<cell|\<sigma\>>>>>
      </eqnarray*>
    </enumerate>
  </definition>

  Algorytm ten najpierw rozgaª¦zia si¦ na poszczególne zmienne, a nast¦pnie
  unifikuje zgromadzon¡ informacj¦. Algorytm generuj¡cy termy b¦dzie
  rozdzielaª informacje o typie, tak »e gdy Rzdecyduje si¦'' na zmienn¡, jej
  typ b¦dzie ju» (w odpowiednim stopniu) okre±lony. Algorytm zawodzi dla
  danej ±cie»ki wyborów, je±li nie odnajdzie odpowiedniej zmiennej w
  ±rodowisku. Zwrócony term ma typ bardziej konkretny ni» typ zadany,
  zwrócone jest te» odpowiednie podstawienie. Je±li <with|mode|math|E> jest
  ±rodowiskiem, <with|mode|math|\<tau\>> typem,
  <with|mode|math|<wide|w|\<vect\>>> ci¡giem liczb naturalnych nazywanym
  ci¡giem albo ±cie»k¡ wyborów, to albo <with|mode|math|\<cal-C\>(E,\<tau\>,V,<wide|w|\<vect\>>)=(T,e,V<rprime|'>,
  <wide|w|\<vect\>><rprime|'>)>, albo <with|mode|math|\<cal-C\>> nie jest
  okre±lone, gdzie <with|mode|math|e> jest typu <with|mode|math|T\<tau\>> w
  ±rodowisku <with|mode|math|T*E>, <with|mode|math|V<rprime|'>> s¡
  niewykorzystanymi zmiennymi typu z <with|mode|math|V>,
  <with|mode|math|<wide|w|\<vect\>><rprime|'>> s¡ niewykorzystanymi wyborami:
  <with|mode|math|w<rprime|'><rsub|i>=w<rsub|i+k>> dla pewnego
  <with|mode|math|k>. Zazwyczaj b¦dziemy pomija¢ ci¡g wyborów i pisa¢
  <with|mode|math|\<cal-C\>(E,\<tau\>,V)=(T,e,V<rprime|'>)>, co oznacza, »e
  równo±¢ zachodzi dla pewnego ustalonego ci¡gu wyborów
  <with|mode|math|<wide|w|\<vect\>>> i zakªadaj¡c odpowiedni
  <with|mode|math|<wide|w|\<vect\>><rprime|'>>. Mo»na przyj¡¢ dowolny
  niesko«czony zbiór zmiennych <with|mode|math|V> i pisa¢
  <with|mode|math|\<cal-C\>(E,\<tau\>)=(T,e)> zakªadaj¡c odpowiedni
  <with|mode|math|V<rprime|'>>.

  <\definition>
    <label|algC><with|mode|math|\<cal-C\>(E,\<tau\>,V,<wide|w|\<vect\>>)=(T,e,V<rprime|'>,<wide|w|\<vect\>><rprime|'>)>,
    gdzie dla <with|mode|math|(w<rsub|1 >mod 4)> równego

    <\enumerate>
      <item>VAR: Variables. Dla <with|mode|math|E(w<rsub|2> mod
      <wide|E|\<bar\>>)=x:\<forall\>\<alpha\><rsub|1>\<ldots\>\<alpha\><rsub|n>.\<sigma\>>
      niech

      <\eqnarray*>
        <tformat|<table|<row|<cell|U>|<cell|=>|<cell|\<b-U\>(\<tau\>,[\<beta\><rsub|1>/\<alpha\><rsub|1>]\<ldots\>[\<beta\><rsub|n>/\<alpha\><rsub|n>]\<sigma\>)>>|<row|<cell|V>|<cell|=>|<cell|{\<beta\><rsub|i>\|1\<leqslant\>i\<leqslant\>n}<wide|\<cup\>|\<dot\>>V<rprime|'>>>|<row|<cell|e>|<cell|=>|<cell|x>>|<row|<cell|T>|<cell|=>|<cell|U>>|<row|<cell|w<rprime|'><rsub|i>>|<cell|=>|<cell|w<rsub|i+2>>>>>
      </eqnarray*>

      Je±li unifikator nie istnieje, <with|mode|math|\<cal-C\>> jest
      nieokre±lone.

      <item>FIX: Functions. Je±li <with|mode|math|\<tau\>=\<sigma\>\<rightarrow\>\<rho\>>,
      niech

      <\eqnarray*>
        <tformat|<table|<row|<cell|(R,e<rsub|1>,V<rprime|'>,<wide|w|\<vect\>><rsub|1>)>|<cell|=>|<cell|\<cal-C\>(E.f:\<tau\>.x:\<sigma\>,\<rho\>,V,(w<rsub|i+1>))>>|<row|<cell|T>|<cell|=>|<cell|R>>|<row|<cell|e>|<cell|=>|<cell|fix
        f x.e<rsub|1>>>|<row|<cell|<wide|w|\<vect\>><rprime|'>>|<cell|=>|<cell|<wide|w|\<vect\>><rsub|1>>>>>
      </eqnarray*>

      gdzie <with|mode|math|f,x> s¡ nowymi zmiennymi. Je±li
      <with|mode|math|\<tau\>=\<alpha\>>, gdzie <with|mode|math|\<alpha\>>
      jest zmienn¡ typu, dla <with|mode|math|\<beta\><rsub|1>,\<beta\>\<in\>V>
      niech

      <\eqnarray*>
        <tformat|<table|<row|<cell|R>|<cell|=>|<cell|[\<beta\><rsub|1>\<rightarrow\>\<beta\>/\<alpha\>]>>|<row|<cell|(S,e<rsub|1>,V<rprime|'>,<wide|w|\<vect\>><rsub|1>)>|<cell|=>|<cell|\<cal-C\>(R*E.f:\<beta\><rsub|1>\<rightarrow\>\<beta\>.x:\<beta\><rsub|1>,\<beta\>,V\<setminus\>{\<beta\><rsub|1>,\<beta\>},(w<rsub|i+1>))>>|<row|<cell|T>|<cell|=>|<cell|S*R>>|<row|<cell|e>|<cell|=>|<cell|fix
        f x.e<rsub|1>>>>>
      </eqnarray*>

      gdzie <with|mode|math|f,x> s¡ nowymi zmiennymi. Je±li
      <with|mode|math|\<tau\>> ma inn¡ posta¢, <with|mode|math|\<cal-C\>>
      jest nieokre±lone.

      <item>APP: Applications. Niech dla <with|mode|math|\<beta\>\<in\>V>

      <\eqnarray*>
        <tformat|<table|<row|<cell|(R,f,V<rsub|1>,<wide|w|\<vect\>><rsub|1>)>|<cell|=>|<cell|\<cal-C\>(E,\<beta\>\<rightarrow\>\<tau\>,V\<setminus\>{\<beta\>},(w<rsub|i+1>))>>|<row|<cell|(S,g,V<rprime|'>,<wide|w|\<vect\>><rsub|2>)>|<cell|=>|<cell|\<cal-C\>(R*E,R\<beta\>,V<rsub|1>,<wide|w|\<vect\>><rsub|1>)>>|<row|<cell|T>|<cell|=>|<cell|S*R>>|<row|<cell|e>|<cell|=>|<cell|f
        g>>|<row|<cell|<wide|w|\<vect\>><rprime|'>>|<cell|=>|<cell|<wide|w|\<vect\>><rsub|2>>>>>
      </eqnarray*>

      <item>LET: Local bindings. Niech dla <with|mode|math|\<beta\>\<in\>V>

      <\eqnarray*>
        <tformat|<table|<row|<cell|(R,f,V<rsub|1>,<wide|w|\<vect\>><rsub|1>)>|<cell|=>|<cell|\<cal-C\>(E,\<beta\>,V\<setminus\>{\<beta\>},(w<rsub|i+1>))>>|<row|<cell|(S,g,V<rprime|'>,<wide|w|\<vect\>><rsub|2>)>|<cell|=>|<cell|\<cal-C\>(R*E.x:\<b-G\>(R\<beta\>,R*E),R\<tau\>,V<rsub|1>,<wide|w|\<vect\>><rsub|1>)>>|<row|<cell|T>|<cell|=>|<cell|S*R>>|<row|<cell|e>|<cell|=>|<cell|let
        x=f in g>>|<row|<cell|<wide|w|\<vect\>><rprime|'>>|<cell|=>|<cell|<wide|w|\<vect\>><rsub|2>>>>>
      </eqnarray*>
    </enumerate>
  </definition>

  Algorytmy dokonuj¡ podstawie« w ±rodowisku dla komunikowania informacji o
  konstruowanym typie: wynikowym typie wyra»enia dla algorytmu inferencji
  oraz konkretyzacji zadanego typu dla algorytmu <with|mode|math|\<cal-C\>>.

  <subsubsection|Poprawno±¢.>

  Dla algorytmów generuj¡cych zadany j¦zyk, wªasno±¢
  <with|font-shape|italic|algorytm><with|mode|math|\<subseteq\>><with|font-shape|italic|j¦zyk>
  nazywamy poprawno±ci¡, a wªasno±¢ <with|font-shape|italic|j¦zyk><with|mode|math|\<subseteq\>><with|font-shape|italic|algorytm>
  peªno±ci¡. Dowody dla <with|mode|math|\<cal-W\>> pochodz¡ z
  <cite|leroy92polymorphic>. Poka»emy najpierw poprawno±¢:

  <\theorem>
    Niech <with|mode|math|e> b¦dzie wyra»eniem, <with|mode|math|E>
    ±rodowiskiem, <with|mode|math|V> zbiorem zmiennych typu. Je±li
    <with|mode|math|(T, \<tau\>, V<rprime|'>)=\<cal-W\>(E,e,V)> jest
    okre±lone, to mo»emy wywnioskowa¢ <with|mode|math|T*E\<vdash\>e:\<tau\>>.
  </theorem>

  <\proof>
    Przez indukcj¦ wzgl¦dem budowy termu:

    <\enumerate>
      <item><with|mode|math|e=x> (VAR: Variables). Mamy <with|mode|math|T=
      \<varnothing\>> i <with|mode|math|\<tau\>=[\<beta\><rsub|1>/\<alpha\><rsub|1>;\<ldots\>;\<beta\><rsub|n>/\<alpha\><rsub|n>]\<sigma\>>,
      gdzie <with|mode|math|E(x)=\<forall\>\<alpha\><rsub|1>\<ldots\>\<alpha\><rsub|n>.\<sigma\>>,
      czyli <with|mode|math|\<tau\>\<leqslant\>E(x)>, sk¡d
      <with|mode|math|E\<vdash\>x:\<tau\>>.

      <item><with|mode|math|e=fix f x.e<rsub|1>> (FIX: Functions). Z zaª.
      ind. mamy:

      <\eqnarray*>
        <tformat|<table|<row|<cell|(R,\<rho\>,V<rsub|1>)>|<cell|=>|<cell|\<cal-W\>(E,e<rsub|1>,V\<setminus\>{\<beta\><rsub|1>,\<beta\>})>>|<row|<cell|R(E.f:\<beta\><rsub|1>\<rightarrow\>\<beta\>.x:\<beta\><rsub|1>)>|<cell|\<vdash\>>|<cell|e<rsub|1>:\<rho\>>>>>
      </eqnarray*>

      Z lematu o podstawianiu, podstawiamy <with|mode|math|U> po obu
      stronach, korzystamy z <with|mode|math|T=U*R>:

      <\equation*>
        T(E.f:\<beta\><rsub|1>\<rightarrow\>\<beta\>.x:\<beta\><rsub|1>)\<vdash\>e<rsub|1>:U\<rho\>
      </equation*>

      gdzie <with|mode|math|U> jest unifikatorem <with|mode|math|R\<beta\>> i
      <with|mode|math|\<rho\>>, mamy wi¦c
      <with|mode|math|T\<beta\>=U\<rho\>>. Pokazali±my w ten sposób, »e:

      <\equation*>
        T*E.f:(T\<beta\><rsub|1>\<rightarrow\>T\<beta\>).x:T\<beta\><rsub|1>\<vdash\>e<rsub|1>:T\<beta\>
      </equation*>

      Stosuj¡c reguª¦ typizowania funkcji (FIX), mamy:

      <\equation*>
        T*E\<vdash\>(fix f x in e<rsub|1>):T\<beta\><rsub|1>\<rightarrow\>T\<beta\>
      </equation*>

      To oczekiwany rezultat, poniewa» <with|mode|math|\<tau\>=T(\<beta\><rsub|1>\<rightarrow\>\<beta\>)=T\<beta\><rsub|1>\<rightarrow\>T\<beta\>>.

      <item><with|mode|math|e=f*g> (APP: Applications). Z zaª. ind. mamy:

      <\eqnarray*>
        <tformat|<table|<row|<cell|R*E>|<cell|\<vdash\>>|<cell|f:\<rho\>>>|<row|<cell|S*R*E>|<cell|\<vdash\>>|<cell|g:\<sigma\>>>>>
      </eqnarray*>

      Stosuj¡c lemat o podstawianiu:

      <\equation*>
        S*R*E\<vdash\>f:S\<rho\>
      </equation*>

      Poniewa» <with|mode|math|U> unifikuje <with|mode|math|S\<rho\>> i
      <with|mode|math|\<sigma\>\<rightarrow\>\<beta\>>, mamy

      <\equation*>
        U*S*R*E\<vdash\>f:U(\<sigma\>\<rightarrow\>\<beta\>)
      </equation*>

      Bior¡c <with|mode|math|T=U*S*R>, z lematu o podstawianiu (drugie
      równanie) mamy:

      <\eqnarray*>
        <tformat|<table|<row|<cell|T*E>|<cell|\<vdash\>>|<cell|f:U\<sigma\>\<rightarrow\>U\<beta\>>>|<row|<cell|T*E>|<cell|\<vdash\>>|<cell|g:U\<sigma\>>>>>
      </eqnarray*>

      Teraz z reguªy typowania APP mamy

      <\equation*>
        T*E\<vdash\>f*g:U\<beta\>
      </equation*>

      co jest oczekiwanym wynikiem <with|mode|math|\<tau\>=U\<beta\>>.

      <item><with|mode|math|e=let x=f in g> (LET: Local bindings). Z zaª.
      ind. mamy:

      <\eqnarray*>
        <tformat|<table|<row|<cell|R*E>|<cell|\<vdash\>>|<cell|f:\<rho\>>>|<row|<cell|S(R*E.x:\<b-G\>(\<rho\>,R*E))>|<cell|\<vdash\>>|<cell|g:\<sigma\>>>>>
      </eqnarray*>

      Przemianowuj¡c zmienne zwi¡zane w <with|mode|math|\<b-G\>(\<rho\>,R*E)>
      mo»na pokaza¢

      <\equation*>
        \<b-G\>(S\<rho\>,S*R*E)=S(\<b-G\>(\<rho\>,R*E))
      </equation*>

      Bior¡c <with|mode|math|T=S*R> mamy:

      <\eqnarray*>
        <tformat|<table|<row|<cell|T*E>|<cell|\<vdash\>>|<cell|f:S\<rho\>>>|<row|<cell|T*E.x:\<b-G\>(S\<rho\>,T*E)>|<cell|\<vdash\>>|<cell|g:\<sigma\>>>>>
      </eqnarray*>

      Stosuj¡c reguª¦ typowania LET:

      <\equation*>
        T*E\<vdash\>let x=f in g:\<sigma\>
      </equation*>

      i <with|mode|math|\<tau\>=\<sigma\>> jak oczekiwali±my.
    </enumerate>

    \;
  </proof>

  <\theorem>
    Niech <with|mode|math|\<tau\>> b¦dzie typem, <with|mode|math|E>
    ±rodowiskiem, <with|mode|math|V> zbiorem zmiennych typu. Je±li
    <with|mode|math|(T,e,V<rprime|'>)=\<cal-C\>(E,\<tau\>,V)> jest okre±lone,
    to mo»emy wywnioskowa¢ <with|mode|math|T*E\<vdash\>e:T\<tau\>>.
  </theorem>

  <\proof>
    Przez indukcj¦ na zªo»ono±¢ generowanego termu:

    <\enumerate>
      <item><with|mode|math|e=x> (VAR: Variables). Gdy
      <with|mode|math|\<sigma\>\<leqslant\>E(x)>, to
      <with|mode|math|T\<sigma\>\<leqslant\>T*E(x)>. Poniewa»
      <with|mode|math|T> jest unifikatorem <with|mode|math|\<sigma\>> oraz
      <with|mode|math|\<tau\>>, a wi¦c <with|mode|math|T\<tau\>\<leqslant\>T*E(x)>,
      st¡d z reguªy typowania VAR mamy <with|mode|math|T*E\<vdash\>x:T\<tau\>>.

      <item><with|mode|math|e=fix f x.e<rsub|1>> (FIX: Functions).
      <with|mode|math|\<tau\>=\<sigma\>\<rightarrow\>\<rho\>> albo
      <with|mode|math|\<tau\>=\<alpha\>>. W pierwszym przypadku, korzystaj¡c
      z zaª. ind. mamy

      <\eqnarray*>
        <tformat|<table|<row|<cell|R(E.f:\<tau\>.x:\<sigma\>)>|<cell|\<vdash\>>|<cell|e<rsub|1>:R\<rho\>>>|<row|<cell|R*E.f:R\<sigma\>\<rightarrow\>R\<rho\>.x:R\<sigma\>>|<cell|\<vdash\>>|<cell|e<rsub|1>:R\<rho\>>>>>
      </eqnarray*>

      Stosuj¡c reguª¦ typizowania funkcji (FIX), mamy:

      <\equation*>
        R*E\<vdash\>(fix f x in e<rsub|1>):R\<sigma\>\<rightarrow\>R\<rho\>
      </equation*>

      To oczekiwany rezultat, poniewa» <with|mode|math|T\<tau\>=R\<tau\>=R\<sigma\>\<rightarrow\>R\<rho\>>
      dla <with|mode|math|T=R>. W drugim przypadku analogicznie: korzystaj¡c
      z zaª. ind. mamy

      <\eqnarray*>
        <tformat|<table|<row|<cell|S(R*E.f:\<beta\><rsub|1>\<rightarrow\>\<beta\>.x:\<beta\><rsub|1>)>|<cell|\<vdash\>>|<cell|e<rsub|1>:S\<beta\>>>|<row|<cell|S*R*E.f:S\<beta\><rsub|1>\<rightarrow\>S\<beta\>.x:S\<beta\><rsub|1>>|<cell|\<vdash\>>|<cell|e<rsub|1>:S\<beta\>>>>>
      </eqnarray*>

      Stosuj¡c reguª¦ typizowania funkcji (FIX), mamy:

      <\equation*>
        S*E\<vdash\>(fix f x in e<rsub|1>):S\<beta\><rsub|1>\<rightarrow\>S\<beta\>
      </equation*>

      To oczekiwany rezultat, poniewa» <with|mode|math|T\<tau\>=S*R\<tau\>=S\<beta\><rsub|1>\<rightarrow\>S\<beta\>>
      dla <with|mode|math|T=S*R>.

      <item><with|mode|math|e=f*g> (APP: Applications). Z zaª. ind. mamy:

      <\eqnarray*>
        <tformat|<table|<row|<cell|R*E>|<cell|\<vdash\>>|<cell|f:R(\<beta\>\<rightarrow\>\<tau\>)>>|<row|<cell|S*R*E>|<cell|\<vdash\>>|<cell|g:S*R\<beta\>>>>>
      </eqnarray*>

      Stosuj¡c lemat o podstawianiu, bior¡c <with|mode|math|T=S*R>:

      <\equation*>
        T*E\<vdash\>f:T\<beta\>\<rightarrow\>T\<tau\>
      </equation*>

      Teraz z reguªy typowania APP mamy

      <\equation*>
        T*E\<vdash\>f g:T\<tau\>
      </equation*>

      co jest oczekiwanym wynikiem.

      <item><with|mode|math|e=let x=f in g> (LET: Local bindings). Z zaª.
      ind. mamy:

      <\eqnarray*>
        <tformat|<table|<row|<cell|R*E>|<cell|\<vdash\>>|<cell|f:R\<beta\>>>|<row|<cell|S(R*E.x:\<b-G\>(R\<beta\>,R*E))>|<cell|\<vdash\>>|<cell|g:S*R\<tau\>>>>>
      </eqnarray*>

      Przemianowuj¡c zmienne zwi¡zane w <with|mode|math|\<b-G\>(R\<beta\>,R*E)>
      mo»na pokaza¢:

      <\equation*>
        \<b-G\>(S*R\<beta\>,S*R*E)=S(\<b-G\>(R\<beta\>,R*E))
      </equation*>

      Bior¡c <with|mode|math|T=S*R> mamy:

      <\eqnarray*>
        <tformat|<table|<row|<cell|T*E>|<cell|\<vdash\>>|<cell|f:S\<rho\>>>|<row|<cell|T*E.x:\<b-G\>(S*R\<beta\>,T*E)>|<cell|\<vdash\>>|<cell|g:T\<tau\>>>>>
      </eqnarray*>

      Stosuj¡c reguª¦ typowania LET:

      <\equation*>
        T*E\<vdash\>(let x=f in g):T\<tau\>
      </equation*>
    </enumerate>

    \;
  </proof>

  <subsubsection|Peªno±¢.>

  Teraz poka»emy peªno±¢, najpierw algorytmu <with|mode|math|\<cal-W\>>, za
  <cite|leroy92polymorphic>.

  <\theorem>
    Niech <with|mode|math|e> b¦dzie wyra»eniem, <with|mode|math|E>
    ±rodowiskiem, <with|mode|math|V> niesko«czonym zbiorem zmiennych typu
    takim, »e <with|mode|math|V\<cap\>\<b-F\>(E)= \<varnothing\>>. Je±li
    istnieje typ <with|mode|math|\<tau\><rprime|'>> i podstawienie
    <with|mode|math|T<rprime|'>> t. »e <with|mode|math|T<rprime|'>E\<vdash\>e:\<tau\><rprime|'>>,
    to <with|mode|math|(T,\<tau\>,V<rprime|'>)=\<cal-W\>(E,e,V)> jest
    okre±lona, i istnieje podstawienie <with|mode|math|P> t. »e

    <\equation*>
      \<tau\><rprime|'>=P\<tau\><space|2fn><with|mode|text|i><space|2fn>T<rprime|'>=P*T<with|mode|text|
      poza >V
    </equation*>
  </theorem>

  <\proof>
    Przez indukcj¦ wzgl¦dem zªo»ono±ci <with|mode|math|e>:

    <\enumerate>
      <item><with|mode|math|e=x> (VAR: Variables). Poniewa»
      <with|mode|math|T<rprime|'>E\<vdash\>x:\<tau\><rprime|'>>, mamy
      <with|mode|math|x\<in\>Dom(T<rprime|'>E)> i
      <with|mode|math|\<tau\><rprime|'>\<leqslant\>T<rprime|'>E(x)>.
      <with|mode|math|x\<in\>Dom(E)>, wi¦c <with|mode|math|\<cal-W\>(E,x,V)>
      jest okre±lony i zwraca

      <\eqnarray*>
        <tformat|<table|<row|<cell|\<tau\>>|<cell|=>|<cell|[\<beta\><rsub|1>/\<alpha\><rsub|1>;\<ldots\>;\<beta\><rsub|n>/\<alpha\><rsub|n>]\<tau\><rsub|x>>>|<row|<cell|T>|<cell|=>|<cell|\<varnothing\>>>|<row|<cell|V<rprime|'>>|<cell|=>|<cell|V\<setminus\>{\<beta\><rsub|1>,\<ldots\>,\<beta\><rsub|n>}>>>>
      </eqnarray*>

      Niech <with|mode|math|E(x)=\<forall\>\<alpha\><rsub|1>\<ldots\>\<alpha\><rsub|n>.\<tau\><rsub|x>>,
      gdzie <with|mode|math|\<alpha\><rsub|i>\<in\>V<rprime|'>> nie wyst¦puj¡
      w <with|mode|math|T<rprime|'>>. Mamy
      <with|mode|math|T<rprime|'>E(x)=\<forall\>\<alpha\><rsub|1>\<ldots\>\<alpha\><rsub|n>.T<rprime|'>\<tau\><rsub|x>>.
      Niech <with|mode|math|R> b¦dzie podstawieniem pod
      <with|mode|math|\<alpha\><rsub|i>> t. »e
      <with|mode|math|\<tau\><rprime|'>=R*T<rprime|'>\<tau\><rsub|x>>. We¹my

      <\equation*>
        P=R*T<rprime|'>[\<alpha\><rsub|1>/\<beta\><rsub|1>;\<ldots\>;\<alpha\><rsub|n>/\<beta\><rsub|n>]
      </equation*>

      Mamy <with|mode|math|P\<tau\>=R*T<rprime|'>\<tau\><rsub|x>=\<tau\><rprime|'>>.
      Co wi¦cej, <with|mode|math|\<alpha\>\<nin\>V> nie s¡ ani
      <with|mode|math|\<alpha\><rsub|i>>, ani
      <with|mode|math|\<beta\><rsub|i>>, wi¦c
      <with|mode|math|P\<alpha\>=R*T<rprime|'>\<alpha\>=T<rprime|'>\<alpha\>>.
      To daje oczekiwany rezultat, bo <with|mode|math|P*T=P> dla
      <with|mode|math|T= \<varnothing\>>.

      <item><with|mode|math|e=fix f x.e<rsub|1>> (FIX: Functions).
      Wyprowadzenie typu <with|mode|math|\<tau\><rprime|'>> ko«czy si¦
      zastosowaniem reguªy FIX:

      <\equation*>
        <frac|T<rprime|'>E.f:(\<rho\><rsub|1><rprime|'>\<rightarrow\>\<rho\><rprime|'>).x:\<rho\><rsub|1><rprime|'>\<vdash\>e<rsub|1>:\<rho\><rprime|'>|T<rprime|'>E\<vdash\>(fix
        f x in e<rsub|1>):\<rho\><rsub|1><rprime|'>\<rightarrow\>\<rho\><rprime|'>>
      </equation*>

      Wybierzmy <with|mode|math|\<beta\><rsub|1>,\<beta\>\<in\>V> jak w
      algorytmie. Okre±lmy ±rodowisko <with|mode|math|E<rsub|1> i
      podstawienie ><with|mode|math|R<rprime|'>> przez

      <\eqnarray*>
        <tformat|<table|<row|<cell|E<rsub|1>>|<cell|=>|<cell|E.f:\<beta\><rsub|1>\<rightarrow\>\<beta\>.x:\<beta\><rsub|1>>>|<row|<cell|R<rprime|'>>|<cell|=>|<cell|T<rprime|'>[\<rho\><rsub|1><rprime|'>/\<beta\><rsub|1>;\<rho\><rprime|'>/\<beta\>]>>>>
      </eqnarray*>

      Mamy <with|mode|math|R<rprime|'>E<rsub|1>=T<rprime|'>E.f:\<rho\><rsub|1><rprime|'>\<rightarrow\>\<rho\><rprime|'>.x:\<rho\><rsub|1><rprime|'>>.
      Stosuj¡c zaª. ind. do <with|mode|math|e<rsub|1>, E<rsub|1>,
      R<rprime|'>, \<rho\><rprime|'>> mamy:

      <\eqnarray*>
        <tformat|<table|<row|<cell|(R,\<rho\>,V<rsub|1>)>|<cell|=>|<cell|\<cal-W\>(E<rsub|1>,e<rsub|1>,V\<setminus\>{\<beta\><rsub|1>,\<beta\>})>>|<row|<cell|\<rho\><rprime|'>>|<cell|=>|<cell|P<rsub|1>\<rho\>>>|<row|<cell|R<rprime|'>>|<cell|=>|<cell|P<rsub|1>R<with|mode|text|
        poza >V\<setminus\>{\<beta\><rsub|1>,\<beta\>}>>>>
      </eqnarray*>

      W szczególno±ci, <with|mode|math|P<rsub|1>R\<beta\>=R<rprime|'>\<beta\>=\<rho\><rprime|'>>,
      st¡d <with|mode|math|P<rsub|1>> jest unifikatorem
      <with|mode|math|R\<beta\>> i <with|mode|math|\<rho\>>. St¡d istnieje
      najbardziej ogólny unifikator tych typów: nazwijmy go
      <with|mode|math|U> -- i <with|mode|math|\<cal-W\>(E,e,V)> (tzn.
      wywoªanie <with|mode|math|\<b-U\>(R\<beta\>,\<rho\>)>) jest dobrze
      okre±lony. Niech <with|mode|math|P> b¦dzie podstawieniem t. »e
      <with|mode|math|P<rsub|1>=P*U>. Poka»emy teraz, »e <with|mode|math|P>
      speªnia »¡danie twierdzenia. Mamy:

      <\eqnarray*>
        <tformat|<table|<row|<cell|P\<tau\>=>|<cell|P*U*R(\<beta\><rsub|1>\<rightarrow\>\<beta\>)>|<cell|<with|mode|text|z
        definicji >\<tau\><with|mode|text| w
        algorytmie>>>|<row|<cell|=>|<cell|P<rsub|1>R(\<beta\><rsub|1>\<rightarrow\>\<beta\>)>|<cell|<with|mode|text|z
        definicji >P>>|<row|<cell|=>|<cell|R<rprime|'>(\<beta\><rsub|1>\<rightarrow\>\<beta\>)>|<cell|<with|mode|text|bo
        >\<beta\><rsub|1>,\<beta\>\<nin\>V\<setminus\>{\<beta\><rsub|1>,\<beta\>}>>|<row|<cell|=>|<cell|\<rho\><rsub|1><rprime|'>\<rightarrow\>\<rho\><rprime|'>>|<cell|<with|mode|text|przez
        konstrukcj¦ >R<rprime|'>>>>>
      </eqnarray*>

      (<with|mode|math|T<rprime|'>> nie dziaªa na
      <with|mode|math|\<rho\><rsub|1><rprime|'>> i
      <with|mode|math|\<rho\><rprime|'>>). Co wi¦cej, dla ka»dej zmiennej
      <with|mode|math|\<gamma\>\<nin\>V>:

      <\eqnarray*>
        <tformat|<table|<row|<cell|P*T\<gamma\>=>|<cell|P*U*R\<gamma\>>|<cell|<with|mode|text|z
        definicji >T<with|mode|text| w algorytmie>>>|<row|<cell|=>|<cell|P<rsub|1>R\<gamma\>>|<cell|<with|mode|text|z
        definicji >P>>|<row|<cell|=>|<cell|R<rprime|'>\<gamma\>>|<cell|<with|mode|text|bo
        >\<gamma\>\<nin\>V>>|<row|<cell|=>|<cell|T<rprime|'>\<gamma\>>|<cell|<with|mode|text|bo
        >\<gamma\>\<nin\>V<with|mode|text| poci¡ga
        >\<gamma\>\<neq\>\<beta\><rsub|1>\<wedge\>\<gamma\>\<neq\>\<beta\>>>>>
      </eqnarray*>

      c.b.d.o.

      <item><with|mode|math|e=f*g> (APP: Applications). Wyprowadzenie
      <with|mode|math|\<tau\><rprime|'>> ko«czy si¦ z

      <\equation*>
        <frac|T<rprime|'>E\<vdash\>f:\<sigma\><rprime|'>\<rightarrow\>\<nu\><rprime|'><space|2fn>T<rprime|'>E\<vdash\>g:\<sigma\><rprime|'>|T<rprime|'>E\<vdash\>f*g:\<nu\><rprime|'>>
      </equation*>

      Stosuj¡c zaª. ind. do <with|mode|math|f,E,\<sigma\><rprime|'>\<rightarrow\>\<nu\><rprime|'>,T<rprime|'>>
      otrzymujemy

      <\eqnarray*>
        <tformat|<table|<row|<cell|(R,\<rho\>,V<rsub|1>)>|<cell|=>|<cell|\<cal-W\>(E,f,V)>>|<row|<cell|\<sigma\><rprime|'>\<rightarrow\>\<nu\><rprime|'>>|<cell|=>|<cell|P<rsub|1>\<rho\>>>|<row|<cell|T<rprime|'>>|<cell|=>|<cell|P<rsub|1>R<with|mode|text|
        poza >V>>>>
      </eqnarray*>

      W szczególno±ci, <with|mode|math|T<rprime|'>E=P<rsub|1>R*E>. Stosujemy
      zaª. ind. do <with|mode|math|g,R*E,\<sigma\><rprime|'>,P<rsub|1>,V<rsub|1>>.
      <with|mode|math|P<rsub|1>> jest dobre, bo
      <with|mode|math|T<rprime|'>E=P<rsub|1>R*E>.

      <\eqnarray*>
        <tformat|<table|<row|<cell|(S,\<sigma\>,V<rsub|2>)>|<cell|=>|<cell|\<cal-W\>(R*E,g,V<rsub|1>)>>|<row|<cell|\<sigma\><rprime|'>>|<cell|=>|<cell|P<rsub|2>\<sigma\>>>|<row|<cell|P<rsub|1>>|<cell|=>|<cell|P<rsub|2>S<with|mode|text|
        poza >V<rsub|1>>>>>
      </eqnarray*>

      Mamy <with|mode|math|P<rsub|1>\<rho\>=P<rsub|2>S\<rho\>>. Niech
      <with|mode|math|P<rsub|3>=P<rsub|2>[\<nu\><rprime|'>/\<beta\>]>. Mamy:

      <\eqnarray*>
        <tformat|<table|<row|<cell|P<rsub|3>S\<rho\>>|<cell|=>|<cell|P<rsub|2>S\<rho\>=P<rsub|1>\<rho\>=\<sigma\><rprime|'>\<rightarrow\>\<nu\><rprime|'>>>|<row|<cell|P<rsub|3>(\<sigma\>\<rightarrow\>\<beta\>)>|<cell|=>|<cell|P<rsub|2>\<sigma\>\<rightarrow\>\<nu\><rprime|'>=\<sigma\><rprime|'>\<rightarrow\>\<nu\><rprime|'>>>>>
      </eqnarray*>

      <with|mode|math|P<rsub|3>> jest wi¦c unifikatorem
      <with|mode|math|S\<rho\>> i <with|mode|math|\<sigma\>\<rightarrow\>\<beta\>>.
      Te typy maj¡ wi¦c najogólniejszy unifikator,
      <with|mode|math|\<cal-W\>(E,f*g,V)> jest dobrze okre±lone. W dodatku,
      mamy <with|mode|math|P<rsub|3>=P<rsub|4>U> dla pewnego
      <with|mode|math|P<rsub|4>>. Teraz poka»emy, »e
      <with|mode|math|P=P<rsub|4>> speªnia wymagania stwierdzenia. Mamy:

      <\equation*>
        P\<tau\>=P<rsub|4>U\<beta\>=P<rsub|3>\<beta\>=\<nu\><rprime|'>
      </equation*>

      a dla wszystkich <with|mode|math|\<gamma\>\<nin\>V>

      <\eqnarray*>
        <tformat|<table|<row|<cell|P*T\<gamma\>=>|<cell|P<rsub|4>U*S*R\<gamma\>>|<cell|<with|mode|text|z
        definicji >T>>|<row|<cell|=>|<cell|P<rsub|3>S*R\<gamma\>>|<cell|<with|mode|text|z
        definicji >P<rsub|4>>>|<row|<cell|=>|<cell|P<rsub|2>S*R\<gamma\>>|<cell|<with|mode|text|bo
        >\<gamma\>\<neq\>\<beta\>, \<beta\> <with|mode|text| nie wyst. w
        >R,S>>|<row|<cell|=>|<cell|P<rsub|1>R\<gamma\>>|<cell|<with|mode|text|bo
        >R\<gamma\>\<nin\>V<rsub|1>>>|<row|<cell|=>|<cell|T<rprime|'>\<gamma\>>|<cell|<with|mode|text|bo
        >\<gamma\>\<nin\>V>>>>
      </eqnarray*>

      <item><with|mode|math|e=let x=f in g> (LET: Local bindings).
      Wyprowadzenie <with|mode|math|\<tau\><rprime|'>> ko«czy si¦ z:

      <\equation*>
        <frac|T<rprime|'>E\<vdash\>f:\<rho\><rprime|'><space|2fn>T<rprime|'>E.x:\<b-G\>(\<rho\><rprime|'>,T<rprime|'>E)\<vdash\>g:\<sigma\><rprime|'>|T<rprime|'>E\<vdash\>(let
        x=f in g):\<sigma\><rprime|'>>
      </equation*>

      Stosujemy zaª. ind. do <with|mode|math|f,E,V,\<rho\><rprime|'>,T<rprime|'>>.
      Otrzymujemy

      <\eqnarray*>
        <tformat|<table|<row|<cell|(R,\<rho\>,V<rsub|1>)>|<cell|=>|<cell|\<cal-W\>(E,f,V)>>|<row|<cell|\<rho\><rprime|'>>|<cell|=>|<cell|P<rsub|1>\<rho\>>>|<row|<cell|T<rprime|'>>|<cell|=>|<cell|P<rsub|1>R<with|mode|text|
        poza >V>>>>
      </eqnarray*>

      W szczególno±ci, <with|mode|math|T<rprime|'>E=P<rsub|1>R*E>. (Teraz
      sfaktoryzujemy ±rodowisko wyprowadzenia
      <with|mode|math|\<sigma\><rprime|'>>.) Šatwo sprawdzi¢, »e
      <with|mode|math|P<rsub|1>\<b-G\>(\<rho\>,R*E)> jest bardziej (nie
      mniej) ogólne ni» <with|mode|math|\<b-G\>(P<rsub|1>\<rho\>,P<rsub|1>R*E)>.<\footnote>
        Niech <with|mode|math|P<rsub|1>\<b-G\>(\<rho\>,R*E)=P<rsub|1>\<forall\>\<alpha\><rsub|1>\<ldots\>\<alpha\><rsub|n>.\<rho\><rsub|1>=\<forall\>\<alpha\><rsub|1>\<ldots\>\<alpha\><rsub|n>.P<rsub|1>\<rho\><rsub|1>>;
        natomiast <with|mode|math|\<b-G\>(P<rsub|1>\<rho\>,P<rsub|1>R*E)=\<b-G\>(\<forall\>\<alpha\><rsub|i>\<ldots\>\<alpha\><rsub|n>.P<rsub|1>\<rho\><rsub|1>,P<rsub|1>R*E)>
        oraz <with|mode|math|\<alpha\><rsub|1>\<ldots\>\<alpha\><rsub|i-1>>
        nie wyst¦puj¡ w <with|mode|math|R*E>; zmienne nie wyst¦puj¡ce w
        <with|mode|math|P<rsub|1>R*E>\0 które wyst¦puj¡ w
        <with|mode|math|R*E>, to te, pod które podstawia
        <with|mode|math|P<rsub|1>>; ale one nie wyst¦puj¡ w
        <with|mode|math|P<rsub|1>\<rho\><rsub|1>>.
      </footnote> \ Poniewa» mo»emy wyprowadzi¢

      <\equation*>
        T<rprime|'>E.x:\<b-G\>(\<rho\><rprime|'>,P<rsub|1>R*E)\<vdash\>g:\<sigma\><rprime|'>
      </equation*>

      z nast¦puj¡cego lematu:

      <\lemma>
        <label|ogolneMocniejsze>Niech <with|mode|math|E,E<rprime|'>> b¦d¡
        ±rodowiskami t. »e <with|mode|math|Dom(E)=Dom(E<rprime|'>)> i
        <with|mode|math|E<rprime|'>(x)\<geqslant\>E(x)> dla wszystkich
        <with|mode|math|x\<in\>Dom(E)>. Je±li
        <with|mode|math|E\<vdash\>e:\<tau\>>, to
        <with|mode|math|E<rprime|'>\<vdash\>e:\<tau\>>.
      </lemma>

      wynika, »e mo»emy równie» wyprowadzi¢

      <\equation*>
        T<rprime|'>E.x:P<rsub|1>\<b-G\>(\<rho\>,R*E)\<vdash\>g:\<sigma\><rprime|'>
      </equation*>

      czyli

      <\equation*>
        P<rsub|1>(R*E.x:\<b-G\>(\<rho\>,R*E))\<vdash\>g:\<sigma\><rprime|'>
      </equation*>

      Stosujemy teraz zaª. ind. do <with|mode|math|g,R*E.x:\<b-G\>(\<rho\>,R*E),\<sigma\><rprime|'>,P<rsub|1>>,
      otrzymuj¡c

      <\eqnarray*>
        <tformat|<table|<row|<cell|(S,\<sigma\>,V<rprime|'>)>|<cell|=>|<cell|\<cal-W\>(R*E.x:\<b-G\>(\<rho\>,R*E),g,V<rsub|1>)>>|<row|<cell|\<sigma\><rprime|'>>|<cell|=>|<cell|P<rsub|2>\<sigma\>>>|<row|<cell|P<rsub|1>>|<cell|=>|<cell|P<rsub|2>S<with|mode|text|
        poza >V<rsub|1>>>>>
      </eqnarray*>

      Algorytm bierze <with|mode|math|\<tau\>=\<sigma\>> i
      <with|mode|math|T=S*R>. Poka»emy, »e <with|mode|math|P=P<rsub|2>>
      speªnia wymagania stwierdzenia. Mamy
      <with|mode|math|P\<tau\>=\<sigma\><rprime|'>>. I je±li
      <with|mode|math|\<gamma\>\<nin\>V>, czyli
      <with|mode|math|\<gamma\>\<nin\>V<rsub|1>>:

      <\eqnarray*>
        <tformat|<table|<row|<cell|P*T\<gamma\>=>|<cell|P<rsub|2>S*R\<gamma\>>|<cell|<with|mode|text|z
        definicji >T>>|<row|<cell|=>|<cell|P<rsub|1>R\<gamma\>>|<cell|<with|mode|text|bo
        >R\<gamma\>\<nin\>V<rsub|1>>>|<row|<cell|=>|<cell|T<rprime|'>\<gamma\>>|<cell|<with|mode|text|bo
        >\<gamma\>\<nin\>V>>>>
      </eqnarray*>

      St¡d <with|mode|math|T<rprime|'>=P*T> poza <with|mode|math|V>, jak
      oczekiwano.
    </enumerate>

    \;
  </proof>

  Teraz sprawdzimy peªno±¢ algorytmu <with|mode|math|\<cal-C\>>. Wprowad¹my
  najpierw inne poj¦cie ogólno±ci typu:

  <\definition>
    Typ <with|mode|math|\<sigma\>> jest bardziej ogólny ni»
    <with|mode|math|\<tau\>>

    <\equation*>
      \<tau\>\<preccurlyeq\>\<sigma\>\<equiv\><with|mode|text| istnieje
      podstawienie >P:<space|0.6spc>P\<sigma\>=\<tau\>
    </equation*>

    Podstawienie <with|mode|math|S> jest bardziej ogólne ni»
    <with|mode|math|R>

    <\eqnarray*>
      <tformat|<table|<row|<cell|R\<preccurlyeq\>S>|<cell|\<equiv\>>|<cell|<with|mode|text|istnieje
      podstawienie >P:<space|0.6spc>P*S=R>>|<row|<cell|>|<cell|\<equiv\>>|<cell|Dom(S)\<subseteq\>Dom(R)<with|mode|text|
      i >\<forall\>\<alpha\>\<in\>Dom(S):R\<alpha\>\<preccurlyeq\>S\<alpha\>>>>>
    </eqnarray*>
  </definition>

  <\theorem>
    <label|pelnoscC>Niech <with|mode|math|e> b¦dzie wyra»eniem,
    <with|mode|math|E> ±rodowiskiem. Dla dowolnego typu
    <with|mode|math|\<tau\>> i podstawienia <with|mode|math|T<rprime|'>> t.
    »e <with|mode|math|T<rprime|'>E\<vdash\>e:T<rprime|'>\<tau\>> oraz
    <with|mode|math|\<b-F\>(T<rprime|'>)\<cap\>Dom(T<rprime|'>)=
    \<varnothing\>>, dla niesko«czonego zbioru zmiennych <with|mode|math|V>
    rozª¡cznego z <with|mode|math|\<b-F\>(E)> i
    <with|mode|math|\<b-F\>(T<rprime|'>)>, dla pewnej ±cie»ki wyborów
    zachodzi <with|mode|math|(T,e,V<rprime|'>)=\<cal-C\>(E,\<tau\>,V)> oraz
    <with|mode|math|T<rprime|'>\<preccurlyeq\>T> poza <with|mode|math|V>.
  </theorem>

  <\proof>
    Przez indukcj¦ wzgl¦dem zªo»ono±ci e:

    <\enumerate>
      <item><with|mode|math|e=x> (VAR: Variables). Poniewa»
      <with|mode|math|T<rprime|'>E\<vdash\>x:\<tau\><rprime|'>>, mamy
      <with|mode|math|x\<in\>Dom(E)> i <with|mode|math|T<rprime|'>\<tau\>\<leqslant\>T<rprime|'>E(x)>.
      Wybieramy VAR w <with|mode|math|\<cal-C\>(E,\<tau\>,V)> i zmienn¡
      <with|mode|math|x> z <with|mode|math|E>. Niech
      <with|mode|math|E(x)=\<forall\>\<alpha\><rsub|1>\<ldots\>\<alpha\><rsub|n>.\<sigma\>>.
      Poniewa» <with|mode|math|T<rprime|'>\<tau\>\<leqslant\>T<rprime|'>E(x)>,
      wi¦c istnieje unifikator

      <\equation*>
        U=\<b-U\>(\<tau\>,[\<beta\><rsub|1>/\<alpha\><rsub|1>;\<ldots\>\<beta\><rsub|n>/\<alpha\><rsub|n>]\<sigma\>)
      </equation*>

      gdzie <with|mode|math|\<beta\><rsub|i>\<in\>V,\<beta\><rsub|i>\<nin\>V<rprime|'>>.
      Poniewa» <with|mode|math|U> jest najogólniejszym unifikatorem a
      <with|mode|math|T<rprime|'>> rozszerzony o podstawienia nad
      <with|mode|math|\<beta\><rsub|i>> (oznaczone wcze±niej
      <with|mode|math|[\<tau\><rsub|i>/\<alpha\><rsub|i>]>, ale
      <with|mode|math|\<alpha\><rsub|i>\<leftrightarrow\>\<beta\><rsub|i>>)
      te» jest unifikatorem, wi¦c <with|mode|math|T<rprime|'>=S*U> poza
      <with|mode|math|V>. Tak wi¦c dla <with|mode|math|T=U> mamy
      <with|mode|math|T<rprime|'>\<preccurlyeq\>T> poza <with|mode|math|V>.

      <item><with|mode|math|e=fix f x.e<rsub|1>> (FIX: Functions).
      Wyprowadzenie typu <with|mode|math|T<rprime|'>\<tau\>> ko«czy si¦ z

      <\equation*>
        <frac|T<rprime|'>E.f:(\<sigma\><rprime|'>\<rightarrow\>\<rho\><rprime|'>).x:\<sigma\><rprime|'>\<vdash\>e<rsub|1>:\<rho\><rprime|'>|T<rprime|'>E\<vdash\>(fix
        f x in e<rsub|1>):\<sigma\><rprime|'>\<rightarrow\>\<rho\><rprime|'>>
      </equation*>

      Typ <with|mode|math|\<tau\>> jako ogólniejszy ma posta¢
      <with|mode|math|\<sigma\>\<rightarrow\>\<rho\>> albo
      <with|mode|math|\<alpha\>> (gdzie <with|mode|math|\<alpha\>> jest
      zmienn¡ typu). Rozpatrzmy najpierw przypadek
      <with|mode|math|\<sigma\>\<rightarrow\>\<rho\>>. Z zaª. ind. dla
      <with|mode|math|T<rprime|'>> i <with|mode|math|\<rho\><rprime|'>>
      (<with|mode|math|T<rprime|'>\<rho\>=\<rho\><rprime|'>>) mamy: istnieje
      ci¡g wyborów daj¡cy

      <\equation*>
        (R,e<rsub|1>,V<rsub|1>)=\<cal-C\>(E.f:\<tau\>.x:\<sigma\>,\<rho\>,V)
      </equation*>

      oraz <with|mode|math|T<rprime|'>\<preccurlyeq\>R> poza
      <with|mode|math|V>. Teza wynika z <with|mode|math|T=R>.

      W przypadku <with|mode|math|\<tau\>=\<alpha\>>,
      <with|mode|math|R=[\<beta\><rsub|1>\<rightarrow\>\<beta\>/\<alpha\>]>,
      gdzie <with|mode|math|\<beta\><rsub|1>,\<beta\>\<in\>V> wprowadzone
      przez algorytm. Poniewa» <with|mode|math|T<rprime|'>\<alpha\>=\<sigma\><rprime|'>\<rightarrow\>\<rho\><rprime|'>>,
      <with|mode|math|T<rprime|'>> mo»na zmodyfikowa¢:
      <with|mode|math|U=\<b-U\>(T<rprime|'>\<alpha\>,\<beta\><rsub|1>\<rightarrow\>\<beta\>)>,
      <with|mode|math|T<rprime|''>=(T<rprime|'>\<setminus\>{\<alpha\>\<mapsto\>\<sigma\><rprime|'>\<rightarrow\>\<rho\><rprime|'>})U*>.
      Z zaª. ind. dla <with|mode|math|T<rprime|''>> i
      <with|mode|math|\<beta\><rsub|1>\<rightarrow\>\<beta\>> mamy

      <\equation*>
        (S,e<rsub|1>,V<rsub|1>)=\<cal-C\>(R*E.f:\<beta\><rsub|1>\<rightarrow\>\<beta\>.x:\<beta\><rsub|1>,\<beta\>,V\<setminus\>{\<beta\><rsub|1>,\<beta\>})
      </equation*>

      oraz <with|mode|math|T<rprime|''>\<preccurlyeq\>S> poza
      <with|mode|math|V\<setminus\>{\<beta\><rsub|1>,\<beta\>}>. Ale
      <with|mode|math|T<rprime|''>(\<beta\><rsub|1>\<rightarrow\>\<beta\>)=T<rprime|'>\<alpha\>>,
      wi¦c <with|mode|math|T<rprime|''>R=T<rprime|'>>, st¡d
      <with|mode|math|T<rprime|'>\<preccurlyeq\>S*R=T>.

      <item><with|mode|math|e=f*g> (APP: Applications). Wyprowadzenie
      <with|mode|math|T<rprime|'>\<tau\>> ko«czy si¦ z

      <\equation*>
        <frac|T<rprime|'>E\<vdash\>f:\<sigma\><rprime|'>\<rightarrow\>\<tau\><rprime|'><space|2fn>T<rprime|'>E\<vdash\>g:\<sigma\><rprime|'>|T<rprime|'>E\<vdash\>f*g:\<tau\><rprime|'>>
      </equation*>

      Niech <with|mode|math|T<rsub|1>=[\<sigma\><rprime|'>/\<beta\>]T<rprime|'>>
      (co nie stwarza problemów, bo <with|mode|math|\<beta\>> nie wyst. w
      <with|mode|math|T<rprime|'>>), stosuj¡c zaª. ind. do
      <with|mode|math|T<rsub|1>> i <with|mode|math|\<beta\>\<rightarrow\>\<tau\>>
      (zachodzi <with|mode|math|T<rsub|1>(\<beta\>\<rightarrow\>\<tau\>)=T<rsub|1>\<beta\>\<rightarrow\>T<rsub|1>\<tau\>=\<sigma\><rprime|'>\<rightarrow\>T<rprime|'>\<tau\>=\<sigma\><rprime|'>\<rightarrow\>\<tau\><rprime|'>>)

      <\equation*>
        (R,f,V<rsub|1>)=\<cal-C\>(E,\<beta\>\<rightarrow\>\<tau\>,V\<setminus\>{\<beta\>})
      </equation*>

      oraz <with|mode|math|T<rsub|1>\<preccurlyeq\>R> poza
      <with|mode|math|V\<setminus\>{\<beta\>}>. Niech
      <with|mode|math|T<rsub|2>:<space|0.6spc>T<rsub|1>=T<rsub|2>R> poza
      <with|mode|math|V\<setminus\>{\<beta\>}>, zastosujmy zaª. ind. do
      <with|mode|math|T<rsub|2>,R*E,R*\<beta\>>
      (<with|mode|math|T<rsub|2>R\<beta\>=T<rsub|1>\<beta\>=\<sigma\><rprime|'>)>:

      <\equation*>
        (S,g,V<rsub|2>)=\<cal-C\>(R*E,R\<beta\>,V<rsub|1>)
      </equation*>

      <with|mode|math|T<rsub|2>\<preccurlyeq\>S> poza
      <with|mode|math|V<rsub|1>> (niech <with|mode|math|T<rsub|3>:<space|0.6spc>T<rsub|2>=T<rsub|3>S>
      poza <with|mode|math|V<rsub|1>>), a wi¦c
      <with|mode|math|T<rsub|1>\<preccurlyeq\>S*R> poza
      <with|mode|math|V\<setminus\>{\<beta\>}> (bo
      <with|mode|math|V<rsub|1>\<subseteq\>V\<setminus\>{\<beta\>})>, czyli
      <with|mode|math|><with|mode|math|T<rprime|'>\<preccurlyeq\>SR=T> poza
      <with|mode|math|V> (bo <with|mode|math|\<beta\>\<in\>V>).

      <item><with|mode|math|e=let x=f in g> (LET: Local bindings).
      Wyprowadzenie <with|mode|math|T<rprime|'>\<tau\>> ko«czy si¦ z

      <\equation*>
        <frac|T<rprime|'>E\<vdash\>f:\<rho\><rprime|'><space|2fn>T<rprime|'>E.x:\<b-G\>(\<rho\><rprime|'>,T<rprime|'>E)\<vdash\>g:\<tau\><rprime|'>|T<rprime|'>E\<vdash\>(let
        x=f in g):\<tau\><rprime|'>>
      </equation*>

      Stosujemy zaª. ind. do <with|mode|math|[\<rho\><rprime|'>/\<beta\>]T<rprime|'>>

      <\equation*>
        (R,f,V<rsub|1>)=\<cal-C\>(E,\<beta\>,V\<setminus\>{\<beta\>})
      </equation*>

      mamy <with|mode|math|><with|mode|math|[\<rho\><rprime|'>/\<beta\>]T<rprime|'>\<preccurlyeq\>R>,
      czyli <with|mode|math|[\<rho\><rprime|'>/\<beta\>]T<rprime|'>=T<rsub|1>R>,
      poza <with|mode|math|V\<setminus\>{\<beta\>}>. Analogicznie jak przy
      dowodzie dla algorytmu <with|mode|math|\<cal-W\>> pokazuje si¦, »e
      mo»emy wyprowadzi¢

      <\equation*>
        T<rprime|'>E.x:T<rsub|1>\<b-G\>(R\<beta\>,R*E)\<vdash\>g:\<tau\><rprime|'>
      </equation*>

      Stosujemy wi¦c zaª. ind. do powy»szego, bior¡c
      <with|mode|math|E<rprime|'>=R*E.x:\<b-G\>(R\<beta\>,R*E)>

      <\equation*>
        (S,g,V<rsub|2>)=\<cal-C\>(R*E.x:\<b-G\>(R\<beta\>,R*E),\<tau\>,V<rsub|1>)
      </equation*>

      oraz <with|mode|math|T<rsub|1>\<preccurlyeq\>S> poza
      <with|mode|math|V<rsub|1>>. St¡d <with|mode|math|T<rprime|'>\<preccurlyeq\>S*R=T>
      poza <with|mode|math|V>, bo <with|mode|math|V<rsub|1>\<subset\>V> i
      <with|mode|math|\<beta\>\<in\>V>.

      \ 
    </enumerate>

    \;
  </proof>

  Zobaczmy, »e <with|mode|math|\<cal-C\>> w pewnym sensie odtwarza, podobnie
  jak <with|mode|math|\<cal-W\>>, najogólniejszy typ skonstruowanego termu.

  <\corollary>
    <label|gentypC>Je±li <with|mode|math|\<beta\>> jest zmienn¡ typu nie
    wyst¦puj¡c¡ w <with|mode|math|E>, <with|mode|math|\<beta\>\<nin\>V>, oraz
    <with|mode|math|\<cal-C\>(E,\<beta\>,V)=(T,e,V<rsub|1>)>, to dla
    dowolnego typu <with|mode|math|\<tau\>> i podstawienia
    <with|mode|math|T<rprime|'>>, <with|mode|math|\<beta\>\<nin\>\<b-F\>(\<tau\>)\<cup\>\<b-F\>(T<rprime|'>)>,
    dla których <with|mode|math|T<rprime|'>E\<vdash\>e:\<tau\>>, mamy
    <with|mode|math|T<rprime|'>\<preccurlyeq\>T> poza
    <with|mode|math|V\<cup\>{\<beta\>}> i
    <with|mode|math|\<tau\>\<preccurlyeq\>T\<beta\>>.
  </corollary>

  <\proof>
    Zaªó»my, »e dla wyborów <with|mode|math|<wide|w|\<vect\>><rsub|1>> i
    <with|mode|math|<wide|w|\<vect\>><rsub|2>> zachodzi
    <with|mode|math|\<cal-C\>(E,\<beta\>,V,<wide|w|\<vect\>><rsub|1>)=(R,e,V<rsub|1>)>
    oraz <with|mode|math|\<cal-C\>(E,\<beta\>,V,<wide|w|\<vect\>><rsub|2>)=(S,e,V<rsub|2>)>.
    Sprawdzaj¡c, »e przebiegi algorytmu si¦ dokªadnie pokrywaj¡ (przez
    indukcj¦ wzgl¦dem <with|mode|math|e>), czyli »e
    <with|mode|math|\<cal-C\>(E,\<beta\>,V,<wide|w|\<vect\>><rsub|1>)=\<cal-C\>(E,\<beta\>,V,<wide|w|\<vect\>><rsub|2>)>,
    otrzymujemy, »e <with|mode|math|R=S>.

    Rozszerzmy <with|mode|math|T<rprime|'>> do
    <with|mode|math|T<rprime|''>=[\<tau\>/\<beta\>]T<rprime|'>>. Mamy
    <with|mode|math|T<rprime|''>E\<vdash\>e:T<rprime|''>\<beta\>>. Ze
    stwierdzenia <reference|pelnoscC> dla pewnej ±cie»ki wyborów
    <with|mode|math|<wide|w|\<vect\>><rsub|1>> i
    <with|mode|math|\<cal-C\>(E,\<beta\>,V,<wide|w|\<vect\>><rsub|1>)=(R,e,V<rsub|1>)>
    mamy <with|mode|math|T<rprime|''>\<preccurlyeq\>R> poza
    <with|mode|math|V>, ale <with|mode|math|R=T>, wi¦c
    <with|mode|math|T<rprime|''>\<preccurlyeq\>T> poza <with|mode|math|V>, a
    st¡d <with|mode|math|T<rprime|'>\<preccurlyeq\>T> poza
    <with|mode|math|V\<cup\>{\<beta\>}> i
    <with|mode|math|\<tau\>=T<rprime|''>\<beta\>\<preccurlyeq\>T\<beta\>>.
  </proof>

  <subsection|Rozszerzenie j¦zyka o konstrukcj¦
  <with|mode|math|case>.><label|MLcase>

  Dotychczasowy system typów nie traktowaª w »aden sposób struktur danych.
  U±ci±limy go pod tym wzgl¦dem i wprowadzimy do j¦zyka manipulacj¦ tzw.
  indukcyjnymi strukturami danych: konstruktory oraz dekonstruktor analizy
  przez przypadki <with|mode|math|case>. Zaprezentowany system typów
  odpowiada systemowi <with|mode|math|\<lambda\><wide||^>> z
  <cite|barthe-typebased> z pomini¦ciem etapów (stages), które wprowadzimy w
  nast¦pnym rozdziale. W kwestii szczegóªów definicji odsyªam do
  <cite|barthe-typebased>.

  <\definition>
    Reguªy typowania dla struktur indukcyjnych:

    <\enumerate-numeric>
      <item>VAR: Variables...

      <item>FIX: Functions...

      <item>APP: Applications...

      <item>LET: Local bindings...

      <item>CASE: Deconstruction

      <\equation*>
        <frac|E\<vdash\>e<rprime|'>:d<wide|\<tau\>|\<vect\>><space|2fn>E\<vdash\>e<rsub|i>:Inst<rsub|c<rsub|i>><wide|\<tau\>|\<vect\>>\<rightarrow\>\<theta\>
        (1\<leqslant\>i\<leqslant\>n)|E\<vdash\>case e<rprime|'> of
        {c<rsub|1>\<Rightarrow\>e<rsub|1>\|\<ldots\>\|c<rsub|n>\<Rightarrow\>e<rsub|n>}:\<theta\>><with|mode|text|
        je±li >\<b-C\>(d)={c<rsub|1>,\<ldots\>,c<rsub|n>}
      </equation*>

      <item>Zamiast reguªy: CONS: Constructor

      <\equation*>
        <frac||E\<vdash\>c:Inst<rsub|c><wide|\<tau\>|\<vect\>>\<rightarrow\>d<wide|\<tau\>|\<vect\>>><with|mode|text|
        je±li >c\<in\>\<b-C\>(d)
      </equation*>

      wprowadzamy zaªo»enie na temat ±rodowiska <with|mode|math|E>:

      <\equation*>
        (\<forall\>d)(\<forall\>c\<in\>\<b-C\>(d)) <with|mode|text| niech
        >c:\<forall\><wide|\<alpha\>|\<vect\>>.Inst<rsub|c><wide|\<alpha\>|\<vect\>>\<rightarrow\>d<wide|\<alpha\>|\<vect\>>\<in\>E,<with|mode|text|
        gdzie >#<wide|\<alpha\>|\<vect\>><with|mode|text| jest arno±ci¡ >d
      </equation*>
    </enumerate-numeric>

    gdzie <with|mode|math|\<b-C\>(d)> jest zbiorem konstruktorów typu
    <with|mode|math|d>, <with|mode|math|<wide|\<tau\>|\<vect\>>> s¡
    argumentami typu, <with|mode|math|Inst<rsub|c><wide|\<tau\>|\<vect\>>>
    jest wektorem typów argumentów konstruktora <with|mode|math|c>, je±li typ
    parametryczny <with|mode|math|d> przybierze parametry
    <with|mode|math|<wide|\<tau\>|\<vect\>>>. Oznaczenie: je±li
    <with|mode|math|<wide|\<sigma\>|\<vect\>>=(\<sigma\><rsub|1>,\<ldots\>,\<sigma\><rsub|n>)=(\<sigma\><rsub|i>)<rsub|1\<leqslant\>i\<leqslant\>n>>,
    to <with|mode|math|#<wide|\<sigma\>|\<vect\>>=n> oraz

    <\equation*>
      <wide|\<sigma\>|\<vect\>>\<rightarrow\>\<tau\>=\<sigma\><rsub|1>\<rightarrow\>\<ldots\>\<rightarrow\>\<sigma\><rsub|n>\<rightarrow\>\<tau\>=\<sigma\><rsub|1>\<rightarrow\>(\<ldots\>\<rightarrow\>(\<sigma\><rsub|n>\<rightarrow\>\<tau\>)\<ldots\>)
    </equation*>
  </definition>

  Wypada rozszerzy¢ algorytmy <with|mode|math|\<cal-W\>> i
  <with|mode|math|\<cal-C\>>.

  <\definition>
    <with|mode|math|\<cal-W\>(E,e,V)=(T,\<tau\>,V<rprime|'>)>, gdzie dopasuj
    <with|mode|math|e>:

    <\enumerate>
      <item><with|mode|math|e=x> (VAR: Variables)...

      <item><with|mode|math|e=fix f x.e<rsub|1>> (FIX: Functions)...

      <item><with|mode|math|e=f*g> (APP: Applications)...

      <item><with|mode|math|e=let x=f in g> (LET: Local bindings)...

      <item><with|mode|math|e=case e<rprime|'> of
      {c<rsub|1>\<Rightarrow\>e<rsub|1>\|\<ldots\>\|c<rsub|n>\<Rightarrow\>e<rsub|n>}>
      (CASE: Deconstruction) Dla typu <with|mode|math|d> o arno±ci
      <with|mode|math|k> (<with|mode|math|k>-parametrycznego) t. »e
      <with|mode|math|c<rsub|1>,\<ldots\>,c<rsub|n>\<in\>\<b-C\>(d)>

      <\eqnarray*>
        <tformat|<table|<row|<cell|V>|<cell|=>|<cell|{\<beta\><rsub|i>\|1\<leqslant\>i\<leqslant\>k}\<cup\>{\<theta\>}<wide|\<cup\>|\<dot\>>V<rsub|r>>>|<row|<cell|(T<rsub|0>,\<rho\>,V<rsub|0>)>|<cell|=>|<cell|\<cal-W\>(E,e<rprime|'>,V<rsub|r>)>>|<row|<cell|U<rsub|0>>|<cell|=>|<cell|\<b-U\>(\<rho\>,d<wide|\<beta\>|\<vect\>>)>>|<row|<cell|(T<rsub|1>,\<sigma\><rsub|1>,V<rsub|1>)>|<cell|=>|<cell|\<cal-W\>(U<rsub|0>T<rsub|0>*E,e<rsub|1>,V<rsub|0>)>>|<row|<cell|U<rsub|1>>|<cell|=>|<cell|\<b-U\>(T<rsub|1>U<rsub|0>T<rsub|0>(Inst<rsub|c<rsub|1>><wide|\<beta\>|\<vect\>>\<rightarrow\>\<theta\>),\<sigma\><rsub|1>)>>|<row|<cell|\<ldots\>>|<cell|>|<cell|>>|<row|<cell|(T<rsub|n>,\<sigma\><rsub|n>,V<rsub|n>)>|<cell|=>|<cell|\<cal-W\>(U<rsub|n-1>T<rsub|n-1>\<ldots\>U<rsub|0>T<rsub|0>E,e<rsub|n>,V<rsub|n-1>)>>|<row|<cell|U<rsub|n>>|<cell|=>|<cell|\<b-U\>(T<rsub|n>U<rsub|n-1>T<rsub|n-1>\<ldots\>U<rsub|0>T<rsub|0>(Inst<rsub|c<rsub|1>><wide|\<beta\>|\<vect\>>\<rightarrow\>\<theta\>),\<sigma\><rsub|n>)>>|<row|<cell|T>|<cell|=>|<cell|U<rsub|n>T<rsub|n>\<ldots\>U<rsub|0>T<rsub|0>>>|<row|<cell|\<tau\>>|<cell|=>|<cell|T\<theta\>>>|<row|<cell|V<rprime|'>>|<cell|=>|<cell|V<rsub|n>>>>>
      </eqnarray*>
    </enumerate>
  </definition>

  <\note>
    <label|ddistr>Dla dowolnego podstawienia <with|mode|math|T>, typu
    indukcyjnego <with|mode|math|d>, typów
    <with|mode|math|<wide|\<tau\>|\<vect\>>,#<wide|\<tau\>|\<vect\>>=ar(d)> i
    konstruktora <with|mode|math|c, c\<in\>\<b-C\>(d)> zachodzi

    <\eqnarray*>
      <tformat|<table|<row|<cell|d(T<wide|\<tau\>|\<vect\>>)>|<cell|=>|<cell|T*d<wide|\<tau\>|\<vect\>>>>|<row|<cell|Inst<rsub|c>T<wide|\<tau\>|\<vect\>>>|<cell|=>|<cell|T*Inst<rsub|c><wide|\<tau\>|\<vect\>>>>>>
    </eqnarray*>
  </note>

  <\definition>
    <with|mode|math|\<cal-C\>(E,\<tau\>,V,<wide|w|\<vect\>>)=(T,e,V<rprime|'>,<wide|w|\<vect\>><rprime|'>)>,
    gdzie dla <with|mode|math|(w<rsub|1 >mod 5)> równego

    <\enumerate>
      <item>VAR: Variables...

      <item>FIX: Functions...

      <item>APP: Applications...

      <item>LET: Local bindings...

      <item>CASE: Deconstruction. Niech <with|mode|math|d> b¦dzie
      <with|mode|math|(w<rsub|i+1> mod D)>-ym typem indukcyjnym, gdzie
      <with|mode|math|D> jest ilo±ci¡ typów indukcyjnych, oraz
      <with|mode|math|k> arno±ci¡ typu <with|mode|math|d>. Niech

      <\eqnarray*>
        <tformat|<table|<row|<cell|V>|<cell|=>|<cell|{\<beta\><rsub|i>\|1\<leqslant\>i\<leqslant\>k}\<cup\>{\<theta\>}<wide|\<cup\>|\<dot\>>V<rsub|r>>>|<row|<cell|(R,e<rprime|'>,V<rsub|0>,<wide|w|\<vect\>><rsub|0>)>|<cell|=>|<cell|\<cal-C\>(E,d<wide|\<beta\>|\<vect\>>,V<rsub|r>,(w<rsub|i+2>))>>|<row|<cell|(T<rsub|1>,e<rsub|1>,V<rsub|1>,<wide|w|\<vect\>><rsub|1>)>|<cell|=>|<cell|\<cal-C\>(R*E,R*(Inst<rsub|c<rsub|1>><wide|\<beta\>|\<vect\>>\<rightarrow\>\<tau\>),V<rsub|0>,<wide|w|\<vect\>><rsub|0>)>>|<row|<cell|\<ldots\>>|<cell|>|<cell|>>|<row|<cell|(T<rsub|n>,e<rsub|n>,V<rsub|n>,<wide|w|\<vect\>><rsub|n>)>|<cell|=>|<cell|\<cal-C\>(T<rsub|n-1>\<ldots\>T<rsub|1>R*E,T<rsub|n-1>\<ldots\>T<rsub|1>R*(Inst<rsub|c<rsub|n>><wide|\<beta\>|\<vect\>>\<rightarrow\>\<tau\>),V<rsub|n-1>,<wide|w|\<vect\>><rsub|n-1>)>>|<row|<cell|T
        >|<cell|=>|<cell|T<rsub|n>\<ldots\>T<rsub|1>R>>|<row|<cell|e>|<cell|=>|<cell|case
        e<rprime|'> of {c<rsub|1>\<Rightarrow\>e<rsub|1>\|\<ldots\>\|c<rsub|n>\<Rightarrow\>e<rsub|n>}>>|<row|<cell|V<rprime|'>>|<cell|=>|<cell|V<rsub|n>>>|<row|<cell|<wide|w|\<vect\>><rprime|'>>|<cell|=>|<cell|<wide|w|\<vect\>><rsub|n>>>>>
      </eqnarray*>
    </enumerate>
  </definition>

  <subsubsection|Poprawno±¢ z <with|mode|math|case>.>

  <\theorem>
    Niech <with|mode|math|e> b¦dzie wyra»eniem, <with|mode|math|E>
    ±rodowiskiem, <with|mode|math|V> zbiorem zmiennych typu. Je±li
    <with|mode|math|(T, \<tau\>, V<rprime|'>)=\<cal-W\>(E,e,V)> jest
    okre±lone, to mo»emy wywnioskowa¢ <with|mode|math|T*E\<vdash\>e:\<tau\>>.
  </theorem>

  <\proof>
    Przez indukcj¦ wzgl¦dem budowy termu:

    <\enumerate>
      <item><with|mode|math|e=x> (VAR: Variables)...

      <item><with|mode|math|e=fix f x.e<rsub|1>> (FIX: Functions)...

      <item><with|mode|math|e=f*g> (APP: Applications)...

      <item><with|mode|math|e=let x=f in g> (LET: Local bindings)...

      <item><with|mode|math|e=case e<rprime|'> of
      {c<rsub|1>\<Rightarrow\>e<rsub|1>\|\<ldots\>\|c<rsub|n>\<Rightarrow\>e<rsub|n>}>
      (CASE: Deconstruction). Z algorytmu i z zaª. ind. mamy:

      <\eqnarray*>
        <tformat|<table|<row|<cell|T<rsub|0>E>|<cell|\<vdash\>>|<cell|e<rprime|'>:\<rho\>>>|<row|<cell|U<rsub|0>>|<cell|=>|<cell|\<b-U\>(\<rho\>,d<wide|\<beta\>|\<vect\>>)>>|<row|<cell|T<rsub|1>U<rsub|0>T<rsub|0>E>|<cell|\<vdash\>>|<cell|e<rsub|1>:\<sigma\><rsub|1>>>|<row|<cell|U<rsub|1>>|<cell|=>|<cell|\<b-U\>(T<rsub|1>U<rsub|0>T<rsub|0>(Inst<rsub|c<rsub|1>><wide|\<beta\>|\<vect\>>\<rightarrow\>\<theta\>),\<sigma\><rsub|1>)>>|<row|<cell|\<ldots\>>|<cell|>|<cell|>>|<row|<cell|T<rsub|n>U<rsub|n-1>T<rsub|n-1>\<ldots\>U<rsub|0>T<rsub|0>E>|<cell|\<vdash\>>|<cell|e<rsub|n>:\<sigma\><rsub|n>>>|<row|<cell|U<rsub|n>>|<cell|=>|<cell|\<b-U\>(T<rsub|n>U<rsub|n-1>T<rsub|n-1>\<ldots\>U<rsub|0>T<rsub|0>(Inst<rsub|c<rsub|n>><wide|\<beta\>|\<vect\>>\<rightarrow\>\<theta\>),\<sigma\><rsub|n>)>>|<row|<cell|T>|<cell|=>|<cell|U<rsub|n>T<rsub|n>\<ldots\>U<rsub|0>T<rsub|0>>>|<row|<cell|\<tau\>>|<cell|=>|<cell|T\<theta\>>>>>
      </eqnarray*>

      Poniewa»

      <\equation*>
        U<rsub|0>\<rho\>=U<rsub|0>d<wide|\<beta\>|\<vect\>>
      </equation*>

      oraz

      <\equation*>
        U<rsub|i>\<sigma\><rsub|i>=U<rsub|i>(Inst<rsub|c<rsub|i>><wide|\<beta\>|\<vect\>>\<rightarrow\>\<theta\>)
      </equation*>

      z lematu o podstawianiu mamy (podstawiaj¡c po obu stronach
      <with|mode|math|U<rsub|i>>, stosuj¡c powy»sz¡ równo±¢, podstawiaj¡c po
      obu stronach <with|mode|math|T<rsub|i+1>,U<rsub|i+1>,\<ldots\>,T<rsub|n>,U<rsub|n>>)

      <\eqnarray*>
        <tformat|<table|<row|<cell|T*E>|<cell|\<vdash\>>|<cell|e<rprime|'>:U<rsub|n>T<rsub|n>\<ldots\>U<rsub|0>d<wide|\<beta\>|\<bar\>>>>|<row|<cell|T*E>|<cell|\<vdash\>>|<cell|e<rsub|1>:T(Inst<rsub|c<rsub|1>><wide|\<beta\>|\<vect\>>\<rightarrow\>\<theta\>)>>|<row|<cell|\<ldots\>>|<cell|>|<cell|>>|<row|<cell|T*E>|<cell|\<vdash\>>|<cell|e<rsub|n>:T(Inst<rsub|c<rsub|n>><wide|\<beta\>|\<vect\>>\<rightarrow\>\<theta\>)>>>>
      </eqnarray*>

      Stosuj¡c fakt <reference|ddistr> mamy

      <\eqnarray*>
        <tformat|<table|<row|<cell|T*E>|<cell|\<vdash\>>|<cell|e<rprime|'>:d(T<wide|\<beta\>|\<vect\>>)>>|<row|<cell|T*E>|<cell|\<vdash\>>|<cell|e<rsub|1>:Inst<rsub|c<rsub|1>>(T<wide|\<beta\>|\<vect\>>)\<rightarrow\>\<tau\>>>|<row|<cell|\<ldots\>>|<cell|>|<cell|>>|<row|<cell|T*E>|<cell|\<vdash\>>|<cell|e<rsub|n>:Inst<rsub|c<rsub|n>>(T<wide|\<beta\>|\<vect\>>)\<rightarrow\>\<tau\>>>>>
      </eqnarray*>

      Z reguªy dekonstrukcji (CASE) wnioskujemy (dla tamtejszych
      <with|mode|math|<wide|\<tau\>|\<vect\>>\<assign\>T<wide|\<beta\>|\<vect\>>>
      i <with|mode|math|\<theta\>\<assign\>\<tau\>>)

      <\equation*>
        T*E\<vdash\>(case e<rprime|'> of {c<rsub|1>\<Rightarrow\>e<rsub|1>\|\<ldots\>\|c<rsub|n>\<Rightarrow\>e<rsub|n>}):\<tau\>
      </equation*>
    </enumerate>

    \;
  </proof>

  <\theorem>
    Niech <with|mode|math|\<tau\>> b¦dzie typem, <with|mode|math|E>
    ±rodowiskiem, <with|mode|math|V> zbiorem zmiennych typu. Je±li
    <with|mode|math|(T,e,V<rprime|'>)=\<cal-C\>(E,\<tau\>,V)> jest okre±lone,
    to mo»emy wywnioskowa¢ <with|mode|math|T*E\<vdash\>e:T\<tau\>>.
  </theorem>

  <\proof>
    Przez indukcj¦ na zªo»ono±¢ generowanego termu:

    <\enumerate>
      <item><with|mode|math|e=x> (VAR: Variables)...

      <item><with|mode|math|e=fix f x.e<rsub|1>> (FIX: Functions)...

      <item><with|mode|math|e=f*g> (APP: Applications)...

      <item><with|mode|math|e=let x=f in g> (LET: Local bindings)...

      <item><with|mode|math|e=case e<rprime|'> of
      {c<rsub|1>\<Rightarrow\>e<rsub|1>\|\<ldots\>\|c<rsub|n>\<Rightarrow\>e<rsub|n>}>
      (CASE: Deconstruction). Z algorytmu i zaª. ind. mamy:

      <\eqnarray*>
        <tformat|<table|<row|<cell|\<rho\>>|<cell|=>|<cell|d<wide|\<beta\>|\<vect\>>>>|<row|<cell|R*E>|<cell|\<vdash\>>|<cell|e<rprime|'>:R\<rho\>>>|<row|<cell|T<rsub|1>R*E>|<cell|\<vdash\>>|<cell|e<rsub|1>:T<rsub|1>R(Inst<rsub|c<rsub|1>><wide|\<beta\>|\<vect\>>\<rightarrow\>\<tau\>)>>|<row|<cell|\<ldots\>>|<cell|>|<cell|>>|<row|<cell|T<rsub|n>\<ldots\>T<rsub|1>R*E>|<cell|\<vdash\>>|<cell|e<rsub|n>:T<rsub|n>\<ldots\>T<rsub|1>R*(Inst<rsub|c<rsub|n>><wide|\<beta\>|\<vect\>>\<rightarrow\>\<tau\>)>>|<row|<cell|T
        >|<cell|=>|<cell|T<rsub|n>\<ldots\>T<rsub|1>R>>>>
      </eqnarray*>

      Stosuj¡c lemat o podstawianiu i fakt <reference|ddistr>, jak w dowodzie
      dla algorytmu <with|mode|math|\<cal-W\>>, otrzymujemy

      <\eqnarray*>
        <tformat|<table|<row|<cell|T*E>|<cell|\<vdash\>>|<cell|e<rprime|'>:d(T<wide|\<beta\>|\<vect\>>)>>|<row|<cell|T*E>|<cell|\<vdash\>>|<cell|e<rsub|1>:Inst<rsub|c<rsub|1>>(T<wide|\<beta\>|\<vect\>>)\<rightarrow\>T\<tau\>>>|<row|<cell|\<ldots\>>|<cell|>|<cell|>>|<row|<cell|T*E>|<cell|\<vdash\>>|<cell|e<rsub|n>:Inst<rsub|c<rsub|n>>(T<wide|\<beta\>|\<vect\>>)\<rightarrow\>T\<tau\>>>>>
      </eqnarray*>

      Z reguªy dekonstrukcji (CASE) wnioskujemy (dla tamtejszych
      <with|mode|math|<wide|\<tau\>|\<vect\>>\<assign\>T<wide|\<beta\>|\<vect\>>>
      i <with|mode|math|\<theta\>\<assign\>T\<tau\>>)

      <\equation*>
        T*E\<vdash\>(case e<rprime|'> of {c<rsub|1>\<Rightarrow\>e<rsub|1>\|\<ldots\>\|c<rsub|n>\<Rightarrow\>e<rsub|n>}):T\<tau\>
      </equation*>
    </enumerate>

    \;
  </proof>

  <subsubsection|Peªno±¢ z <with|mode|math|case>.>

  <\theorem>
    Niech <with|mode|math|e> b¦dzie wyra»eniem, <with|mode|math|E>
    ±rodowiskiem, <with|mode|math|V> niesko«czonym zbiorem zmiennych typu
    takim, »e <with|mode|math|V\<cap\>\<b-F\>(E)= \<varnothing\>>. Je±li
    istnieje typ <with|mode|math|\<tau\><rprime|'>> i podstawienie
    <with|mode|math|T<rprime|'>> t. »e <with|mode|math|T<rprime|'>E\<vdash\>e:\<tau\><rprime|'>>,
    to <with|mode|math|(T,\<tau\>,V<rprime|'>)=\<cal-W\>(E,e,V)> jest
    okre±lona, i istnieje podstawienie <with|mode|math|P> t. »e

    <\equation*>
      \<tau\><rprime|'>=P\<tau\><space|2fn><with|mode|text|i><space|2fn>T<rprime|'>=P*T<with|mode|text|
      poza >V
    </equation*>
  </theorem>

  <\proof>
    Przez indukcj¦ wzgl¦dem zªo»ono±ci <with|mode|math|e>:

    <\enumerate>
      <item><with|mode|math|e=x> (VAR: Variables)...

      <item><with|mode|math|e=fix f x.e<rsub|1>> (FIX: Functions)...

      <item><with|mode|math|e=f*g> (APP: Applications)...

      <item><with|mode|math|e=let x=f in g> (LET: Local bindings)...

      <item><with|mode|math|e=case e<rprime|'> of
      {c<rsub|1>\<Rightarrow\>e<rsub|1>\|\<ldots\>\|c<rsub|n>\<Rightarrow\>e<rsub|n>}>
      (CASE: Deconstruction). Wyprowadzenie typu
      <with|mode|math|\<tau\><rprime|'>> ko«czy si¦ z

      <\equation*>
        <frac|T<rprime|'>E\<vdash\>e<rprime|'>:d<wide|\<gamma\>|\<vect\>><space|2fn>T<rprime|'>E\<vdash\>e<rsub|i>:Inst<rsub|c<rsub|i>><wide|\<gamma\>|\<vect\>>\<rightarrow\>\<tau\><rprime|'>
        (1\<leqslant\>i\<leqslant\>n)|T<rprime|'>E\<vdash\>case e<rprime|'>
        of {c<rsub|1>\<Rightarrow\>e<rsub|1>\|\<ldots\>\|c<rsub|n>\<Rightarrow\>e<rsub|n>}:\<tau\><rprime|'>>
      </equation*>

      Stosujemy zaª. ind. <with|mode|math|n+1>-krotnie

      <\eqnarray*>
        <tformat|<table|<row|<cell|(T<rsub|0>,\<rho\>,V<rsub|0>)>|<cell|=>|<cell|\<cal-W\>(E,e<rprime|'>,V<rsub|r>)>>|<row|<cell|d<wide|\<gamma\>|\<vect\>>>|<cell|=>|<cell|P<rsub|0>\<rho\>>>|<row|<cell|T<rprime|'>>|<cell|=>|<cell|P<rsub|0>T<rsub|0><with|mode|text|
        poza >V<rsub|r>>>|<row|<cell|U<rsub|0>>|<cell|=>|<cell|\<b-U\>(\<rho\>,d<wide|\<beta\>|\<vect\>>)>>|<row|<cell|P<rsub|0>>|<cell|=>|<cell|P<rsub|0><rprime|'>U<rsub|0><with|mode|text|
        poza ><wide|\<beta\>|\<vect\>>>>|<row|<cell|T<rprime|'>E>|<cell|=>|<cell|P<rsub|0>T<rsub|0>E=P<rsub|0><rprime|'>U<rsub|0>T<rsub|0>E>>|<row|<cell|(T<rsub|1>,\<sigma\><rsub|1>,V<rsub|1>)>|<cell|=>|<cell|\<cal-W\>(U<rsub|0>T<rsub|0>*E,e<rsub|1>,V<rsub|0>)>>|<row|<cell|Inst<rsub|c<rsub|1>><wide|\<gamma\>|\<vect\>>\<rightarrow\>\<tau\><rprime|'>>|<cell|=>|<cell|P<rsub|1>\<sigma\><rsub|1>>>|<row|<cell|P<rsub|0><rprime|'>>|<cell|=>|<cell|P<rsub|1>T<rsub|1><with|mode|text|
        poza >V<rsub|0>>>|<row|<cell|U<rsub|1>>|<cell|=>|<cell|\<b-U\>(T<rsub|1>U<rsub|0>T<rsub|0>(Inst<rsub|c<rsub|1>><wide|\<beta\>|\<vect\>>\<rightarrow\>\<theta\>),\<sigma\><rsub|1>)>>|<row|<cell|P<rsub|1>>|<cell|=>|<cell|P<rsub|1><rprime|'>U<rsub|1><with|mode|text|
        poza >\<theta\>>>|<row|<cell|T<rprime|'>E>|<cell|=>|<cell|P<rsub|1><rprime|'>U<rsub|1>T<rsub|1>U<rsub|0>T<rsub|0>E>>|<row|<cell|(T<rsub|2>,\<sigma\><rsub|2>,V<rsub|2>)>|<cell|=>|<cell|\<cal-W\>(U<rsub|1>T<rsub|1>U<rsub|0>T<rsub|0>E,e<rsub|2>,V<rsub|1>)>>|<row|<cell|Inst<rsub|c<rsub|2>><wide|\<gamma\>|\<vect\>>\<rightarrow\>\<tau\><rprime|'>>|<cell|=>|<cell|P<rsub|2>\<sigma\><rsub|2>>>|<row|<cell|P<rsub|1><rprime|'>>|<cell|=>|<cell|P<rsub|2>T<rsub|2><with|mode|text|
        poza >V<rsub|1>>>|<row|<cell|U<rsub|2>>|<cell|=>|<cell|\<b-U\>(T<rsub|2>U<rsub|1>T<rsub|1>U<rsub|0>T<rsub|0>(Inst<rsub|c<rsub|2>><wide|\<beta\>|\<vect\>>\<rightarrow\>\<theta\>),\<sigma\><rsub|2>)>>|<row|<cell|P<rsub|2>>|<cell|=>|<cell|P<rsub|2><rprime|'>U<rsub|2><with|mode|text|
        poza >\<theta\>>>|<row|<cell|\<ldots\>>|<cell|>|<cell|>>|<row|<cell|(T<rsub|n>,\<sigma\><rsub|n>,V<rsub|n>)>|<cell|=>|<cell|\<cal-W\>(U<rsub|n-1>T<rsub|n-1>\<ldots\>U<rsub|0>T<rsub|0>E,e<rsub|n>,V<rsub|n-1>)>>|<row|<cell|Inst<rsub|c<rsub|n>><wide|\<gamma\>|\<vect\>>\<rightarrow\>\<tau\><rprime|'>>|<cell|=>|<cell|P<rsub|n>\<sigma\><rsub|n>>>|<row|<cell|P<rsub|n-1><rprime|'>>|<cell|=>|<cell|P<rsub|n>T<rsub|n><with|mode|text|
        poza >V<rsub|n-1>>>|<row|<cell|U<rsub|n>>|<cell|=>|<cell|\<b-U\>(T<rsub|n>U<rsub|n-1>T<rsub|n-1>\<ldots\>U<rsub|0>T<rsub|0>(Inst<rsub|c<rsub|n>><wide|\<beta\>|\<vect\>>\<rightarrow\>\<theta\>),\<sigma\><rsub|n>)>>|<row|<cell|P<rsub|n>>|<cell|=>|<cell|P<rsub|n><rprime|'>U<rsub|n><with|mode|text|
        poza >\<theta\>>>|<row|<cell|T>|<cell|=>|<cell|U<rsub|n>T<rsub|n>\<ldots\>U<rsub|0>T<rsub|0>>>|<row|<cell|T<rprime|'>>|<cell|=>|<cell|P<rsub|n><rprime|'>T*<with|mode|text|
        poza >V>>|<row|<cell|\<tau\>>|<cell|=>|<cell|T\<theta\>>>>>
      </eqnarray*>

      Unifikator <with|mode|math|U<rsub|0>> istnieje, bo
      <with|mode|math|P<rsub|0>\<rho\>=d<wide|\<gamma\>|\<vect\>>=[<wide|\<gamma\>|\<vect\>>/<wide|\<beta\>|\<vect\>>]d<wide|\<beta\>|\<vect\>>>,
      gdzie <with|mode|math|[<wide|\<gamma\>|\<vect\>>/<wide|\<beta\>|\<vect\>>]=[\<gamma\><rsub|1>/\<beta\><rsub|1>;\<ldots\>;\<gamma\><rsub|ar(d)>/\<beta\><rsub|ar(d)>]>.
      <with|mode|math|P<rsub|0>=P<rsub|0><rprime|'>U<rsub|0>> poza
      <with|mode|math|<wide|\<beta\>|\<vect\>>> dla pewnego
      <with|mode|math|P<rsub|0><rprime|'>>, bo
      <with|mode|math|><with|mode|math|[<wide|\<gamma\>|\<vect\>>/<wide|\<beta\>|\<vect\>>]P<rsub|0>>
      jest innym unifikatorem; (je±li <with|mode|math|U<rsub|0>> podstawia
      pod <with|mode|math|\<rho\>>, które jest wtedy zmienn¡, to
      <with|mode|math|P<rsub|0><rprime|'>> podstawia pod
      <with|mode|math|\<beta\><rsub|i>>; je±li <with|mode|math|U<rsub|0>>
      podstawia tylko pod <with|mode|math|\<beta\><rsub|i>>, to
      <with|mode|math|P<rsub|0><rprime|'>=P<rsub|0>>; je±li
      <with|mode|math|U<rsub|0>\<alpha\>=\<beta\><rsub|i>>, to
      <with|mode|math|P<rsub|0><rprime|'>\<beta\><rsub|i>=P<rsub|0>\<alpha\>>).
      Istnieje unifikator <with|mode|math|U<rsub|1>>, bo
      <with|mode|math|P<rsub|1>\<sigma\><rsub|1>=Inst<rsub|c<rsub|1>><wide|\<gamma\>|\<vect\>>\<rightarrow\>\<tau\><rprime|'>>,
      a <with|mode|math|P<rsub|1>T<rsub|1>U<rsub|0>T<rsub|0>(Inst<rsub|c<rsub|1>><wide|\<beta\>|\<vect\>>\<rightarrow\>\<theta\>)=P<rsub|0><rprime|'>U<rsub|0>T<rsub|0>(Inst<rsub|c<rsub|1>><wide|\<beta\>|\<vect\>>\<rightarrow\>\<theta\>)=Inst<rsub|c<rsub|1>><wide|\<gamma\>|\<vect\>>\<rightarrow\>\<theta\>>,
      bo <with|mode|math|d(P<rsub|0><rprime|'>U<rsub|0><wide|\<beta\>|\<vect\>>)=P<rsub|0><rprime|'>(U<rsub|0>d<wide|\<beta\>|\<vect\>>)=P<rsub|0><rprime|'>U<rsub|0>\<rho\>=P<rsub|0>\<rho\>=d<wide|\<gamma\>|\<vect\>>>.
      St¡d te» <with|mode|math|P<rsub|1>=P<rsub|1><rprime|'>U<rsub|1>> poza
      <with|mode|math|\<the4a\>>, bo <with|mode|math|[\<tau\><rprime|'>/\<theta\>]P<rsub|1>>
      jest unifikatorem. Niech <with|mode|math|\<sigma\><rsub|1><rsup|\<theta\>>>
      oznacza fragment typu <with|mode|math|U<rsub|1>\<sigma\><rsub|1>>
      odpowiadaj¡cy <with|mode|math|U<rsub|1>\<theta\>>. Istnieje unifikator
      <with|mode|math|U<rsub|2>>, bo <with|mode|math|P<rsub|2>\<sigma\><rsub|2>=Inst<rsub|c<rsub|2>><wide|\<gamma\>|\<vect\>>\<rightarrow\>\<tau\><rprime|'>>,
      a

      <\eqnarray*>
        <tformat|<table|<row|<cell|P<rsub|2>T<rsub|2>U<rsub|1>T<rsub|1>U<rsub|0>T<rsub|0>(Inst<rsub|c<rsub|2>><wide|\<beta\>|\<vect\>>\<rightarrow\>\<theta\>)>|<cell|=>|<cell|P<rsub|1><rprime|'>U<rsub|1>T<rsub|1>U<rsub|0>T<rsub|0>(Inst<rsub|c<rsub|2>><wide|\<beta\>|\<vect\>>\<rightarrow\>\<theta\>)>>|<row|<cell|>|<cell|=>|<cell|P<rsub|1><rprime|'>U<rsub|1>T<rsub|1>U<rsub|0>T<rsub|0>Inst<rsub|c<rsub|2>><wide|\<beta\>|\<vect\>>\<rightarrow\>P<rsub|1><rprime|'>U<rsub|1>T<rsub|1>U<rsub|0>T<rsub|0>\<theta\>>>|<row|<cell|>|<cell|=>|<cell|P<rsub|1>T<rsub|1>U<rsub|0>T<rsub|0>Inst<rsub|c<rsub|2>><wide|\<beta\>|\<vect\>>\<rightarrow\>P<rsub|1><rprime|'>(U<rsub|1>\<theta\>)>>|<row|<cell|>|<cell|=>|<cell|P<rsub|0><rprime|'>U<rsub|0>T<rsub|0>Inst<rsub|c<rsub|2>><wide|\<beta\>|\<vect\>>\<rightarrow\>P<rsub|1><rprime|'>\<sigma\><rsub|1><rsup|\<theta\>>>>|<row|<cell|>|<cell|=>|<cell|Inst<rsub|c<rsub|2>><wide|\<gamma\>|\<vect\>>\<rightarrow\>(\<tau\><rprime|'><with|mode|text|
        albo >\<theta\>)>>>>
      </eqnarray*>

      Tak»e <with|mode|math|P<rsub|2>=P<rsub|2><rprime|'>U<rsub|2>> poza
      <with|mode|math|\<theta\>>, bo je±li nie <with|mode|math|P<rsub|2>>, to
      napewno <with|mode|math|[\<tau\><rprime|'>/\<theta\>]P<rsub|2>> jest
      unifikatorem. Podobnie istniej¡ unifikatory <with|mode|math|U<rsub|i>>
      dla <with|mode|math|i=3,\<ldots\>,n>. Mamy
      <with|mode|math|P<rsub|n><rprime|'>T=P<rsub|n><rprime|'>U<rsub|n>T<rsub|n>\<ldots\>U<rsub|0>T<rsub|0>=P<rsub|n>T<rsub|n>\<ldots\>U<rsub|0>T<rsub|0>=P<rsub|n-1><rprime|'>U<rsub|n-1>T<rsub|4-1>\<ldots\>U<rsub|0>T<rsub|0>=P<rsub|0><rprime|'>U<rsub|0>T<rsub|0>=P<rsub|0>T<rsub|0>=T<rprime|'>>
      poza <with|mode|math|V>, bo <with|mode|math|<wide|\<beta\>|\<vect\>>,{\<theta\>},V<rsub|r>,V<rsub|i>\<subset\>V>.
      Tak»e <with|mode|math|P<rsub|n><rprime|'>U<rsub|n>T<rsub|n>\<ldots\>U<rsub|0>T<rsub|0>\<theta\>=\<tau\><rprime|'>>
      je±li które± spo±ród <with|mode|math|U<rsub|i>> podstawia pod
      <with|mode|math|\<theta\>>, w przec. przyp.
      <with|mode|math|P<rsub|n><rprime|'>T=\<theta\>>. Okre±lmy
      <with|mode|math|P=[\<tau\><rprime|'>/\<theta\>]P<rsub|n><rprime|'>>.
      <with|mode|math|P> speªnia warunki stwierdzenia.
    </enumerate>

    \;
  </proof>

  <\theorem>
    <label|pelnoscCd>Niech <with|mode|math|e> b¦dzie wyra»eniem,
    <with|mode|math|E> ±rodowiskiem. Dla dowolnego typu
    <with|mode|math|\<tau\>> i podstawienia <with|mode|math|T<rprime|'>> t.
    »e <with|mode|math|T<rprime|'>E\<vdash\>e:T<rprime|'>\<tau\>> oraz
    <with|mode|math|\<b-F\>(T<rprime|'>)\<cap\>Dom(T<rprime|'>)=
    \<varnothing\>> (?), dla niesko«czonego zbioru zmiennych
    <with|mode|math|V> rozª¡cznego z <with|mode|math|\<b-F\>(E)> i
    <with|mode|math|\<b-F\>(T<rprime|'>)>, dla pewnej ±cie»ki wyborów
    zachodzi <with|mode|math|(T,e,V<rprime|'>)=\<cal-C\>(E,\<tau\>,V)> oraz
    <with|mode|math|T<rprime|'>\<preccurlyeq\>T> poza <with|mode|math|V>.
  </theorem>

  <\proof>
    Przez indukcj¦ wzgl¦dem zªo»ono±ci e:

    <\enumerate>
      <item><with|mode|math|e=x> (VAR: Variables)...

      <item><with|mode|math|e=fix f x.e<rsub|1>> (FIX: Functions)...

      <item><with|mode|math|e=f*g> (APP: Applications)...

      <item><with|mode|math|e=let x=f in g> (LET: Local bindings)...

      <item><with|mode|math|e=case e<rprime|'> of
      {c<rsub|1>\<Rightarrow\>e<rsub|1>\|\<ldots\>\|c<rsub|n>\<Rightarrow\>e<rsub|n>}>
      (CASE: Deconstruction). Wyprowadzenie
      <with|mode|math|T<rprime|'>\<tau\>> ko«czy si¦ z

      <\equation*>
        <frac|T<rprime|'>E\<vdash\>e<rprime|'>:d<wide|\<gamma\>|\<vect\>><space|2fn>T<rprime|'>E\<vdash\>e<rsub|i>:Inst<rsub|c<rsub|i>><wide|\<gamma\>|\<vect\>>\<rightarrow\>\<tau\><rprime|'>
        (1\<leqslant\>i\<leqslant\>n)|T<rprime|'>E\<vdash\>case e<rprime|'>
        of {c<rsub|1>\<Rightarrow\>e<rsub|1>\|\<ldots\>\|c<rsub|n>\<Rightarrow\>e<rsub|n>}:\<tau\><rprime|'>>
      </equation*>

      gdzie <with|mode|math|\<tau\><rprime|'>=T<rprime|'>\<tau\>>. Wybieramy
      typ indukcyjny <with|mode|math|d>. Stosuj¡c
      <with|mode|math|n+1>-krotnie zaª. ind. mamy

      <\eqnarray*>
        <tformat|<table|<row|<cell|(R,e<rprime|'>,V<rsub|0>,<wide|w|\<vect\>><rsub|0>)>|<cell|=>|<cell|\<cal-C\>(E,d<wide|\<beta\>|\<vect\>>,V<rsub|r>,(w<rsub|i+2>))>>|<row|<cell|[<wide|\<gamma\>|\<vect\>>/<wide|\<beta\>|\<vect\>>]T<rprime|'>>|<cell|\<preccurlyeq\>>|<cell|R<with|mode|text|
        poza >V<rsub|r>>>|<row|<cell|[<wide|\<gamma\>|\<vect\>>/<wide|\<beta\>|\<vect\>>]T<rprime|'>>|<cell|=>|<cell|P<rsub|0>R<with|mode|text|
        poza >V<rsub|r>>>|<row|<cell|(T<rsub|1>,e<rsub|1>,V<rsub|1>,<wide|w|\<vect\>><rsub|1>)>|<cell|=>|<cell|\<cal-C\>(R*E,R*(Inst<rsub|c<rsub|1>><wide|\<beta\>|\<vect\>>\<rightarrow\>\<tau\>),V<rsub|0>,<wide|w|\<vect\>><rsub|0>)>>|<row|<cell|P<rsub|0>>|<cell|\<preccurlyeq\>>|<cell|T<rsub|1><with|mode|text|
        poza >V<rsub|0>>>|<row|<cell|P<rsub|0>>|<cell|=>|<cell|P<rsub|1>T<rsub|1><with|mode|text|
        poza >V<rsub|0>>>|<row|<cell|(T<rsub|2>,e<rsub|2>,V<rsub|2>,<wide|w|\<vect\>><rsub|2>)>|<cell|=>|<cell|\<cal-C\>(T<rsub|1>R*E,T<rsub|1>R(Inst<rsub|c<rsub|2>><wide|\<beta\>|\<vect\>>\<rightarrow\>\<tau\>),V<rsub|1>,<wide|w|\<vect\>><rsub|1>)>>|<row|<cell|P<rsub|1>>|<cell|\<preccurlyeq\>>|<cell|T<rsub|2><with|mode|text|
        poza >V<rsub|1>>>|<row|<cell|P<rsub|1>>|<cell|=>|<cell|P<rsub|2>T<rsub|2><with|mode|text|
        poza >V<rsub|1>>>|<row|<cell|\<ldots\>>|<cell|>|<cell|>>|<row|<cell|(T<rsub|n>,e<rsub|n>,V<rsub|n>,<wide|w|\<vect\>><rsub|n>)>|<cell|=>|<cell|\<cal-C\>(T<rsub|n-1>\<ldots\>T<rsub|1>R*E,T<rsub|n-1>\<ldots\>T<rsub|1>R*(Inst<rsub|c<rsub|n>><wide|\<beta\>|\<vect\>>\<rightarrow\>\<tau\>),V<rsub|n-1>,<wide|w|\<vect\>><rsub|n-1>)>>|<row|<cell|P<rsub|n-1>>|<cell|\<preccurlyeq\>>|<cell|T<rsub|n><with|mode|text|
        poza >V<rsub|n-1>>>|<row|<cell|P<rsub|n-1>>|<cell|=>|<cell|P<rsub|n>T<rsub|n><with|mode|text|
        poza >V<rsub|n-1>>>|<row|<cell|T >|<cell|=>|<cell|T<rsub|n>\<ldots\>T<rsub|1>R>>|<row|<cell|T<rprime|'>
        >|<cell|=>|<cell|P<rsub|n>T<with|mode|text| poza >V>>>>
      </eqnarray*>

      \ <with|mode|math|[<wide|\<gamma\>|\<vect\>>/<wide|\<beta\>|\<vect\>>]T<rprime|'>d<wide|\<beta\>|\<vect\>>=[<wide|\<gamma\>|\<vect\>>/<wide|\<beta\>|\<vect\>>]d<wide|\<beta\>|\<vect\>>=d<wide|\<gamma\>|\<vect\>>>.
      <with|mode|math|P<rsub|n>T=P<rsub|n>T<rsub|n>\<ldots\>T<rsub|1>R=P<rsub|n-1>T<rsub|n-1>\<ldots\>T<rsub|1>R=\<ldots\>=P<rsub|0>R=[<wide|\<gamma\>|\<vect\>>/<wide|\<beta\>|\<vect\>>]T<rprime|'>>
      poza <with|mode|math|V<rsub|r>\<cup\>V<rsub|0>\<cup\>\<ldots\>\<cup\>V<rsub|n-1>\<subset\>V>,
      oraz <with|mode|math|<wide|\<beta\>|\<vect\>>\<subset\>V>, czyli
      <with|mode|math|P<rsub|n>T=T<rprime|'>> poza <with|mode|math|V>.
    </enumerate>

    \;
  </proof>

  <subsubsection|Zagadnienia praktyczne: CASE sterowane u»yciem.>

  Aby zmniejszy¢ przypadkowo±¢ u»y¢ reguªy CASE, wprowadzamy do ±rodowiska
  specjalne zmienne <with|mode|math|x<rsub|c<rsub|i>,j>:\<forall\><wide|\<beta\>|\<vect\>>.(Inst<rsub|c<rsub|i>><wide|\<beta\>|\<vect\>>)<rsub|j>>
  oznaczaj¡ce wyj¦cie <with|mode|math|j>-tego argumentu konstruktora
  <with|mode|math|c<rsub|i>>. Dla ka»dego wyboru zmiennej generycznej
  <with|mode|math|x<rsub|c<rsub|i>,j>> generowane i wprowadzane do ±rodowiska
  s¡ nowe zmienne <with|mode|math|x<rsub|c<rsub|i>,j><rsup|k>:(Inst<rsub|c<rsub|i>><wide|\<beta\>|\<vect\>>)<rsub|j>>
  dla <with|mode|math|j=1,\<ldots\>,ar(c<rsub|i>)>, odpowiadaj¡ce argumentom
  konstruktora <with|mode|math|c<rsub|i>> z odpowiedniej dekonstrukcji CASE
  (gdzie <with|mode|math|<wide|\<beta\>|\<vect\>>> s¡ ±wie»ymi zmiennymi z
  <with|mode|math|V>); u»yta zostaje zmienna
  <with|mode|math|x<rsub|c<rsub|i>,j><rsup|k>>. W fazie postprocessingu
  konstrukcje CASE s¡ zastosowane w najw¦»szych podtermach obejmuj¡cych
  <with|mode|math|x<rsub|c<rsub|i>,j><rsup|k>> dla ustalonych
  <with|mode|math|i,k>, tak, »eby »adne <with|mode|math|x<rsub|c<rsub|i>,j><rsup|k>>
  nie byªo gªow¡ ''swojego'' podtermu. Stworzony podterm nazywamy gaª¦zi¡
  gªówn¡ odpowiedniego zastosowania CASE; rekurencyjnie generowane s¡
  pozostaªe gaª¦zie CASE. W jednoprzebiegowym algorytmie nale»y przyj¡¢ jak¡±
  arbitraln¡ strategi¦ limitowania rozmiaru gaª¦zi.<new-page>

  \;

  <section|Monotoniczno±¢ i wªasno±¢ stopu.>

  Teraz zaprezentuj¦ system kontroluj¡cy gª¦boko±¢ rekurencji, zapewniaj¡cy w
  ten sposób wªasno±¢ stopu. System <with|mode|math|\<lambda\><wide||^>>
  zostaª przedstawiony w <cite|barthe-typebased>. Typy danych w
  <with|mode|math|\<lambda\><wide||^>> s¡ indeksowane informacj¡ o gª¦boko±ci
  struktur, tzw. etapami: <with|mode|math|d<rsup|s><wide|\<tau\>|\<vect\>>>,
  <with|mode|math|d> jest typem danych, <with|mode|math|<rsup|s>> jest
  etapem, <with|mode|math|<wide|\<tau\>|\<vect\>>> s¡ parametrami typu.
  Reguªa wprowadzaj¡ca rekurencj¦ zapewnia, »e argument funkcji w wywoªaniach
  rekurencyjnych b¦dzie malaª, a poniewa» rozmiary danych s¡ sko«czone, wi¦c
  program rekurencyjny w ko«cu si¦ zatrzyma.

  Etapy konstruuje si¦ ze zmiennych etapu, unarnego operatora
  <with|mode|math|<wide||^>> oznaczaj¡cego jednostkowe zwi¦kszenie rozmiaru,
  oraz etapu pochªaniaj¡cego <with|mode|math|\<infty\>>, oznaczaj¡cego
  dowolny rozmiar. <with|mode|math|<wide|\<iota\>|^>> oznacza wszystkie
  rozmiary nie wi¦ksze wi¦cej ni» o jeden od rozmiarów oznaczanych przez
  <with|mode|math|\<iota\>>. <with|mode|math|d<rsup|s><wide|\<tau\>|\<vect\>>>
  oznacza wszystkie dane ``typu <with|mode|math|d<wide|\<tau\>|\<vect\>>>'' o
  rozmiarze nale»¡cym do <with|mode|math|s> (alternatywnie mo»na mówi¢: nie
  wi¦kszym ni» <with|mode|math|s>).

  <subsection|System typów i algorytm <with|mode|math|\<cal-C\>>.>

  Tak wygl¡da prezentacja w <cite|barthe-typebased>:

  <\definition>
    Porównywanie etapów <with|mode|math|\<preccurlyeq\>> i podtypowanie
    <with|mode|math|\<sqsubseteq\>>. Reguªy porównywania etapów:

    <\enumerate-numeric>
      <item>(REFL)

      <\equation*>
        <frac||s\<preccurlyeq\>s>
      </equation*>

      <item>(TRANS)

      <\equation*>
        <frac|s\<preccurlyeq\>r<space|2fn>r\<preccurlyeq\>p|s\<preccurlyeq\>p>
      </equation*>

      <item>(HAT)

      <\equation*>
        <frac||s\<preccurlyeq\><wide|s|^>>
      </equation*>

      <item>(INFTY)

      <\equation*>
        <frac||s\<preccurlyeq\>\<infty\>>
      </equation*>
    </enumerate-numeric>

    Reguªy podtypowania:

    <\enumerate>
      <item>(REFL)

      <\equation*>
        <frac||s\<sqsubseteq\>s>
      </equation*>

      <item>(DATA)

      <\equation*>
        <frac|s\<preccurlyeq\>r<space|2fn>\<tau\><rsub|i>\<sqsubseteq\>\<tau\><rsub|i><rprime|'><space|2fn>(1\<leqslant\>i\<leqslant\>ar(d))|d<rsup|s><wide|\<tau\>|\<vect\>>\<sqsubseteq\>d<rsup|r><wide|\<tau\>|\<vect\>><rprime|'>>
      </equation*>

      <item>(FUNC)

      <\equation*>
        <frac|\<tau\><rprime|'>\<sqsubseteq\>\<tau\><space|2fn>\<sigma\>\<sqsubseteq\>\<sigma\><rprime|'>|\<tau\>\<rightarrow\>\<sigma\>\<sqsubseteq\>\<tau\><rprime|'>\<rightarrow\>\<sigma\><rprime|'>>
      </equation*>
    </enumerate>
  </definition>

  <\definition>
    Reguªy typowania.

    <\enumerate>
      <item>(VAR)

      <\equation*>
        <frac||E\<vdash\>x:\<sigma\>>
      </equation*>

      gdy <with|mode|math|(x:\<sigma\>)\<in\>\<Gamma\>>.

      <item>(ABS)

      <\equation*>
        <frac|E.x:\<tau\>\<vdash\>e:\<sigma\>|E\<vdash\>\<lambda\>x.e:\<tau\>\<rightarrow\>\<sigma\>>
      </equation*>

      <item>(APP)

      <\equation*>
        <frac|E\<vdash\>e:\<tau\>\<rightarrow\>\<sigma\><space|2fn>E\<vdash\>e<rprime|'>:\<tau\>|E\<vdash\>e
        e<rprime|'>:\<sigma\>>
      </equation*>

      <item>(CONS)

      <\equation*>
        <frac||E\<vdash\>Inst<rsub|c><rsup|s><wide|\<tau\>|\<vect\>>\<rightarrow\>d<rsup|<wide|s|^>><wide|\<tau\>|\<vect\>>>
      </equation*>

      gdy <with|mode|math|c\<in\>\<b-C\>(d)>.

      <item>(CASE)

      <\equation*>
        <frac|E\<vdash\>e<rprime|'>:d<rsup|<wide|s|^>><wide|\<tau\>|\<vect\>><space|2fn>E\<vdash\>e<rsub|i>:Inst<rsub|c<rsub|i>><rsup|s><wide|\<tau\>|\<vect\>>\<rightarrow\>\<theta\><space|2fn>(1\<leqslant\>i\<leqslant\>n)|E\<vdash\>case
        e<rprime|'> of {c<rsub|1>\<Rightarrow\>e<rsub|1>\|\<ldots\>\|c<rsub|n>\<Rightarrow\>e<rsub|n>}:\<theta\>>
      </equation*>

      gdy <with|mode|math|\<b-C\>(d)={c<rsub|1>,\<ldots\>,c<rsub|n>}>.

      <item>(REC)

      <\equation*>
        <frac|E.f:d<rsup|\<iota\>><wide|\<tau\>|\<vect\>>\<rightarrow\>\<theta\>\<vdash\>e:d<rsup|<wide|\<iota\>|^>><wide|\<tau\>|\<vect\>>\<rightarrow\>[<wide|\<iota\>|^>/\<iota\>]\<theta\><space|2fn>\<iota\>
        pos \<theta\>|E\<vdash\>(letrec f=e):d<rsup|s><wide|\<tau\>|\<vect\>>\<rightarrow\>[s/\<iota\>]\<theta\>>
      </equation*>

      gdy <with|mode|math|\<iota\>> nie wyst¦puje w
      <with|mode|math|E,<wide|\<tau\>|\<vect\>>>.

      <item>(SUB)

      <\equation*>
        <frac|E\<vdash\>e:\<sigma\><space|2fn>\<sigma\>\<sqsubseteq\>\<sigma\><rprime|'>|E\<vdash\>e:\<sigma\><rprime|'>>
      </equation*>
    </enumerate>

    Pozytywne-negatywne wyst¡pienia zmiennej etapu:

    <\enumerate>
      <item>(SP1)

      <\equation*>
        <frac||\<iota\> pos \<alpha\>>
      </equation*>

      <item>(SP2)

      <\equation*>
        <frac|\<iota\> neg \<tau\><space|2fn>\<iota\> pos \<sigma\>|\<iota\>
        pos \<tau\>\<rightarrow\>\<sigma\>>
      </equation*>

      <item>(SP3)

      <\equation*>
        <frac|\<iota\> pos \<tau\><rsub|i><space|2fn>(1\<leqslant\>i\<leqslant\>ar(d))|\<iota\>
        pos d<rsup|s><wide|\<tau\>|\<vect\>>>
      </equation*>

      <item>(SN1)

      <\equation*>
        <frac||\<iota\> neg \<alpha\>>
      </equation*>

      <item>(SN2)

      <\equation*>
        <frac|\<iota\> pos \<tau\><space|2fn>\<iota\> neg \<sigma\>|\<iota\>
        neg \<tau\>\<rightarrow\>\<sigma\>>
      </equation*>

      <item>(SN3)

      <\equation*>
        <frac|\<iota\> nocc s<space|2fn>\<iota\> neg
        \<tau\><rsub|i><space|2fn>(1\<leqslant\>i\<leqslant\>ar(d))|\<iota\>
        neg d<rsup|s><wide|\<tau\>|\<vect\>>>
      </equation*>
    </enumerate>
  </definition>

  Jednak my potrzebujemy w reguªach typowania wskazówek co do podstawie«,
  dlatego b¦dziemy jawnie obsªugiwa¢ polimorfizm, wprowadzaj¡c explicite
  kwantyfikacj¦ zmiennych etapu. Poniewa» rekurencja jest dopuszczalna tylko
  wzgl¦dem argumentu b¦d¡cego typem danych, musimy przywróci¢ podziaª na
  abstrakcj¦ i rekurencj¦, jednak dostosujemy system do tego z pierwszego
  rozdziaªu, zast¦puj¡c <with|mode|math|letrec f=e> (REC) przez konstrukcj¦
  <with|mode|math|fix f x.e> (FIX). Wprowadzimy te» definicje lokalne (LET).
  Zamiast trudnej do kontroli reguªy (SUB), wprowadzamy podtypowanie obok
  konkretyzacji typu w regule (VAR). Co istotniejsze, wprowadzimy staªe etapu
  (albo zmienne uniwersalne etapu), poniewa» zmienne etapu (albo zmienne
  egzystencjalne, zmienne unifikacji) w typie zadanym zostaªyby potraktowane
  jako niewiadome. Podobnie, wprowadzimy staªe typu (albo zmienne uniwersalne
  typu), w odró»nieniu od konstruktorów typów danych <with|mode|math|d> i od
  zmiennych typu (egzystencjalnych, zmiennych unifikacji). (Egzystencjalne)
  zmienne wolne typu lub etapu nazywamy niewiadomymi typu lub etapu,
  odpowiednio.

  <\definition>
    Generalizacja

    <\eqnarray*>
      <tformat|<table|<row|<cell|\<b-G\>(\<tau\>,E)>|<cell|=>|<cell|\<forall\>\<alpha\><rsub|1>,\<ldots\>,\<alpha\><rsub|n>.\<tau\>>>>>
    </eqnarray*>

    gdzie <with|mode|math|\<alpha\><rsub|1>,\<ldots\>\<alpha\><rsub|n>> s¡
    dokªadnie tymi zmiennymi wolnymi typu lub etapu (niewiadomymi) w
    <with|mode|math|\<tau\>>, które nie wyst¦puj¡ w <with|mode|math|E>.
  </definition>

  <\definition>
    Konkretyzacja typu zmiennej ze ±rodowiska: <with|mode|math|\<tau\> > jest
    konkretyzacj¡ typu zmiennej <with|mode|math|x> ze ±rodowiska
    <with|mode|math|E>, <with|mode|math|\<alpha\><rsub|i>> s¡ zmiennymi typu,
    a <with|mode|math|\<iota\><rsub|i>> s¡ zmiennymi etapu,

    <\eqnarray*>
      <tformat|<table|<row|<cell|\<tau\>\<leqslant\>E(x)>|<cell|\<equiv\>>|<cell|E=\<ldots\>;x:\<forall\>\<alpha\><rsub|1>\<ldots\>\<alpha\><rsub|n>\<iota\><rsub|1>\<ldots\>\<iota\><rsub|m>.\<sigma\>;\<ldots\><with|mode|text|
      i >\<tau\>=[\<tau\><rsub|1>/\<alpha\><rsub|1>;\<ldots\>;\<tau\><rsub|n>/\<alpha\><rsub|n>;s<rsub|1>/\<iota\><rsub|1>;\<ldots\>;s<rsub|m>/\<iota\><rsub|m>]\<sigma\>>>>>
    </eqnarray*>

    dla pewnych typów <with|mode|math|\<tau\><rsub|1>,\<ldots\>,\<tau\><rsub|n>>
    oraz etapów <with|mode|math|s<rsub|1>,\<ldots\>,s<rsub|m>>.
  </definition>

  Poni»ej, podtypowanie jest tak jak okre±lono powy»ej.

  <\definition>
    Dostosowane reguªy typowania dla <with|mode|math|\<lambda\><wide||^>>.

    <\enumerate>
      <item>VAR: Variables.

      <\equation*>
        <frac|\<tau\>\<leqslant\>E(x)<space|2fn>\<sigma\>\<sqsubseteq\>\<tau\>|E\<vdash\>x:\<sigma\>>
      </equation*>

      <item>ABS: Abstractions.

      <\equation*>
        <frac|E.x:\<tau\>\<vdash\>e:\<sigma\>|E\<vdash\>\<lambda\>x.e:\<tau\>\<rightarrow\>\<sigma\>>
      </equation*>

      <item>FIX: Recursive functions.

      <\equation*>
        <frac|E.f:d<rsup|\<iota\>><wide|\<tau\>|\<vect\>>\<rightarrow\>\<theta\>.x:d<rsup|<wide|\<iota\>|^>><wide|\<tau\>|\<vect\>>\<vdash\>e:[<wide|\<iota\>|^>/\<iota\>]\<theta\><space|2fn>\<iota\>
        pos \<theta\>|E\<vdash\>(fix f x=e):d<rsup|s><wide|\<tau\>|\<vect\>>\<rightarrow\>[s/\<iota\>]\<theta\>>
      </equation*>

      gdzie <with|mode|math|\<iota\>> nie wyst¦puje w <with|mode|math|E> ani
      w <with|mode|math|<wide|\<tau\>|\<vect\>>>.

      \;

      <item>APP: Applications.

      <\equation*>
        <frac|E\<vdash\>e:\<sigma\>\<rightarrow\>\<tau\><space|2fn>E\<vdash\>e<rprime|'>:\<sigma\>|E\<vdash\>e
        e<rprime|'>:\<tau\>>
      </equation*>

      <item>LET: Local bindings.

      <\equation*>
        <frac|E\<vdash\>e<rprime|'>:\<sigma\><space|2fn>E.x:\<b-G\>(\<sigma\>,E)\<vdash\>e:\<tau\>|E\<vdash\>(let
        x=e<rprime|'> in e):\<tau\>>
      </equation*>

      <item>CASE: Deconstruction

      <\equation*>
        <frac|E\<vdash\>e<rprime|'>:d<rsup|<wide|s|^>><wide|\<tau\>|\<vect\>><space|2fn>E\<vdash\>e<rsub|i>:Inst<rsub|c<rsub|i>><rsup|s><wide|\<tau\>|\<vect\>>\<rightarrow\>\<theta\>
        (1\<leqslant\>i\<leqslant\>n)|E\<vdash\>case e<rprime|'> of
        {c<rsub|1>\<Rightarrow\>e<rsub|1>\|\<ldots\>\|c<rsub|n>\<Rightarrow\>e<rsub|n>}:\<theta\>><with|mode|text|
        je±li >\<b-C\>(d)={c<rsub|1>,\<ldots\>,c<rsub|n>}
      </equation*>

      <item>Zamiast reguªy: CONS: Constructor

      <\equation*>
        <frac||E\<vdash\>c:Inst<rsub|c><rsup|s><wide|\<tau\>|\<vect\>>\<rightarrow\>d<rsup|<wide|s|^>><wide|\<tau\>|\<vect\>>><with|mode|text|
        je±li >c\<in\>\<b-C\>(d)
      </equation*>

      wprowadzamy zaªo»enie na temat ±rodowiska <with|mode|math|E>:

      <\equation*>
        \<forall\>d\<forall\>c\<in\>\<b-C\>(d) <with|mode|text| niech
        >c:\<forall\>\<alpha\><rsub|1>\<ldots\>\<alpha\><rsub|n>\<iota\>.Inst<rsub|c><rsup|\<iota\>><wide|\<alpha\>|\<vect\>>\<rightarrow\>d<rsup|<wide|\<iota\>|^>><wide|\<alpha\>|\<vect\>>\<in\>E,<with|mode|text|
        gdzie >n<with|mode|text| jest arno±ci¡ >d
      </equation*>
    </enumerate>
  </definition>

  Aby opracowa¢ algorytm generowania termów <with|mode|math|\<cal-C\>> dla
  <with|mode|math|\<lambda\><wide||^>>, potrzebujemy mechanizmu szukaj¡cego
  mo»liwo±ci zaj±cia relacji podtypowania, tak jak unifikacja jest ü
  mechanizmem szukania konkretyzacji. Odpowiedni algorytm nazwiemy
  <with|mode|math|\<b-U\><rsub|\<sqsubseteq\>>>. Zachodzi
  <with|mode|math|U=\<b-U\><rsub|\<sqsubseteq\>>(\<tau\>,\<sigma\>)>, je±li
  <with|mode|math|U\<tau\>\<sqsubseteq\>U\<sigma\>>, przy czym
  <with|mode|math|U> jest podstawieniem zarówno pod zmienne typu, jak i pod
  zmienne etapu.

  <\definition>
    <label|algC><with|mode|math|\<cal-C\>(E,\<tau\>,V,<wide|w|\<vect\>>)=(T,e,V<rprime|'>,<wide|w|\<vect\>><rprime|'>)>,
    gdzie dla <with|mode|math|(w<rsub|1 >mod 4)> równego

    <\enumerate>
      <item>VAR: Variables. Dla <with|mode|math|E(w<rsub|2> mod
      <wide|E|\<bar\>>)=x:\<forall\>\<alpha\><rsub|1>\<ldots\>\<alpha\><rsub|n>.\<sigma\>>
      niech

      <\eqnarray*>
        <tformat|<table|<row|<cell|U>|<cell|=>|<cell|\<b-U\><rsub|\<sqsubseteq\>>(\<tau\>,[\<beta\><rsub|1>/\<alpha\><rsub|1>]\<ldots\>[\<beta\><rsub|n>/\<alpha\><rsub|n>]\<sigma\>)>>|<row|<cell|V>|<cell|=>|<cell|{\<beta\><rsub|i>\|1\<leqslant\>i\<leqslant\>n}<wide|\<cup\>|\<dot\>>V<rprime|'>>>|<row|<cell|e>|<cell|=>|<cell|x>>|<row|<cell|T>|<cell|=>|<cell|U>>|<row|<cell|w<rprime|'><rsub|i>>|<cell|=>|<cell|w<rsub|i+2>>>>>
      </eqnarray*>

      Je±li unifikator nie istnieje, <with|mode|math|\<cal-C\>> jest
      nieokre±lone.

      <item>ABS: Abstractions. Je±li <with|mode|math|\<tau\>=\<sigma\>\<rightarrow\>\<rho\>>,
      niech

      <\eqnarray*>
        <tformat|<table|<row|<cell|(R,e<rsub|1>,V<rprime|'>,<wide|w|\<vect\>><rsub|1>)>|<cell|=>|<cell|\<cal-C\>(E.x:\<sigma\>,\<rho\>,V,(w<rsub|i+1>))>>|<row|<cell|T>|<cell|=>|<cell|R>>|<row|<cell|e>|<cell|=>|<cell|\<lambda\>x.e<rsub|1>>>|<row|<cell|<wide|w|\<vect\>><rprime|'>>|<cell|=>|<cell|<wide|w|\<vect\>><rsub|1>>>>>
      </eqnarray*>

      gdzie <with|mode|math|f,x> s¡ nowymi zmiennymi. Je±li
      <with|mode|math|\<tau\>=\<alpha\>>, gdzie <with|mode|math|\<alpha\>>
      jest zmienn¡ typu, dla <with|mode|math|\<beta\><rsub|1>,\<beta\>\<in\>V>
      niech

      <\eqnarray*>
        <tformat|<table|<row|<cell|R>|<cell|=>|<cell|[\<beta\><rsub|1>\<rightarrow\>\<beta\>/\<alpha\>]>>|<row|<cell|(S,e<rsub|1>,V<rprime|'>,<wide|w|\<vect\>><rsub|1>)>|<cell|=>|<cell|\<cal-C\>(R*E.x:\<beta\><rsub|1>,\<beta\>,V\<setminus\>{\<beta\><rsub|1>,\<beta\>},(w<rsub|i+1>))>>|<row|<cell|T>|<cell|=>|<cell|S*R>>|<row|<cell|e>|<cell|=>|<cell|\<lambda\>x.e<rsub|1>>>>>
      </eqnarray*>

      gdzie <with|mode|math|f,x> s¡ nowymi zmiennymi. Je±li
      <with|mode|math|\<tau\>> ma inn¡ posta¢, <with|mode|math|\<cal-C\>>
      jest nieokre±lone.

      <item>FIX: Functions. Je±li <with|mode|math|\<tau\>=d<rsup|s><wide|\<sigma\>|\<vect\>>\<rightarrow\>\<theta\>>,
      niech <with|mode|math|\<kappa\>> dowolne takie, »e
      <with|mode|math|[s/\<iota\>]\<kappa\>=\<theta\>>, oraz

      <\eqnarray*>
        <tformat|<table|<row|<cell|(R,e<rsub|1>,V<rprime|'>,<wide|w|\<vect\>><rsub|1>)>|<cell|=>|<cell|\<cal-C\>(E.f:d<rsup|\<iota\>><wide|\<sigma\>|\<vect\>>\<rightarrow\>\<kappa\>.x:d<rsup|<wide|\<iota\>|^>><wide|\<sigma\>|\<vect\>>,[<wide|\<iota\>|^>/\<iota\>]\<kappa\>,V,(w<rsub|i+1>))>>|<row|<cell|T>|<cell|=>|<cell|R>>|<row|<cell|e>|<cell|=>|<cell|fix
        f x.e<rsub|1>>>|<row|<cell|<wide|w|\<vect\>><rprime|'>>|<cell|=>|<cell|<wide|w|\<vect\>><rsub|1>>>>>
      </eqnarray*>

      gdzie <with|mode|math|f,x> s¡ nowymi zmiennymi. Je±li
      <with|mode|math|\<tau\>=\<alpha\>>, gdzie <with|mode|math|\<alpha\>>
      jest zmienn¡ typu, dla <with|mode|math|\<beta\><rsub|i>,\<beta\><rprime|'>,\<beta\><rprime|''>,\<beta\><rprime|'''>,\<iota\>,\<eta\>\<in\>V>
      niech

      <\eqnarray*>
        <tformat|<table|<row|<cell|R>|<cell|=>|<cell|[d<rsup|\<eta\>><wide|\<beta\>|\<vect\>>\<rightarrow\>\<beta\><rprime|'''>/\<alpha\>]>>|<row|<cell|(S,e<rsub|1>,V<rprime|'>,<wide|w|\<vect\>><rsub|1>)>|<cell|=>|<cell|\<cal-C\>(R*E.f:d<rsup|\<iota\>><wide|\<beta\>|\<vect\>>\<rightarrow\>\<beta\><rprime|''>.x:d<rsup|<wide|\<iota\>|^>><wide|\<beta\>|\<vect\>>,\<beta\><rprime|'>,V\<setminus\>{\<beta\><rsub|i>,\<beta\><rprime|'>,\<beta\><rprime|''>,\<beta\><rprime|'''>,\<iota\>,\<eta\>},(w<rsub|i+1>))>>|<row|<cell|U>|<cell|=>|<cell|\<b-U\>([<wide|\<iota\>|^>/\<iota\>]\<beta\><rprime|''>,\<beta\><rprime|'>)>>|<row|<cell|W>|<cell|=>|<cell|\<b-U\>([\<eta\>/\<iota\>]\<beta\><rprime|''>,\<beta\><rprime|'''>)>>|<row|<cell|T>|<cell|=>|<cell|W*U*S*R>>|<row|<cell|e>|<cell|=>|<cell|fix
        f x.e<rsub|1>>>>>
      </eqnarray*>

      gdzie <with|mode|math|f,x> s¡ nowymi zmiennymi. Je±li
      <with|mode|math|\<tau\>> ma inn¡ posta¢, <with|mode|math|\<cal-C\>>
      jest nieokre±lone.

      <item>APP: Applications. Niech dla <with|mode|math|\<beta\>\<in\>V>

      <\eqnarray*>
        <tformat|<table|<row|<cell|(R,f,V<rsub|1>,<wide|w|\<vect\>><rsub|1>)>|<cell|=>|<cell|\<cal-C\>(E,\<beta\>\<rightarrow\>\<tau\>,V\<setminus\>{\<beta\>},(w<rsub|i+1>))>>|<row|<cell|(S,g,V<rprime|'>,<wide|w|\<vect\>><rsub|2>)>|<cell|=>|<cell|\<cal-C\>(R*E,R\<beta\>,V<rsub|1>,<wide|w|\<vect\>><rsub|1>)>>|<row|<cell|T>|<cell|=>|<cell|S*R>>|<row|<cell|e>|<cell|=>|<cell|f
        g>>|<row|<cell|<wide|w|\<vect\>><rprime|'>>|<cell|=>|<cell|<wide|w|\<vect\>><rsub|2>>>>>
      </eqnarray*>

      <item>LET: Local bindings. Niech dla <with|mode|math|\<beta\>\<in\>V>

      <\eqnarray*>
        <tformat|<table|<row|<cell|(R,f,V<rsub|1>,<wide|w|\<vect\>><rsub|1>)>|<cell|=>|<cell|\<cal-C\>(E,\<beta\>,V\<setminus\>{\<beta\>},(w<rsub|i+1>))>>|<row|<cell|(S,g,V<rprime|'>,<wide|w|\<vect\>><rsub|2>)>|<cell|=>|<cell|\<cal-C\>(R*E.x:\<b-G\>(R\<beta\>,R*E),R\<tau\>,V<rsub|1>,<wide|w|\<vect\>><rsub|1>)>>|<row|<cell|T>|<cell|=>|<cell|S*R>>|<row|<cell|e>|<cell|=>|<cell|let
        x=f in g>>|<row|<cell|<wide|w|\<vect\>><rprime|'>>|<cell|=>|<cell|<wide|w|\<vect\>><rsub|2>>>>>
      </eqnarray*>

      <item>CASE: Deconstruction. Niech <with|mode|math|d> b¦dzie
      <with|mode|math|(w<rsub|i+1> mod D)>-ym typem indukcyjnym, gdzie
      <with|mode|math|D> jest ilo±ci¡ typów indukcyjnych, oraz
      <with|mode|math|k> arno±ci¡ typu <with|mode|math|d>. Niech

      <\eqnarray*>
        <tformat|<table|<row|<cell|V>|<cell|=>|<cell|{\<beta\><rsub|i>\|1\<leqslant\>i\<leqslant\>k}<wide|\<cup\>|\<dot\>>{\<iota\>,\<theta\>}<wide|\<cup\>|\<dot\>>V<rsub|r>>>|<row|<cell|(R,e<rprime|'>,V<rsub|0>,<wide|w|\<vect\>><rsub|0>)>|<cell|=>|<cell|\<cal-C\>(E,d<rsup|<wide|\<iota\>|^>><wide|\<beta\>|\<vect\>>,V<rsub|r>,(w<rsub|i+2>))>>|<row|<cell|(T<rsub|1>,e<rsub|1>,V<rsub|1>,<wide|w|\<vect\>><rsub|1>)>|<cell|=>|<cell|\<cal-C\>(R*E,R*(Inst<rsub|c<rsub|1>><rsup|\<iota\>><wide|\<beta\>|\<vect\>>\<rightarrow\>\<tau\>),V<rsub|0>,<wide|w|\<vect\>><rsub|0>)>>|<row|<cell|\<ldots\>>|<cell|>|<cell|>>|<row|<cell|(T<rsub|n>,e<rsub|n>,V<rsub|n>,<wide|w|\<vect\>><rsub|n>)>|<cell|=>|<cell|\<cal-C\>(T<rsub|n-1>\<ldots\>T<rsub|1>R*E,T<rsub|n-1>\<ldots\>T<rsub|1>R*(Inst<rsub|c<rsub|n>><rsup|\<iota\>><wide|\<beta\>|\<vect\>>\<rightarrow\>\<tau\>),V<rsub|n-1>,<wide|w|\<vect\>><rsub|n-1>)>>|<row|<cell|T
        >|<cell|=>|<cell|T<rsub|n>\<ldots\>T<rsub|1>R>>|<row|<cell|e>|<cell|=>|<cell|case
        e<rprime|'> of {c<rsub|1>\<Rightarrow\>e<rsub|1>\|\<ldots\>\|c<rsub|n>\<Rightarrow\>e<rsub|n>}>>|<row|<cell|V<rprime|'>>|<cell|=>|<cell|V<rsub|n>>>|<row|<cell|<wide|w|\<vect\>><rprime|'>>|<cell|=>|<cell|<wide|w|\<vect\>><rsub|n>>>>>
      </eqnarray*>
    </enumerate>
  </definition>

  Uwagi: zmienna etapu <with|mode|math|\<iota\>>, podobnie jak parametry typu
  <with|mode|math|<wide|\<beta\>|\<vect\>>>, w regule (CASE) i (FIX), s¡
  zmiennymi wolnymi, które mog¡ zunifikowa¢, ``dowiaduj¡c si¦'' (np. od typu
  <with|mode|math|\<tau\>> w przypadku (CASE)) jaki etap b¡d¹ typ jest
  potrzebny.

  <subsubsection|Unifikacja z podtypowaniem
  <with|mode|math|\<b-U\><rsub|\<sqsubseteq\>>>.>

  Potrzebujemy najogólniejszego unifikatora, w nast¦puj¡cym sensie: je±li
  <with|mode|math|U=\<b-U\><rsub|\<sqsubseteq\>>(\<tau\>,\<sigma\>)>, to
  <with|mode|math|U\<tau\>\<sqsubseteq\>U\<sigma\>>, oraz je±li
  <with|mode|math|V\<tau\>\<sqsubseteq\>V\<sigma\>>, to
  <with|mode|math|V\<tau\>\<sqsubseteq\>U\<tau\>> oraz
  <with|mode|math|U\<sigma\>\<sqsubseteq\>V\<sigma\>>. Odpowiednio, je±li
  <with|mode|math|U=\<b-U\><rsub|st>(r,s)>, to
  <with|mode|math|U*r\<preccurlyeq\>U*s> oraz je±li
  <with|mode|math|V*r\<preccurlyeq\>V*s>, to
  <with|mode|math|V*r\<preccurlyeq\>U*r> oraz
  <with|mode|math|U*s\<preccurlyeq\>V*s>.

  Najpierw porównajmy etapy.

  <\definition>
    <with|mode|math|\<b-U\><rsub|st>(r,s)=> dopasuj <with|mode|math|r,s>
    dobieraj¡c pierwszy pasuj¡cy przypadek

    <\enumerate>
      <item><with|mode|math|#,\<infty\>>: zwró¢ <with|mode|math|[]> (reguªa
      INFTY)

      <item><with|mode|math|<wide|r|^>,<wide|s|^>>: zwró¢
      <with|mode|math|\<b-U\><rsub|st>(r,s)>

      <item><with|mode|math|r,<wide|s|^>>: zwró¢
      <with|mode|math|\<b-U\><rsub|st>(r,s)> (reguªa HAT)

      <item><with|mode|math|\<iota\>,#>, gdzie <with|mode|math|\<iota\>> jest
      zmienn¡ etapu: zwró¢ <with|mode|math|[s/\<iota\>]> (<with|mode|math|s>
      jest zmienn¡ lub staª¡ etapu)

      <item><with|mode|math|#,\<iota\>>, gdzie <with|mode|math|\<iota\>> jest
      zmienn¡ etapu: je±li <with|mode|math|\<iota\>> nie wyst¦puje w
      <with|mode|math|r>, zwró¢ <with|mode|math|[r/\<iota\>]>
    </enumerate>
  </definition>

  <\definition>
    <with|mode|math|\<b-U\>(\<tau\>,\<sigma\>)=> dopasuj
    <with|mode|math|\<tau\>,\<sigma\>>

    <\enumerate>
      <item><with|mode|math|\<alpha\><rsub|>,#> i <with|mode|math|\<alpha\>>
      jest zmienn¡ typu: je±li <with|mode|math|\<alpha\>> nie wyst¦puje w
      <with|mode|math|\<sigma\>>, zwró¢ <with|mode|math|[\<sigma\>/\<alpha\>]>

      <item><with|mode|math|#,\<alpha\>> i <with|mode|math|\<alpha\>> jest
      zmienn¡ typu: je±li <with|mode|math|\<alpha\>> nie wyst¦puje w
      <with|mode|math|\<tau\>>, zwró¢ <with|mode|math|[\<tau\>/\<alpha\>]>

      <item><with|mode|math|\<alpha\>,\<alpha\>>: zwró¢ <with|mode|math|[]>

      <item><with|mode|math|\<tau\><rsub|1>\<rightarrow\>\<tau\><rsub|2>,\<sigma\><rsub|1>\<rightarrow\>\<sigma\><rsub|2>>:
      niech <with|mode|math|U<rsub|1>=\<b-U\>(\<tau\><rsub|2>,\<sigma\><rsub|2>)>,
      zwró¢ <with|mode|math|\<b-U\>(U<rsub|1>\<sigma\><rsub|1>,U<rsub|1>\<tau\><rsub|1>)>

      <item><with|mode|math|d<rsup|r><wide|\<tau\>|\<vect\>>,d<rsup|s><wide|\<sigma\>|\<vect\>>>:
      niech

      <\eqnarray*>
        <tformat|<table|<row|<cell|U<rsub|0>>|<cell|=>|<cell|\<b-U\><rsub|st>(r,s)>>|<row|<cell|U<rsub|1>>|<cell|=>|<cell|\<b-U\>(U<rsub|0>\<tau\><rsub|1>,U<rsub|0>\<sigma\><rsub|1>)>>|<row|<cell|\<ldots\>>|<cell|>|<cell|>>|<row|<cell|U<rsub|#<wide|\<tau\>|\<vect\>>>>|<cell|=>|<cell|U<rsub|#<wide|\<tau\>|\<vect\>>>(U<rsub|0>\<ldots\>U<rsub|#<wide|\<tau\>|\<vect\>>-1>\<tau\><rsub|#<wide|\<tau\>|\<vect\>>>,U<rsub|0>\<ldots\>U<rsub|#<wide|\<tau\>|\<vect\>>-1>\<sigma\><rsub|#<wide|\<tau\>|\<vect\>>>)>>>>
      </eqnarray*>
    </enumerate>
  </definition>

  <new-page>

  \;

  <section|Generowanie: mechanizmy do zastosowania.>

  Wykonamy krok wstecz od j¦zyka ML z poprzedniego paragrafu, pomijaj¡c
  dekonstrukcj¦ (<with|mode|math|case>), definicje rekurencyjne i lokalne,
  aby do generowania termów wykorzysta¢ doskonaª¡ maszyneri¦, opracowan¡ dla
  j¦zyka Prolog. Przy okazji poczynimy krok w kierunku j¦zyka HMG(X),
  wprowadzaj¡c typy indukcyjne z wi¦zami unifikacyjnymi.

  <subsection|System typów z typami indukcyjnymi z wi¦zami unifikacyjnymi.>

  Modyfikacja, daj¡ca system typów z typami indukcyjnymi z wi¦zami
  unifikacyjnymi, dotyczy reguª CASE i CONS. Jednak, aby móc zastosowa¢
  mechanizm z korzy±ci¡ dla cho¢by najprostszych funkcji rekurencyjnych,
  potrzebna jest rekurencja polimorficzna.

  <\definition>
    <label|construnif>Reguªy typowania dla typów indukcyjnych z wi¦zami
    unifikacyjnymi:

    <\enumerate-numeric>
      <item>VAR: Variables...

      <item>ABS: <with|mode|math|\<lambda\>>-abstractions...

      <item>APP: Applications...

      <item>LETREC: Polymorphic Recursion.

      <\equation*>
        <frac|E.x:\<rho\>\<vdash\>e<rprime|'>:\<sigma\><space|2fn>\<rho\>=\<b-G\>(\<sigma\>,E)<space|2fn>E.x:\<rho\>\<vdash\>e:\<tau\>|E\<vdash\>(letrec
        x=e<rprime|'> in e):\<tau\>>
      </equation*>

      <item>CASE: Deconstruction

      <\equation*>
        <frac|E\<vdash\>e<rprime|'>:d<wide|\<tau\>|\<vect\>><space|2fn>T<rsub|i>E\<vdash\>e<rsub|i>:T<rsub|i>Inst<rsub|c<rsub|i>><wide|\<alpha\><rsub|>|\<vect\>><rsub|i>\<rightarrow\>T<rsub|i>\<theta\>
        (1\<leqslant\>i\<leqslant\>n)|E\<vdash\>case e<rprime|'> of
        {c<rsub|1>\<Rightarrow\>e<rsub|1>\|\<ldots\>\|c<rsub|n>\<Rightarrow\>e<rsub|n>}:\<theta\>><with|mode|text|
        je±li >\<b-C\>(d)={c<rsub|1>,\<ldots\>,c<rsub|n>}
      </equation*>

      gdzie <with|mode|math|T<rsub|i>=\<b-U\>(<wide|\<tau\>|\<vect\>>,Tyargs<rsub|c<rsub|i>><wide|\<alpha\>|\<vect\>><rsub|i>)>,
      dla wszystkich <with|mode|math|1\<leqslant\>i\<leqslant\>n> takich, »e
      <with|mode|math|<wide|\<tau\>|\<vect\>>> i
      <with|mode|math|Tyargs<rsub|c<rsub|i>><wide|\<alpha\>|\<vect\>>>
      unifikuj¡, <with|mode|math|<wide|\<alpha\>|\<vect\>>\<cap\>(\<b-F\>(<wide|\<tau\>|\<vect\>>)\<cup\>\<b-F\>(E)\<cup\>\<b-F\>(\<theta\>))=
      \<varnothing\>> (<with|mode|math|<wide|\<alpha\>|\<vect\>>> s¡ nowymi
      zmiennymi). Pozostaªe <with|mode|math|T<rsub|i>> s¡ dowolne.

      <item>CONS: Constructor

      <\equation*>
        <frac||E\<vdash\>c:Inst<rsub|c><wide|\<sigma\>|\<vect\>>\<rightarrow\>d(Tyargs<rsub|c><wide|\<sigma\>|\<vect\>>)><with|mode|text|
        je±li >c\<in\>\<b-C\>(d)
      </equation*>

      odpowiednio zaªo»enie na temat ±rodowiska <with|mode|math|E>:

      <\equation*>
        (\<forall\>d)(\<forall\>c\<in\>\<b-C\>(d)) <with|mode|text| niech
        >c:\<forall\><wide|\<alpha\>|\<vect\>>.Inst<rsub|c><wide|\<alpha\>|\<vect\>>\<rightarrow\>d(Tyargs<rsub|c><wide|\<alpha\>|\<vect\>>)\<in\>E,<with|mode|text|
        gdzie >#<wide|\<alpha\>|\<vect\>><with|mode|text| jest arno±ci¡ >d
      </equation*>
    </enumerate-numeric>

    gdzie <with|mode|math|\<b-C\>(d)> jest zbiorem konstruktorów typu
    <with|mode|math|d>, <with|mode|math|Tyargs<rsub|c><wide|\<sigma\>|\<vect\>>><with|mode|math|>
    jest wektorem argumentów typu zadanym przez konstruktor
    <with|mode|math|c> przy parametrach <with|mode|math|<wide|\<sigma\>|\<vect\>>>,
    <with|mode|math|Inst<rsub|c><wide|\<sigma\>|\<vect\>>> jest wektorem
    typów argumentów konstruktora <with|mode|math|c> dla parametrów
    <with|mode|math|<wide|\<sigma\>|\<vect\>>>, oraz
    <with|mode|math|Tyargs<rsub|c><wide|\<sigma\>|\<vect\>>=[<wide|\<sigma\>|\<vect\>>/<wide|\<alpha\>|\<vect\>>]<with|mode|text|<with|mode|math|Tyargs<rsub|c><wide|\<alpha\>|\<vect\>>>>>,
    <with|mode|math|Inst<rsub|c><wide|\<sigma\>|\<vect\>>=[<wide|\<sigma\>|\<vect\>>/<wide|\<alpha\>|\<vect\>>]<with|mode|text|<with|mode|math|Inst<rsub|c><wide|\<alpha\>|\<vect\>>>>>.
  </definition>

  Gaª¦zie <with|mode|math|case>, dla których unifikator nie istnieje, s¡ tzw.
  martwym kodem, nie osi¡galnym podczas wykonania programu.
  <with|mode|math|T<rsub|i>> komunikuje typowi <with|mode|math|\<theta\>>
  dokonany wybór. Przedstawiony system, je±li pomin¡¢ fakt, »e u»ywamy
  prostej analizy przez przypadki zamiast peªnego dopasowywania wzorca,
  odpowiada minimalnej wersji <with|mode|math|HMG>, obejmowanej przez
  <with|mode|math|HMG(X)> dla wszystkich j¦zyków wi¦zów <with|mode|math|X>.

  <\example>
    Zobaczmy definicj¦ typu lista z parametrem oznaczaj¡cym dªugo±¢.

    <\eqnarray*>
      <tformat|<table|<row|<cell|Nil>|<cell|:>|<cell|\<forall\>\<alpha\>.list(\<alpha\>,0)>>|<row|<cell|Cons>|<cell|:>|<cell|\<forall\>\<alpha\>\<beta\>.\<alpha\>\<rightarrow\>list(\<alpha\>,\<beta\>)\<rightarrow\>list(\<alpha\>,1+\<beta\>)>>>>
    </eqnarray*>
  </example>

  <subsubsection|Generowanie <with|mode|math|\<eta\>>-dªugich
  <with|mode|math|\<beta\>>-normalnych polimorficznych
  <with|mode|math|\<lambda\>>-termów: Prolog.><label|prolog>

  Niestety, ''czysty'' prolog odpowiada generowaniu termów tylko dla j¦zyków
  pierwszego rz¦du (nie myli¢ z systemami typów pierwszego rz¦du; nawet
  system przedstawiony powy»ej jest pierwszego rz¦du: pod zmienne typu nie
  mo»na podstawia¢ skwantyfikowanych typów, czyli schematów typu).
  Podstawowym krokiem, który trzeba podj¡¢, jest przej±cie od klauzul
  hornowskich, ''definite clauses'' (<with|mode|math|a\<rightarrow\>b\<rightarrow\>\<ldots\>\<rightarrow\>c>,
  gdzie <with|mode|math|a,b,\<ldots\>,c> s¡ atomowe) do dowolnych wyra»e«
  implikacyjnych (czyli zawieraj¡cych <with|mode|math|\<rightarrow\>> jako
  jedyny spójnik logiczny). System typów, dla którego generowanie termów
  <with|mode|math|\<eta\>>-dªugich <with|mode|math|\<beta\>>-normalnych mo»na
  osi¡gn¡¢ dostosowuj¡c metod¦ SLD-rezolucji, to:

  <\definition>
    Reguªy typowania dla polimorficznych <with|mode|math|\<lambda\>>-termów:

    <\enumerate-numeric>
      <item>VAR: Variables.

      <\equation*>
        <frac|E(x)=\<forall\><wide|\<alpha\>|\<vect\>>.\<tau\>|E\<vdash\>x:[<wide|\<sigma\>|\<vect\>>/<wide|\<alpha\>|\<vect\>>]\<tau\>>
      </equation*>

      <item>ABS: <with|mode|math|\<lambda\>>-abstractions.

      <\equation*>
        <frac|E.x:\<sigma\>\<vdash\>e:\<tau\>|E\<vdash\>\<lambda\>x.e:\<sigma\>\<rightarrow\>\<tau\>>
      </equation*>

      <item>APP: Applications.

      <\equation*>
        <frac|E\<vdash\>e:\<sigma\>\<rightarrow\>\<tau\><space|2fn>E\<vdash\>e<rprime|'>:\<sigma\>|E\<vdash\>e
        e<rprime|'>:\<tau\>>
      </equation*>

      <item>CONS: Constructor

      <\equation*>
        <frac|c\<in\>\<b-C\>(d)|E\<vdash\>c:Inst<rsub|c><wide|\<sigma\>|\<vect\>>\<rightarrow\>d(Tyargs<rsub|c><wide|\<sigma\>|\<vect\>>)>
      </equation*>

      odpowiednio zaªo»enie na temat ±rodowiska <with|mode|math|E>:

      <\equation*>
        (\<forall\>d)(\<forall\>c\<in\>\<b-C\>(d)) <with|mode|text| niech
        >c:\<forall\><wide|\<alpha\>|\<vect\>>.Inst<rsub|c><wide|\<alpha\>|\<vect\>>\<rightarrow\>d(Tyargs<rsub|c><wide|\<alpha\>|\<vect\>>)\<in\>E,<with|mode|text|
        gdzie >#<wide|\<alpha\>|\<vect\>><with|mode|text| jest arno±ci¡ >d
      </equation*>
    </enumerate-numeric>

    przy oznaczeniach jak powy»ej.
  </definition>

  <subsubsection|W stron¦ peªnego <with|mode|math|HMG(X)>.>

  Definicje lokalne nie wpªywaj¡ na logik¦, a jedynie pozwalaj¡ wielokrotnie
  wykorzystywa¢ wyniki po±rednie przeszukiwania.

  Definicje rekurencyjne w postaci nieograniczonej s¡ paradoksalne:
  rozszerzaj¡ zbiór aksjomatów o faªszywy schemat zdaniowy
  <with|mode|math|(X\<rightarrow\>X)\<rightarrow\>X>. (Dlatego w GP system
  typów powinien by¢ rozszerzony by wymusza¢ wªasno±¢ stopu.) W przypadku
  rekurencji ``zwykªej'' zmienne wolne s¡ skwantyfikowane wspólnie:
  <with|mode|math|\<forall\>((X\<rightarrow\>X)\<rightarrow\>X)>, a w
  przypadku rekurencji polimorficznej s¡ skwantyfikowane niezale»nie:
  <with|mode|math|\<forall\>((\<forall\>(X)\<rightarrow\>X)\<rightarrow\>X)>.

  Dekonstrukcja (analiza przez przypadki) z punktu widzenia logiki jest
  eliminacj¡ spójnika ''lub'', a nast¦pnie eliminacj¡ kwantyfikatora
  egzystencjalnego w ka»dym dysjunkcie. Jej wprowadzenie odpowiada
  wprowadzeniu aksjomatów:

  <\equation*>
    (\<exists\><wide|\<sigma\>|\<vect\>>.d(Tyargs<rsub|c<rsub|1>><wide|\<sigma\>|\<vect\>>)\<rightarrow\><big|wedge>Inst<rsub|c<rsub|1>><wide|\<sigma\>|\<vect\>>)\<vee\>\<ldots\>\<vee\>(\<exists\><wide|\<sigma\>|\<vect\>>.d(Tyargs<rsub|c<rsub|n>><wide|\<sigma\>|\<vect\>>)\<rightarrow\><big|wedge>Inst<rsub|c<rsub|n>><wide|\<sigma\>|\<vect\>>)
  </equation*>

  gdzie <with|mode|math|\<b-C\>(d)={c<rsub|1>,\<ldots\>,c<rsub|n>}>. Z punktu
  widzenia przeszukiwania wprowadzenie definicji lokalnej odpowiada
  rozgaª¦zieniu si¦ ze wzgl¦du na mo»liwe warto±ci pewnych zmiennych wolnych
  w <with|mode|math|d<wide|\<tau\>|\<vect\>>>: w ró»nych gaª¦ziach zmienne te
  konkretyzuj¡ si¦ (niezale»nie), a (pomimo to) w wej±ciowym
  <with|mode|math|d<wide|\<tau\>|\<vect\>>> pozostaj¡ nieskonkretyzowane
  (porównaj reguª¦ (CASE) z definicji <reference|construnif>, warunek na
  podstawienia unifikuj¡ce). Nast¦pnie pozyskiwana jest informacja
  specyficzna dla danego kostruktora.

  <subsection|Programy bez nieu»ytecznych definicji lokalnych.>

  Odpowiedni mechanizm definicji lokalnych, wªa±ciwie wspóªpracuj¡cy z
  operatorem mutacji, jest kluczowy dla ponownego wykorzystywania raz
  wyewoluowanego kodu przez programy, bez anga»owania mechanizmów
  rekombinacji. Nieu»ytecznych definicji nie b¦dziemy generowa¢, je±li
  wielokrotne u»ycie kodu b¦dzie si¦ opieraªo na kodzie ju» wygenerowanym w
  jakim± celu.

  Do±¢ radykalne rozwi¡zanie wspieraj¡ce ``code reuse'' polega¢ mo»e na
  dodawaniu, dla ka»dego skonstruowanego podtermu, odpowiadaj¡cej mu zmiennej
  do ±rodowiska. W momencie, gdy z podtermu ``uciekaj¡'' zmienne wolne (np.
  wychodzimy poza odpowiedni¡ <with|mode|math|\<lambda\>>-abstrakcj¦), typ
  zmiennej jest wzgl¦dem ich typów ``podnoszony'' i je±li zmienna zostanie
  u»yta, to b¦dzie zaaplikowana do warto±ci zast¦puj¡cej zmienne, które
  ``uciekªy''. Caªy mechanizm jednak trudno zintegrowa¢ z polimorficznym
  systemem typów, »eby typy zmiennych byªy mo»liwie ogólne.

  <chapter|Rekombinacja i generalizacja><label|rekombinacja>

  <section|Rekombinacja swobodna.>

  Niech <with|mode|math|Dom(E<rsub|0>)\<subseteq\>Dom(E<rsub|1>)> i
  <with|mode|math|Dom(E<rsub|0>)\<subseteq\>Dom(E<rsub|2>)> oraz istniej¡
  <with|mode|math|T<rsub|1>,T<rsub|2>>, »e
  <with|mode|math|T<rsub|1>E<rsub|0>=E<rsub|1>\|<rsub|Dom(E<rsub|0>)>> i
  <with|mode|math|T<rsub|2>E<rsub|0>=E<rsub|2>\|<rsub|Dom(E<rsub|0>)>> oraz
  <with|mode|math|T<rsub|1>E<rsub|0>\<vdash\>e<rsub|0>:\<tau\><rsub|0>>.
  Znajd¹my podtermy <with|mode|math|e<rsub|1>,e<rsub|2>> wprowadzone do
  typizacji rodziców z typizacjami <with|mode|math|E<rsub|1>\<vdash\>e<rsub|1>:\<tau\><rsub|1>>
  oraz <with|mode|math|E<rsub|2>\<vdash\>e<rsub|2>:\<tau\><rsub|2>> (program
  <with|mode|math|e<rsub|0>> -- nadterm <with|mode|math|e<rsub|1>> nazywa si¦
  matk¡, a program-nadterm <with|mode|math|e<rsub|2>> -- ojcem), dla których
  istnieje <with|mode|math|H<rsub|L>*E<rsub|1>(x)=E<rsub|2>(h(x))>, oraz typ
  <with|mode|math|H<rsub|R>\<tau\><rsub|2>=\<tau\><rsub|1>>, przy czym
  <with|mode|math|H<rsub|R>> nie podstawia pod zmienne wyst¦puj¡ce w
  <with|mode|math|E<rsub|2>> (<with|mode|math|Dom(H<rsub|R>)\<cap\>\<b-F\>(E<rsub|2>)=
  \<varnothing\>>). Trójk¦ <with|mode|math|h,H<rsub|L>,H<rsub|R>> nazwiemy
  <with|mode|math|E<rsub|0>>-homomorfizmem typizowa«
  <with|mode|math|E<rsub|1>\<vdash\>e<rsub|1>:\<tau\><rsub|1>> oraz
  <with|mode|math|E<rsub|2>\<vdash\>e<rsub|2>:\<tau\><rsub|2>>. Rekombinacj¡
  swobodn¡ matki <with|mode|math|e<rsub|0>> na pozycji podtermu
  <with|mode|math|e<rsub|1>> z ojcem na pozycji podtermu
  <with|mode|math|e<rsub|2>> nazywamy program
  <with|mode|math|H<rsub|L>*T<rsub|1>E<rsub|0>\<vdash\>[h(e<rsub|2>)/e<rsub|1>]e<rsub|0>:H<rsub|L>\<tau\><rsub|0>>.
  Typizacja ta mo»e by¢ (podobnie, jak w wyniku mutacji) nadokre±lona
  wzgl¦dem ±rodowiska <with|mode|math|E<rsub|0>>; mo»emy wi¦c przeprowadzi¢
  retypizacj¦.

  \;

  <section|Anty-unifikacja drugiego rz<abbr|>¦du -- prosty przypadek.>

  <label|antyunif1rz>

  Przedstawimy w tym podrozdziale anty-unifikacj¦ pierwszego rz¦du w algebrze
  termów odpowiadaj¡cej danemu j¦zykowi rozszerzaj¡cemu
  <with|mode|math|\<lambda\>>-rachunek. Ta anty-unifikacja odpowiada pewnym
  prostym przypadkom anty-unifikacji drugiego rz¦du. Termy algebry termów
  nazywam te» <with|mode|math|\<lambda\>>-strukturami: s¡ to termy, w których
  konstrukcje <with|mode|math|\<lambda\>>-rachunku (czy te» j¦zyków
  rozszerzaj¡cych j¦zyk <with|mode|math|\<lambda\>>-termów) s¡ symbolami
  funkcyjnymi, a staªe i zmienne <with|mode|math|\<lambda\>>-termu s¡
  symbolami staªymi. Jedyna modyfikacja wzgl¦dem sformuªowa« zwykªych algebr
  termów i anty-unifikacji pierwszego rz¦du w nich wi¡»e si¦ z obsªug¡
  <with|mode|math|\<alpha\>>-równowa»no±ci i zmiennych zwi¡zanych.

  Warto porówna¢ niniejsze sformuªowanie z tym zaproponowanym w
  <cite|lu-generalization>. Nasza generalizacja radzi sobie ze zmiennymi
  zwi¡zanymi przez bezpo±redni¡ obsªug¦ kontekstu (i ograniczenie do
  generalizacji ''ground terms''), generalizacja w <cite|lu-generalization>
  przez ``variable freezing'' (eliminacj¦ zmiennych przez podstawienie
  staªych) i zabronienie <with|mode|math|\<lambda\>>-abstrakcji w
  argumentach. Generalizacja w <cite|lu-generalization> czy te» w systemie CC
  jak w pracy Pfenninga <cite|pfenning91unification> jest dodatkowo
  skomplikowana przez wyst¦powanie typów w termach (''explicit
  polymorphism''). Nasze generalizacje s¡ czysto syntaktyczne, w sensie, »e
  nie rozpatruj¡ typów termów. Wynika to z zaªo»enia stosowania systemów
  typów bez annotacji typami w termach; caªy ci¦»ar spada oczywi±cie na
  dowody zgodno±ci z odpowiednim systemem typów.

  W kwestii skierowania porz¡dku, ``co kraj to obyczaj''. W pracy
  <cite|hasker95> generalizacj¦ oznacza si¦ <with|mode|math|\<sqcap\>>, a w
  pracach <cite|pfenning91unification> oraz <cite|lu-generalization> przez
  <with|mode|math|\<sqcup\>>.

  <subsection|Definicja.><label|firstord>

  Zamiast formalnej definicji <with|mode|math|\<lambda\>>-struktur przykªad:
  programowi

  <\equation*>
    fix f x.case x of {Nil\<Rightarrow\>0; Cons \<Rightarrow\>
    \<lambda\>y.\<lambda\>z.+1 (f z)}
  </equation*>

  odpowiada <with|mode|math|\<lambda\>>-struktura:

  <\equation*>
    fix<rsub|f,x>(case<rsup|list>(x,0,\<lambda\><rsub|y>(\<lambda\><rsub|z>(<with|mode|text|@>(<with|mode|text|@(+,>1),<with|mode|text|@>(f,z))))))
  </equation*>

  Stosujemy adaptacj¦ algorytmu Gerarda Hueta obsªuguj¡c¡ zmienne zwi¡zane
  (kontekst):

  <\definition>
    Anty-unifikacja pierwszego rz¦du <with|mode|math|\<lambda\>>-struktur:

    <\eqnarray*>
      <tformat|<table|<row|<cell|F<rsub|<wide|x|\<vect\>>>(s<rsub|1>,\<ldots\>,s<rsub|n>)\<sqcap\><rsub|<wide|z|\<vect\>>>F<rsub|<wide|y|\<vect\>>>(t<rsub|1>,\<ldots\>,t<rsub|n>)>|<cell|=>|<cell|F<rsub|<wide|u|\<vect\>>>([<wide|u|\<vect\>>/<wide|x|\<vect\>>]s<rsub|1>\<sqcap\><rsub|<wide|z|\<vect\>>.<wide|u|\<vect\>>>[<wide|u|\<vect\>>/<wide|y|\<vect\>>]t<rsub|1>,\<ldots\>,[<wide|u|\<vect\>>/<wide|x|\<vect\>>]s<rsub|n>\<sqcap\><rsub|<wide|z|\<vect\>>.<wide|u|\<vect\>>>[<wide|u|\<vect\>>/<wide|y|\<vect\>>]t<rsub|n>),<space|2fn>F\<in\>\<cal-C\>>>|<row|<cell|s\<sqcap\><rsub|<wide|z|\<vect\>>>s>|<cell|=>|<cell|s>>|<row|<cell|s\<sqcap\><rsub|<wide|z|\<vect\>>>t>|<cell|=>|<cell|\<phi\>([<wide|v|\<vect\>>/<wide|z|\<vect\>>]s,[<wide|v|\<vect\>>/<wide|z|\<vect\>>]t),<space|2fn><with|mode|text|w
      przec. przyp.>>>>>
    </eqnarray*>

    gdzie <with|mode|math|<wide|x|\<vect\>>> i
    <with|mode|math|<wide|y|\<vect\>>> s¡ ci¡gami tej samej dªugo±ci zera lub
    wi¦cej zmiennych zwi¡zanych przez konstrukcj¦ <with|mode|math|F>,
    <with|mode|math|<wide|u|\<vect\>>> jest ci¡giem nowych (nie wyst¦puj¡cych
    w <with|mode|math|<wide|s|\<vect\>>> ani w
    <with|mode|math|<wide|t|\<vect\>>>) zmiennych j¦zyka,
    <with|mode|math|<wide|v|\<vect\>>> jest odcinkiem pocz¡tkowym dªugo±ci
    <with|mode|math|#<wide|z|\<vect\>>> ustalonego ci¡gu zmiennych
    <with|mode|math|v<rsub|1>,v<rsub|2>,\<ldots\>> rozª¡cznego z pozostaªymi
    zmiennymi u»ywanymi przez algorytm. <with|mode|math|\<phi\>> jest
    bijekcj¡ mi¦dzy parami <with|mode|math|\<lambda\>>-struktur modulo
    <with|mode|math|\<alpha\>>-równowa»no±¢ a zbiorem zmiennych
    <with|mode|math|M> (rozª¡cznym ze zmiennymi j¦zyka). Niech

    <\eqnarray*>
      <tformat|<table|<row|<cell|s\<sqcap\>t>|<cell|=>|<cell|s\<sqcap\><rsub|\<epsilon\>>t>>>>
    </eqnarray*>

    gdzie <with|mode|math|\<epsilon\>> jest ci¡giem pustym.
  </definition>

  Dla j¦zyka ML mamy <with|mode|math|\<cal-C\>={<with|mode|text|@>,\<lambda\>,fix,let}\<cup\>{case<rsup|d>}<rsub|d\<in\>D>>
  gdzie <with|mode|math|D> jest zbiorem typów algebraicznych;
  @,<with|mode|math|case<rsup|d>> wi¡»¡ zero zmiennych,
  <with|mode|math|\<lambda\>,let> wi¡»¡ jedn¡ zmienn¡, <with|mode|math|fix>
  wi¡»e dwie zmienne. Dalej uto»samiamy termy j¦zyka i odpowiednie struktury,
  przeksztaªcaj¡c jedne w drugie w miar¦ potrzeby. Oznacza to, »e j¦zyk
  rozszerzamy o tzw. meta-zmienne ze zbioru <with|mode|math|M>. Podstawienie
  <with|mode|math|<wide|v|\<vect\>>> zapewnia, »e podtermy ró»ni¡ce si¦ tylko
  nazwami zmiennych wolnych b¦d¡ uto»samiane.

  <subsection|Wªasno±¢: maksymalnie specyficzna generalizacja.>

  Poka»emy teraz, »e powy»ej zdefiniowana operacja jest maksymalnie
  specyficzn¡ generalizacj¡ (anty-unifikacj¡) dla porz¡dku podstawieniowego.

  Zdefiniujmy teraz podstawienie obsªuguj¡ce kontekst. Pami¦tajmy, »e zwykªe
  podstawienie <with|mode|math|[<wide|t|\<vect\>>/<wide|x|\<vect\>>]s> nie
  podstawia pod zmienne zwi¡zane.

  <\definition>
    <with|mode|math|>Podstawienie obsªuguj¡ce kontekst:

    <\eqnarray*>
      <tformat|<table|<row|<cell|%(T,<wide|x|\<vect\>>;F<rsub|<wide|y|\<vect\>>>(t<rsub|1>,\<ldots\>,t<rsub|n>))>|<cell|=>|<cell|F<rsub|<wide|u|\<vect\>>>(%(T,<wide|x|\<vect\>>.<wide|u|\<vect\>>;[<wide|u|\<vect\>>/<wide|y|\<vect\>>]t<rsub|1>),\<ldots\>,%(T,<wide|x|\<vect\>>.<wide|u|\<vect\>>;[<wide|u|\<vect\>>/<wide|y|\<vect\>>]t<rsub|n>))<space|2fn>F\<in\>\<cal-C\>>>|<row|<cell|%(T,<wide|x|\<vect\>>;Y)>|<cell|=>|<cell|[<wide|x|\<vect\>>/<wide|y|\<vect\>>]s<space|2fn><with|mode|text|je±li
      \ >Y\<in\>M,T(Y)=<wide|y|\<vect\>>;s>>|<row|<cell|%(T,<wide|x|\<vect\>>;s)>|<cell|=>|<cell|s<space|2fn><with|mode|text|w
      przeciwnym przypadku>>>>>
    </eqnarray*>

    gdzie <with|mode|math|<wide|u|\<vect\>>> jest ci¡giem nowych (nie
    wyst¦puj¡cych w <with|mode|math|<wide|t|\<vect\>>>) zmiennych j¦zyka.
  </definition>

  <\definition>
    \;

    <\eqnarray*>
      <tformat|<table|<row|<cell|<wide|x|\<vect\>>;t\<leqslant\><wide|x|\<vect\>>;s>|<cell|\<equiv\>>|<cell|(\<exists\>T)
      %(T,<wide|x|\<vect\>>;t)=<rsub|\<alpha\>>s>>>>
    </eqnarray*>
  </definition>

  Poka»my na rozgrzewk¦

  <\theorem>
    \;

    <\eqnarray*>
      <tformat|<table|<row|<cell|<wide|y|\<vect\>>;r\<sqcap\><rsub|<wide|y|\<vect\>>>s>|<cell|\<leqslant\>>|<cell|<wide|y|\<vect\>>;r>>|<row|<cell|<wide|y|\<vect\>>;r\<sqcap\><rsub|<wide|y|\<vect\>>>s>|<cell|\<leqslant\>>|<cell|<wide|y|\<vect\>>;s>>>>
    </eqnarray*>
  </theorem>

  <\proof>
    Pokazujemy pierwsz¡ nierówno±¢ przez indukcj¦ wzgl¦dem zªo»ono±ci
    <with|mode|math|r> a drug¡ wzgl¦dem zªo»ono±ci <with|mode|math|s>. W
    odpowiednim miejscu algorytmu <with|mode|math|\<sqcap\>>, wystarczy bra¢
    <with|mode|math|T(\<phi\>([<wide|v|\<vect\>>/<wide|z|\<vect\>>]s,[<wide|v|\<vect\>>/<wide|z|\<vect\>>]t))=<wide|v|\<vect\>>;[<wide|v|\<vect\>>/<wide|z|\<vect\>>]s>
    dla pierwszej nierówno±ci i <with|mode|math|T(\<phi\>([<wide|v|\<vect\>>/<wide|z|\<vect\>>]s,[<wide|v|\<vect\>>/<wide|z|\<vect\>>]t))=<wide|v|\<vect\>>;[<wide|v|\<vect\>>/<wide|z|\<vect\>>]t>
    dla drugiej, gdzie <with|mode|math|<wide|z|\<vect\>>,<wide|v|\<vect\>>,s,t>
    jak w algorytmie <with|mode|math|\<sqcap\>>.
  </proof>

  <\theorem>
    \;

    <\eqnarray*>
      <tformat|<table|<row|<cell|(\<forall\><wide|x|\<vect\>>;t)>|<cell|<wide|x|\<vect\>>;t\<leqslant\><wide|x|\<vect\>>;r\<wedge\><wide|x|\<vect\>>;t\<leqslant\><wide|x|\<vect\>>;s>|<cell|\<Rightarrow\><space|0.6spc><wide|x|\<vect\>>;t\<leqslant\><wide|x|\<vect\>>;r\<sqcap\><rsub|<wide|x|\<vect\>>>s>>>>
    </eqnarray*>
  </theorem>

  <\proof>
    Ustalmy <with|mode|math|<wide|x|\<vect\>>;t>. Z zaªo»enia twierdzenia
    mamy podstawienia <with|mode|math|P,Q>:

    <\equation*>
      %(P,<wide|x|\<vect\>>;t)=r,%(Q,<wide|x|\<vect\>>;t)=s
    </equation*>

    . Niech <with|mode|math|P(X<rsub|i>)=<wide|x|\<vect\>><rsup|i>;p<rsub|i>,Q(X<rsub|i>)=<wide|y|\<vect\>><rsup|i>;q<rsub|i>>
    dla <with|mode|math|X<rsub|i>\<in\>Dom(P)=Dom(Q)=\<b-F\>\<b-M\>(t)>.
    Poka»emy, »e <with|mode|math|T(X<rsub|i>)=<wide|u|\<vect\>>;[<wide|u|\<vect\>>/<wide|x|\<vect\>><rsup|i>]p<rsub|i>\<sqcap\><rsub|<wide|u|\<vect\>>>[<wide|u|\<vect\>>/<wide|y|\<vect\>><rsup|i>]q<rsub|i>>
    daje <with|mode|math|%(T,<wide|x|\<vect\>>;t)=r\<sqcap\><rsub|<wide|x|\<vect\>>>s>.
    Przeprowad¹my indukcj¦ wzgl¦dem zªo»ono±ci <with|mode|math|t>, przez
    analiz¦ wyprowadzenia <with|mode|math|r\<sqcap\><rsub|<wide|x|\<vect\>>>s>.

    <\enumerate>
      <item><with|mode|math|t=X<rsub|i>\<in\>M>. Wt\0dy \0
      <with|mode|math|[<wide|x|\<vect\>>/<wide|x|\<vect\>><rsup|i>]p<rsub|i>=r>,
      <with|mode|math|[<wide|x|\<vect\>>/<wide|y|\<vect\>><rsup|i>]q<rsub|i>=s>
      oraz <with|mode|math|T(Y)=<wide|x|\<vect\>>;r\<sqcap\><rsub|<wide|x|\<vect\>>>s>.

      <item><with|mode|math|t=F<rsub|<wide|z|\<vect\>>>(t<rsub|1>,\<ldots\>,t<rsub|n>)>.
      Z zaªo»enia twierdzenia, musi by¢ <with|mode|math|r=F<rsub|<wide|v|\<vect\>>>(r<rsub|1>,\<ldots\>,r<rsub|n>),s=F<rsub|<wide|w|\<vect\>>>(s<rsub|1>,\<ldots\>,s<rsub|n>)>;
      st¡d

      <\eqnarray*>
        <tformat|<table|<row|<cell|r\<sqcap\><rsub|<wide|x|\<vect\>>>s>|<cell|=>|<cell|F<rsub|<wide|u|\<vect\>>>([<wide|u|\<vect\>>/<wide|v|\<vect\>>]r<rsub|1>\<sqcap\><rsub|<wide|x|\<vect\>>.<wide|u|\<vect\>>>[<wide|u|\<vect\>>/<wide|w|\<vect\>>]s<rsub|1>,\<ldots\>,[<wide|u|\<vect\>>/<wide|v|\<vect\>>]r<rsub|n>\<sqcap\><rsub|<wide|x|\<vect\>>.<wide|u|\<vect\>>>[<wide|u|\<vect\>>/<wide|w|\<vect\>>]s<rsub|n>>>>>
      </eqnarray*>

      Poniewa» <with|mode|math|t<rsub|i>\<leqslant\>r<rsub|i>> i
      <with|mode|math|t<rsub|i>\<leqslant\>s<rsub|i>>, co wynika z definicji
      podstawienia <with|mode|math|%> i <with|mode|math|\<alpha\>>-równowa»no±ci,
      z zaª. ind. mamy <with|mode|math|<wide|x|\<vect\>>.<wide|u|\<vect\>>;[<wide|u|\<vect\>>/<wide|z|\<vect\>>]t<rsub|i>\<leqslant\><wide|x|\<vect\>>.<wide|u|\<vect\>>;[<wide|u|\<vect\>>/<wide|v|\<vect\>>]r<rsub|i>\<sqcap\><rsub|<wide|x|\<vect\>>.<wide|u|\<vect\>>>[<wide|u|\<vect\>>/<wide|w|\<vect\>>]s<rsub|i>>.
      St¡d

      <\eqnarray*>
        <tformat|<table|<row|<cell|r\<sqcap\><rsub|<wide|x|\<vect\>>>s>|<cell|=>|<cell|F<rsub|<wide|u|\<vect\>>>(%(T<rsub|1>,<wide|x|\<vect\>>.<wide|u|\<vect\>>;[<wide|u|\<vect\>>/<wide|z|\<vect\>>]t<rsub|1>),\<ldots\>,%(T<rsub|n>,<wide|x|\<vect\>>.<wide|u|\<vect\>>;[<wide|u|\<vect\>>/<wide|z|\<vect\>>]t<rsub|n>))>>>>
      </eqnarray*>

      gdzie <with|mode|math|T<rsub|j>(X<rsub|i>)=<wide|u|\<vect\>>;[<wide|u|\<vect\>>/<wide|x|\<vect\>><rsup|i>]p<rsub|i>\<sqcap\><rsub|<wide|u|\<vect\>>>[<wide|u|\<vect\>>/<wide|y|\<vect\>><rsup|i>]q<rsub|i>=T(X<rsub|i>)>.

      <item><with|mode|math|t=c>. Wtedy musi by¢
      <with|mode|math|r=s=r\<sqcap\>s=c>.
    </enumerate>

    \;
  </proof>

  <subsection|Zgodno±¢ rekombinacji z systemem typów.>

  <\definition>
    Niech dane b¦d¡ programy <with|mode|math|s,t>, oraz
    <with|mode|math|T<rsub|1>E<rsub|0>\<vdash\>s:T<rsub|1>\<tau\><rsub|0>> i
    <with|mode|math|T<rsub|2>E<rsub|0>\<vdash\>t:T<rsub|2>\<tau\><rsub|0>>.
    Rekombinacj¡ nazwiemy program <with|mode|math|r=%(R,\<epsilon\>;s\<sqcap\><rsub|\<epsilon\>>t)>,
    gdzie <with|mode|math|%(S,\<epsilon\>;s\<sqcap\><rsub|\<epsilon\>>t)=s>,
    <with|mode|math|%(T,\<epsilon\>;s\<sqcap\><rsub|\<epsilon\>>t)=t> oraz
    <with|mode|math|R(X<rsub|i>)=S(X<rsub|i>)> lub
    <with|mode|math|R(X<rsub|i>)=T(X<rsub|i>)>. Rekombinacj¦ nazywamy
    poprawn¡, je±li <with|mode|math|T<rsub|3>E<rsub|0>\<vdash\>r:T<rsub|3>\<tau\><rsub|0>>
    dla pewnego <with|mode|math|T<rsub|3>>.
  </definition>

  Zbadajmy teraz, dla jakich podstawie« <with|mode|math|R>,
  <with|mode|math|r=%(R,s\<sqcap\>t)> jest rekombinacj¡ (tzn.
  <with|mode|math|r> jest typizowalny). Otrzymamy w ten sposób algorytm
  rekombinacji. Badanie b¦dzie polegaªo na generalizacji wyprowadze«
  najogólniejszych typów dla <with|mode|math|s> i <with|mode|math|t> w
  ±rodowisku <with|mode|math|E<rsub|0>>.

  Zastosujmy algorytm inferencji typu (prototypem jest algorytm
  <with|mode|math|\<cal-W\>>) do problemu
  <with|mode|math|E<rsub|0>,s\<sqcap\>t>; niech zwraca wyznaczone typy
  meta-zmiennych. Modyfikujemy algorytm tak, »e gdy ma wyznacza¢ typ którego±
  z wyst¡pie« meta-zmiennej <with|mode|math|X<rsub|i>> (w ±rodowisku
  <with|mode|math|E<rsub|1>>), wyznacza typy dla
  <with|mode|math|S(X<rsub|i>)> oraz <with|mode|math|T(X<rsub|i>)> (z
  przemianowanymi zmiennymi kontekstu tak, aby odpowiadaªy zmiennym
  wprowadzonym do <with|mode|math|E<rsub|1>>) w ±rodowisku
  <with|mode|math|E<rsub|1>>. Nast¦pnie generalizuje znalezione typy (zwykªym
  algorytmem anty-unifikacji pierwszego rz¦du). Za zmienne generalizacji
  wstawia nowe konstruktory typu zaaplikowane do listy zmiennych typu: listy
  wszystkich zmiennych wyst¦puj¡cych w podtermach ''ró»nicowych'' (typach z
  podstawie« generalizacji pod t¡ zmienn¡), wynik przekazuje jako znaleziony
  typ. Podobnie, generalizuje typy w zwracanych podstawieniach, i zwraca
  podstawienie z typami ze zmiennymi generalizacji zast¡pionymi przez nowe
  konstruktory. (Nazwijmy te nowe konstruktory zmiennymi generalizacji typu,
  TGV.) Je±li które± z podstawie« generalizacji jest zmienn¡ typu, to
  nazywamy j¡ zmienn¡ projekcyjn¡ tej TGV. Podstawienia generalizacji danej
  TGV nazywamy gaª¦ziami tej zmiennej. Unifikacja TGV z typem polega na
  osobnych unifikacjach gaª¦zi z tym typem, i je±li pojawiaj¡ si¦ w nim TGV,
  na unifikowaniu z odpowiedni¡ gaª¦zi¡ ka»dej TGV. Je±li TGV traci w wyniku
  unifikacji wszystkie zmienne projekcyjne, \ jej gaª¦zie s¡ ponownie
  generalizowane, i je±li znaleziona anty-instancja jest nietrywialna, to
  jest podstawiana pod t¡ TGV.

  Zmienne typu podzielimy na specyficzne, wprowadzone w inferencji typu
  wyst¡pienia meta-zmiennej, i niespecyficzne, pozostaªe. Specyficzne zmienne
  typu b¦d¡ si¦ pojawiaªy tylko w odpowiednich gaª¦ziach ró»nych TGV. Je±li w
  wyniku unifikacji gaª¦zi powstaj¡ podstawienia niespecyficzne, to s¡ one
  ujmowane w TGV, która na pozostaªej gaª¦zi ma (now¡, specyficzn¡) zmienn¡
  projekcyjn¡. St¡d, je±li inna podgaª¡¹ b¦dzie unifikowa¢ do tej zmiennej
  (zast¡pionej przez skonstruowan¡ TGV), to podstawienia zostan¡
  zgeneralizowane, i we wszystkie wyst¡pienia (najpierw zmiennej
  niespecyficznej, nast¦pnie zamienionej na TGV) trafia \ anty-instancja z
  odpowiednimi TGV.

  Je±li TGV jest unifikowana z podgaª¦zi¡ innej TGV, to para tych zmiennych
  jest zapami¦tywana w zbiorze unifikowanych TGV. Je±li nast¦puje
  podstawienie pod TGV, to pary zawieraj¡ce t¡ zmienn¡ w zbiorze
  unifikowanych TGV s¡ zast¦powane przez pary ``zmienna unifikowana do
  podstawianej w zast¦powanej parze'' - ''TGV wyst¦puj¡ce w podstawieniu''. W
  zbiorze unifikowanych TGV uwzgl¦dniamy te» podstawienia pod zwykªe zmienne
  typu, kiedy pewne TGV trac¡ zmienn¡ projekcyjn¡. Je±li zmienna typu zostaje
  skwantyfikowana (zgeneralizowana w sensie polimorfizmu), to w zbiorze
  unifikowanych TGV przestaje ona by¢ zmienn¡ projekcyjn¡.

  Despecyfikacja zmiennych. Po zako«czeniu inferencji, usuwamy TGV której
  obydwie gaª¦zie s¡ zmiennymi specyficznymi (i albo obydwie s¡
  nieskwantyfikowane, albo obydwie s¡ skwantyfikowane), zast¦puj¡c te zmienne
  now¡ zmienn¡ niespecyficzn¡ (nie ograniczon¡ do gaª¦zi odpowiadaj¡cych
  jednemu programowi). Usuwamy te» pary zawieraj¡ce t¡ zmienn¡ ze zbioru
  unifikowanych TGV. (Usuwamy te» wszystkie TGV, które te» miaªy te zmienne
  jako projekcyjne, zgodnie z zasad¡, »e generalizujemy TGV które trac¡ swoje
  zmienne projekcyjne.) Post¦pujemy tak, dopóki s¡ TGV z dwiema specyficznymi
  zmiennymi projekcyjnymi. Jest to krok niedeterministyczny algorytmu: wynik
  zale»y od kolejno±ci wyboru TGV.

  Silna despecyfikacja konkretyzuj¡ca stanowi ostatni¡, opcjonaln¡ faz¦
  algorytmu. Mo»na pozby¢ si¦ jeszcze wi¦kszej ilo±ci TGV, kosztem
  konkretyzacji ``answer substitution''. Usuwamy TGV maj¡c¡ zmienn¡
  projekcyjn¡ (mo»e by¢ niespecyficzna) nie skwantyfikowan¡ (czyli woln¡ w
  caªym typowaniu), podstawiaj¡c pod zmienn¡ projekcyjn¡ pozostaª¡ gaª¡¹ TGV,
  o ile zmienna projekcyjna nie wyst¦puje w tej gaª¦zi. Pami¦tamy, aby doda¢
  to podstawienie do ``answer substitution''. Gdy która± TGV w wyniku starci
  swoje zmienne projekcyjne, generalizujemy gaª¦zie i powtarzamy
  despecyfikacj¦ dla (ewentualnie) powstaªych TGV. Jest to krok
  niedeterministyczny.

  <\lemma>
    Tak zmodyfikowany algorytm ko«czy prac¦ zwracaj¡c pewien typ i
    podstawienie.
  </lemma>

  Nazwijmy dwa wyst¡pienia meta-zmiennych zale»nymi, je±li typ jednego
  zawiera TGV unifikowan¡ z TGV wyst¦puj¡c¡ w typie drugiego (tzn. para tych
  TGV nale»y do zbioru unifikowanych TGV), a silnie zale»nymi, je±li »adna
  TGV z pary nie zawiera zmiennej projekcyjnej.

  <\definition>
    Rekombinacja podstawie« typów: <with|mode|math|T<rsub|3>\<in\>\<b-R\>(T<rsub|1>,T<rsub|2>)>
    je±li

    <\eqnarray*>
      <tformat|<table|<row|<cell|T<rsub|3>\<alpha\>>|<cell|=>|<cell|H(\<tau\>\<sqcap\>\<sigma\>)<space|2fn>\<alpha\>\<in\>Dom(T<rsub|1>)\<cap\>Dom(T<rsub|2>)>>|<row|<cell|\<tau\>=T<rsub|1>\<alpha\>>|<cell|>|<cell|\<sigma\>=T<rsub|2>\<alpha\>>>|<row|<cell|H\<beta\>=T\<beta\>>|<cell|\<vee\>>|<cell|H\<beta\>=S\<beta\><space|2fn>\<beta\>\<in\>\<b-M\>\<b-V\>(\<tau\>\<sqcap\>\<sigma\>)>>|<row|<cell|T(\<tau\>\<sqcap\>\<sigma\>)=\<tau\>>|<cell|>|<cell|S(\<tau\>\<sqcap\>\<sigma\>)=\<sigma\>>>>>
    </eqnarray*>

    gdzie <with|mode|math|\<sqcap\>> jest generalizacj¡ pierwszego rz¦du,
    <with|mode|math|\<b-M\>\<b-V\>> zwraca zmienne wstawione przez
    generalizacj¦.
  </definition>

  <\theorem>
    Rekombinacja, która pod wyst¡pienia zale»ne bez despecyfikacji
    konkretyzuj¡cej podstawia z tego samego podstawienia (rodzica), jest
    poprawna. Je±li <with|mode|math|T<rsub|1>E<rsub|0>\<vdash\>s:T<rsub|1>\<tau\><rsub|0>>
    i <with|mode|math|T<rsub|2>E<rsub|0>\<vdash\>t:T<rsub|2>\<tau\><rsub|0>>,
    to <with|mode|math|T<rsub|3>E<rsub|0>\<vdash\>r:T<rsub|3>\<tau\><rsub|0>>
    i <with|mode|math|T<rsub|3>\<in\>\<b-R\>(T<rsub|1>,T<rsub|2>)>, dodatkowo
    je±li <with|mode|math|T<rsub|1>\<tau\><rsub|0>> i
    <with|mode|math|T<rsub|2>\<tau\><rsub|0>> s¡ pryncypalnymi typami
    <with|mode|math|s> i <with|mode|math|t>, to
    <with|mode|math|T<rsub|3>\<tau\><rsub|0>> jest typem pryncypalnym (ang.
    principal type) programu <with|mode|math|r>. Rekombinacja, która pod
    wyst¡pienia zale»ne po despecyfikacji konkretyzuj¡cej podstawia z tych
    samych podstawie«, jest poprawna. Rekombinacja, która pod wyst¡pienia
    silnie zale»ne podstawia z ró»nych podstawie« (rodziców), nie jest
    poprawna.
  </theorem>

  <\proof>
    (Szkicowe uzasadnienie twierdzenia.)

    <\enumerate>
      <item>Je±li pod TGV podstawimy odpowiednie podstawienia generalizacji,
      ze zmiennymi zast¦pionymi przez argumenty TGV, to uzyskamy przebiegi
      algorytmu odpowiadaj¡ce przebiegom dla rodziców, je±li staniemy przed
      faz¡ despecyfikacji konkretyzuj¡cej. Kolejne genralizacje nie wpªywaj¡
      na odpowiednio±¢ z przebiegiem algorytmu <with|mode|math|\<cal-W\>> dla
      zagadnie« <with|mode|math|E<rsub|0>,r> i <with|mode|math|E<rsub|0>,s>.
      Despecyfikacja zmiennych (niekonkretyzuj¡ca) odpowiada przemianowaniu
      zmiennych nie zmieniaj¡cemu wyprowadzenia (»adne zmienne nie zostaj¡
      uto»samione).

      <item>Ka»da TGV jest zwi¡zana z pewn¡ meta-zmienn¡ w
      <with|mode|math|s\<sqcap\>t>: ka»da TGV powstaje albo w generalizacji
      typizowa« dla podstawie« pod meta-zmienn¡, albo z podstawienia pod
      zmienn¡ niespecyficzn¡ powstaªego przy typizowaniu podstawie« pod
      meta-zmienn¡, wtedy jest zwi¡zana z t¡ meta-zmienn¡, albo z
      generalizacji gaª¦zi innej TGV, wtedy jest zwi¡zana z meta-zmienn¡
      macierzystej TGV.

      <item>Obierzmy pewn¡ rekombinacj¦ <with|mode|math|R>. B¦dziemy
      rekonstruowa¢ typizacj¦ dla rekombinanta
      <with|mode|math|%(R,s\<sqcap\>t)> przez wybieranie tych gaª¦zi TGV,
      które podstawienie (<with|mode|math|S(X)> czy <with|mode|math|T(X)>)
      zostaªo wybrane dla meta-zmiennej <with|mode|math|X> zwi¡zanej z dan¡
      TGV.

      <item>Wyprowadzenie typu z tak podstawionymi TGV odpowiada
      wyprowadzeniu typu dla rekombinanta, o ile ono istnieje: cz¦±¢
      odpowiadaj¡ca <with|mode|math|s\<sqcap\>t> jest wspólna dla wszystkich
      rekombinantów, jako cz¦±¢ odpowiadaj¡c¡ meta-zmiennej
      <with|mode|math|X> zostaªo wybrane pewne wyprowadzenie typu dla tego
      wªa±nie podstawienia <with|mode|math|R(X)>.

      <item>Wyprowadzenie typu dla <with|mode|math|%(R,s\<sqcap\>t)> daje si¦
      zrekonstruowa¢, poniewa» komunikacja wewn¡trz wyprowadzenia nie jest
      zaburzona: je±li pewne dwa typy s¡ unifikowane, to zawieraj¡ TGV albo
      s¡ cz¦±ci¡ gaª¦zi TGV zwi¡zanych z meta-zmiennymi zale»nymi, czyli
      zgodnie z warunkami twierdzenia, <with|mode|math|R> prowadzi do
      wybrania odpowiadaj¡cych sobie gaª¦zi, i na mocy odpowiedniego
      wyprowadzenia dla <with|mode|math|s> albo dla <with|mode|math|t>, typy
      te s¡ unifikowalne.

      <item>W zrekonstruowanej typizacji <with|mode|math|T<rsub|3>\<in\>\<b-R\>(T<rsub|1>,T<rsub|2>)>
      poniewa» algorytm (bez despecyfikacji konkretyzuj¡cej) zwraca
      generalizacj¦ podstawie«. Zrekonstruowany typ jest pryncypalny,
      poniewa» jest wynikiem zwracanym przez algorytm inferencji dla
      rekombinanta.

      <item>Despecyfikacja konkretyzuj¡ca zachowuje poprawno±¢, poniewa»
      podstawia pod zmienne typu wolne w typizacji.

      <item>Krzy»owanie podstawie« silnie zale»nych daje nietypizowalny
      program, poniewa» w (deterministycznym) przebiegu algorytmu inferencji
      napotyka si¦ wtedy na niespeªnialn¡ unifikacj¦ ró»nych gaª¦zi TGV
      zaczynaj¡cych si¦ od staªych (konstruktorów typu).
    </enumerate>
  </proof>

  Zauwa»my, »e algorytm nie uwzgl¦dnia to»samo±ci meta-zmiennych przy ró»nych
  ich wyst¡pieniach w anty-instancji. Dla potrzeb programowania genetycznego
  wydaje si¦ nawet korzystne ograniczenie generalizacji do termów liniowych
  ze wzgl¦du na meta-zmienne; jednocze±nie bardzo by to upro±ciªo algorytm
  generalizacji.

  <subsection|Zwi¡zek z algorytmami z prac <cite|pfenning91unification> i
  <cite|lu-generalization>.>

  Pod wzgl¦dem syntaktycznym zaprezentowany algorytm jest sªabszy od tych ze
  wspomnianych prac przez brak obsªugi permutacji kontekstu, jednak ªatwo go
  rozszerzy¢, aby tak¡ obsªug¦ zapewniaª. Natomiast mocniejszy jest od
  <cite|pfenning91unification> w tym, »e stosuje generalizacj¦ drugiego rz¦du
  z ``subterm restriction'', czyli ograniczeniem do podtermów
  generalizowanych termów (i odró»nieniem zmiennych termu od meta-zmiennych
  generalizacji), a nie ``pattern restriction'', czyli ograniczeniem do
  podtermów które s¡ zmiennymi zwi¡zanymi (obejmowan¡ przez ''subterm
  restriction''). Od <cite|lu-generalization> mocniejszy jest w tym, »e
  pozwala na zmienne zwi¡zane lokalnie, czyli m.in. na
  <with|mode|math|\<lambda\>>-abstrakcje w pozycjach argumentowych. Pokazuje
  to, »e wspomniane algorytmy s¡ syntaktycznie bliskie algorytmom pierwszego
  rz¦du; zasadnicz¡ ró»nic¡ z syntaktycznego punktu widzenia jest obsªuga
  permutacji (tutaj permutacji zmiennych zwi¡zanych, kontekstu).

  Pod wzgl¦dem obsªugi typów algorytm z paragrafu <reference|firstord> jest
  nie do przyj¦cia. Jedynie w przypadku systemów z jawnym polimorfizmem
  (''explicit polymorphism'') (koduj¡cych typy wewn¡trz termów), jak te u»yte
  we wspomnianych pracach, algorytm syntaktyczny mo»e zidentyfikowa¢ typy
  równowa»ne w ró»nych kontekstach. Wªa±nie dlatego opracowali±my algorytm
  ``inferencji typu dla anty-instancji'' na wzór systemów z ``ad-hoc
  polymorphism''. Czy da si¦ ten wynik przenie±¢ na grunt polimorfizmu
  parametrycznego, pozostaje do zbadania.<new-page>

  \;

  <section|Generalizacja drugiego rz¦du i ogólne
  struktury.><label|antyunif2rz>

  Teraz zajmiemy si¦ algorytmem anty-unifikacji ``prawdziwie'' drugiego
  rz¦du.

  <subsection|Generalizacje rekombinatorowe z pracy <cite|hasker95>.>

  W tym paragrafie prezentuj¦ definicje i wybrane fakty z rozdziaªów 5 i 6
  pracy Haskera.

  <subsubsection|Definicje ogólne i algorytm dla termów monadycznych.>

  <\definition>
    Zbiór generalizacji termów <with|mode|math|a,b>

    <\eqnarray*>
      <tformat|<table|<row|<cell|\<b-G\>(a,b)>|<cell|=>|<cell|{<left|langle>\<theta\><rsub|i>:t<rsub|i>\<rightarrow\>a,\<theta\><rsub|i><rprime|'>:t<rsub|i>\<rightarrow\>b<right|rangle>}>>>>
    </eqnarray*>

    Aplikacja podstawienia do generalizacji

    <\eqnarray*>
      <tformat|<table|<row|<cell|\<rho\>:<left|langle>\<theta\>:t\<rightarrow\>a,\<theta\><rprime|'>:t\<rightarrow\>b<right|rangle>\<rightarrow\><left|langle>\<sigma\>:s\<rightarrow\>a,\<sigma\><rprime|'>:s\<rightarrow\>b<right|rangle>>|<cell|\<Leftrightarrow\>>|<cell|\<rho\>(t)=s,\<theta\>=\<rho\>\<circ\>\<sigma\>,\<theta\><rprime|'>=\<rho\>\<circ\>\<sigma\><rprime|'>>>>>
    </eqnarray*>

    Przez <with|mode|math|g<rsub|1>\<rightarrow\>g<rsub|2>> oznaczamy fakt
    <with|mode|math|(\<exists\>\<rho\>)\<rho\>:g<rsub|1>\<rightarrow\>g<rsub|2>>.
  </definition>

  <\definition>
    <with|mode|math|\<Gamma\>=MSG(a,b)> jest zbiorem maksymalnie
    specyficznych generalizacji, je±li

    <\enumerate>
      <item>(Soundness:) <with|mode|math|\<Gamma\>\<subseteq\>\<b-G\>(a,b)>

      <item>(Completeness:) <with|mode|math|(\<forall\>g\<in\>\<b-G\>(a,b))(\<exists\>g<rprime|'>\<in\>\<Gamma\>)
      g\<rightarrow\>g<rprime|'>>

      <item>(Minimality:) <with|mode|math|(\<forall\>g,g<rprime|'>\<in\>\<Gamma\>)g\<rightarrow\>g<rprime|'>\<Rightarrow\>g=g<rprime|'>>

      <item>(Uniqueness:) <with|mode|math|(\<forall\>g\<in\>\<b-G\>(a,b)\<forall\>g<rprime|'>\<in\>\<Gamma\>)<space|0.2spc>\<rho\>:g\<rightarrow\>g<rprime|'>\<wedge\>\<rho\><rprime|'>:g\<rightarrow\>g<rprime|'>\<Rightarrow\>\<rho\>=\<rho\><rprime|'>>
    </enumerate>
  </definition>

  <\definition>
    Niech <with|mode|math|\<b-G\><rprime|'>(a,b)> b¦dzie podzbiorem
    <with|mode|math|\<b-G\>(a,b)> takim, »e je±li
    <with|mode|math|<left|langle>\<theta\><rsub|1>:s\<rightarrow\>a,\<theta\><rsub|2>:s\<rightarrow\>b<right|rangle>\<in\>\<b-G\><rprime|'>(a,b)>
    i <with|mode|math|f\<in\>\<b-F\>(s)>, to
    <with|mode|math|\<theta\><rsub|1>(f)=\<theta\><rsub|2>(f)\<Rightarrow\>\<theta\><rsub|1>(f)=f>.
  </definition>

  <\definition>
    Para zmiennych <with|mode|math|f,g> w termie <with|mode|math|t> jest
    przylegªa (ang. adjacent) je±li <with|mode|math|t> zawiera podterm równy
    <with|mode|math|f*g>.
  </definition>

  <\definition>
    Generalizacja <with|mode|math|<left|langle>\<theta\><rsub|1>:t\<rightarrow\>a<rsub|1>,\<theta\><rsub|2>:t\<rightarrow\>a<rsub|2><right|rangle>>
    jest redundantna, je±li <with|mode|math|f> i <with|mode|math|g> s¡
    przylegªymi zmiennymi wolnymi w <with|mode|math|t> oraz zachodzi jedno z:
    <with|mode|math|\<theta\><rsub|1>(f)\<neq\>f,\<theta\><rsub|2>(f)\<neq\>f,\<theta\><rsub|1>(g)\<neq\>g,\<theta\><rsub|2>(g)\<neq\>g>.
  </definition>

  <\definition>
    <with|mode|math|\<b-C\>\<b-G\>(a,b)>, zbiór skondensowanych
    generalizacji, to podzbiór <with|mode|math|\<b-G\>(a,b)> nie zawieraj¡cy
    generalizacji redundantnych. Zbiór maksymalnie specyficznych
    generalizacji skondensowanych, <with|mode|math|MSC(a,b)>, to zbiór
    maksymalnie specyficznych generalizacji w
    <with|mode|math|\<b-C\>\<b-G\>(a,b)>.
  </definition>

  <\definition>
    Kiedy <with|mode|math|g<rsub|1>\<rightarrow\>g<rsub|2>> w
    <with|mode|math|\<b-C\>\<b-G\>(a,b)>, to mówimy, »e
    <with|mode|math|g<rsub|1>> jest bardziej ogólna (mniej specyficzna) ni»
    <with|mode|math|g<rsub|2>>, <with|mode|math|g<rsub|1>\<geqslant\>g<rsub|2>>.
  </definition>

  Oznaczmy przez

  <\equation*>
    <frac|t,\<theta\><rsub|1>,\<theta\><rsub|2>|t<rprime|'>,\<theta\><rsub|1><rprime|'>,\<theta\><rsub|2><rprime|'>>
  </equation*>

  reguª¦ przeksztaªcania generalizacji <with|mode|math|<left|langle>\<theta\><rsub|1>:t\<rightarrow\>a,\<theta\><rsub|2>:t\<rightarrow\>b<right|rangle>>
  w <with|mode|math|<left|langle>\<theta\><rsub|1><rprime|'>:t<rprime|'>\<rightarrow\>a,\<theta\><rsub|2><rprime|'>:t<rprime|'>\<rightarrow\>b<right|rangle>>,
  gdzie ''mianownik'' jest ±ci±le bardziej specyficzny ni» ''licznik''.

  <\definition>
    ›eby policzy¢ <with|mode|math|MSC(a,b)> zaczynamy z
    <with|mode|math|g<rsub|0>\<in\>\<b-C\>\<b-G\>(a,b)> i stosujemy nast.
    reguªy, a» »adna nie b¦dzie stosowalna:

    <\enumerate>
      <item>(Delete)

      <\equation*>
        <frac|t,\<theta\><rsub|1>\<cup\>{s/f},\<theta\><rsub|2>\<cup\>{s/f}|{s/f}(t),\<theta\><rsub|1>,\<theta\><rsub|2>>
      </equation*>

      <item>(Merge)

      <\equation*>
        <frac|t,\<theta\><rsub|1>\<cup\>{r/f,r/f<rprime|'>},\<theta\><rsub|2>\<cup\>{s/f,s/f<rprime|'>}|{f/f<rprime|'>}(t),\<theta\><rsub|1>\<cup\>{r/f},\<theta\><rsub|2>\<cup\>{s/f}>
      </equation*>

      <item>(Factor)

      <\equation*>
        <frac|t,\<theta\><rsub|1>\<cup\>{r*K*r<rprime|'>/f},\<theta\><rsub|2>\<cup\>{s*K*s<rprime|'>/f}|{h*K*h<rprime|'>/f}(t),\<theta\><rsub|1>\<cup\>{r/h,r<rprime|'>/h<rprime|'>},\<theta\><rsub|2>\<cup\>{s/h,s<rprime|'>/h<rprime|'>}>
      </equation*>
    </enumerate>
  </definition>

  <subsubsection|Relewantne kombinatory i algorytm dla termów poliadycznych.>

  <\definition>
    Kombinatory kartezja«skie:

    <\eqnarray*>
      <tformat|<table|<row|<cell|\<pi\><left|langle>p,p<rprime|'><right|rangle>=p>|<cell|\<pi\><rprime|'><left|langle>p,p<rprime|'><right|rangle>=p<rprime|'>>|<cell|<left|langle>\<pi\>r,\<pi\><rprime|'>r<right|rangle>=r<space|2fn>!<rsub|A>t=!<rsub|B>>>>>
    </eqnarray*>
  </definition>

  Mo»na pokaza¢ <with|mode|math|<left|langle>p,p<rprime|'><right|rangle>r=<left|langle>p*r,p<rprime|'>*r<right|rangle>>.
  <with|mode|math|!<rsub|A>:A\<rightarrow\>u> posyªa argument typu
  <with|mode|math|A> do typu ``unit'', tzn. ignoruje argument.

  Problem dopasowywania (ang. matching) (oraz generalizacji) nie jest dobrze
  okre±lony dla typów produktowych w ogólno±ci; pod jedn¡ zmienn¡ mo»na
  podstawia¢ coraz bardziej zªo»one struktury, a pod drug¡ odpowiednie
  projekcje pozbywaj¡ce si¦ ich. Wybranym ograniczeniem jest ograniczenie
  typów wynikowych funkcji do typów bez produktów. Ale to nie rozwi¡zuje
  jeszcze problemu okre±lono±ci generalizacji, poniewa» projekcje ci¡gle
  pozwalaj¡ ignorowa¢ podtermy anty-instancji. Dlatego wprowadza si¦
  relewantne kombinatory.

  Produkt typów i konstruktor pary oznaczamy przez kropk¦, np.
  <with|mode|math|A\<cdot\>(B\<cdot\>C)\<cong\>(A\<cdot\>B)\<cdot\>C>.

  <\definition>
    Restruktorem nazywamy par¦ dwóch wzorców <with|mode|math|p\<mapsto\>q>,
    gdzie wzorce <with|mode|math|p,q> skªadaj¡ si¦ ze zmiennych
    <with|mode|math|x,y,z,\<ldots\>>, symbolu specjalnego
    <with|mode|math|1<rsub|u>> oraz operatora binarnego
    ``<with|mode|math|\<cdot\>>''. Restruktor nazywamy relewantnym, je±li
    <with|mode|math|p> jest liniowe, ozn. <with|mode|math|linear(p)>, oraz
    <with|mode|math|\<b-F\>(p)=\<b-F\>(q)>, tzn. ka»da zmienna wyst¦puj¡ca w
    restruktorze pojawia si¦ po prawej stronie. Zakªadamy nast¦puj¡ce
    równo±ci mi¦dzy termami (po prawej stronie warunki zachodzenia):

    <\equation*>
      <tabular|<tformat|<cwith|1|-1|1|1|cell-halign|r>|<table|<row|<cell|(s<rsub|1>\<cdot\>s<rsub|2>)(t<rsub|1>\<cdot\>t<rsub|2>)>|<cell|=>|<cell|s<rsub|1>t<rsub|1>\<cdot\>s<rsub|2>t<rsub|2>>|<cell|>>|<row|<cell|\<b-1\><rsub|X>>|<cell|=>|<cell|p\<mapsto\>p>|<cell|p:<rsub|P>X>>|<row|<cell|p\<mapsto\>q>|<cell|=>|<cell|\<sigma\>(p)\<mapsto\>\<sigma\>(q)>|<cell|linear(\<sigma\>(p))>>|<row|<cell|(p\<mapsto\>q)t>|<cell|=>|<cell|\<theta\>(q)(r\<mapsto\>\<sigma\>(q))>|<cell|\<theta\>(p)=t\<wedge\>\<sigma\>(p)=r>>|<row|<cell|(p\<mapsto\>q)(r\<mapsto\>p)>|<cell|=>|<cell|r\<mapsto\>q>|<cell|>>|<row|<cell|(p<rsub|1>\<mapsto\>q<rsub|1>)\<cdot\>(p<rsub|2>\<mapsto\>q<rsub|2>)>|<cell|=>|<cell|p<rsub|1>\<cdot\>p<rsub|2>\<mapsto\>q<rsub|1>\<cdot\>q<rsub|2>>|<cell|linear(p<rsub|1>\<cdot\>p<rsub|2>)>>>>>
    </equation*>
  </definition>

  Powy»ej, <with|mode|math|\<theta\>> jest podstawieniem termów pod zmienne
  wzorca, a <with|mode|math|\<sigma\>> jest podstawieniem wzorców pod zmienne
  wzorca. Przykªadowa interpretacja reguªy czwartej:
  <with|mode|math|\<theta\>> wyªuskuje wyniki <with|mode|math|t> i
  <with|mode|math|\<theta\>(q)> ustawia je we wzorzec <with|mode|math|q>,
  nast¦pnie <with|mode|math|\<sigma\>(q)> porz¡dkuje argumenty wedªug wzorca
  <with|mode|math|q>, »eby je dostarczy¢ <with|mode|math|\<theta\>(q)>; jest
  to mo»liwe, bo argumenty rozdzielaj¡ si¦ wedªug uszczegóªowienia wzorca
  <with|mode|math|p> do funkcji atomowych <with|mode|math|t> (których typ
  wynikowy nie jest produktem).

  Wprowadzamy nast¦puj¡ce skróty:

  <\equation*>
    <tabular|<tformat|<cwith|1|-1|4|4|cell-halign|r>|<table|<row|<cell|<with|mode|text|associate
    left:>>|<cell|\<alpha\><rsub|X,Y,Z>>|<cell|=>|<cell|p\<cdot\>(q\<cdot\>r)>|<cell|\<mapsto\>>|<cell|(p\<cdot\>q)\<cdot\>r>>|<row|<cell|<with|mode|text|associate
    right:>>|<cell|\<alpha\><rsub|X,Y,Z><rsup|-1>>|<cell|=>|<cell|(p\<cdot\>q)\<cdot\>r>|<cell|\<mapsto\>>|<cell|p\<cdot\>(q\<cdot\>r)>>|<row|<cell|<with|mode|text|delete
    left:>>|<cell|\<lambda\><rsub|X>>|<cell|=>|<cell|\<b-1\><rsub|\<b-u\>>\<cdot\>p>|<cell|\<mapsto\>>|<cell|p>>|<row|<cell|<with|mode|text|insert
    left:>>|<cell|\<lambda\><rsub|X><rsup|-1>>|<cell|=>|<cell|p>|<cell|\<mapsto\>>|<cell|\<b-1\><rsub|\<b-u\>>\<cdot\>p>>|<row|<cell|<with|mode|text|delete
    right:>>|<cell|\<varrho\><rsub|X>>|<cell|=>|<cell|p\<cdot\>\<b-1\><rsub|\<b-u\>>>|<cell|\<mapsto\>>|<cell|p>>|<row|<cell|<with|mode|text|insert
    right:>>|<cell|\<varrho\><rsub|X><rsup|-1>>|<cell|=>|<cell|p>|<cell|\<mapsto\>>|<cell|p\<cdot\>\<b-1\><rsub|\<b-u\>>>>|<row|<cell|<with|mode|text|commute:>>|<cell|\<gamma\><rsub|X,Y>>|<cell|=>|<cell|p\<cdot\>q>|<cell|\<mapsto\>>|<cell|q\<cdot\>p>>|<row|<cell|<with|mode|text|duplicate:>>|<cell|\<delta\><rsub|X>>|<cell|=>|<cell|p>|<cell|\<mapsto\>>|<cell|p\<cdot\>p>>>>>
  </equation*>

  <\definition>
    Niech <with|mode|math|\<cal-R\>> b¦dzie zbiorem termów generowanych przez
    produkcj¦

    <\equation*>
      R:\<assign\>\<b-1\>\|\<alpha\>\|\<alpha\><rsup|-1>\|\<lambda\>\|\<lambda\><rsup|-1>\|\<varrho\>\|\<varrho\><rsup|-1>\|\<gamma\>\|\<delta\>\|R*R\|R\<cdot\>R
    </equation*>
  </definition>

  Poniewa» zachodz¡ równania:

  <\equation*>
    <tabular|<tformat|<cwith|1|-1|1|1|cell-halign|r>|<cwith|1|-1|5|5|cell-halign|r>|<table|<row|<cell|(\<alpha\>\<cdot\>\<b-1\>)\<alpha\>(\<b-1\>\<cdot\>\<alpha\>)>|<cell|=>|<cell|\<alpha\>\<alpha\>>|<cell|<space|2fn>>|<cell|(\<varrho\>\<cdot\>\<b-1\>)\<alpha\>>|<cell|=>|<cell|\<b-1\>\<cdot\>\<lambda\>>>|<row|<cell|\<lambda\><rsub|\<b-u\>>>|<cell|=>|<cell|\<varrho\><rsub|\<b-u\>>>|<cell|>|<cell|\<gamma\>\<gamma\>>|<cell|=>|<cell|\<b-1\>>>|<row|<cell|\<lambda\>\<gamma\>>|<cell|=>|<cell|\<varrho\>>|<cell|>|<cell|(\<gamma\>\<cdot\>\<b-1\>)\<alpha\>(\<b-1\>\<cdot\>\<gamma\>)>|<cell|=>|<cell|\<alpha\>\<gamma\>\<alpha\>>>|<row|<cell|\<alpha\>(\<b-1\>\<cdot\>\<delta\>)\<delta\>>|<cell|=>|<cell|(\<delta\>\<cdot\>\<b-1\>)\<delta\>>|<cell|>|<cell|\<gamma\>\<delta\>>|<cell|=>|<cell|\<delta\>>>|<row|<cell|\<lambda\><rsub|\<b-u\>>\<delta\><rsub|\<b-u\>>>|<cell|=>|<cell|\<b-1\><rsub|\<b-u\>>>|<cell|>|<cell|\<varrho\><rsub|\<b-u\>>\<delta\><rsub|\<b-u\>>>|<cell|=>|<cell|\<b-1\><rsub|\<b-u\>>>>>>>
  </equation*>

  mamy fakt

  <\theorem>
    Dla ka»dego relewantnego restruktora <with|mode|math|p\<mapsto\>q>
    istnieje <with|mode|math|r\<in\>\<cal-R\>>,
    <with|mode|math|r=p\<mapsto\>q>.
  </theorem>

  Dopasowywanie (ang. matching) relewantnych kombinatorów jest rozstrzygalne
  np. przez sprowadzenie do kombinatorów kartezja«skich.

  <\definition>
    Zmienne wolne <with|mode|math|f,g> w <with|mode|math|t> s¡ przylegªe,
    je±li istnieje podterm <with|mode|math|f*s> w <with|mode|math|t> i
    relewantny restruktor <with|mode|math|p\<mapsto\>q> taki, »e
    <with|mode|math|f(p\<mapsto\>q)s=f(g\<cdot\>s<rprime|'>)> dla pewnego
    <with|mode|math|s<rprime|'>>.
  </definition>

  Czyli zmienne s¡ przylegªe, je±li nie s¡ rozdzielone przez staª¡.

  <\definition>
    Podstawienie <with|mode|math|{t/x}> jest przemianowaniem, je±li
    <with|mode|math|t> jest postaci <with|mode|math|y\<tau\>> dla pewnej
    zmiennej wolnej <with|mode|math|y> oraz obustronnie odwracalnego
    restruktora relewantnego <with|mode|math|\<tau\>>.
  </definition>

  <\theorem>
    Dla staªej <with|mode|math|K> w <with|mode|math|t> istniej¡
    <with|mode|math|r,s> takie, »e <with|mode|math|t=r(K\<cdot\>\<b-1\>)s>.
  </theorem>

  <\definition>
    Asocjacyjne restruktory, <with|mode|math|\<cal-A\>>, to restruktory
    generowane przez produkcj¦

    <\equation*>
      A:\<assign\>\<b-1\>\|\<alpha\>\|\<alpha\><rsup|-1>\|A*A\|A\<cdot\>A
    </equation*>
  </definition>

  Je±li oznaczymy <with|mode|math|<wide|s<rsub|n>|\<vect\>>=s<rsub|1>\<cdot\>(s<rsub|2>\<cdot\>\<ldots\>(s<rsub|n-1>\<cdot\>s<rsub|n>)\<ldots\>)>,
  to, je±li rozumie¢ ''podterm'' jako ''podterm pierwszego rz¦du'' (czyli np.
  <with|mode|math|s> nie jest podtermem w <with|mode|math|s*t>):

  <\theorem>
    Dla termu <with|mode|math|t> i podtermu <with|mode|math|K*s> o
    <with|mode|math|m> wyst¡pieniach w <with|mode|math|t>, istniej¡
    <with|mode|math|r,<wide|s<rsub|n>|\<vect\>>,\<mu\>\<in\>\<cal-A\>,\<tau\>\<in\>\<cal-R\>>
    takie, »e <with|mode|math|t=r(\<delta\><rsup|m>K\<mu\>(<wide|s<rsub|n>|\<vect\>>)\<cdot\>\<b-1\>)\<tau\>>.
  </theorem>

  <\definition>
    <label|algMSC>›eby policzy¢ <with|mode|math|MSC(a,b)> zaczynamy z
    <with|mode|math|g<rsub|0>\<in\>\<b-C\>\<b-G\>(a,b)> i stosujemy nast.
    reguªy, a» »adna nie b¦dzie stosowalna:

    <\enumerate>
      <item>(Delete)

      <\equation*>
        <frac|t,\<theta\><rsub|1>\<cup\>{s/f},\<theta\><rsub|2>\<cup\>{s/f}|{s/f}(t),\<theta\><rsub|1>,\<theta\><rsub|2>>
      </equation*>

      <item>(Merge) Dla obustronnie odwracalnego restruktora
      <with|mode|math|\<tau\>>

      <\equation*>
        <frac|t,\<theta\><rsub|1>\<cup\>{r/f,r\<tau\>/f<rprime|'>},\<theta\><rsub|2>\<cup\>{s/f,s\<tau\>/f<rprime|'>}|{f\<tau\>/f<rprime|'>}(t),\<theta\><rsub|1>\<cup\>{r/f},\<theta\><rsub|2>\<cup\>{s/f}>
      </equation*>

      <item>(Factor-Constant)

      <\equation*>
        <frac|t,\<theta\><rsub|1>\<cup\>{r(\<delta\><rsup|m>K\<mu\>(<wide|r<rsub|n>|\<vect\>>)\<cdot\>\<b-1\>)\<tau\>/f},\<theta\><rsub|2>\<cup\>{s(\<delta\><rsup|m<rprime|'>>K\<mu\>(<wide|s<rsub|n>|\<vect\>>)\<cdot\>\<b-1\>)\<tau\>/f}|{h*(K\<mu\>(<wide|h<rsub|n>|\<vect\>>)\<cdot\>\<b-1\>)\<tau\>/f}(t),\<theta\><rsub|1>\<cup\>{r(\<delta\><rsup|m>\<cdot\>\<b-1\>)/h,<wide|r<rsub|n>|\<vect\>>/<wide|h<rsub|n>|\<vect\>>},\<theta\><rsub|2>\<cup\>{s(\<delta\><rsup|m<rprime|'>>\<cdot\>\<b-1\>)/h,<wide|s<rsub|n>|\<vect\>>/<wide|h<rsub|n>|\<vect\>>}>
      </equation*>

      <item>(Factor-Restructor)

      <\equation*>
        <frac|t,\<theta\><rsub|1>\<cup\>{r\<tau\>/f},\<theta\><rsub|2>\<cup\>{s\<tau\>/f}|{h\<tau\>/f}(t),\<theta\><rsub|1>\<cup\>{r/h},\<theta\><rsub|2>\<cup\>{s/h}>
      </equation*>

      oraz <with|mode|math|\<tau\>> nie ma lewostronnego elementu odwrotnego.
    </enumerate>
  </definition>

  <subsubsection|Praktyczny algorytm uwzgl¦dniaj¡cy rozmiar generalizacji.>

  Przedstawimy efektywny algorytm, wedªug <cite|hasker95> znajduj¡cy
  u»yteczny podzbiór <with|mode|math|MSC(a,b)>, przy zaªo»eniach:

  <\enumerate>
    <item>Termy <with|mode|math|a> i <with|mode|math|b> nie zawieraj¡
    zmiennych wolnych.

    <item>Termy <with|mode|math|a> i <with|mode|math|b> s¡ pierwszego rz¦du,
    tzn. s¡ kombinatorami typu <with|mode|math|\<b-u\>\<rightarrow\>X>.

    <item>Jest pojedynczy typ bazowy <with|mode|math|\<iota\>>; dane maj¡ typ
    <with|mode|math|\<b-u\>\<rightarrow\>\<iota\>> a funkcje maj¡ typ
    <with|mode|math|\<iota\>\<cdot\>\<iota\>\<cdot\>\<ldots\>\<cdot\>\<iota\>\<rightarrow\>\<iota\>>.
  </enumerate>

  <\definition>
    Dla pewnej funkcji <with|mode|math|size> i porz¡dku na jej
    przeciwdziedzinie <with|mode|math|\<leqslant\>>

    <\eqnarray*>
      <tformat|<table|<row|<cell|MSC<rsub|max>(a,b)>|<cell|=>|<cell|{g:g\<in\>MSC(a,b)\<wedge\>(\<forall\>g<rprime|'>\<in\>MSC(a,b))
      size(g<rprime|'>)\<leqslant\>size(g)}>>>>
    </eqnarray*>
  </definition>

  Ustalmy funkcj¦ mierz¡c¡ <with|mode|math|size:MSC(a,b)\<rightarrow\><left|langle>N,N<right|rangle>>

  <\equation*>
    size(<left|langle>\<theta\><rsub|1>:t\<rightarrow\>a,\<theta\><rsub|2>:t\<rightarrow\>b<right|rangle>)=<left|langle>size(t),size(\<theta\><rsub|1>)+size(\<theta\><rsub|2>)<right|rangle>
  </equation*>

  gdzie dla termów t

  <\eqnarray*>
    <tformat|<table|<row|<cell|size(t)>|<cell|=>|<cell|<choice|<tformat|<table|<row|<cell|size(r)+size(s)>|<cell|<with|mode|text|je±li
    >t=r*s\<vee\>t=r\<cdot\>s>>|<row|<cell|0>|<cell|<with|mode|text|je±li
    >t=p\<mapsto\>q\<vee\>t=\<b-1\>\<vee\>t<with|mode|text| jest zmienn¡
    woln¡>>>|<row|<cell|1>|<cell|<with|mode|text|w przeciwnym
    przypadku>>>>>>>>>>
  </eqnarray*>

  i dla podstawie« <with|mode|math|\<theta\>>

  <\eqnarray*>
    <tformat|<table|<row|<cell|size(\<theta\>)>|<cell|=>|<cell|<big|sum><rsub|x\<in\>Dom(\<theta\>)>size(\<theta\>(x))>>>>
  </eqnarray*>

  Dla tej definicji <with|mode|math|size>, okre±lmy
  <with|mode|math|\<leqslant\>> jako

  <\eqnarray*>
    <tformat|<table|<row|<cell|<left|langle>a,b<right|rangle>\<leqslant\><left|langle>c,d<right|rangle>>|<cell|\<Longleftrightarrow\>>|<cell|a\<less\>c\<vee\>(a=c\<wedge\>b\<geqslant\>d)>>>>
  </eqnarray*>

  <\definition>
    Drzewo typizowane to zorientowane drzewo etykietowane takie, »e je±li
    w¦zeª <with|mode|math|t> jest symbolem funkcyjnym arno±ci
    <with|mode|math|n> to <with|mode|math|t> ma <with|mode|math|n> synów.
  </definition>

  <\definition>
    Cz¦±ciow¡ permutacj¡ z <with|mode|math|n> do <with|mode|math|m> jest
    wªo»enie <with|mode|math|\<phi\>> z <with|mode|math|S> do
    <with|mode|math|{1,\<ldots\>,m}> gdzie <with|mode|math|S> jest
    <with|mode|math|k>-elementowym podzbiorem
    <with|mode|math|{1,\<ldots\>,n}> oraz <with|mode|math|k=min(n,m)>.
  </definition>

  <\definition>
    Typizowane drzewo <with|mode|math|s> jest obj¦te (ang. embedded) w t,

    <\eqnarray*>
      <tformat|<table|<row|<cell|s=f(s<rsub|1>,\<ldots\>,s<rsub|m>)>|<cell|\<trianglelefteq\>>|<cell|g(t<rsub|1>,\<ldots\>,t<rsub|n>)=t>>>>
    </eqnarray*>

    je±li zachodzi dowolny z nast¦puj¡cych warunków:

    <\enumerate>
      <item><with|mode|math|s\<trianglelefteq\>t<rsub|i>,<space|2fn>\<exists\>i\<in\>{1,\<ldots\>,n}>

      <item><with|mode|math|label(f)=label(g),
      <space|2em>s<rsub|i>\<trianglelefteq\>t<rsub|i><space|2fn>\<forall\>i\<in\>{1,\<ldots\>,n}>

      <item><with|mode|math|f> jest zmienn¡, oraz, dla pewnej injekcji
      <with|mode|math|\<phi\>> z <with|mode|math|{1,\<ldots\>,m}> do
      <with|mode|math|{1,\<ldots\>,n}>, <with|mode|math|s<rsub|i>\<trianglelefteq\>t<rsub|\<phi\>(i)><space|0.6spc>\<forall\>i\<in\>{1,\<ldots\>,m}>.
    </enumerate>

    Je±li drzewo <with|mode|math|s> jest puste, to przyjmujemy
    <with|mode|math|s\<trianglelefteq\>t> dla dowolnego <with|mode|math|t>.
  </definition>

  Hasker w <cite|hasker95> bª¦dnie definiuje punkt 3, zamiast wymaga¢
  injekcji pozwala na permutacj¦ cz¦±ciow¡. Nie jest wtedy prawd¡, »e
  poni»sze <with|mode|math|gentrees> odpowiada dalej zdefiniowanemu zbiorowi
  <with|mode|math|\<cal-M\>> maksymalnych dopasowa«. Rozszerzenie definicji
  na przypadek drzewa <with|mode|math|s> pustego ma charakter techniczny.

  <\definition>
    \;

    <\eqnarray*>
      <tformat|<table|<row|<cell|gentrees(a,b)>|<cell|=>|<cell|{t\|t\<trianglelefteq\>a,t\<trianglelefteq\>b,(\<forall\>t<rprime|'>:t<rprime|'>\<trianglelefteq\>a\<wedge\>t<rprime|'>\<trianglelefteq\>b)
      size(t<rprime|'>)\<leqslant\>size(t)}>>>>
    </eqnarray*>
  </definition>

  Numerujemy kolejno w¦zªy drzew u»ywaj¡c przej±cia wszerz z indeksem
  korzenia ustawionym na 1. Je±li w¦zeª jest bli»ej korzenia, to ma mniejszy
  indeks. Indeks w¦zªa <with|mode|math|p> jest oznaczony
  <with|mode|math|index(p)>, a w¦zeª (i poddrzewo, kontekst rozró»nia)
  <with|mode|math|t> o indeksie <with|mode|math|i> przez
  <with|mode|math|t/i>. Korze« drzewa <with|mode|math|t> oznaczamy
  odpowiednio <with|mode|math|t/1>. Etykieta w¦zªa <with|mode|math|p> jest
  oznaczona przez <with|mode|math|label(p)>. Niech <with|mode|math|\|t\|>
  b¦dzie ilo±ci¡ w¦zªów w <with|mode|math|t>. Definiujemy macierze
  <with|mode|math|N> i <with|mode|math|N<rprime|'>> rozmiaru
  <with|mode|math|\|t<rsub|1>\| \<times\> \|t<rsub|2>\|>:

  <\definition>
    Niech synami <with|mode|math|t<rsub|1>/i> b¦d¡
    <with|mode|math|<wide|p<rsub|m>|\<vect\>>>, a synami
    <with|mode|math|t<rsub|2>/j> b¦d¡ <with|mode|math|<wide|q<rsub|n>|\<vect\>>>
    (dla <with|mode|math|m,n\<geqslant\>0>), gdzie
    <with|mode|math|<wide|u<rsub|n>|\<vect\>>=u<rsub|1>,\<ldots\>,u<rsub|n>>.
    Wtedy <with|mode|math|N<rsub|i,j>> jest zbiorem zawieraj¡cym sum¦ rodzin
    zbiorów

    <\enumerate>
      <item><with|mode|math|{{<left|langle>i,index(q)<right|rangle>}\|q\<in\><wide|q<rsub|m>|\<vect\>>}>

      <item><with|mode|math|{{<left|langle>index(p),j<right|rangle>}\|p\<in\><wide|p<rsub|n>|\<vect\>>}>

      <item><with|mode|math|{{<left|langle>index(p<rsub|k>),index(q<rsub|\<phi\>(k)>)<right|rangle>\|k\<in\>Dom(\<phi\>)}\|
      \<phi\><with|mode|text| jest cz¦±ciow¡ permutacj¡ z >n<with|mode|text|
      do >m}>
    </enumerate>

    oraz <with|mode|math|N<rsub|i,j><rprime|'>> jest zbiorem

    <\eqnarray*>
      <tformat|<table|<row|<cell|N<rsub|i,j><rprime|'>>|<cell|=>|<cell|<choice|<tformat|<table|<row|<cell|{<left|langle>i,j<right|rangle>,<left|langle>index(p<rsub|k>),index(q<rsub|k>)<right|rangle>\|1\<leqslant\>k\<leqslant\>n}>|<cell|label(t<rsub|1>/i)=label(t<rsub|2>/j)>>|<row|<cell|\<varnothing\>>|<cell|<with|mode|text|w
      przeciwnym przypadku>>>>>>>>>>
    </eqnarray*>
  </definition>

  Definiujemy teraz macierze <with|mode|math|M,M<rprime|'>> zawieraj¡ce
  rozmiary maksymalnie obj¦tych drzew otrzymanych z <with|mode|math|N> i
  <with|mode|math|N<rprime|'>>. Oznaczmy

  <\eqnarray*>
    <tformat|<table|<row|<cell|M<rsub|\<Sigma\>P>>|<cell|=>|<cell|<big|sum><rsub|<left|langle>p,q<right|rangle>\<in\>P>M<rsub|p,q>>>>>
  </eqnarray*>

  <\definition>
    \;

    <\eqnarray*>
      <tformat|<table|<row|<cell|M<rsub|i,j><rprime|'>>|<cell|=>|<cell|<choice|<tformat|<table|<row|<cell|0>|<cell|N<rprime|'><rsub|i,j>=
      \<varnothing\>>>|<row|<cell|1+M<rsub|\<Sigma\>(N<rprime|'><rsub|i,j><mid|\\>{<left|langle>i,j<right|rangle>})>>|<cell|<with|mode|text|w
      przeciwnym przypadku>>>>>>>>|<row|<cell|M<rsub|i,j>>|<cell|=>|<cell|max{M<rprime|'><rsub|i,j>,M<rsub|\<Sigma\>P>\|P\<in\>N<rsub|i,j>}>>>>
    </eqnarray*>
  </definition>

  Otrzymujemy

  <\equation*>
    M<rsub|1,1>=\|t\|<with|mode|text| dla >t\<in\>gentrees(a,b)
  </equation*>

  Stosuj¡c memoizacj¦, mo»na efektywnie policzy¢ (jak w metodach
  programowania dynamicznego)

  <\code>
    for i=<with|mode|math|n> downto 1

    \ \ for j=<with|mode|math|m> downto 1

    \ \ \ \ compute <with|mode|math|M<rprime|'><rsub|i,j>> and
    <with|mode|math|M<rsub|i,j>>
  </code>

  ›eby znale¹¢ maksymalnie du»e obj¦te drzewa definiujemy

  <\definition>
    \;

    <\eqnarray*>
      <tformat|<table|<row|<cell|I<rsub|i,j>>|<cell|=>|<cell|{P\<in\>N<rsub|i,j>\|M<rsub|i,j>=M<rsub|\<Sigma\>P>}\<cup\>{N<rsub|i,j><rprime|'>\|M<rsub|i,j>=M<rprime|'><rsub|i,j>}>>>>
    </eqnarray*>
  </definition>

  <\definition>
    Niech <with|mode|math|P\<in\>N<rsub|i,j>>, wtedy

    <\eqnarray*>
      <tformat|<table|<row|<cell|matches<rsub|<left|langle>i,j<right|rangle>>>|<cell|=>|<cell|<big|cup><rsub|<left|langle>p,q<right|rangle>\<in\>P<mid|\\>{<left|langle>i,j<right|rangle>}>matches<rsub|<left|langle>p,q<right|rangle>>\<cup\><choice|<tformat|<table|<row|<cell|{<left|langle>i,j<right|rangle>}>|<cell|<with|mode|text|je±li
      ><left|langle>i,j<right|rangle>\<in\>P>>|<row|<cell|\<varnothing\>>|<cell|<with|mode|text|w
      przec. przyp.>>>>>>>>>>
    </eqnarray*>

    Definicja jest niedeterministyczna ze wzgl¦du na wybór
    <with|mode|math|P>. Oznaczamy zbiór wszystkich rozwi¡za« przez

    <\eqnarray*>
      <tformat|<table|<row|<cell|\<cal-M\>>|<cell|=>|<cell|{matches<rsub|<left|langle>1,1<right|rangle>>}>>>>
    </eqnarray*>
  </definition>

  <subsection|Algorytm rekonstrukcji generalizacji z relewantnymi
  <with|mode|math|\<lambda\>>-abstrakcjami.>

  Generalizacja drugiego rz¦du w porz¡dku danym przez podstawienia wyra»a si¦
  w j¦zyku <with|mode|math|\<lambda\>>-termów pierwszego rz¦du: zmienne
  zwi¡zane <with|mode|math|\<lambda\>>-abstrakcji sªu»¡ do ``sklejania''
  podstawie« z antyinstancj¡. (Ogólnie, rz¡d generalizacji w porz¡dku
  podstawieniowym jest o 1 wi¦kszy ni» rz¡d potrzebnych
  <with|mode|math|\<lambda\>>-termów.) Dopiero w porz¡dku aplikacyjnym (gdzie
  podstawienia s¡ realizowane przez <with|mode|math|\<beta\>>-redukcj¦) rz¡d
  generalizacji jest taki sam jak rz¡d <with|mode|math|\<lambda\>>-termów.

  B¦dziemy si¦ posªugiwa¢ <with|mode|math|\<lambda\>>-rachunkiem, poniewa»
  jest wygodniejszy dla manipulacji lokaln¡ struktur¡ aplikacyjn¡ ni» algebra
  kombinatorów: ''nitki'' ª¡cz¡ce funkcj¦ i argument mog¡ by¢ jawnie nazwane;
  poza tym, jest bardziej naturalny przy traktowaniu termów jako drzew.
  B¦dziemy u»ywa¢ postaci ``uncurried'', bardziej odpowiedniej w j¦zyku
  drugiego rz¦du. <with|mode|math|\<lambda\>>-termy u»ywane w generalizacji
  b¦dziemy uwa»a¢ za ró»ne od wszelkich konstrukcji j¦zyka, którego termy
  generalizujemy; zbiór zmiennych generalizacji, czyli meta-zmiennych,
  oznaczmy <with|mode|math|M>.

  Ograniczymy si¦ do relewantnego <with|mode|math|\<lambda\>>-rachunku, tzn.
  do <with|mode|math|\<lambda\>>-abstrakcji relewantnych.

  <\definition>
    <with|mode|math|\<lambda\>>-abstrakcja
    <with|mode|math|\<lambda\>x<rsub|1>,\<ldots\>,x<rsub|n>.t> jest
    relewantna, je±li <with|mode|math|{x<rsub|1>,\<ldots\>,x<rsub|n>}=\<b-F\><rsub|M>(t)>,
    gdzie <with|mode|math|\<b-F\><rsub|M>> oznacza wolne meta-zmienne termu.
  </definition>

  Opracujemy algorytm rekonstrukcji generalizacji z macierzy
  <with|mode|math|I>. Taki algorytm nie byª podany bezpo±rednio w pracy
  Haskera. Zbiory zawarte w <with|mode|math|I<rsub|i,j>> oznaczaj¡ mo»liwe do
  podj¦cia w pozycji <with|mode|math|i,j> dopasowania kroki:

  <\enumerate>
    <item>Doª¡cz korze« drugiego termu do konstruowanego podstawienia, caªy
    pierwszy term zachowaj dla dalszej generalizacji.

    <item>Doª¡cz korze« pierwszego termu do konstruowanego podstawienia, caªy
    drugi term zachowaj dla dalszej generalizacji.

    <item>Doª¡cz korzenie obu termów do konstruowanego podstawienia,
    przydziel podtermy, które w dalszym przebiegu b¦d¡ tworzy¢ argumenty
    konstruowanego podstawienia (zmiennej).

    <item>Utwórz anty-instancj¦ z korzeni obu podtermów (o ile maj¡ wspóln¡
    etykiet¦), konstruuj generalizacj¦ (anty-instancj¦) dla ka»dego
    argumentu.
  </enumerate>

  Algorytm generalizacji <with|mode|math|\<b-A\><rsub|s>(i,j)=Subst(l,r,\<theta\><rsub|1>,\<theta\><rsub|2>,V,H,S)>
  lub <with|mode|math|\<b-A\><rsub|s>(i,j)=AntiInst(g,\<theta\><rsub|1>,\<theta\><rsub|2>)>,
  gdzie <with|mode|math|i,j> to pozycje (indeksy) w generalizowanych
  programach, <with|mode|math|l,r> lewe (daj¡ce <with|mode|math|s)> i prawe
  (daj¡ce <with|mode|math|t)> aktualnie konstruowane podstawienia,
  <with|mode|math|\<theta\><rsub|i>> wynikowe podstawienia generalizacji,
  <with|mode|math|<wide|V|\<vect\>>> zmienne zwi¡zane aktualnych podstawie«
  generalizacji, <with|mode|math|<wide|H|\<vect\>>> podtermy anty-instancji w
  kolejno±ci odpowiadaj¡cej <with|mode|math|V>, <with|mode|math|S> pozostaªe
  do przetworzenia fragmenty programów (''skrawki''), <with|mode|math|g>
  skonstruowan¡ anty-instancj¦.

  Przy generalizacji programów <with|mode|math|s,t>,
  <with|mode|math|\<b-A\><rsub|s>(i,j,\<theta\><rsub|1>,\<theta\><rsub|2>)>
  zwraca: wybierz <with|mode|math|P\<in\>I<rsub|i,j>> i w zale»no±ci od
  kategorii rodzin podzbioróªw, do której <with|mode|math|P> nale»y

  <\enumerate>
    <item><with|mode|math|P={<left|langle>i,j<rprime|'><right|rangle>},t/j=f(t<rsub|1>,\<ldots\>,t<rsub|n>),t/j<rprime|'>=t<rsub|k>>.
    Aby skróci¢ sformuªowania, dopuszczamy wsz¦dzie przypadek
    <with|mode|math|n=0>.

    <\code>
      je±li <with|mode|math|A<rsub|s>(i,j<rprime|'>)=Subst(l,r,\<theta\><rsub|1>,\<theta\><rsub|2>,<wide|V|\<vect\>>,<wide|H|\<vect\>>,S)>

      <\eqnarray*>
        <tformat|<table|<row|<cell|r<rprime|'>>|<cell|=>|<cell|f(r<rsub|1>,\<ldots\>,r<rsub|n>)>>|<row|<cell|r<rsub|m>>|<cell|=>|<cell|x<rsub|m><with|mode|text|
        dla >1\<leqslant\>m\<leqslant\>n,m\<neq\>k>>|<row|<cell|r<rsub|k>>|<cell|=>|<cell|r>>|<row|<cell|S<rprime|'>>|<cell|=>|<cell|S\<cup\>{t<rsub|m>/x<rsub|m>\|1\<leqslant\>m\<leqslant\>n,m\<neq\>k}>>>>
      </eqnarray*>

      \ \ \ \ zwró¢ <with|mode|math|Subst(l,r<rprime|'>,\<theta\><rsub|1>,\<theta\><rsub|2>,<wide|V|\<vect\>>,<wide|H|\<vect\>>,S<rprime|'>)>

      w p.p. <with|mode|math|A<rsub|s>(i,j<rprime|'>)=AntiInst(g,\<theta\><rsub|1>,\<theta\><rsub|2>)>

      <\eqnarray*>
        <tformat|<table|<row|<cell|r<rprime|'>>|<cell|=>|<cell|f(r<rsub|1>,\<ldots\>,r<rsub|n>)>>|<row|<cell|r<rsub|m>>|<cell|=>|<cell|x<rsub|m><with|mode|text|
        dla >1\<leqslant\>m\<leqslant\>n,m\<neq\>k>>|<row|<cell|r<rsub|k>>|<cell|=>|<cell|X>>|<row|<cell|<wide|V|\<vect\>><rprime|'>>|<cell|=>|<cell|<wide|V|\<vect\>>.X>>|<row|<cell|<wide|H|\<vect\>><rprime|'>>|<cell|=>|<cell|<wide|H|\<vect\>>.g>>|<row|<cell|S<rprime|'>>|<cell|=>|<cell|S\<cup\>{t<rsub|m>/x<rsub|m>\|1\<leqslant\>m\<leqslant\>n,m\<neq\>k}>>>>
      </eqnarray*>

      \ \ \ \ zwró¢ <with|mode|math|Subst(X,r<rprime|'>,\<theta\><rsub|1>,\<theta\><rsub|2>,<wide|V|\<vect\>><rprime|'>,<wide|H|\<vect\>><rprime|'>,S<rprime|'>)>
    </code>

    <with|mode|math|x<rsub|m>> oraz <with|mode|math|X> s¡ nowymi
    meta-zmiennymi.

    <item><with|mode|math|P={<left|langle>i<rprime|'>,j<right|rangle>},s/i=f(s<rsub|1>,\<ldots\>,s<rsub|n>),s/i<rprime|'>=s<rsub|k>>.

    <\code>
      je±li <with|mode|math|A<rsub|s>(i<rprime|'>,j)=Subst(l,r,\<theta\><rsub|1>,\<theta\><rsub|2>,<wide|V|\<vect\>>,<wide|H|\<vect\>>,S)>

      <\eqnarray*>
        <tformat|<table|<row|<cell|l<rprime|'>>|<cell|=>|<cell|f(l<rsub|1>,\<ldots\>,l<rsub|n>)>>|<row|<cell|l<rsub|m>>|<cell|=>|<cell|x<rsub|m><with|mode|text|
        dla >1\<leqslant\>m\<leqslant\>n,m\<neq\>k>>|<row|<cell|l<rsub|k>>|<cell|=>|<cell|l>>|<row|<cell|S<rprime|'>>|<cell|=>|<cell|S\<cup\>{t<rsub|m>/x<rsub|m>\|1\<leqslant\>m\<leqslant\>n,m\<neq\>k}>>>>
      </eqnarray*>

      \ \ \ \ zwró¢ <with|mode|math|Subst(l<rprime|'>,r,\<theta\><rsub|1>,\<theta\><rsub|2>,<wide|V|\<vect\>>,<wide|H|\<vect\>>,S<rprime|'>)>

      w p.p. <with|mode|math|A<rsub|s>(i<rprime|'>,j)=AntiInst(g,\<theta\><rsub|1>,\<theta\><rsub|2>)>

      <\eqnarray*>
        <tformat|<table|<row|<cell|l<rprime|'>>|<cell|=>|<cell|f(l<rsub|1>,\<ldots\>,l<rsub|n>)>>|<row|<cell|l<rsub|m>>|<cell|=>|<cell|x<rsub|m><with|mode|text|
        dla >1\<leqslant\>m\<leqslant\>n,m\<neq\>k>>|<row|<cell|l<rsub|k>>|<cell|=>|<cell|X>>|<row|<cell|<wide|V|\<vect\>><rprime|'>>|<cell|=>|<cell|<wide|V|\<vect\>>.X>>|<row|<cell|<wide|H|\<vect\>><rprime|'>>|<cell|=>|<cell|<wide|H|\<vect\>>.g>>|<row|<cell|S<rprime|'>>|<cell|=>|<cell|S\<cup\>{s<rsub|m>/x<rsub|m>\|1\<leqslant\>m\<leqslant\>n,m\<neq\>k}>>>>
      </eqnarray*>

      \ \ \ \ zwró¢ <with|mode|math|Subst(l<rprime|'>,X,\<theta\><rsub|1>,\<theta\><rsub|2>,<wide|V|\<vect\>><rprime|'>,<wide|H|\<vect\>><rprime|'>,S<rprime|'>)>
    </code>

    <with|mode|math|x<rsub|m>> oraz <with|mode|math|X> s¡ nowymi
    meta-zmiennymi.

    <item><with|mode|math|P={<left|langle>i<rsub|1>,j<rsub|1><right|rangle>,\<ldots\>,<left|langle>i<rsub|k>,j<rsub|k><right|rangle>},s/i=f(s<rsub|1>,\<ldots\>,s<rsub|n>),t/j=g(t<rsub|1>,\<ldots\>,t<rsub|n<rprime|'>>),s/i<rsub|m>=s<rsub|\<psi\><rsub|m>>,t/j<rsub|m>=t<rsub|\<phi\>(\<psi\><rsub|m>)>,1\<leqslant\>m\<leqslant\>k,Dom(\<phi\>)={\<psi\><rsub|1>,\<ldots\>,\<psi\><rsub|k>}>
    w porz¡dku rosn¡cym.

    <\code>
      <with|mode|math|<wide|V|\<vect\>><rprime|'>\<assign\><wide|V|\<vect\>>,<wide|H|\<vect\>><rprime|'>\<assign\><wide|H|\<vect\>>>

      dla <with|mode|math|1\<leqslant\>m\<leqslant\>k>

      \ \ \ \ je±li <with|mode|math|A<rsub|s>(i<rsub|m>,j<rsub|m>)=Subst(l<rsup|m>,r<rsup|m>,\<theta\><rsub|1><rsup|m>,\<theta\><rsub|2><rsup|m>,<wide|V|\<vect\>><rsup|m>,<wide|H|\<vect\>><rsup|m>,S<rsup|m>)>

      <\eqnarray*>
        <tformat|<table|<row|<cell|l<rsub|\<psi\><rsub|m>>>|<cell|=>|<cell|l<rsup|m>>>|<row|<cell|r<rsub|\<phi\>(\<psi\><rsub|m>)>>|<cell|=>|<cell|r<rsup|m>>>>>
      </eqnarray*>

      \ \ \ \ w p.p. <with|mode|math|A<rsub|s>(i<rsub|m>,j<rsub|m>)=AntiInst(g<rsup|m>,\<theta\><rsub|1><rsup|m>,\<theta\><rsub|2><rsup|m>)>

      <\eqnarray*>
        <tformat|<table|<row|<cell|l<rsub|\<psi\><rsub|m>>>|<cell|=>|<cell|X<rsub|m>>>|<row|<cell|r<rsub|\<phi\>(\<psi\><rsub|m>)>>|<cell|=>|<cell|X<rsub|m>>>|<row|<cell|<wide|V|\<vect\>><rprime|'>>|<cell|\<assign\>>|<cell|<wide|V|\<vect\>><rprime|'>.X<rsub|m>>>|<row|<cell|<wide|H|\<vect\>><rprime|'>>|<cell|\<assign\>>|<cell|<wide|H|\<vect\>><rprime|'>.g>>>>
      </eqnarray*>

      nast¦pnie

      <\eqnarray*>
        <tformat|<table|<row|<cell|S<rprime|'>>|<cell|=>|<cell|S\<cup\>{s<rsub|m>/x<rsub|m>,t<rsub|m<rprime|'>>/y<rsub|m<rprime|'>>\|1\<leqslant\>m\<leqslant\>n,1\<leqslant\>m<rprime|'>\<leqslant\>n<rprime|'>,m\<nin\>Dom(\<phi\>),m<rprime|'>\<nin\>Ran(\<phi\>)}>>|<row|<cell|l<rsub|m>>|<cell|=>|<cell|x<rsub|m>,<space|2fn>1\<leqslant\>m\<leqslant\>n,m\<nin\>Dom(\<phi\>)>>|<row|<cell|r<rsub|m>>|<cell|=>|<cell|y<rsub|m>,<space|2fn>1\<leqslant\>m\<leqslant\>n<rprime|'>,m\<nin\>Ran(\<phi\>)>>|<row|<cell|l<rprime|'>>|<cell|=>|<cell|f(l<rsub|1>,\<ldots\>,l<rsub|n>)>>|<row|<cell|r<rprime|'>>|<cell|=>|<cell|g(r<rsub|1>,\<ldots\>,r<rsub|n<rprime|'>>)>>|<row|<cell|\<theta\><rsub|1><rprime|'>>|<cell|=>|<cell|<big|cup><rsub|1\<leqslant\>m\<leqslant\>k>\<theta\><rsub|1><rsup|m>>>|<row|<cell|\<theta\><rsub|2><rprime|'>>|<cell|=>|<cell|<big|cup><rsub|1\<leqslant\>m\<leqslant\>k>\<theta\><rsub|2><rsup|m>>>>>
      </eqnarray*>

      zwró¢ <with|mode|math|Subst(l<rprime|'>,r<rprime|'>,\<theta\><rsub|1><rprime|'>,\<theta\><rsub|2><rprime|'>,<wide|V|\<vect\>><rprime|'>,<wide|H|\<vect\>><rprime|'>,S<rprime|'>)>
    </code>

    <with|mode|math|x<rsub|m>,y<rsub|m>> oraz <with|mode|math|X<rsub|m>> s¡
    nowymi meta-zmiennymi.

    <item><with|mode|math|P={<left|langle>i,j<right|rangle>,<left|langle>i<rsub|1>,j<rsub|1><right|rangle>,\<ldots\>,<left|langle>i<rsub|n>,j<rsub|n><right|rangle>},s/i=f(s<rsub|1>,\<ldots\>,s<rsub|n>),t/j=f(t<rsub|1>,\<ldots\>,t<rsub|n>),s/i<rsub|m>=s<rsub|m>,t/j<rsub|m>=t<rsub|m>,1\<leqslant\>m\<leqslant\>n.>

    <\code>
      <with|mode|math|\<theta\><rsub|1><rprime|'>\<assign\>\<theta\><rsub|1>,\<theta\><rsub|2><rprime|'>\<assign\>\<theta\><rsub|2>>

      dla <with|mode|math|1\<leqslant\>m\<leqslant\>n>

      \ \ \ \ je±li <with|mode|math|A<rsub|s>(i<rsub|m>,j<rsub|m>)=Subst(l<rsup|m>,r<rsup|m>,\<theta\><rsub|1><rsup|m>,\<theta\><rsub|2><rsup|m>,<wide|V|\<vect\>><rsup|m>,<wide|H|\<vect\>><rsup|m>,S<rsup|m>)>

      <\eqnarray*>
        <tformat|<table|<row|<cell|S<rprime|'><rsub|1>(x)>|<cell|=>|<cell|A<rsub|p>(<wide|V|\<vect\>><rsup|m>,\<theta\><rsub|1><rsup|m><wide|H|\<vect\>><rsup|m>,S<rsup|m>(x))<space|2fn>x\<in\>Dom(S<rsup|m>)>>|<row|<cell|S<rprime|'><rsub|2>(x)>|<cell|=>|<cell|A<rsub|p>(<wide|V|\<vect\>><rsup|m>,\<theta\><rsub|2><rsup|m><wide|H|\<vect\>><rsup|m>,S<rsup|m>(x))<space|2fn>x\<in\>Dom(S<rsup|m>)>>|<row|<cell|\<theta\><rsub|1><rprime|'>>|<cell|\<assign\>>|<cell|\<theta\><rsub|1><rprime|'>\<cup\>\<theta\><rsub|1><rsup|m>\<cup\>{\<lambda\><wide|V|\<vect\>><rsup|m>.S<rprime|'><rsub|1>(l<rsup|m>)/Z<rsub|m>}>>|<row|<cell|\<theta\><rsub|2><rprime|'>>|<cell|\<assign\>>|<cell|\<theta\><rsub|2><rprime|'>\<cup\>\<theta\><rsub|2><rsup|m>\<cup\>{\<lambda\><wide|V|\<vect\>><rsup|m>.S<rprime|'><rsub|2>(r<rsup|m>)/Z<rsub|m>}>>|<row|<cell|g<rsub|m>>|<cell|=>|<cell|Z<rsub|m>(<wide|H|\<vect\>><rsup|m>)>>>>
      </eqnarray*>

      \ \ \ \ w p.p. <with|mode|math|A<rsub|s>(i<rsub|m>,j<rsub|m>)=AntiInst(g<rsup|m>,\<theta\><rsub|1><rsup|m>,\<theta\><rsub|2><rsup|m>)>

      <\eqnarray*>
        <tformat|<table|<row|<cell|\<theta\><rsub|1><rprime|'>>|<cell|=>|<cell|\<theta\><rsub|1><rprime|'>\<cup\>\<theta\><rsub|1><rsup|m>>>|<row|<cell|\<theta\><rsub|2><rprime|'>>|<cell|=>|<cell|\<theta\><rsub|2><rprime|'>\<cup\>\<theta\><rsub|2><rsup|m>>>|<row|<cell|g<rsub|m>>|<cell|=>|<cell|g<rsup|m>>>>>
      </eqnarray*>

      zwró¢ <with|mode|math|AntiInst(f(g<rsub|1>,\<ldots\>,g<rsub|n>),<wide|\<theta\>|\<vect\>><rprime|'><rsub|1>,<wide|\<theta\>|\<vect\>><rsub|2><rprime|'>)>
    </code>

    <with|mode|math|Z<rsub|m>> s¡ nowymi meta-zmiennymi.

    <item><with|mode|math|P= \<varnothing\>,s/i=c,t/j=d,c\<neq\>d>, zwró¢
    <with|mode|math|Subst(c,d,\<varnothing\>,\<varnothing\>,\<varnothing\>,\<varnothing\>,\<varnothing\>)>.
  </enumerate>

  ›eby wyznaczy¢ generalizacj¦ (anty-unifikacj¦) programów
  <with|mode|math|s,t>:

  <\code>
    wyznacz macierze <with|mode|math|N,N<rprime|'>,M,M<rprime|'>,I>

    je±li <with|mode|math|A<rsub|s>(1,1)=Subst(l,r,\<theta\><rsub|1>,\<theta\><rsub|2>,<wide|V|\<vect\>>,<wide|H|\<vect\>>,S)>

    <\eqnarray*>
      <tformat|<table|<row|<cell|S<rprime|'><rsub|1>(x)>|<cell|=>|<cell|A<rsub|p>(<wide|V|\<vect\>>,\<theta\><rsub|1><wide|H|\<vect\>>,S(x))<space|2fn>x\<in\>Dom(S)>>|<row|<cell|S<rprime|'><rsub|2>(x)>|<cell|=>|<cell|A<rsub|p>(<wide|V|\<vect\>>,\<theta\><rsub|2><wide|H|\<vect\>>,S(x))<space|2fn>x\<in\>Dom(S)>>|<row|<cell|\<theta\><rsub|1><rprime|'>>|<cell|=>|<cell|\<theta\><rsub|1>\<cup\>{\<lambda\><wide|V|\<vect\>>.S<rprime|'><rsub|1>(l)/Z}>>|<row|<cell|\<theta\><rsub|2><rprime|'>>|<cell|=>|<cell|\<theta\><rsub|2>\<cup\>{\<lambda\><wide|V|\<vect\>>.S<rprime|'><rsub|2>(r)/Z}>>|<row|<cell|g>|<cell|=>|<cell|Z<rsub|>(<wide|H|\<vect\>>)>>>>
    </eqnarray*>

    \ \ \ \ zwró¢ <with|mode|math|g,\<theta\><rsub|1><rprime|'>,\<theta\><rsub|2><rprime|'>>

    w p. p. <with|mode|math|A<rsub|s>(1,1)=AntiInst(g,\<theta\><rsub|1>,\<theta\><rsub|2>)>

    \ \ \ \ zwró¢ <with|mode|math|g,\<theta\><rsub|1>,\<theta\><rsub|2>>
  </code>

  Pozostaje jeszcze zadanie wyznaczenia <with|mode|math|A<rsub|p>(<wide|V|\<vect\>>,<wide|H|\<vect\>>,t)>.
  Maj¡c ju» rozwi¡zane zadanie maksymalizacji rozmiaru anty-instancji,
  zajmiemy si¦ minimalizacj¡ rozmiaru podstawie«. Poniewa» posta¢
  anty-instancji determinuje argumenty podstawie«, na ich podstawie trzeba
  optymalnie ``wykroi¢ skrawki''. Wystarczy przegl¡da¢ term
  <with|mode|math|t> od ko«ców (od li±ci), szukaj¡c najdªu»ej pasuj¡cego
  argumentu z <with|mode|math|<wide|H|\<vect\>>>. Przy odpowiedniej
  reprezentacji, sprowadza si¦ to do porównywania stringów. Jako wa»ne
  zadanie pozostaje zbadanie zªo»ono±ci obliczeniowej powstaªych algorytmów i
  ewentualna optymalizacja algorytmu <with|mode|math|A<rsub|p>(<wide|V|\<vect\>>,<wide|H|\<vect\>>,t)>.

  Algorytm <with|mode|math|A<rsub|p>(<wide|V|\<vect\>>,<wide|H|\<vect\>>,t)>:

  <\enumerate>
    <item>Sprowad¹ <with|mode|math|t> i elementy
    <with|mode|math|<wide|H|\<vect\>>> do postaci odwrotnej notacji polskiej
    (ang. RPN): <with|mode|math|t<rsub|r>,<wide|H|\<vect\>><rsub|r>>.

    <item>Znajd¹ string z <with|mode|math|<wide|H|\<vect\>><rsub|r>> o
    maksymalnej dªugo±ci b¦d¡cy odcinkiem pocz¡tkowym
    <with|mode|math|t<rsub|r>>. Je±li takiego nie ma, zako«cz (zako«cz
    wywoªanie rekurencyjne). (Krok niedeterministyczny.)

    <item>Zast¡p znaleziony odc. pocz¡tkowy <with|mode|math|t<rsub|0>> w
    <with|mode|math|t<rsub|r>> odpowiedni¡ zmienn¡ <with|mode|math|x<rsub|0>>
    z <with|mode|math|<wide|V|\<vect\>>>.

    <item>Okre±l odcinek pocz¡tkowy <with|mode|math|s<rsub|r>> taki, »e
    <with|mode|math|t<rsub|0>> jest argumentem funkcji b¦d¡cej ostatnim
    elementem <with|mode|math|s<rsub|r>> (tzn. najmniejszy podterm
    <with|mode|math|t<rsub|r>>, »e <with|mode|math|t<rsub|0>> jest jego
    ±cisªym podtermem). Je±li taki <with|mode|math|s<rsub|r>> istnieje, to
    wywoªaj rekurencyjnie od punktu 2 dla
    <with|mode|math|s<rprime|'><rsub|r>>, gdzie
    <with|mode|math|s<rsub|r>=t<rsub|0>.s<rprime|'><rsub|r>>.

    <item>Je±li <with|mode|math|s<rsub|r>\<neq\>t<rsub|r>> (a je±li
    <with|mode|math|s<rsub|r>> nie istnieje, to je±li
    <with|mode|math|t<rsub|0>\<neq\>t<rsub|r>>), wywoªaj rekurencyjnie od
    punktu 2 dla <with|mode|math|><with|mode|math|t<rprime|'><rsub|r>>, gdzie
    <with|mode|math|t<rsub|r>=s<rsub|r>.t<rprime|'><rsub|r>> (a je±li
    <with|mode|math|s<rsub|r>> nie istnieje,
    <with|mode|math|t<rsub|r>=t<rsub|0>.t<rsub|r><rprime|'>>).

    <item>Poskªadaj odpowiedzi, zast¦puj¡ce odpowiednie podtermy
    <with|mode|math|t<rsub|r>> przez zmienne, i zwró¢ tak przeksztaªcony
    term.
  </enumerate>

  <subsection|Generalizacja przez znajdowanie maksymalnych wspólnych
  podstruktur.>

  W tym podrozdziale poka»emy, »e efektywny algorytm Haskera nie oblicza
  <with|mode|math|MSC<rsub|max>>. Podamy te» algorytm obliczaj¡cy
  <with|mode|math|MSC>. Powód, dla którego efektywny algorytm Haskera nie
  oblicza <with|mode|math|MSC<rsub|max>> jest taki sam, jak powód, dla
  którego zrezygnowano z kombinatorów kartezja«skich na rzecz relewantnych:
  »eby wykorzysta¢ t¦ sam¡ informacj¦ w ró»nych miejscach, stosuj¡c algorytm
  rekursji wzdªu» struktury termów, trzeba j¡ skopiowa¢, a nast¦pnie skasowa¢
  w niepotrzebnych miejscach. Algorytm Haskera wyklucza kopiowanie, »eby nie
  byªo konieczne kasowanie. Dopuszczenie kasowania prowadzi do patologicznych
  pseudo-generalizacji.

  Niekiedy mówi¡c o drzewie, ma si¦ na my±li nie tylko graf skierowany, ale
  jeszcze porz¡dek okre±lony dla ka»dego w¦zªa na przylegªych do niego
  kraw¦dziach. Tak te» niejawnie przyjmuje Hasker w swojej definicji drzewa
  typizowanego.

  Porz¡dkiem <with|mode|math|sub> wyznaczonym przez drzewo typizowane
  <with|mode|math|t> nazwiemy domkni¦cie przechodnie relacji danej przez graf
  <with|mode|math|t>: <with|mode|math|sub(v<rsub|1>,v<rsub|2>)>, je±li w¦zeª
  <with|mode|math|v<rsub|2>> nale»y do poddrzewa zaczepionego w
  <with|mode|math|v<rsub|1>>. Zbiór w¦zªów drzewa oznaczmy przez
  <with|mode|math|V(t)>. Niech <with|mode|math|V> b¦dzie wyró»nion¡ etykiet¡
  oznaczaj¡c¡ zmienne. Niech predykat <with|mode|math|label<rsub|k>(v)\<equiv\>(label(v)=k\<vee\>label(v)=V)>.
  Niech relacja

  <\equation*>
    argn<rsub|n>(v<rsub|1>,v<rsub|2>)=(n\<leqslant\>outdeg(v<rsub|1>))\<wedge\>sub(v<rsub|1>,v<rsub|2>)\<wedge\>(label<rsub|V>(v<rsub|1>)\<vee\><with|mode|text|wierzchoªek
    <with|mode|math|v<rsub|2>> nale»y do poddrzewa zaczepionego w
    <with|mode|math|n>-tym argumencie w¦zªa >v<rsub|1>)
  </equation*>

  \ <with|mode|math|>(Je±li <with|mode|math|n> jest wi¦ksze od arno±ci
  funkcji <with|mode|math|label(v<rsub|1>)>, to
  <with|mode|math|{v<rsub|2>\|argn<rsub|n>(v<rsub|1>,v<rsub|2>)}=
  \<varnothing\>}>).

  <\definition>
    Niech <with|mode|math|G=V(t)<mid|\\>{p\|label<rsub|V>(p)}>. Struktur¡
    <with|mode|math|Struct(t)> wyznaczon¡ przez drzewo typizowane
    <with|mode|math|t> nazywamy system relacyjny
    <with|mode|math|<left|langle>G,{label<rsub|k>\|k<with|mode|text| jest
    etykiet¡>}\<cup\>{sub}\<cup\>{argn<rsub|n>\|1\<leqslant\>n\<leqslant\><with|mode|text|maksymalna
    arno±¢ symb. funkcyjnych >t},\<varnothing\>,\<varnothing\><right|rangle>>
    (bez operacji i elementów wyró»nionych; relacje s¡ obci¦te do zbiorów
    <with|mode|math|G<rsup|n>>).
  </definition>

  <\definition>
    Monomorfizmem systemów relacyjnych <with|mode|math|\<b-A\>> i
    <with|mode|math|\<b-B\>> nazywamy ró»nowarto±ciowy silny homomorfizm,
    tzn. odwzorowanie <with|mode|math|h:A<above|\<longrightarrow\>|1-1>B>
    takie, »e <with|mode|math|r<rsup|A>(a<rsub|1>,\<ldots\>,a<rsub|n>)\<equiv\>r<rsup|B>(h(a<rsub|1>),\<ldots\>,h(a<rsub|n>))>.
  </definition>

  Definicja systemu relacyjnego i monomorfizmu, patrz <cite|logikaZbierski>.
  Zamysªem twierdzenia jest wskazanie, »e algorytm z <cite|hasker95> (a
  wªa±ciwie mój algorytm, na bazie struktury wyznaczonej przez Haskera)
  zwraca generalizacj¦, ale nie <with|mode|math|MSC<rsub|max>>.

  <\theorem>
    Je±li drzewo typizowane <with|mode|math|s> jest obj¦te przez drzewo
    typizowane <with|mode|math|t>, <with|mode|math|s\<trianglelefteq\>t>, to
    istnieje monomorfizm <with|mode|math|h> ze <with|mode|math|Struct(s)> do
    <with|mode|math|Struct(t)>, <with|mode|math|h[Struct(s)]\<leqslant\>Struct(t)>.
    Jednak je±li nawet istnieje monomorfizm <with|mode|math|h> ze
    <with|mode|math|Struct(s)> do <with|mode|math|Struct(t)>, to ci¡gle mo»e
    nie zachodzi¢ <with|mode|math|s<rprime|'>\<trianglelefteq\>t<rprime|'>>
    dla »adnych <with|mode|math|s<rprime|'>,t<rprime|'>:
    Struct(s)=Struct(s<rprime|'>),Struct(t)=Struct(t<rprime|'>)>.
  </theorem>

  Przypomnijmy definicj¦: Typizowane drzewo <with|mode|math|s> jest obj¦te
  (ang. embedded) w t,

  <\eqnarray*>
    <tformat|<table|<row|<cell|s=f(s<rsub|1>,\<ldots\>,s<rsub|m>)>|<cell|\<trianglelefteq\>>|<cell|g(t<rsub|1>,\<ldots\>,t<rsub|n>)=t>>>>
  </eqnarray*>

  je±li zachodzi dowolny z nast¦puj¡cych warunków:

  <\enumerate>
    <item><with|mode|math|s\<trianglelefteq\>t<rsub|i>,<space|2fn>\<exists\>i\<in\>{1,\<ldots\>,n}>

    <item><with|mode|math|label(f)=label(g),
    <space|2em>s<rsub|i>\<trianglelefteq\>t<rsub|i><space|2fn>\<forall\>i\<in\>{1,\<ldots\>,n}>

    <item><with|mode|math|f> jest zmienn¡, oraz, dla pewnej injekcji
    <with|mode|math|\<phi\>> z <with|mode|math|{1,\<ldots\>,m}> do
    <with|mode|math|{1,\<ldots\>,n}>, <with|mode|math|s<rsub|i>\<trianglelefteq\>t<rsub|\<phi\>(i)><space|0.6spc>\<forall\>i\<in\>{1,\<ldots\>,m}>.
  </enumerate>

  <\proof>
    Cz¦±¢ <with|mode|math|s\<trianglelefteq\>t\<Longrightarrow\>h[Struct(s)]\<leqslant\>Struct(t)>.
    Niech drzewa typizowane speªniaj¡ <with|mode|math|s\<trianglelefteq\>t>.
    Przeprowad¹my indukcj¦ ze wzgl¦du na rozmiar <with|mode|math|t>.

    Niech <with|mode|math|t> b¦dzie li±ciem. Wtedy <with|mode|math|s> jest
    li±ciem, mo»e zachodzi¢ 2. lub 3. punkt definicji obejmowania. Je±li
    <with|mode|math|f> jest zmienn¡, to monomorfizm jest trywialny (pusty). W
    przeciwnym przypadku <with|mode|math|label(s/1)=label(t/1)> i wszystkie
    relacje si¦ pokrywaj¡, <with|mode|math|h(s/1)=t/1> jest monomorfizmem.

    Niech teraz <with|mode|math|g(t<rsub|1>,\<ldots\>,t<rsub|n>)=t,n\<geqslant\>1>.
    Je±li zachodzi punkt 1. definicji obejmowania, to monomorfizm mamy z zaª.
    ind.

    Je±li zachodzi punkt 2., to z zaª. ind. mamy <with|mode|math|n>
    monomorfizmów, które skªadamy razem i dodajemy <with|mode|math|h(f)=g>
    otrzymuj¡c monomorfizm ze <with|mode|math|Struct(s)> w
    <with|mode|math|Struct(t)>. Wida¢ zgodno±¢ relacji
    <with|mode|math|label<rsub|k>> i <with|mode|math|sub>, natomiast zgodno±¢
    relacji <with|mode|math|argn<rsub|i>> wynika st¡d, »e sparowane s¡
    odpowiednie <with|mode|math|s<rsub|i>> oraz <with|mode|math|t<rsub|i>>.

    Je±li zachodzi punkt 3., to z zaª. ind. mamy <with|mode|math|n>
    monomorfizmów dla podsystemów <with|mode|math|Struct(s<rsub|i>)> w
    <with|mode|math|Struct(t<rsub|\<phi\>(i)>)>. Relacje <with|mode|math|sub>
    i <with|mode|math|argn<rsub|l>> nie zachodz¡ dla »adnych par z
    <with|mode|math|Struct(s<rsub|i>)\<times\><with|mode|text|<with|mode|math|Struct(s<rsub|j>)>>,i\<neq\>j>,
    ani dla »adnych par z <with|mode|math|Struct(t<rsub|i>)\<times\><with|mode|text|<with|mode|math|Struct(t<rsub|j>)>>,i\<neq\>j>,
    a no±nikiem <with|mode|math|Struct(s)> jest suma no±ników
    <with|mode|math|Struct(s<rsub|i>)>, wi¦c skªadaj¡c otrzymane
    <with|mode|math|n> monomorfizmów otrzymujemy szukany monomorfizm.

    Cz¦±¢ <with|mode|math|s\<trianglelefteq\>t <neg|\<Longleftarrow\>>
    h[Struct(s)]\<leqslant\>Struct(t)>. Niech b¦dzie dany monomorfizm
    <with|mode|math|h> ze <with|mode|math|Struct(s)> w
    <with|mode|math|Struct(t)>. Przeprowad¹my prób¦ indukcji ze wzgl¦du na
    liczebno±¢ no±nika <with|mode|math|Struct(t)>.

    Niech no±nik <with|mode|math|Struct(t)> b¦dzie pusty. Wymusza to, »e
    no±nik <with|mode|math|Struct(s)> te» jest pusty. Obierzmy jako
    <with|mode|math|s<rprime|'>> drzewo puste, wtedy
    <with|mode|math|s<rprime|'>\<trianglelefteq\>t<rprime|'>=t>.

    Je±li no±nik <with|mode|math|Struct(s)> jest pusty, obierzmy jako
    <with|mode|math|s<rprime|'>> drzewo puste, wtedy
    <with|mode|math|s<rprime|'>\<trianglelefteq\>t<rprime|'>=t>.

    Niech <with|mode|math|s=f(s<rsub|1>,\<ldots\>,s<rsub|m>),g(t<rsub|1>,\<ldots\>,t<rsub|n>)=t>.
    Je±li <with|mode|math|f> nie jest zmienn¡ oraz <with|mode|math|h(f)=g>,
    obieramy punkt 2. derywacji i podderywacje obejmowania mieliby±my z
    zaªo»enia indukcyjnego: poniewa» <with|mode|math|h> jest zgodna z
    <with|mode|math|argn<rsub|i>>, wi¦c jest homomorfizmem podsystemów
    <with|mode|math|Struct(s<rsub|i>)> w <with|mode|math|Struct(t<rsub|i>)>.
    Tez¦ mieliby±my dla <with|mode|math|s<rprime|'>=f(s<rsub|1><rprime|'>,\<ldots\>,s<rsub|m><rprime|'>),g(t<rsub|1><rprime|'>,\<ldots\>,t<rsub|n><rprime|'>)=t<rprime|'>>.

    Je±li <with|mode|math|h(f)\<neq\>g>, to obieramy punkt 1. derywacji dla
    odpowiednich poddrzew <with|mode|math|t> tak dªugo, a» zejdziemy do
    podtermu o korzeniu <with|mode|math|t<rsup|1>/1=g<rsup|1>=h(f)>
    (pami¦tamy, »e <with|mode|math|h(f)\<in\>Struct(t)>). Poniewa»
    <with|mode|math|h> jest zgodna z <with|mode|math|sub>, wi¦c
    <with|mode|math|h[Struct(s)]\<subseteq\>Struct(t<rsup|1>)>, st¡d
    <with|mode|math|h> jest monomorfizmem <with|mode|math|Struct(s)> w
    <with|mode|math|Struct(t<rsup|1>)> i mo»emy wykorzysta¢ rezultat dany
    wy»ej (tzn. dla przypadku <with|mode|math|h(f)=g>) dla uzyskania
    potrzebnej podderywacji: niech zwrócone drzewa b¦d¡
    <with|mode|math|s<rprime|'>,t<rsup|1><rprime|'>>. Tez¦ mieliby±my dla
    <with|mode|math|s<rprime|'>,[t<rsup|1><rprime|'>/t<rsup|1>]t>.

    Je±li <with|mode|math|f> jest zmienn¡, to mo»emy obra¢ w derywacji
    relacji obejmowania punkt 1 lub 3. Potrzebujemy tak dobra¢ permutacje,
    aby pary: minimalna <with|mode|math|f<rsub|i>> nale»¡ca do no±nika
    <with|mode|math|Struct(s)> i <with|mode|math|h(f<rsub|i>)> si¦ spotkaªy.
    Jednak <with|mode|math|h> mo»e ª¡czy¢ minimalne
    <with|mode|math|f<rsub|i>> z dowolnie ulokowanymi nieporównywalnymi przez
    <with|mode|math|sub> podtermami <with|mode|math|t>.

    Dla przykªadu, niech <with|mode|math|x> b¦dzie zmienn¡ funkcyjn¡:

    <\eqnarray*>
      <tformat|<table|<row|<cell|s>|<cell|=>|<cell|x(a,b,c)>>|<row|<cell|t>|<cell|=>|<cell|f(a,g(b,c))>>>>
    </eqnarray*>

    Monomorfizm <with|mode|math|h(a<rsub|s>)=a<rsub|t>,h(b<rsub|s>)=b<rsub|t>,h(c<rsub|s>)=c<rsub|t>>,
    ale <with|mode|math|s<neg|\<trianglelefteq\>> t>.

    \;
  </proof>

  Maksymalne izomorficzne podsystemy to takie, które nie s¡ podsystemami
  innych izomorficznych podsystemów. Podobnie mo»na udowodni¢, »e:

  <\theorem>
    Zbiory z <with|mode|math|\<cal-M\>> wyznaczaj¡ izomorficzne podsystemy
    systemów relacyjnych <with|mode|math|Struct(s)> i
    <with|mode|math|Struct(t)>, dla ustalonych drzew typizowanych
    <with|mode|math|s> i <with|mode|math|t>. Jednak nie musz¡ to by¢
    maksymalne podsystemy izomorficzne.
  </theorem>

  Teraz przejd¹my do meritum:

  We¹my generalizacj¦ programów <with|mode|math|a> i <with|mode|math|b>.
  (Niech jej anty-instancja i podstawienia b¦d¡ w postaci normalnej, tzn. bez
  restruktorów wewn¡trz termów, tylko po prawej.) We wszystkich
  restruktorach, wyró»nijmy pewne wyst¡pienia zmiennych prawej strony tak,
  aby ka»dy restruktor byª liniowy je±li uwzgl¦dnia¢ tylko te wyst¡pienia
  (eliminacja powtórze«). Teraz dokonajmy podstawie« generalizacji i
  wyró»nijmy te wyst¡pienia symboli (w¦zªy drzewa), które pochodz¡ od
  korzenia anty-instancji, albo pochodz¡ od anty-instancji poprzez zmienn¡
  wyró»nion¡. Mo»na zauwa»y¢, »e ka»demu wyst¡pieniu symbolu w anty-instancji
  odpowiada identyfikowalne wyró»nione wyst¡pienie symbolu w uzyskanych z
  podstawienia programach (wyró»niony w¦zeª drzewa). To pozwala zbudowa¢
  odpowiednio±¢ mi¦dzy wyró»nionymi w¦zªami <with|mode|math|a> i
  <with|mode|math|b>. Nazwijmy j¡ odpowiednio±ci¡ przez uliniowienie.

  <\theorem>
    Ka»da odpowiednio±¢ przez uliniowienie dana przez generalizacj¦
    <with|mode|math|<left|langle>t,\<theta\><rsub|1>,\<theta\><rsub|2><right|rangle>
    >jest izomorfizmem odpowiednich podsystemów <with|mode|math|Struct(a)> i
    <with|mode|math|Struct(b)>. Podsystemy te s¡ izomorficzne z systemem
    relacyjnym <with|mode|math|Struct(t)>.
  </theorem>

  Pami¦tamy z definicji, »e zmienne s¡ usuwane z no±nika
  <with|mode|math|Struct(t)>.

  <\proof>
    Przeprowad¹my indukcj¦ wzgl¦dem struktury anty-instancji.

    Je±li w korzeniu anty-instancji jest staªa, to stosuj¡c zaª. ind. do
    bezpo±rednich podtermów <with|mode|math|a>, <with|mode|math|b> i
    anty-instancji (odpowiadaj¡cych sobie, tak, »e
    <with|mode|math|argn<rsub|i>> jest zachowana), otrzymujemy tez¦,
    przyjmuj¡c <with|mode|math|h(a/1)=b/1>, odpowiednio
    <with|mode|math|h<rsub|1>(a/1)=t/1,h<rsub|2>(b/1)=t/1>. (Je±li nie ma
    podtermów, to teza wynika natychmiast dla <with|mode|math|h(a/1)=b/1>,
    <with|mode|math|h<rsub|1>(a/1)=t/1,h<rsub|2>(b/1)=t/1>.)

    Je±li za± w korzeniu anty-instancji jest zmienna, to ustalamy, jakie
    zmienne restruktorów s¡ wyró»nione w podstawieniach. Nast¦pnie tworzymy
    trójki: argument zmiennej w korzeniu anty-instancji, podterm
    <with|mode|math|a> uzyskany z podstawienia tego argumentu pod zmienn¡
    wyró»nion¡ w podstawieniu daj¡cym <with|mode|math|a>, podterm
    <with|mode|math|b> tak samo. Stosujemy zaªo»enie indukcyjne do ka»dej
    trójki (z tymi samymi podstawieniami generalizacji). Szukany izomorfizm
    jest zªo»eniem otrzymanych izomorfizmów, wystarczy pokaza¢, »e s¡ zgodne.
    Ale je±li dwa w¦zªy le»¡ w dziedzinach ró»nych izomorfizmów, to le»¡ w
    rozª¡cznych podtermach, wi¦c <with|mode|math|argn<rsub|i>> ani
    <with|mode|math|sub> nie zachodzi mi¦dzy nimi; to samo dla dwóch w¦zªów w
    obrazach ró»nych izomorfizmów, w szczególno±ci dla obrazów wspomnianych
    w¦zªów z dziedzin. St¡d zªo»enie izomorfizmów jest izomorfizmem. (Dotyczy
    to wszystkich trzech izomorfizmów, równie» tych na
    <with|mode|math|Struct(t)>, poniewa» <with|mode|math|t/1> nie nale»y do
    no±nika.)
  </proof>

  <\theorem>
    Je±li pewna (dowolna) odpowiednio±¢ przez uliniowienie wyznacza
    maksymalne izomorficzne podsystemy, to generalizacja jest sprowadzalna do
    <with|mode|math|MSC(a,b)> przez co najwy»ej ª¡czenie zmiennych (reguªa
    Merge).
  </theorem>

  <\proof>
    Poka»emy, »e do tej generalizacji nie stosuje si¦ »adna, poza (Merge),
    reguªa spo±ród tych w definicji <reference|algMSC>, czyli

    <\enumerate>
      <item>(Delete)

      <\equation*>
        <frac|t,\<theta\><rsub|1>\<cup\>{s/f},\<theta\><rsub|2>\<cup\>{s/f}|{s/f}(t),\<theta\><rsub|1>,\<theta\><rsub|2>>
      </equation*>

      <item>(Merge) Dla obustronnie odwracalnego restruktora
      <with|mode|math|\<tau\>>

      <\equation*>
        <frac|t,\<theta\><rsub|1>\<cup\>{r/f,r\<tau\>/f<rprime|'>},\<theta\><rsub|2>\<cup\>{s/f,s\<tau\>/f<rprime|'>}|{f\<tau\>/f<rprime|'>}(t),\<theta\><rsub|1>\<cup\>{r/f},\<theta\><rsub|2>\<cup\>{s/f}>
      </equation*>

      <item>(Factor-Constant)

      <\equation*>
        <frac|t,\<theta\><rsub|1>\<cup\>{r(\<delta\><rsup|m>K\<mu\>(<wide|r<rsub|n>|\<vect\>>)\<cdot\>\<b-1\>)\<tau\>/f},\<theta\><rsub|2>\<cup\>{s(\<delta\><rsup|m<rprime|'>>K\<mu\>(<wide|s<rsub|n>|\<vect\>>)\<cdot\>\<b-1\>)\<tau\>/f}|{h*(K\<mu\>(<wide|h<rsub|n>|\<vect\>>)\<cdot\>\<b-1\>)\<tau\>/f}(t),\<theta\><rsub|1>\<cup\>{r(\<delta\><rsup|m>\<cdot\>\<b-1\>)/h,<wide|r<rsub|n>|\<vect\>>/<wide|h<rsub|n>|\<vect\>>},\<theta\><rsub|2>\<cup\>{s(\<delta\><rsup|m<rprime|'>>\<cdot\>\<b-1\>)/h,<wide|s<rsub|n>|\<vect\>>/<wide|h<rsub|n>|\<vect\>>}>
      </equation*>

      <item>(Factor-Restructor)

      <\equation*>
        <frac|t,\<theta\><rsub|1>\<cup\>{r\<tau\>/f},\<theta\><rsub|2>\<cup\>{s\<tau\>/f}|{h\<tau\>/f}(t),\<theta\><rsub|1>\<cup\>{r/h},\<theta\><rsub|2>\<cup\>{s/h}>
      </equation*>

      oraz <with|mode|math|\<tau\>> nie ma lewostronnego elementu odwrotnego.
    </enumerate>

    Zaªó»my, »e do generalizacji stosuje si¦ reguªa (Delete). We¹my dowoln¡
    odpowiednio±¢ przez uliniowienie. Ustalmy pewne wyst¡pienie zmiennej
    <with|mode|math|f> w anty-instancji. Poniewa» podsystemy tej
    odpowiednio±ci s¡ izomorficzne ze <with|mode|math|Struct(t)>, wi¦c
    miejsce w porz¡dku odpowiedniego wyst¡pienia <with|mode|math|s> w
    drzewach <with|mode|math|a> i <with|mode|math|b> jest takie samo w obydwu
    podsystemach. St¡d mo»na je rozszerzy¢ dodaj¡c odpowiednie wyst¡pienia
    <with|mode|math|s> i zachowuj¡c wªasno±¢ izomorfizmu, czyli nie jest on
    maksymalny.

    Teraz zaªó»my, »e do generalizacji stosuje si¦ reguªa (Merge). Je±li
    przed jej zastosowaniem »adna inna reguªa si¦ nie stosuje, to po
    zastosowaniu (Merge) te» nie b¦dzie si¦ stosowa¢, bo je±li stosuje si¦ do
    <with|mode|math|f> po (Merge), to stosuje si¦ te» do <with|mode|math|f>
    przed (Merge). St¡d sprowadzaj¡c dowolny generalizator skondensowany do
    generalizatora <with|mode|math|MSC>, mo»na najpierw stosowa¢ pozostaªe
    reguªy, a gdy »adna si¦ nie b¦dzie stosowa¢, same reguªy (Merge).

    Zaªó»my, »e do generalizacji stosuje si¦ reguªa (Factor-Constant).
    Ustalmy wyst¡pienie zmienej <with|mode|math|f>, podobnie jak w przypadku
    (Delete). Wybierzmy pierwsze spo±ród <with|mode|math|m>
    wyselekcjonowanych wyst¡pie« staªej <with|mode|math|K> z ustalonych
    pozycji w <with|mode|math|a>, podobnie pierwsze spo±ród
    <with|mode|math|m<rprime|'>> wyst¡pie« w <with|mode|math|b>. Ze wzgl¦du
    na to, »e staªa <with|mode|math|K> ma tak¡ sam¡ struktur¦ argumentów w
    obu podstawieniach w tych wyst¡pieniach, ma dokªadnie te same elementy
    ponad ze wzgl¦du na relacje <with|mode|math|sub> i
    <with|mode|math|argn<rsub|i>> w obu podsystemach odpow. z
    <with|mode|math|a> i z <with|mode|math|b> izomorficznych ze
    <with|mode|math|Struct(t)>. Oczywi±cie ma te» te same elementy pod (s¡ to
    elementy <with|mode|math|Struct(t)> pod <with|mode|math|f> w
    <with|mode|math|t>); st¡d izomorfizm mo»na rozszerzy¢ o odwzorowanie tych
    wyst¡pie« <with|mode|math|K>, nie jest wi¦c maksymalny.

    Zaªó»my, »e do generalizacji stosuje si¦ reguªa (Factor-Restructor).
    Reguªa ta oznacza, »e pewne argumenty anty-instancji zostan¡ powielone.
    Ustalmy dowoln¡ odpowiednio±¢ przez uliniowienie. Ustalmy jeden z
    argumentów, który ma by¢ powielony w wyniku reguªy. Oznacza to, »e w
    restruktorze ma on co najmniej dwa wyst¡pienia po prawej. Wybierzmy po
    jednym niewyró»nionym wyst¡pieniu w ka»dym z podstawie«. Mo»emy teraz
    rozszerzy¢ izomorfizm, chocia»by odwzorowuj¡c korze« podtermu
    <with|mode|math|a> odpowiadaj¡cego argumetnowi wybranego podstawienia w
    tak okre±lony w¦zeª <with|mode|math|b>. To zachowa izomorfizm, poniewa»
    odwzorowane w¦zªy nie maj¡ niczego ponad w podsystemach do których b¦d¡
    dodane, a pod maj¡ to, co ``pod zmienn¡ <with|mode|math|f>''.
  </proof>

  <paragraph|Zagadnienia praktyczne.>Powy»sze twierdzenie podpowiada, »e
  mo»na szuka¢ maksymalnych izomorficznych podsystemów »eby znale¹¢
  <with|mode|math|MSC(a,b)>; po znalezieniu izomorfizmu rekonstruujemy
  anty-instancj¦, która b¦dzie liniowa; nast¦pnie ª¡czymy zmienne i
  ``kompresujemy skrawki'' algorytmem <with|mode|math|A<rsub|p>>.

  Jednak dla potrzeb programowania genetycznego, wªa±nie taka generalizacja,
  liniowa wzgl¦dem meta-zmiennych generalizacji i
  <with|mode|math|\<lambda\>>-abstrakcji generalizacji, wydaje si¦
  odpowiednia.

  Mo»liwo±¢ okre±lenia efektywnego algorytmu znajdowania maksymalnej wspólnej
  podstruktury w ogólnym przypadku zale»y od systemu; nie mo»e by¢ zbyt
  bogaty w ''niestrukturalny'' sposób. Relacje mog¡ np. wyznacza¢ jakie±
  uporz¡dkowanie, pozwalaj¡ce na zastosowanie programowania dynamicznego, jak
  tutaj relacja <with|mode|math|sub>.

  Okre±lenie generalizacji a nast¦pnie rekombinacji w terminologii
  podstruktur ma du»e znaczenie dla programowania genetycznego, i szerzej dla
  syntezy (czy wnioskowania) indukcyjnej i analogicznej. Wiele (by¢ mo»e
  wi¦kszo±¢) skutecznych zastosowa« GP wykorzystuje struktury bliskie
  problemowi: struktury grafowe i ``wariacje na ich temat'', np. zastosowania
  w projektowaniu obwodów elektrycznych filtruj¡cych (sukcesy promowane przez
  Koz¦), anten do telefonów komórkowych, stworze« poruszaj¡cych si¦ w
  ±rodowisku fizycznym (system Framsticks opracowywany na UAM w Poznaniu; GP
  konstruuje budow¦ fizyczn¡ stworzenia i budow¦ jego mózgu). Obecnie
  wykorzystywane w tych systemach operatory rekombinacji najcz¦±ciej dokonuj¡
  przypadkowej wymiany fragmentów reprezentacji. Dla przykªadu, w systemie
  Framsticks trzeba sztucznie ograniczy¢ rekombinacj¦ do wymiany wag w sieci
  neuronowej, aby zapobiec psuciu przez rekombinacj¦ dobrze dostosowanych
  struktur neuronalnych.

  <paragraph|Uwaga natury teoretycznej.>Odpowiednio±¢ mi¦dzy generalizacjami
  a maksymalnymi izomorficznymi podstrukturami (podsystemami) wynika st¡d, »e
  generalizacja to anty-instancja \ o r a z \ podstawienia. Generalizacja
  b¦d¡ca <with|mode|math|MSC> mo»e mie¢ nie najbardziej specyficzn¡
  anty-instancj¦. Oznacza to, »e maksymalne izomorficzne podsystemy
  <with|mode|math|s<rprime|'>\<sim\>t<rprime|'>,s<rprime|'>\<less\>s,t<rprime|'>\<less\>t>
  mog¡ by¢ parami izomorficzne z izomorficznymi podsystemami
  <with|mode|math|s<rprime|'>\<sim\>s<rprime|''>,t<rprime|'>\<sim\>t<rprime|''>,s<rprime|''>\<less\>s,t<rprime|''>\<less\>t>,
  dla których istniej¡ <with|mode|math|s<rprime|'''>\<sim\>t<rprime|'''>,s<rprime|''>\<less\>s<rprime|'''>\<leqslant\>s,t<rprime|''>\<less\>t<rprime|'''>\<leqslant\>t>.

  <subsubsection|Znajdowanie maksymalnych izomorficznych podsystemów.>

  Najprostszym sposobem znajdowania maksymalnych izomorficznych podsystemów
  jest:

  <\code>
    <with|mode|math|C> := zbiór par pozycji o tych samych etykietach

    <with|mode|math|M> := <with|mode|math|\<varnothing\>>

    dopóki <with|mode|math|C\<neq\>\<varnothing\>>

    \ \ wybierz <with|mode|math|(p,q)\<in\>C>

    \ \ je±li dla wszystkich <with|mode|math|(p<rprime|'>,q<rprime|'>)\<in\>M>

    \ \ \ \ <with|mode|math|(sub(p,p<rprime|'>)\<equiv\>sub(q,q<rprime|'>))\<wedge\><big|wedge><rsub|1\<leqslant\>i\<leqslant\>ar(p)>argn<rsub|i>(p,p<rprime|'>)\<equiv\>argn<rsub|i>(q,q<rprime|'>)>

    \ \ to <with|mode|math|M> := <with|mode|math|M\<cup\>{(p,q)}>

    \ \ <with|mode|math|C> := <with|mode|math|C<mid|\\>{(p,q)}>

    zwró¢ <with|mode|math|M>
  </code>

  Ma on zªo»ono±¢ <with|mode|math|O(n<rsup|4>)>, gdzie <with|mode|math|n>
  jest sum¡ dªugo±ci generalizowanych termów: najpierw generowanych jest
  mniej ni» <with|mode|math|n<rsup|2>> par, nast¦pnie dla ka»dej z nich
  dokonywanych jest mniej ni» <with|mode|math|n<rsup|2>> sprawdze«. Zalet¡
  tego algorytmu jest, »e mo»na uwzgl¦dni¢ preferencje co do wybieranych par.
  W przypadku programowania genetycznego mo»na np. preferowa¢ pary pozycji,
  dla których podejrzewa si¦ \Rto»samo±¢ genealogiczn¡'' (pochodzenie od
  wspólnego przodka).

  Wprowad¹my oznaczenia: par¦ <with|mode|math|(p,q)\<in\>C> nazywamy
  Pareto-maksymaln¡ w <with|mode|math|C> je±li

  <\equation*>
    \<neg\>(\<exists\>(p<rprime|'>,q<rprime|'>)\<in\>C)
    p<rprime|'>\<neq\>p\<wedge\>q<rprime|'>\<neq\>q\<wedge\>sub(p,p<rprime|'>)\<wedge\>sub(q,q<rprime|'>)
  </equation*>

  \;

  Odpowiednio definiuje si¦ par¦ Pareto-minimaln¡ w <with|mode|math|C>.
  Wprowadzimy teraz wydajniejsze algorytmy. Algorytm, przetwarzaj¡cy pozycje
  od li±ci ku korzeniowi:

  <\code>
    <with|mode|math|C> := zbiór par pozycji o tych samych etykietach

    <with|mode|math|M> := <with|mode|math|\<varnothing\>>

    dopóki <with|mode|math|C\<neq\>\<varnothing\>>

    \ \ 1: wybierz <with|mode|math|(p,q)> Pareto-maksymaln¡ w
    <with|mode|math|C>

    \ \ 2: <with|mode|math|C> := <with|mode|math|C<mid|\\>{(p<rprime|'>,q<rprime|'>)\|sub(p,p<rprime|'>)\<vee\>sub(q,q<rprime|'>)}>

    \ \ 3: <with|mode|math|C> := <with|mode|math|C<mid|\\>{(p<rprime|'>,q<rprime|'>)\|(\<exists\>i)
    argn<rsub|i>(p<rprime|'>,p)\<nequiv\>argn<rsub|i>(q<rprime|'>,q)}>

    \ \ <with|mode|math|M> := <with|mode|math|M\<cup\>{(p,q)}>

    zwró¢ <with|mode|math|M>
  </code>

  Algorytm przetwarzaj¡cy pozycje od korzenia ku li±ciom (odpowiada
  klasycznym rekurencyjnym sformuªowaniom generalizacji termów):

  <\code>
    przetwórz(<with|mode|math|C>) =

    \ \ <with|mode|math|M> := <with|mode|math|\<varnothing\>>

    \ \ dopóki <with|mode|math|C\<neq\>\<varnothing\>>

    \ \ \ \ 1: wybierz <with|mode|math|(p,q)> Pareto-minimaln¡ w
    <with|mode|math|C>

    \ \ \ \ dla i=1 do <with|mode|math|ar(p)>

    \ \ \ \ \ \ 2: <with|mode|math|M> := <with|mode|math|M\<cup\>>przetwórz(<with|mode|math|><with|mode|math|{(p<rprime|'>,q<rprime|'>)\<in\>C\|
    (\<exists\>i) argn<rsub|i>(p,p<rprime|'>)\<wedge\>argn<rsub|i>(q,q<rprime|'>)}>)

    \ \ \ \ 3: <with|mode|math|C> := <with|mode|math|C<mid|\\>{(p<rprime|'>,q<rprime|'>)\|sub(p,p<rprime|'>)\<vee\>sub(q,q<rprime|'>)}>

    \ \ zwró¢ <with|mode|math|M>

    \;

    <with|mode|math|C> := zbiór par pozycji o tych samych etykietach

    zwró¢ przetwórz(<with|mode|math|C>)
  </code>

  Algorytm od-korzenia-ku-li±ciom ªatwo zaimplementowa¢ wydajniej -- ze
  zªo»ono±ci¡ <with|mode|math|O(n<rsup|2>)>. Zbiór <with|mode|math|C> mo»na
  generowa¢ w sposób leniwy z poddrzew <with|mode|math|s,t:
  C\<subset\>s\<times\>t>, poniewa» operacje na przynale»no±ci do tego zbioru
  to 3: usuwanie poddrzew oraz 2: przekazywanie poddrzew do dalszego
  przetwarzania. Wystarczy opracowa¢ mechanizm wyboru (punkt 1) nie
  przetwarzaj¡cy par wielokrotnie. Mo»na to zrobi¢ przechowuj¡c przetworzone
  poddrzewa <with|mode|math|S,T>: <with|mode|math|S\<ni\>s<rprime|'>>
  (odpowiednio <with|mode|math|T\<ni\>t<rprime|'>>) oraz w pojedynczym kroku
  dodawa¢ w¦zeª <with|mode|math|p> do <with|mode|math|s<rprime|'>> lub
  <with|mode|math|q> do <with|mode|math|t<rprime|'>> i szuka¢
  <with|mode|math|q> (odpowiednio <with|mode|math|p>) w
  <with|mode|math|t<rprime|'>\<in\>T> (odpowiednio w
  <with|mode|math|s<rprime|'>\<in\>S>) o tej samej etykiecie; po znalezieniu,
  zast¡pi¢ <with|mode|math|t<rprime|'>> w <with|mode|math|T> przez poddrzewa
  powstaªe przez usuni¦cie z <with|mode|math|t<rprime|'>> w¦zªów od korzenia
  <with|mode|math|t<rprime|'>> do w¦zªa <with|mode|math|q> (odpowiednio dla
  przypadku <with|mode|math|s<rprime|'>,S,p>).

  <\theorem>
    Powy»sze algorytmy generuj¡ izomorfimy maksymalnych izomorficznych
    podsystemów.
  </theorem>

  Konstrukcja generalizacji ograniczonych do <with|mode|math|MSC<rsub|max>>,
  a wi¦c nie tylko maksymalnie specyficznych, ale i najwi¦kszych rozmiarem,
  jest trudniejsza. Przy przetwarzaniu od-li±ci-ku-korzeniowi mo»emy
  zastosowa¢ metod¦ programowania dynamicznego: najlepiej dopasowane drzewa
  maj¡ te» najlepiej dopasowane poddrzewa. Jednak nale»y uwzgl¦dni¢ wszystkie
  mo»liwe dopasowania powy»ej przetwarzanej pary. Dla zbioru
  <with|mode|math|C> wszystkich par pozycji o takich samych etykietach:

  <\verse>
    Gdy wszystkie pary z <with|mode|math|C> powy»ej
    <with|mode|math|(p,q)\<in\>C> zostaªy ju» ocenione, skonstruuj wszystkie
    maksymalnie liczne zbiory par Pareto-minimalnych z

    <\equation*>
      {(p<rprime|'>,q<rprime|'>)\<in\>C\| (\<exists\>i)
      argn<rsub|i>(p,p<rprime|'>)\<wedge\>argn<rsub|i>(q,q<rprime|'>)}
    </equation*>

    takich, »e elementy par w konstruowanym zbiorze s¡ nieporównywalne, oce«
    zbiory na sum¦ ocen nale»¡cych do nich par, oce« <with|mode|math|(p,q)>
    na maksimum z ocen skonstruowanych zbiorów plus jeden. Skojarz z par¡
    <with|mode|math|(p,q)> zbiór, dla którego zachodzi maksimum, na potrzeby
    rekonstrukcji izomorfizmu.
  </verse>

  Niestety, nawet przy wydajnej implementacji algorytm oparty na powy»szej
  regule b¦dzie miaª du»¡ zªo»ono±¢ obliczeniow¡. Pozostaje mie¢ nadziej¦, »e
  w praktycznych przypadkach zbiory par Pareto-minimalnych z
  <with|mode|math|{(p<rprime|'>,q<rprime|'>)\<in\>C\| (\<exists\>i)
  argn<rsub|i>(p,p<rprime|'>)\<wedge\>argn<rsub|i>(q,q<rprime|'>)}> dla
  danych <with|mode|math|p,q> nie b¦d¡ bardzo liczne.

  <subsubsection|Rozszerzanie generalizacji na
  <with|mode|math|\<lambda\>>-termy z definicjami lokalnymi i
  rekurencyjnymi.>\ 

  Anty-unifikacja z poprzednich podrozdziaªªów bezpo±rednio przenosi si¦ na
  przypadek definicji lokalnych, poniewa» w reprezentacji grafowej wyznaczaj¡
  one ci¡gle relacj¦ porz¡dku. Natomiast zastosowanie do definicji
  rekurencyjnych wymaga dalszych bada«, ale wi¡»e si¦ z prowadzonymi przez
  innych badaniami nad indukcj¡ funkcji rekurencyjnych.

  <subsubsection|Zgodno±¢ z systemem typów.>

  Opracowanie algorytmu z obsªug¡ zmiennych zwi¡zanych w j¦zyku (w
  przeciwie«stwie do meta-zmiennych) na wzór potraktowania ich w pierwszym
  podrozdziale, oraz opracowanie rekombinacji zgodnej z systemem typów, to
  zadanie na blisk¡ przyszªo±¢.

  <chapter|Zako«czenie>

  <section|Wkªad pracy.>

  Postawione zadanie: Perspektywy programowania genetycznego w j¦zykach
  typizowanych -- postanowiªem rozpatrze¢ od strony teoretycznej,
  umieszczaj¡c zagadnienia GP w nowym dla nich kontekscie syntezy dedukcyjnej
  i indukcyjnej programów.

  We wprowadzeniu przedstawiªem tematyk¦ pracy, jej cele, oraz szerszy
  kontekst, w tym zwi¡zki z teori¡ ewolucji darwinowskiej (poj¦cie genu jako
  jednostki selekcji).

  W pierwszej cz¦±ci pracy (rozdziaª <reference|generowanie>) zajmowaªem si¦
  zagadnieniami syntezy dedukcyjnej. Wskazaªem na zwi¡zek syntezy dedukcyjnej
  z inferencj¡ typów i postawione jej wyzwanie: inferowa¢ peªn¡ specyfikacj¦
  logiczn¡ konstruowanego programu. Opracowaªem algorytmy generowania
  programów dla j¦zyka ML (system typów Damasa-Milnera) o charakterze
  teoretycznym, z peªnymi dowodami poprawno±ci
  (<with|font-shape|italic|algorytm<with|mode|math|\<subseteq\>>j¦zyk>) i
  peªno±ci (<with|font-shape|italic|j¦zyk<with|mode|math|\<subseteq\>>algorytm>).
  Algorytmy te uwypuklaj¡ analogi¦ generowania termów i inferencji typów.
  Przedstawiªem system typów <with|mode|math|\<lambda\><wide| |^>>
  kontroluj¡cy rekurencj¦ (zapewniaj¡cy wªasno±¢ stopu), razem z algorytmem
  generowania programów. Wskazaªem na praktyczny mechanizm generowania
  termów: metod¦ rezolucji. Wskazaªem na najodpowiedniejszego moim zdaniem
  kandydata na j¦zyk dla programowania genetycznego: j¦zyk
  <with|mode|math|HMG(X)>, przy czym uproszczony przez rezygnacj¦ z peªnego
  dopasowywania wzorca. Podaªem proste sformuªowanie ``podatnego'' na metod¦
  rezolucji j¦zyka pozwalaj¡cego na kodowanie specyfikacji wyra»alnych
  mechanizmem unifikacji. Wspomniaªem tak»e o bardzo istotnym zagadnieniu
  maksymalizacji ``code reuse'' poprzez elastyczne mechanizmy wprowadzania
  definicji lokalnych.

  W drugiej cz¦±ci pracy (rozdziaª <reference|rekombinacja>) zaj¡ªem si¦
  kluczowym zagadnieniem syntezy indukcyjnej: generalizacj¡. Generalizacja ma
  szerokie zastosowania, natomiast zastosowanie jej, w postaci
  anty-unifikacji, jako techniki rekombinacji w programowaniu genetycznym
  jest nowatorskie. W usytuowaniu szeroko rozumianych algorytmów genetycznych
  u»ywano (w pewnym sensie) generalizacji dla rekombinacji, w postaci
  rekombinacji zachowuj¡cej maksymalne wspólne schematy.

  W kontekscie zªo»onych systemów typów zagadnienie znalezienia swego rodzaju
  homomorfizmu typizowa«, pozwalaj¡cego wymienia¢ fragmenty programów, jest
  trudnym zadaniem. Nie wydaje si¦ rozs¡dne po±wi¦ca¢ energii na poszukiwanie
  homomorfizmu typizowa« dla czego± tak przypadkowego jak rekombinacja
  swobodna; anty-unifikacja proponuje bardziej rozs¡dne pozycje dla
  rekombinacji. Opracowaªem syntaktyczny algorytm anty-unifikacji obsªuguj¡cy
  wi¡zania zmiennych (kontekst); jest on syntaktycznie mocniejszy (po prostej
  modyfikacji dodaj¡cej permutacj¦ kontekstu) od pozostaªych przytoczonych
  podej±¢ do anty-unifikacji, ale dziaªa w j¦zyku nietypizowanym. Aby
  zastosowa¢ ten algorytm dla rekombinacji termów typizowanych (ale bez
  annotacji typami w termach) opracowaªem algorytm inferencji typów daj¡cy
  typizacj¦ dla ka»dego poprawnego dziecka danej pary rodziców, okre±laj¡cy,
  które dzieci s¡ poprawnie typizowane.

  Z my±l¡ o przyszªych zastosowaniach do rekombinacji programów bogato
  wykorzystuj¡cych definicje lokalne, zaj¡ªem si¦ peªn¡ syntaktyczn¡
  unifikacj¡ drugiego rz¦du. Znakomite sformuªowanie generalizacji w j¦zyku
  kombinatorów zawiera praca Haskera. Praca nie zawiera bezpo±redniego
  sformuªowania algorytmu znajduj¡cego generalizacje, który dostarczyªem dla
  opracowanego tam praktycznego algorytmu konstrukcji anty-instancji.
  Pokazaªem, »e opracowany w tezie Haskera algorytm praktyczny nie jest tak
  mocny, jak si¦ tam stwierdza: nie daje anty-instancji dla maksymalnie
  specyficznych generalizacji. Znalazªem obrazowe podej±cie do zagadnienia
  anty-unifikacji drugiego rz¦du, które uogólnia si¦ na dowolne systemy
  relacyjne: zadanie znajdowania maksymalnych izomorficznych podstruktur
  generalizowanych struktur. Zaproponowaªem algorytm rozwi¡zuj¡cy to zadanie
  oraz przedstawiªem problem maksymalizacji rozmiaru szukanych podstruktur,
  odpowiadaj¡cy problemowi znajdowania <with|mode|math|MSC<rsub|max>> z
  rozdziaªu 6 pracy <cite|hasker95>.

  <section|Postawione zadania.>

  Przeprowadzone badania wskazaªy kilka problemów, które trzeba b¡d¹ warto
  rozwi¡za¢, nim przyst¡pi si¦ do implementacji systemu programowania
  genetycznego opartego o systemy typów bardziej zªo»one ni» system
  Curry'ego-Hindley'a (patrz <cite|henglein93type>).

  Pierwszym obszernym zadaniem jest stworzenie systemu GP optymalizuj¡cego
  ``code reuse''; jest ono ±ci±le zwi¡zane z wynikªym problemem (raczej
  technicznym), inferencji najogólniejszego typu jednocze±nie z typem
  konkretyzuj¡cym zadany.

  Drugim zadaniem jest peªna inferencja typu dla <with|mode|math|HMG(X)>
  poprzez wykorzystanie mechanizmów inferencji typu dla rekurencji
  polimorficznej. Na bazie inferencji typu nale»y skonstruowa¢ algorytm
  generuj¡cy programy <with|mode|math|HMG(X)>.

  Trzecim zadaniem jest zbadanie zªo»ono±ci obliczeniowej problemu
  znajdowania generalizacji z <with|mode|math|MSC<rsub|max>>.

  Czwartym zadaniem jest dokonanie dla peªnej anty-unifikacji drugiego rz¦du
  tego, czego podrozdziaª <reference|antyunif1rz> dokonuje dla
  anty-unifikacji pierwszego rz¦du: wprowadzenie obsªugi zmiennych
  zwi¡zanych, opracowanie algorytmu inferencji typu dla rekombinantów.

  Pozostaje do zbadania szeroka klasa dziedzin zwi¡zanych z generowaniem
  termów: teorii rezolucji i programowania w logice, programowania wi¦zów,
  poszukiwania dowodów i interaktywnego dowodzenia, dla spo»ytkowania w
  teorii programowania genetycznego.

  Nie wolno te» zapomina¢, »e teoria jest wst¦pem do praktyki.

  <\bibliography|bib|plain|/home/luki/praca/biblio.bib>
    <\bib-list|10>
      <bibitem*|1><label|bib-altenberg94evolvability>Lee Altenberg.
      <newblock>The evolution of evolvability in genetic programming.
      <newblock>In <with|font-shape|italic|Advances in Genetic Programming>,
      1994.

      <bibitem*|2><label|bib-blickle94genetic>Tobias Blickle and Lothar
      Thiele. <newblock>Genetic programming and redundancy. <newblock>In
      J.<nbsp>Hopf, editor, <with|font-shape|italic|Genetic Algorithms within
      the Framework of Evolutionary Computation (Workshop at KI-94,
      Saarbrücken)>, pages 33--38, Im Stadtwald, Building 44, D-66123
      Saarbrücken, Germany, 1994. Max-Planck-Institut für Informatik
      (MPI-I-94-241).

      <bibitem*|3><label|bib-dawkins>Richard Dawkins.
      <newblock><with|font-shape|italic|Samolubny gen>. <newblock>Proszynski
      i S-ka, 1996.

      <bibitem*|4><label|bib-dhaeseleer94context>Patrik D'haeseleer.
      <newblock>Context preserving crossover in genetic programming.
      <newblock>In <with|font-shape|italic|Proceedings of the 1994 IEEE World
      Congress on Computational Intelligence>, volume<nbsp>1, pages 256--261,
      Orlando, Florida, USA, 27-29 1994. IEEE Press.

      <bibitem*|5><label|bib-galmiche00proofsearch>Didier Galmiche and
      David<nbsp>J. Pym. <newblock>Proof-search in type-theoretic languages:
      an introduction. <newblock><with|font-shape|italic|Theoretical Computer
      Science>, 232(1--2):5--53, 2000.

      <bibitem*|6><label|bib-goldberg>David<nbsp>E. Goldberg.
      <newblock><with|font-shape|italic|Algorytmy genetyczne i ich
      zastosowania>. <newblock>Wydawnictwa Naukowo-Techniczne, Warszawa,
      1995.

      <bibitem*|7><label|bib-hasker95>Robert<nbsp>W. Hasker.
      <newblock><with|font-shape|italic|The Replay of Program Derivations>.
      <newblock>PhD thesis, University of Illinois at Urbana-Champaign, 1995.

      <bibitem*|8><label|bib-henglein93type>Fritz Henglein. <newblock>Type
      inference with polymorphic recursion.
      <newblock><with|font-shape|italic|ACM Transactions on Programming
      Languages and Systems>, 15(2):253--289, April 1993.

      <bibitem*|9><label|bib-lu-generalization>Masaami<nbsp>Hagiya
      Jianguo<nbsp>Lu, Masateru<nbsp>Harao. <newblock>Generalization in
      <with|mode|math|\<lambda\>2>. <newblock>In <with|font-shape|italic|5th
      Workshop on Logic, Language, Information and Computation>, Sao Paulo,
      Brazil, July 1998.

      <bibitem*|10><label|bib-koza92>John<nbsp>R. Koza.
      <newblock><with|font-shape|italic|Genetic Programming: On the
      Programming of Computers by Means of Natural Selection>. <newblock>MIT
      Press, 1992.

      <bibitem*|11><label|bib-leroy92polymorphic>Xavier Leroy.
      <newblock>Polymorphic typing of an algorithmic language.
      <newblock>Technical report, INRIA, 1992.

      <bibitem*|12><label|bib-pfenning91unification>Frank Pfenning.
      <newblock>Unification and anti-unification in the Calculus of
      Constructions. <newblock>In <with|font-shape|italic|Sixth Annual IEEE
      Symposium on Logic in Computer Science>, pages 74--85, Amsterdam, The
      Netherlands, 1991.

      <bibitem*|13><label|bib-radcliffe92algebra>Nicolas<nbsp>J. Radcliffe.
      <newblock>The algebra of genetic algorithms. <newblock>Technical Report
      TR92-11, Edinburgh Parallel Computing Centre, University of Edinburgh,
      1992.

      <bibitem*|14><label|bib-nagano-proof>Daisuke<nbsp>Nagano
      Sachio<nbsp>Hirokawa. <newblock>Long normal form proof search and
      counter-model generation. <newblock><with|font-shape|italic|Electronic
      Notes in Theoretical Computer Science>, 37:1--11, 2001.

      <bibitem*|15><label|bib-ute-inductive>Ute Schmid.
      <newblock><with|font-shape|italic|Inductive Synthesis of Functional
      Programs, Universal Planning, Folding of Finite Programs, and Schema
      Abstraction by Analogical Reasoning>. <newblock>Springer, 2003.

      <bibitem*|16><label|bib-simonet03constraintbased>V.<nbsp>Simonet and
      F.<nbsp>Pottier. <newblock>Constraint-based type inference for guarded
      algebraic data types. <newblock>Research Report 5462, INRIA, January
      2005.

      <bibitem*|17><label|bib-xi01dependent>Hongwei Xi. <newblock>Dependent
      types for program termination verification. <newblock>In
      <with|font-shape|italic|16th Symposium on Logic in Computer Science>,
      pages 169--180, Florence, September 2001.

      <bibitem*|18><label|bib-tinayu99>Gwoing<nbsp>Tina Yu.
      <newblock><with|font-shape|italic|An Analysis of the Impact of
      Functional Programming Techniques on Genetic Programming>.
      <newblock>PhD thesis, University College, London, Gower Street, London,
      WC1E 6BT, 1999.

      <bibitem*|19><label|bib-logikaZbierski>Pawel<nbsp>Zbierski
      Zofia<nbsp>Adamowicz. <newblock><with|font-shape|italic|Logika
      matematyczna>. <newblock>Panstwowe Wydawnictwo Naukowe, Warszawa, 1991.
    </bib-list>
  </bibliography>
</body>

<\initial>
  <\collection>
    <associate|font|roman>
    <associate|language|polish>
    <associate|page-medium|paper>
    <associate|page-show-hf|true>
  </collection>
</initial>

<\references>
  <\collection>
    <associate||<tuple|2.1|26>>
    <associate|DamasMilner|<tuple|2.2|20>>
    <associate|MLcase|<tuple|2.2.2|28>>
    <associate|algC|<tuple|2.49|36>>
    <associate|algMSC|<tuple|3.27|50>>
    <associate|antyunif1rz|<tuple|3.2|43>>
    <associate|antyunif2rz|<tuple|3.3|48>>
    <associate|auto-1|<tuple|<uninit>|3>>
    <associate|auto-10|<tuple|1.2.6|8>>
    <associate|auto-11|<tuple|1.2.6.1|8>>
    <associate|auto-12|<tuple|1.2.6.2|9>>
    <associate|auto-13|<tuple|1.2.6.3|9>>
    <associate|auto-14|<tuple|1.2.6.4|9>>
    <associate|auto-15|<tuple|1.2.7|9>>
    <associate|auto-16|<tuple|1.2.8|10>>
    <associate|auto-17|<tuple|1.2.9|10>>
    <associate|auto-18|<tuple|1.2.9.1|10>>
    <associate|auto-19|<tuple|1.2.9.2|11>>
    <associate|auto-2|<tuple|1|5>>
    <associate|auto-20|<tuple|1.2.10|12>>
    <associate|auto-21|<tuple|1.2.10.1|12>>
    <associate|auto-22|<tuple|1.2.10.2|12>>
    <associate|auto-23|<tuple|1.2.11|12>>
    <associate|auto-24|<tuple|1.2.11.1|12>>
    <associate|auto-25|<tuple|1.2.11.2|13>>
    <associate|auto-26|<tuple|1.2.11.3|13>>
    <associate|auto-27|<tuple|2|15>>
    <associate|auto-28|<tuple|2.1|15>>
    <associate|auto-29|<tuple|2.1.1|15>>
    <associate|auto-3|<tuple|1.1|5>>
    <associate|auto-30|<tuple|2.1.1.0.1|15>>
    <associate|auto-31|<tuple|2.1.1.0.2|15>>
    <associate|auto-32|<tuple|2.1.1.0.3|16>>
    <associate|auto-33|<tuple|2.1.2|16>>
    <associate|auto-34|<tuple|2.1.2.0.4|16>>
    <associate|auto-35|<tuple|2.1.2.0.5|16>>
    <associate|auto-36|<tuple|2.1.3|17>>
    <associate|auto-37|<tuple|2.1.3.0.6|17>>
    <associate|auto-38|<tuple|2.1.3.0.7|17>>
    <associate|auto-39|<tuple|2.1.4|18>>
    <associate|auto-4|<tuple|1.2|6>>
    <associate|auto-40|<tuple|2.2|20>>
    <associate|auto-41|<tuple|2.2.1|21>>
    <associate|auto-42|<tuple|2.2.1.1|22>>
    <associate|auto-43|<tuple|2.2.1.2|24>>
    <associate|auto-44|<tuple|2.2.2|28>>
    <associate|auto-45|<tuple|2.2.2.1|30>>
    <associate|auto-46|<tuple|2.2.2.2|31>>
    <associate|auto-47|<tuple|2.2.2.3|33>>
    <associate|auto-48|<tuple|2.3|34>>
    <associate|auto-49|<tuple|2.3.1|34>>
    <associate|auto-5|<tuple|1.2.1|6>>
    <associate|auto-50|<tuple|2.3.1.1|38>>
    <associate|auto-51|<tuple|2.4|39>>
    <associate|auto-52|<tuple|2.4.1|39>>
    <associate|auto-53|<tuple|2.4.1.1|40>>
    <associate|auto-54|<tuple|2.4.1.2|40>>
    <associate|auto-55|<tuple|2.4.2|40>>
    <associate|auto-56|<tuple|3|43>>
    <associate|auto-57|<tuple|3.1|43>>
    <associate|auto-58|<tuple|3.2|43>>
    <associate|auto-59|<tuple|3.2.1|43>>
    <associate|auto-6|<tuple|1.2.2|6>>
    <associate|auto-60|<tuple|3.2.2|44>>
    <associate|auto-61|<tuple|3.2.3|45>>
    <associate|auto-62|<tuple|3.2.4|47>>
    <associate|auto-63|<tuple|3.3|48>>
    <associate|auto-64|<tuple|3.3.1|48>>
    <associate|auto-65|<tuple|3.3.1.1|48>>
    <associate|auto-66|<tuple|3.3.1.2|49>>
    <associate|auto-67|<tuple|3.3.1.3|50>>
    <associate|auto-68|<tuple|3.3.2|52>>
    <associate|auto-69|<tuple|3.3.3|56>>
    <associate|auto-7|<tuple|1.2.3|6>>
    <associate|auto-70|<tuple|3.3.3.0.1|59>>
    <associate|auto-71|<tuple|3.3.3.0.2|59>>
    <associate|auto-72|<tuple|3.3.3.1|59>>
    <associate|auto-73|<tuple|3.3.3.2|61>>
    <associate|auto-74|<tuple|3.3.3.3|61>>
    <associate|auto-75|<tuple|4|63>>
    <associate|auto-76|<tuple|4.1|63>>
    <associate|auto-77|<tuple|4.2|64>>
    <associate|auto-78|<tuple|4.2|65>>
    <associate|auto-79|<tuple|2.1|?>>
    <associate|auto-8|<tuple|1.2.4|8>>
    <associate|auto-9|<tuple|1.2.5|8>>
    <associate|bib-altenberg94evolvability|<tuple|1|65>>
    <associate|bib-barthe-typebased|<tuple|2|53>>
    <associate|bib-blickle94genetic|<tuple|2|65>>
    <associate|bib-dawkins|<tuple|3|65>>
    <associate|bib-dhaeseleer94context|<tuple|4|65>>
    <associate|bib-galmiche00proofsearch|<tuple|5|65>>
    <associate|bib-goldberg|<tuple|6|65>>
    <associate|bib-hasker95|<tuple|7|65>>
    <associate|bib-henglein93type|<tuple|8|65>>
    <associate|bib-koza92|<tuple|10|65>>
    <associate|bib-leroy92polymorphic|<tuple|11|65>>
    <associate|bib-logikaZbierski|<tuple|19|65>>
    <associate|bib-lu-generalization|<tuple|9|65>>
    <associate|bib-nagano-proof|<tuple|14|65>>
    <associate|bib-nilsson95prolog|<tuple|17|53>>
    <associate|bib-pfenning91unification|<tuple|12|65>>
    <associate|bib-radcliffe92algebra|<tuple|13|65>>
    <associate|bib-simonet03constraintbased|<tuple|16|65>>
    <associate|bib-tinayu99|<tuple|18|65>>
    <associate|bib-ute-inductive|<tuple|15|65>>
    <associate|bib-xi01dependent|<tuple|17|65>>
    <associate|construnif|<tuple|2.52|39>>
    <associate|cutelim|<tuple|2.17|17>>
    <associate|ddistr|<tuple|2.38|29>>
    <associate|firstord|<tuple|3.2.1|43>>
    <associate|footnote-1|<tuple|1|19>>
    <associate|fotype|<tuple|2.3.1|?>>
    <associate|generowanie|<tuple|2|15>>
    <associate|gentypC|<tuple|2.35|28>>
    <associate|gly-1|<tuple|1|?>>
    <associate|ogolneMocniejsze|<tuple|2.32|26>>
    <associate|pelnoscC|<tuple|2.34|27>>
    <associate|pelnoscCd|<tuple|2.43|33>>
    <associate|prolog|<tuple|2.4.1.1|40>>
    <associate|rekombinacja|<tuple|3|43>>
    <associate|rozstrzyg|<tuple|1.2.6.4|9>>
    <associate|toc-1|<tuple|1|2>>
    <associate|toc-10|<tuple|1.6.3|5>>
    <associate|toc-11|<tuple|1.6.4|5>>
    <associate|toc-12|<tuple|1.7|5>>
    <associate|toc-13|<tuple|1.8|6>>
    <associate|toc-14|<tuple|1.9|6>>
    <associate|toc-15|<tuple|1.9.1|6>>
    <associate|toc-16|<tuple|1.9.2|7>>
    <associate|toc-17|<tuple|1.10|8>>
    <associate|toc-18|<tuple|1.10.1|8>>
    <associate|toc-19|<tuple|1.10.2|8>>
    <associate|toc-2|<tuple|1.1|2>>
    <associate|toc-20|<tuple|1.11|8>>
    <associate|toc-21|<tuple|1.11.1|8>>
    <associate|toc-22|<tuple|1.11.2|9>>
    <associate|toc-23|<tuple|1.11.3|9>>
    <associate|toc-24|<tuple|1.11.4|9>>
    <associate|toc-25|<tuple|1.11.4|9>>
    <associate|toc-26|<tuple|1.11.4|9>>
    <associate|toc-27|<tuple|2|9>>
    <associate|toc-28|<tuple|2.1|9>>
    <associate|toc-29|<tuple|2.1.1|9>>
    <associate|toc-3|<tuple|1.2|2>>
    <associate|toc-30|<tuple|2.1.1|9>>
    <associate|toc-31|<tuple|3|10>>
    <associate|toc-32|<tuple|3.|10>>
    <associate|toc-33|<tuple|2.1.2|10>>
    <associate|toc-34|<tuple|2.1.2|10>>
    <associate|toc-35|<tuple|13|11>>
    <associate|toc-36|<tuple|2.1.3|11>>
    <associate|toc-37|<tuple|2.1.3|11>>
    <associate|toc-38|<tuple|17|12>>
    <associate|toc-39|<tuple|2.1.4|12>>
    <associate|toc-4|<tuple|1.3|2>>
    <associate|toc-40|<tuple|2.2|13>>
    <associate|toc-41|<tuple|2.2.1|14>>
    <associate|toc-42|<tuple|2.2.2|16>>
    <associate|toc-43|<tuple|2.2.3|18>>
    <associate|toc-44|<tuple|2.2.4|21>>
    <associate|toc-45|<tuple|2.2.5|23>>
    <associate|toc-46|<tuple|2.2.6|24>>
    <associate|toc-47|<tuple|2.2.7|27>>
    <associate|toc-48|<tuple|2.3|27>>
    <associate|toc-49|<tuple|2.3.1|27>>
    <associate|toc-5|<tuple|1.4|4>>
    <associate|toc-50|<tuple|2.3.2|31>>
    <associate|toc-51|<tuple|2.3.2|31>>
    <associate|toc-52|<tuple|2.4|32>>
    <associate|toc-53|<tuple|2.4.1|32>>
    <associate|toc-54|<tuple|53|33>>
    <associate|toc-55|<tuple|4.|33>>
    <associate|toc-56|<tuple|2.4.2|33>>
    <associate|toc-57|<tuple|3|34>>
    <associate|toc-58|<tuple|3.1|34>>
    <associate|toc-59|<tuple|3.1.1|34>>
    <associate|toc-6|<tuple|1.5|4>>
    <associate|toc-60|<tuple|3.1.2|35>>
    <associate|toc-61|<tuple|3.1.3|36>>
    <associate|toc-62|<tuple|3.1.4|38>>
    <associate|toc-63|<tuple|3.2|38>>
    <associate|toc-64|<tuple|3.2.1|38>>
    <associate|toc-65|<tuple|3.2.1|38>>
    <associate|toc-66|<tuple|3.|39>>
    <associate|toc-67|<tuple|4.|41>>
    <associate|toc-68|<tuple|3.2.2|43>>
    <associate|toc-69|<tuple|3.2.3|46>>
    <associate|toc-7|<tuple|1.6|4>>
    <associate|toc-70|<tuple|4.|49>>
    <associate|toc-71|<tuple|3.2.4|49>>
    <associate|toc-72|<tuple|3.2.5|50>>
    <associate|toc-73|<tuple|4|50>>
    <associate|toc-74|<tuple|4.1|50>>
    <associate|toc-75|<tuple|4.2|51>>
    <associate|toc-76|<tuple|4.2|51>>
    <associate|toc-77|<tuple|4.1|?>>
    <associate|toc-78|<tuple|4.1|?>>
    <associate|toc-79|<tuple|4.1|?>>
    <associate|toc-8|<tuple|1.6.1|4>>
    <associate|toc-80|<tuple|4.1|?>>
    <associate|toc-81|<tuple|5.1|?>>
    <associate|toc-82|<tuple|5.1|?>>
    <associate|toc-9|<tuple|1.6.2|5>>
    <associate|wlasnstopu|<tuple|1.2.10.2|12>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|bib>
      pfenning91unification

      lu-generalization

      hasker95

      goldberg

      koza92

      dawkins

      altenberg94evolvability

      ute-inductive

      galmiche00proofsearch

      nilsson95prolog

      nagano-proof

      hasker95

      pfenning91unification

      hasker95

      lu-generalization

      radcliffe92algebra

      dhaeseleer94context

      blickle94genetic

      radcliffe92algebra

      hasker95

      simonet03constraintbased

      henglein93type

      tinayu99

      barthe-typebased

      xi01dependent

      barthe-typebased

      hasker95

      nagano-proof

      nagano-proof

      leroy92polymorphic

      leroy92polymorphic

      leroy92polymorphic

      leroy92polymorphic

      barthe-typebased

      barthe-typebased

      barthe-typebased

      barthe-typebased

      lu-generalization

      lu-generalization

      lu-generalization

      pfenning91unification

      hasker95

      pfenning91unification

      lu-generalization

      pfenning91unification

      lu-generalization

      pfenning91unification

      lu-generalization

      hasker95

      hasker95

      hasker95

      logikaZbierski

      hasker95

      hasker95

      henglein93type
    </associate>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|Spis
      tre±ci> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-1><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|1<space|2spc>Wprowadzenie>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-2><vspace|0.5fn>

      1.1<space|2spc>Wst¦p. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-3>

      1.2<space|2spc>Zagadnienia. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-4>

      <with|par-left|<quote|1.5fn>|1.2.1<space|2spc>GP i geny.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-5>>

      <with|par-left|<quote|1.5fn>|1.2.2<space|2spc>Zalety wprowadzenia
      typizacji: programowanie dedukcyjne.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-6>>

      <with|par-left|<quote|1.5fn>|1.2.3<space|2spc>Automatyczne
      programowanie -- synteza programów: synteza dedukcyjna i synteza
      indukcyjna. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-7>>

      <with|par-left|<quote|1.5fn>|1.2.4<space|2spc>Operatory genetyczne i
      generowanie termów. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-8>>

      <with|par-left|<quote|1.5fn>|1.2.5<space|2spc>Generowanie termów i
      ``answer substitution''. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-9>>

      <with|par-left|<quote|1.5fn>|1.2.6<space|2spc>Zacie±nianie
      odpowiednio±ci mi¦dzy ci¡giem wyborów a poprawnie typowanymi termami;
      przeszukiwanie. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-10>>

      <with|par-left|<quote|3fn>|1.2.6.1<space|2spc>Generowanie termów jako
      przeszukiwanie przestrzeni programów.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-11>>

      <with|par-left|<quote|3fn>|1.2.6.2<space|2spc>O potrzebie inferencji
      typu. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-12>>

      <with|par-left|<quote|3fn>|1.2.6.3<space|2spc>Algorytm ``head-driven''.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-13>>

      <with|par-left|<quote|3fn>|1.2.6.4<space|2spc>Rozstrzygalno±¢ problemu
      niepusto±ci typu w ML. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-14>>

      <with|par-left|<quote|1.5fn>|1.2.7<space|2spc>Definicje rekurencyjne i
      definicje lokalne. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-15>>

      <with|par-left|<quote|1.5fn>|1.2.8<space|2spc>Rekombinacja i
      homomorfizm typizowa«. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-16>>

      <with|par-left|<quote|1.5fn>|1.2.9<space|2spc>Rekombinacja przez
      anty-unifikacj¦. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-17>>

      <with|par-left|<quote|3fn>|1.2.9.1<space|2spc>Generalizacja i GP.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-18>>

      <with|par-left|<quote|3fn>|1.2.9.2<space|2spc>Rekombinacja zgodna z
      mutacj¡ i anty-unifikacja drugiego rz¦du.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-19>>

      <with|par-left|<quote|1.5fn>|1.2.10<space|2spc>Systemy typów z wi¦zami.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-20>>

      <with|par-left|<quote|3fn>|1.2.10.1<space|2spc>Nierozstrzygalno±¢
      inferencji typu dla rekurencji polimorficznej.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-21>>

      <with|par-left|<quote|3fn>|1.2.10.2<space|2spc>Wªasno±¢ stopu
      zapewniona przez system typów. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-22>>

      <with|par-left|<quote|1.5fn>|1.2.11<space|2spc>Dalej w pracy.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-23>>

      <with|par-left|<quote|3fn>|1.2.11.1<space|2spc>Rozdziaª 2 --
      Generowanie termów. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-24>>

      <with|par-left|<quote|3fn>|1.2.11.2<space|2spc>Rozdziaª 3 --
      Generalizacja. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-25>>

      <with|par-left|<quote|3fn>|1.2.11.3<space|2spc>Rozdziaª 4 --
      Zako«czenie. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-26>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|2<space|2spc>Generowanie
      termów.> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-27><vspace|0.5fn>

      2.1<space|2spc>System typów prostych a intuicjonistyczny rachunek zda«.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-28>

      <with|par-left|<quote|1.5fn>|2.1.1<space|2spc>System dedukcji
      naturalnej i typizowany <with|mode|<quote|math>|\<lambda\>>-rachunek.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-29>>

      <with|par-left|<quote|6fn>|System dedukcji naturalnej.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-30><vspace|0.15fn>>

      <with|par-left|<quote|6fn>|Przypisanie typu do
      <with|mode|<quote|math>|\<lambda\>>-termu.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-31><vspace|0.15fn>>

      <with|par-left|<quote|6fn>|Izomorfizm Curry'ego-Howarda.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-32><vspace|0.15fn>>

      <with|par-left|<quote|1.5fn>|2.1.2<space|2spc>Dowody w postaci
      normalnej. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-33>>

      <with|par-left|<quote|6fn>|Beta redukcja.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-34><vspace|0.15fn>>

      <with|par-left|<quote|6fn>|Twierdzenie o normalizacji.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-35><vspace|0.15fn>>

      <with|par-left|<quote|1.5fn>|2.1.3<space|2spc>Poszukiwanie dowodów.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-36>>

      <with|par-left|<quote|6fn>|Rachunek sekwentów <with|mode|<quote|math>|N
      J<rsub|\<beta\>>>. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-37><vspace|0.15fn>>

      <with|par-left|<quote|6fn>|Drzewo dedukcyjne.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-38><vspace|0.15fn>>

      <with|par-left|<quote|1.5fn>|2.1.4<space|2spc>Algorytm generuj¡cy
      <with|mode|<quote|math>|\<lambda\>>-termy.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-39>>

      2.2<space|2spc>System Damasa-Milnera: inferencja typu i generowanie
      termu. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-40>

      <with|par-left|<quote|1.5fn>|2.2.1<space|2spc>Algorytm inferencji typu
      <with|mode|<quote|math>|\<cal-W\>> i algorytm generowania termu
      <with|mode|<quote|math>|\<cal-C\>>.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-41>>

      <with|par-left|<quote|3fn>|2.2.1.1<space|2spc>Poprawno±¢.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-42>>

      <with|par-left|<quote|3fn>|2.2.1.2<space|2spc>Peªno±¢.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-43>>

      <with|par-left|<quote|1.5fn>|2.2.2<space|2spc>Rozszerzenie j¦zyka o
      konstrukcj¦ <with|mode|<quote|math>|case>.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-44>>

      <with|par-left|<quote|3fn>|2.2.2.1<space|2spc>Poprawno±¢ z
      <with|mode|<quote|math>|case>. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-45>>

      <with|par-left|<quote|3fn>|2.2.2.2<space|2spc>Peªno±¢ z
      <with|mode|<quote|math>|case>. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-46>>

      <with|par-left|<quote|3fn>|2.2.2.3<space|2spc>Zagadnienia praktyczne:
      CASE sterowane u»yciem. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-47>>

      2.3<space|2spc>Monotoniczno±¢ i wªasno±¢ stopu.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-48>

      <with|par-left|<quote|1.5fn>|2.3.1<space|2spc>System typów i algorytm
      <with|mode|<quote|math>|\<cal-C\>>.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-49>>

      <with|par-left|<quote|3fn>|2.3.1.1<space|2spc>Unifikacja z
      podtypowaniem <with|mode|<quote|math>|\<b-U\><rsub|\<sqsubseteq\>>>.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-50>>

      2.4<space|2spc>Generowanie: mechanizmy do zastosowania.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-51>

      <with|par-left|<quote|1.5fn>|2.4.1<space|2spc>System typów z typami
      indukcyjnymi z wi¦zami unifikacyjnymi.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-52>>

      <with|par-left|<quote|3fn>|2.4.1.1<space|2spc>Generowanie
      <with|mode|<quote|math>|\<eta\>>-dªugich
      <with|mode|<quote|math>|\<beta\>>-normalnych polimorficznych
      <with|mode|<quote|math>|\<lambda\>>-termów: Prolog.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-53>>

      <with|par-left|<quote|3fn>|2.4.1.2<space|2spc>W stron¦ peªnego
      <with|mode|<quote|math>|HMG(X)>. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-54>>

      <with|par-left|<quote|1.5fn>|2.4.2<space|2spc>Programy bez
      nieu»ytecznych definicji lokalnych.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-55>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|3<space|2spc>Rekombinacja
      i generalizacja> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-56><vspace|0.5fn>

      3.1<space|2spc>Rekombinacja swobodna.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-57>

      3.2<space|2spc>Anty-unifikacja drugiego rz<group|>¦du -- prosty
      przypadek. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-58>

      <with|par-left|<quote|1.5fn>|3.2.1<space|2spc>Definicja.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-59>>

      <with|par-left|<quote|1.5fn>|3.2.2<space|2spc>Wªasno±¢: maksymalnie
      specyficzna generalizacja. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-60>>

      <with|par-left|<quote|1.5fn>|3.2.3<space|2spc>Zgodno±¢ rekombinacji z
      systemem typów. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-61>>

      <with|par-left|<quote|1.5fn>|3.2.4<space|2spc>Zwi¡zek z algorytmami z
      prac [<write|bib|pfenning91unification><reference|bib-pfenning91unification>]
      i [<write|bib|lu-generalization><reference|bib-lu-generalization>].
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-62>>

      3.3<space|2spc>Generalizacja drugiego rz¦du i ogólne struktury.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-63>

      <with|par-left|<quote|1.5fn>|3.3.1<space|2spc>Generalizacje
      rekombinatorowe z pracy [<write|bib|hasker95><reference|bib-hasker95>].
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-64>>

      <with|par-left|<quote|3fn>|3.3.1.1<space|2spc>Definicje ogólne i
      algorytm dla termów monadycznych. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-65>>

      <with|par-left|<quote|3fn>|3.3.1.2<space|2spc>Relewantne kombinatory i
      algorytm dla termów poliadycznych. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-66>>

      <with|par-left|<quote|3fn>|3.3.1.3<space|2spc>Praktyczny algorytm
      uwzgl¦dniaj¡cy rozmiar generalizacji.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-67>>

      <with|par-left|<quote|1.5fn>|3.3.2<space|2spc>Algorytm rekonstrukcji
      generalizacji z relewantnymi <with|mode|<quote|math>|\<lambda\>>-abstrakcjami.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-68>>

      <with|par-left|<quote|1.5fn>|3.3.3<space|2spc>Generalizacja przez
      znajdowanie maksymalnych wspólnych podstruktur.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-69>>

      <with|par-left|<quote|6fn>|Zagadnienia praktyczne.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-70><vspace|0.15fn>>

      <with|par-left|<quote|6fn>|Uwaga natury teoretycznej.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-71><vspace|0.15fn>>

      <with|par-left|<quote|3fn>|3.3.3.1<space|2spc>Znajdowanie maksymalnych
      izomorficznych podsystemów. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-72>>

      <with|par-left|<quote|3fn>|3.3.3.2<space|2spc>Rozszerzanie
      generalizacji na <with|mode|<quote|math>|\<lambda\>>-termy z
      definicjami lokalnymi i rekurencyjnymi.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-73>>

      <with|par-left|<quote|3fn>|3.3.3.3<space|2spc>Zgodno±¢ z systemem
      typów. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-74>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|4<space|2spc>Zako«czenie>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-75><vspace|0.5fn>

      4.1<space|2spc>Wkªad pracy. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-76>

      4.2<space|2spc>Postawione zadania. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-77>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|Bibliografia>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-78><vspace|0.5fn>
    </associate>
  </collection>
</auxiliary>