/*  Course:  CSC350: Logic Programming for Artificial Intelligence
    Module:  8 - Midterm Review and Exam
    Competencies: 1-6 (cumulative through Modules 1-7; emphasis on 2 and 4)
    Purpose: Ten self-test practice problems covering the first half of
             the course. Each problem gives a specification, a TODO stub,
             and test queries with expected results. Replace each stub's
             body and re-consult the file to check yourself.
    Runs in: SWI-Prolog AND SICStus Prolog (portable, ISO-style).

    The stubs are written as  ... :- fail.  so the file loads cleanly
    even before you start. Delete the stub when you write your answer.
*/

:- use_module(library(lists)).

/* Shared facts for problems 1-3. */
parent(pam, bob).
parent(tom, bob).
parent(tom, liz).
parent(bob, ann).
parent(bob, pat).
parent(pat, jim).
female(pam). female(liz). female(ann). female(pat).
male(tom).   male(bob).   male(jim).

/* -------------------------------------------------------------------
   PROBLEM 1 (Module 1/5: rules).  Define sister(X, Y): X is a sister
   of Y -- X is female, they share a parent, and X \== Y.
   Test:  ?- sister(ann, pat).        % expected: true
          ?- sister(X, jim).          % expected: no solutions
   ------------------------------------------------------------------- */
sister(_X, _Y) :- fail.                                   % TODO

/* -------------------------------------------------------------------
   PROBLEM 2 (Module 4: recursion). Define descendant(X, Y): X is a
   child, grandchild, ... of Y. Mind your recursion direction --
   no left recursion (Module 3!).
   Test:  ?- descendant(jim, tom).    % expected: true
          ?- descendant(X, bob).      % expected: ann, pat, jim
   ------------------------------------------------------------------- */
descendant(_X, _Y) :- fail.                               % TODO

/* -------------------------------------------------------------------
   PROBLEM 3 (Module 6: negation). Define childless(X): X is a known
   person with no children. Get the goal ORDER right (\+ needs ground
   goals -- generate candidates first).
   Test:  ?- childless(jim).          % expected: true
          ?- childless(bob).          % expected: false
   ------------------------------------------------------------------- */
childless(_X) :- fail.                                    % TODO

/* -------------------------------------------------------------------
   PROBLEM 4 (Module 5: list recursion). Define count_occurrences(X,
   List, N): X appears N times in List.
   Test:  ?- count_occurrences(a, [a,b,a,c,a], N).   % expected: N = 3
          ?- count_occurrences(z, [a,b], N).         % expected: N = 0
   ------------------------------------------------------------------- */
count_occurrences(_X, _List, _N) :- fail.                 % TODO

/* -------------------------------------------------------------------
   PROBLEM 5 (Module 5: accumulators). Define max_of_list(List, Max)
   for a nonempty numeric list, using an accumulator.
   Test:  ?- max_of_list([3, 9, 2, 7], M).           % expected: M = 9
   ------------------------------------------------------------------- */
max_of_list(_List, _Max) :- fail.                         % TODO

/* -------------------------------------------------------------------
   PROBLEM 6 (Module 5: unification -- no coding). For each query,
   PREDICT (write it down!) the result, then verify at the prompt:
     a)  ?- f(X, b) = f(a, Y).
     b)  ?- f(X, X) = f(a, b).
     c)  ?- [H|T] = [1, 2, 3].
     d)  ?- [X, Y] = [1 | [2]].
     e)  ?- X == Y.
     f)  ?- 2 + 3 = 5.            % careful! = is not arithmetic
   ------------------------------------------------------------------- */

/* -------------------------------------------------------------------
   PROBLEM 7 (Module 5: structures). Using the term date(D, M, Y),
   define same_month(D1, D2): two dates fall in the same month of the
   same year. One clause, no body goals needed beyond unification.
   Test:  ?- same_month(date(1, jun, 2026), date(15, jun, 2026)).  % true
          ?- same_month(date(1, jun, 2026), date(1, jun, 2027)).   % false
   ------------------------------------------------------------------- */
same_month(_D1, _D2) :- fail.                             % TODO

/* -------------------------------------------------------------------
   PROBLEM 8 (Module 6: collectors -- no coding). The KB below is
   loaded. Predict the result of each query, then verify:
     a)  ?- findall(P, enrolled(P, prolog), L).
     b)  ?- findall(P, enrolled(P, basket_weaving), L).
     c)  ?- bagof(P, enrolled(P, basket_weaving), L).
     d)  ?- setof(C, P^enrolled(P, C), L).
   ------------------------------------------------------------------- */
enrolled(ava, prolog).
enrolled(ben, prolog).
enrolled(ava, databases).

/* -------------------------------------------------------------------
   PROBLEM 9 (Module 6: cut). Define interval_label(X, Label):
        X < 0          -> negative
        0 =< X =< 100  -> in_range
        X > 100        -> too_big
   Write it twice: with cuts, and with if-then-else. Both must give
   exactly ONE answer for any number (no extra answers on ;).
   Test:  ?- interval_label(-5, L).    % L = negative, no choicepoint
          ?- interval_label(50, L).    % L = in_range
   ------------------------------------------------------------------- */
interval_label(_X, _Label) :- fail.                       % TODO

/* -------------------------------------------------------------------
   PROBLEM 10 (Modules 3/6: generate and test). Two guards each make a
   statement; knights always tell the truth, knaves always lie.
        Guard A says: "We are both knaves."
   What are A and B? Model it: each guard is knight or knave; A's
   statement is true iff A is a knight. Define solve_guards(A, B).
   Test:  ?- solve_guards(A, B).
          % expected: exactly one solution -- work out which before
          % you run it. (Hint: can a knight say "we are both knaves"?)
   ------------------------------------------------------------------- */
solve_guards(_A, _B) :- fail.                             % TODO

/*  Done? Module 9 turns puzzle modeling like Problem 10 into a full
    knowledge-representation topic.                                   */
