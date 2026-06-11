/*  Course:  CSC350: Logic Programming for Artificial Intelligence
    Module:  5 - Prolog Review and Core Mechanisms
    Competencies: 4 (develop solutions in Prolog)
    Purpose: A guided tour of unification, the mechanism behind parameter
             passing, data construction, and pattern matching in Prolog.
             Work through the suggested queries IN ORDER, predicting each
             result before you run it.
    Runs in: SWI-Prolog AND SICStus Prolog (portable, ISO-style).

    -------------------------------------------------------------------
    PART A. Unification basics (=/2). Predict, then try:

      ?- X = hello.                  % variable vs constant: binds
      ?- hello = hello.              % identical constants: succeeds
      ?- hello = goodbye.            % different constants: fails
      ?- X = Y.                      % two variables: they become shared
      ?- X = Y, Y = 3.               % ...so binding Y also binds X

    PART B. Structures unify part-by-part:

      ?- point(X, 2) = point(1, Y).        % X=1, Y=2
      ?- date(D, M, 2026) = date(10, june, Y).
      ?- f(X, X) = f(a, b).                % fails: X can't be both
      ?- f(X, X) = f(a, a).                % succeeds
      ?- foo(X) = bar(X).                  % different functors: fails

    PART C. Partial instantiation -- terms with holes:

      ?- T = movie(Title, 1979), T = movie('Alien', Year).
      % T is built incrementally by two unifications.

    PART D. =/2 vs ==/2 vs =:=/2 -- three different "equals":

      ?- X = 1 + 2.                  % unify: X is the TERM +(1,2)
      ?- X is 1 + 2.                 % evaluate: X = 3
      ?- 1 + 2 =:= 3.                % arithmetic comparison: true
      ?- 1 + 2 == 3.                 % term identity: FALSE (+(1,2) ≠ 3)
      ?- X == Y.                     % distinct unbound vars: false
      ?- X = Y, X == Y.              % after unification: true

    PART E. The occurs check:

      ?- unify_with_occurs_check(X, f(X)).   % fails, as logic demands
      % Plain =/2 omits the check for speed (both SWI and SICStus),
      % so  ?- X = f(X).  creates a cyclic term instead of failing.
      % SWI prints it finitely (X = f(f(f(...)))); don't rely on this.
    -------------------------------------------------------------------
    The predicates below use unification to COMPUTE -- no arithmetic,
    no explicit assignment, just pattern matching on structure.
*/

% swap_pair(P, Q): Q is P with its two components exchanged.
% Unification decomposes P and builds Q in a single head.
swap_pair(pair(A, B), pair(B, A)).

% first_arg/2, building and taking apart dates:
year_of(date(_, _, Y), Y).
month_of(date(_, M, _), M).

% substitute(Old, New, Term, Result): replace Old by New everywhere in
% a (non-list) term built from constants -- unification drives the walk.
substitute(Old, New, Old, New) :- !.
substitute(_, _, Term, Term) :-
    \+ compound(Term), !.            % constants other than Old: unchanged
substitute(Old, New, Term, Result) :-
    Term =.. [F|Args],               % "univ": decompose any structure
    sub_list(Old, New, Args, NewArgs),
    Result =.. [F|NewArgs].

sub_list(_, _, [], []).
sub_list(Old, New, [A|As], [B|Bs]) :-
    substitute(Old, New, A, B),
    sub_list(Old, New, As, Bs).

/*  Try:
      ?- swap_pair(pair(1, two), Q).
      ?- year_of(date(10, june, 2026), Y).
      ?- substitute(x, 5, f(x, g(x, y)), R).      % R = f(5, g(5, y))
    =../2 ("univ") and compound/1 are ISO and work in both systems.   */
