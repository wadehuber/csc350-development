/*  Course:  CSC350: Logic Programming for Artificial Intelligence
    Module:  1 - Propositional and Predicate Logic
    Competencies: 1 (appraise concepts of logic in a CS context),
                  3 (knowledge representation: formulas as symbolic data)
    Purpose: Represent propositional formulas as Prolog terms and evaluate
             them under a truth assignment. Demonstrates a core symbolic-AI
             idea: logical formulas are just data structures a program can
             inspect and manipulate.
    Runs in: SWI-Prolog AND SICStus Prolog (portable, ISO-style).

    Suggested queries:
      ?- eval(implies(p, or(p, q)), [p=true, q=false], V).
      ?- eval(and(p, not(p)), [p=true], V).
      ?- tautology(implies(and(p, q), p)).
      ?- tautology(implies(p, q)).          % fails: not a tautology
*/

:- use_module(library(lists)).   % member/2 (needed by SICStus; harmless in SWI)

/* ---------------------------------------------------------------------
   Formulas are Prolog terms:
     proposition letters:  p, q, r, ... (any atom)
     connectives:          not(F), and(F,G), or(F,G), implies(F,G), iff(F,G)
   An assignment is a list of Letter=Boolean pairs, e.g. [p=true, q=false].
   --------------------------------------------------------------------- */

% eval(+Formula, +Assignment, -Value)
% Value is the truth value (true/false) of Formula under Assignment.
eval(not(F), A, V) :-
    eval(F, A, VF),
    negate(VF, V).
eval(and(F, G), A, V) :-
    eval(F, A, VF),
    eval(G, A, VG),
    conj(VF, VG, V).
eval(or(F, G), A, V) :-
    eval(F, A, VF),
    eval(G, A, VG),
    disj(VF, VG, V).
eval(implies(F, G), A, V) :-          % F -> G  ==  ~F v G
    eval(or(not(F), G), A, V).
eval(iff(F, G), A, V) :-              % F <-> G == (F -> G) & (G -> F)
    eval(and(implies(F, G), implies(G, F)), A, V).
eval(Letter, A, V) :-                 % base case: look the letter up
    atom(Letter),
    \+ connective(Letter),
    member(Letter=V, A).

connective(not(_)).
connective(and(_, _)).
connective(or(_, _)).
connective(implies(_, _)).
connective(iff(_, _)).

% Truth tables for the basic connectives, written as facts.
negate(true, false).
negate(false, true).

conj(true,  true,  true).
conj(true,  false, false).
conj(false, true,  false).
conj(false, false, false).

disj(true,  true,  true).
disj(true,  false, true).
disj(false, true,  true).
disj(false, false, false).

/* ---------------------------------------------------------------------
   Tautology checking: a formula is a tautology if it is true under
   EVERY assignment. We generate all assignments by backtracking and
   check that none makes the formula false.
   --------------------------------------------------------------------- */

% letters(+Formula, -Letters): the proposition letters in Formula (with
% duplicates removed by sort/2, which is ISO).
letters(F, Letters) :-
    letters_list(F, L),
    sort(L, Letters).

letters_list(not(F), L) :- letters_list(F, L).
letters_list(and(F, G), L) :-
    letters_list(F, LF), letters_list(G, LG), append(LF, LG, L).
letters_list(or(F, G), L) :-
    letters_list(F, LF), letters_list(G, LG), append(LF, LG, L).
letters_list(implies(F, G), L) :-
    letters_list(F, LF), letters_list(G, LG), append(LF, LG, L).
letters_list(iff(F, G), L) :-
    letters_list(F, LF), letters_list(G, LG), append(LF, LG, L).
letters_list(Letter, [Letter]) :-
    atom(Letter), \+ connective(Letter).

% assignment(+Letters, -Assignment): on backtracking, enumerates every
% possible truth assignment for the letters (2^N solutions).
assignment([], []).
assignment([L|Ls], [L=V|Rest]) :-
    boolean(V),
    assignment(Ls, Rest).

boolean(true).
boolean(false).

% tautology(+Formula): succeeds if no assignment makes Formula false.
tautology(F) :-
    letters(F, Letters),
    \+ ( assignment(Letters, A),
         eval(F, A, false) ).

% contradiction(+Formula): no assignment makes it true.
contradiction(F) :-
    letters(F, Letters),
    \+ ( assignment(Letters, A),
         eval(F, A, true) ).
