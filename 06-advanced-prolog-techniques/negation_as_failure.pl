/*  Course:  CSC350: Logic Programming for Artificial Intelligence
    Module:  6 - Advanced Prolog Programming Techniques
    Competencies: 4 (develop Prolog solutions), 6 (logic programming for AI)
    Purpose: Negation as failure (\+) and the closed-world assumption:
             what "not provable" buys us, and the unbound-variable trap
             every Prolog programmer must learn once.
    Runs in: SWI-Prolog AND SICStus Prolog (portable, ISO-style).
             (SWI prints `false` where SICStus prints `no`.)

    Suggested queries, in order:
      1.  ?- can_fly(tweety).
      2.  ?- can_fly(pingu).
      3.  ?- can_fly(rocky).          % rocky isn't in the KB at all
      4.  ?- bachelor(X).             % surprisingly FAILS -- read Part B
      5.  ?- bachelor_fixed(X).
*/

/* -------------------- PART A: the basic idea ----------------------- */

bird(tweety).
bird(pingu).
bird(sam).

penguin(pingu).

/*  "Birds fly, unless they are penguins."
    \+ Goal succeeds iff Goal CANNOT BE PROVED. Under the closed-world
    assumption (CWA) -- "what my KB doesn't entail is false" -- this is
    a workable stand-in for logical negation, and it is how databases,
    planners, and expert systems reason every day.                     */

can_fly(X) :-
    bird(X),
    \+ penguin(X).

/*  Query 3 (?- can_fly(rocky).) fails because rocky isn't a known bird.
    Note the asymmetry: CWA concludes "rocky can't fly" from ABSENCE of
    information. Logical negation would need a fact saying so. This is
    exactly the trade-off discussed in Module 3's limitations notes.   */

/* -------------------- PART B: the unbound-variable trap ------------ */

person(ann).
person(bob).
person(carl).

married(ann).

% INTENDED: "X is a bachelor if X is unmarried."
% BROKEN: with X unbound, \+ married(X) asks "is there NO married
% person at all?" -- married(ann) is provable, so \+ fails, so
% bachelor/1 fails for everyone. (Also: X never gets bound inside \+;
% negation as failure never produces bindings.)
bachelor(X) :-
    \+ married(X),
    person(X).

% FIX: generate candidates FIRST, so X is bound when \+ runs.
% Rule of thumb: \+ is only meaningful on GROUND goals.
bachelor_fixed(X) :-
    person(X),
    \+ married(X).

/* -------------------- PART C: \+ in a real idiom ------------------- */

% set_difference(+Xs, +Ys, -Zs): Zs = elements of Xs not in Ys.
% A bread-and-butter use of negation as failure.
set_difference([], _, []).
set_difference([X|Xs], Ys, Zs) :-
    memberchk_p(X, Ys), !,
    set_difference(Xs, Ys, Zs).
set_difference([X|Xs], Ys, [X|Zs]) :-
    set_difference(Xs, Ys, Zs).

% memberchk_p/2: deterministic membership test (portable version of
% SWI's memberchk/2, which SICStus also provides in library(lists);
% defined here to keep the file self-contained).
memberchk_p(X, [X|_]) :- !.
memberchk_p(X, [_|T]) :- memberchk_p(X, T).

/*  Try:  ?- set_difference([a,b,c,d], [b,d], Z).        Z = [a,c]      */
