/*  Course:  CSC350: Logic Programming for Artificial Intelligence
    Module:  6 - Advanced Prolog Programming Techniques
    Competencies: 4 (develop Prolog solutions), 6 (logic programming
                  solutions for computational problems)
    Purpose: Nondeterministic programming -- predicates with many
             solutions as a design tool: generators, generate-and-test,
             and the three solution-collectors findall/bagof/setof.
    Runs in: SWI-Prolog AND SICStus Prolog (portable, ISO-style).

    Suggested queries, in order:
      1.  ?- digit(D).                          % press ; -- a generator
      2.  ?- pythagorean(A, B, C).              % generate-and-test
      3.  ?- slow_sort([3, 1, 2], S).
      4.  ?- findall(X, likes(mary, X), L).
      5.  ?- findall(X, likes(zoe, X), L).      % succeeds with L = []
      6.  ?- bagof(X, likes(zoe, X), L).        % FAILS -- compare with 5
      7.  ?- bagof(X, likes(P, X), L).          % groups by P! press ;
      8.  ?- bagof(X, P^likes(P, X), L).        % ^ ignores P: one bag
      9.  ?- setof(X, P^likes(P, X), L).        % sorted, no duplicates
*/

:- use_module(library(lists)).   % select/2 etc. for SICStus; harmless in SWI

/* -------------------- GENERATORS ----------------------------------- */

% digit(D): on backtracking, enumerates 0..9. A predicate with ten
% solutions is not a bug -- it is a loop you haven't asked to run yet.
digit(0). digit(1). digit(2). digit(3). digit(4).
digit(5). digit(6). digit(7). digit(8). digit(9).

/* -------------------- GENERATE AND TEST ---------------------------- */

% pythagorean(A, B, C): single-digit Pythagorean triples.
% The digit/1 goals GENERATE candidates; the arithmetic goal TESTS.
% Backtracking wires them together automatically.
pythagorean(A, B, C) :-
    digit(A), A > 0,
    digit(B), B >= A,         % B >= A avoids mirror duplicates
    digit(C), C > 0,
    C * C =:= A * A + B * B.

% slow_sort(List, Sorted): permutation sort -- the purest possible
% generate-and-test: try permutations until one is ordered. Perfect
% specification, terrible algorithm (O(n!)); Module 7's CLP example is
% the antidote. Try lists of length 7+ and feel the factorial.
slow_sort(List, Sorted) :-
    perm(List, Sorted),
    ordered(Sorted).

ordered([]).
ordered([_]).
ordered([X, Y | Rest]) :-
    X =< Y,
    ordered([Y | Rest]).

% perm(L, P): P is a permutation of L. (Defined locally for portability:
% permutation/2 is a library predicate in both systems but autoloaded
% only in SWI.) select_p/3 nondeterministically picks an element.
perm([], []).
perm(L, [X|P]) :-
    select_p(X, L, Rest),
    perm(Rest, P).

select_p(X, [X|T], T).
select_p(X, [H|T], [H|R]) :- select_p(X, T, R).

/* -------------------- COLLECTING SOLUTIONS ------------------------- */

likes(mary, wine).
likes(mary, food).
likes(john, wine).
likes(john, mary).

/*  All three collectors are ISO and behave identically in SWI/SICStus:

    findall(T, Goal, L)  -- L = all instances of T; L = [] if Goal has
                            no solutions; free variables NOT grouped.
    bagof(T, Goal, L)    -- FAILS if no solutions; groups answers by the
                            free variables of Goal (query 7!); V^Goal
                            existentially quantifies V away (query 8).
    setof(T, Goal, L)    -- bagof + sort + remove duplicates.

    Rule of thumb: findall for "just give me the list", setof for
    "the set, properly", bagof when grouping by a free variable is
    exactly what you want.                                              */

% who_likes_what(Report): build a grouped report using bagof's grouping.
who_likes_what(Person-Things) :-
    bagof(X, likes(Person, X), Things).

/*  Try:  ?- who_likes_what(R).   then ;   -- one R per person.        */
