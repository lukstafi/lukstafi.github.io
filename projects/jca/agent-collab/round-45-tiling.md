---
title: "JCA Round 45: Tiling an exponential square inside a common ground row"
date: 2026-11-21
---

**Theorem.** On finite binary trees, quantified equational JCA with one required fully specified ground row is NEXP-complete when the row is supplied as an acyclic term graph. Writing the entire row out as trees gives NP-completeness. The lower bound has two quantifier blocks $\forall H\,\exists Y$, no designated parameters, and five implications with jointly satisfiable, input-only premises. Round 46 reduces the five to two. All the public values of the required row point into the same linear-size chain of perfectly balanced trees. [Explicit-tree bound](round-42-maximal.html) · [Two implications](round-46-two-observations.html)

For the upper bound, unfold the input row and apply the NP verification with an explicit tree example. Unfolding a bounded-arity DAG costs at most singly exponential time. This upper bound also covers the designated-variable presentations and arbitrary read permissions of Round 42. The following lower bound also proves NEXP-hardness when only *existence* of a common active row is required. [Common-witness upper bound](round-44-common-witness.html)

## Read a perfect tree as an array

Use the NEXP-hard problem of tiling a torus of side $2^n$ with a specified word along the beginning of row zero. There is a fixed finite tile set $T$ and fixed horizontal and vertical compatibility relations for which this is hard, with $n$ one more than the length of the input word. [Tobies, §3, Corollary 3.3](https://www.cs.cmu.edu/afs/cs/project/jair/pub/volume12/tobies00a-html/node4.html)

An array of depth $d$ and alphabet $A$ is a perfect binary term with $2^d$ leaves that are universal input names $h_{A,t}$ for $t\in A$. An existential output gives the term. Each alphabet has its own distinct inputs. We enforce the stated type and depth even though the prefix lets every output read every input.

Use two shape branches. In copy $k$ of the test, the premise identifies every $h_{A,t}$ with a probe $r_{A,k,0}$ and defines $r_{A,k,i+1}=f(r_{A,k,i},r_{A,k,i})$ up to the maximum requested depth. The conclusion equates each output of type $(A,d)$ to $r_{A,k,d}$. The two copies have disjoint registers, all universally quantified. On a generic assignment satisfying either premise, probes for distinct alphabets are independent. A term using a register of that very test might shortcut a whole subtree. In the other test the same register is an independent letter absent from the prescribed tree. Hence no output can use a register of either copy. A literal leaf or a leaf of another alphabet would likewise contradict the required equality. The only possible terms are exactly the prescribed arrays. This is a test of ordinary relevance, so the probes may be treated as rigid letters by separation in a nontrivial free algebra.

For the converse from an arbitrary answer to terms, specialize its nuisance parameters at a common active row. The existential outputs are then terms in the universal inputs. In fact every answer with this prefix admits such a specialization even before imposing a common-row requirement here: the only premises refer to universal moves, and the constraints on those moves have the simultaneous assignment given below. [Strategy specialization](round-44-common-witness.html#use-all-the-unification-traces-at-the-same-row)

## Move the last address bit to the front

Initially the board has depth $d=2n$. The address bits are the $n$ bits of $x$, least significant first, followed by the $n$ bits of $y$ in that order. Write $T_j$ for its layout after $j$ last-to-front rotations, using a fresh alphabet of tile names at each stage. For a rotation introduce a depth-$d-1$ array $P_j$ over *all pairs* $(l,r)$ of tiles, and two depth-$d-1$ arrays $L_j,R_j$ over the next tile alphabet.

Three further implications perform leaf substitutions. Each premise gives a simultaneous assignment of the distinct pair-letter inputs, leaving all tile-letter inputs independent.

| Mode | Image of a pair letter $(l,r)$ | Required equality |
|---|---|---|
| Expand | $f(h_{j,l},h_{j,r})$ | $P_j=T_j$ |
| First | $h_{j+1,l}$ | $P_j=L_j$ |
| Second | $h_{j+1,r}$ | $P_j=R_j$ |

Also impose $T_{j+1}=f(L_j,R_j)$ in the expansion conclusion. Its tile letters are unaffected by that premise, so the equality holds as an open term. Expansion forces the pair at each of the $2^{d-1}$ addresses to be exactly the two former sibling tiles. The two projections then send the former last bit to the front of the address and preserve the order of the others. After $n$ rotations, $y$ is first, least significant bit first, followed by $x$. All stages share the same three implications because their pair alphabets are disjoint.

## Compare every neighboring pair with polynomially many equations

In the $x$-first board, addresses with $j$ low one-bits followed by a zero have prefix $1^j0$. Their horizontal successors have prefix $0^j1$ with the *same* remaining bits. There is one such class for $0\le j<n$, and the wraparound class compares $1^n$ with $0^n$. For each class introduce a depth-$d-|p|$ array over the alphabet of **legal horizontal pairs**, where $p$ is the source prefix. Its first and second projections must equal the two board subtrees at the indicated prefixes. Use the first and second branches already defined, with the edge letters mapped to their respective tile letters. Apply the same construction to the $y$-first board for vertical neighbors.

A subtree at a written path needs only polynomially many output names. Along the trie of requested paths introduce both children and require $U=f(U_0,U_1)$ in the expansion conclusion. These equations involve only tile arrays. Pin every prescribed tile of the initial word at its leaf in the same conclusion. There are $O(n)$ rotations and neighboring classes, and polynomially many named paths and register equations. The compiler writes ordinary equations as trees. It never expands the board into the input.

A tiling supplies all these term strategies by arranging its tiles, sibling pairs and neighboring pairs in the indicated orders. Conversely, the typed initial board assigns a tile to every position. Pair expansion forces every rotation, the legal pair arrays check every torus edge, and the leaf equations give the initial word. This recovers a tiling from any successful answer.

## All five premises have a single explicit witness

Let $g_0=a$ and $g_{i+1}=f(g_i,g_i)$. Give every tile letter of stage $j$ the ground value $g_j$, every pair letter for rotation $j$ the value $g_{j+1}$, and every edge letter the same value as a tile at its checked stage. Call its subscript the rank of the alphabet. Set shape register $i$ for an alphabet of rank $r$ to $g_{r+i}$. Every expansion and both projections agree at this assignment. Give each output of type $(A,d')$ the value $g_{\mathrm{rank}(A)+d'}$. These are the values of every honest strategy there, independent of the tiling. In particular the full **public** row is known before solving the source instance. Its deepest term is $g_{3n}$ and every coordinate reuses the same chain of $O(n)$ nodes.

The [compiler](round-45-tiling.py) generates the five ordinary implications, this ground row, and candidate term strategies for concrete grids. It checks them by finite-tree unification against direct horizontal, vertical, wraparound, and initial-word checks on 52 grids. Returning one test's own depth register is explicitly rejected by the other test.
