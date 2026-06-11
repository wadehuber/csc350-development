/*  Course:  CSC350: Logic Programming for Artificial Intelligence
    Module:  6 - Advanced Prolog Programming Techniques
    Competencies: 4 (develop Prolog solutions), 6 (control of search)
    Purpose: The cut (!): committing to choices and pruning the search
             tree. Demonstrates the difference between a GREEN cut
             (efficiency only) and a RED cut (changes the meaning).
    Runs in: SWI-Prolog AND SICStus Prolog (portable, ISO-style).

    Suggested queries, in order (press ; after each answer!):
      1.  ?- max_nocut(3, 7, M).      % correct, but a choice point lingers
      2.  ?- max_cut(3, 7, M).        % same answer, no choice point
      3.  ?- classify(0, C).
      4.  ?- first_red([a, b, c], X). % then READ the red-cut warning
      5.  ?- once_demo(X).
*/

/* -------------------- GREEN CUT: prune, same meaning --------------- */

% Without a cut: logically correct. But after answering via clause 1,
% Prolog keeps a choice point; pressing ; makes it re-test via clause 2.
max_nocut(X, Y, X) :- X >= Y.
max_nocut(X, Y, Y) :- X < Y.

% With a cut: once X >= Y has succeeded, clause 2 could not possibly
% yield a different correct answer, so committing loses nothing. A cut
% that only removes wasted work is a GREEN cut.
max_cut(X, Y, X) :- X >= Y, !.
max_cut(_, Y, Y).

/*  CAREFUL: max_cut's second clause RELIES on the cut -- read alone,
    "the max of X and Y is Y" is false. The program is only correct as
    a whole. Many style guides therefore prefer if-then-else, which is
    ISO, works in both systems, and keeps the commitment visible:      */

max_ite(X, Y, M) :-
    ( X >= Y -> M = X ; M = Y ).

/* -------------------- MUTUALLY EXCLUSIVE CASES --------------------- */

% Cuts mark "no later clause can apply", saving useless backtracking.
classify(N, negative) :- N < 0, !.
classify(0, zero)     :- !.
classify(_, positive).

/* -------------------- RED CUT: changes the answers ----------------- */

% first_red(List, X): X is the FIRST element; the cut discards the rest
% of the list's elements as answers. Deleting this cut changes the SET
% OF ANSWERS (it would enumerate every element) -- that makes it a RED
% cut: sometimes justified, always worth a comment.
first_red([X|_], X) :- !.
first_red([_|T], X) :- first_red(T, X).

/* -------------------- once/1: a disciplined cut -------------------- */

likes(mary, wine).
likes(mary, food).
likes(john, wine).

% once/1 (ISO, both systems): succeed at most once. Use it at the CALL
% site instead of scattering cuts through definitions.
once_demo(X) :-
    once(likes(mary, X)).

/* Search-tree picture for query 2 (?- max_cut(3, 7, M).):

                 max_cut(3,7,M)
                 /            \
        clause 1:              clause 2:
        3 >= 7, !, M=3         M=7   <- reached only because clause 1
           |                            failed BEFORE its cut ran
         fails

   The cut never executed, so no pruning happened -- which is exactly
   right: pruning may only happen after the guard has succeeded.       */
