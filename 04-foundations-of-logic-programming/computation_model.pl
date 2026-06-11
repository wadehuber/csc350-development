/*  Course:  CSC350: Logic Programming for Artificial Intelligence
    Module:  4 - Foundations of Logic Programming
    Competencies: 1 (principles of logic in CS),
                  5 (evaluate the logic programming paradigm)
    Purpose: Make the computation model of logic programs VISIBLE. We
             store a small program as clause/2 data and run it with a
             meta-interpreter that performs SLD goal reduction explicitly,
             optionally returning the proof tree it constructs.
    Runs in: SWI-Prolog AND SICStus Prolog (portable, ISO-style).

    Suggested queries:
      ?- solve(grandparent(tom, X)).
      ?- solve_trace(grandparent(tom, X), Proof).
      ?- solve_trace(ancestor(tom, jim), Proof).
*/

/* ---------------------------------------------------------------------
   The OBJECT program, stored as data. clause_kb(Head, Body) represents
   the Horn clause "Head :- Body"; a body of `true` marks a fact.
   (We use our own clause_kb/2 rather than asserting real clauses so the
   whole demonstration is self-contained and portable.)
   --------------------------------------------------------------------- */

clause_kb(parent(tom, bob), true).
clause_kb(parent(tom, liz), true).
clause_kb(parent(bob, ann), true).
clause_kb(parent(bob, pat), true).
clause_kb(parent(pat, jim), true).

clause_kb(grandparent(X, Z), (parent(X, Y), parent(Y, Z))).

clause_kb(ancestor(X, Z), parent(X, Z)).
clause_kb(ancestor(X, Z), (parent(X, Y), ancestor(Y, Z))).

/* ---------------------------------------------------------------------
   THE COMPUTATION MODEL, in four clauses.

   SLD resolution, one sentence: to solve a goal, find a clause whose
   head UNIFIES with it, and solve the clause's body, left to right;
   on failure, BACKTRACK to the next matching clause.

   That sentence is this code:
   --------------------------------------------------------------------- */

% solve(+Goal): Goal is derivable from the clause_kb/2 program.
solve(true) :-
    !.                                % nothing left to prove
solve((A, B)) :-
    !,
    solve(A),                         % leftmost goal first ("computation rule")
    solve(B).
solve(Goal) :-
    clause_kb(Goal, Body),            % clause choice ("search rule"); head
    solve(Body).                      %   unification happens right here

/* The two cuts above are bookkeeping: they commit to the recursive
   decomposition for `true` and conjunctions, which can't match the
   third clause anyway. All real search happens in clause_kb/2 choice. */

% ---------------------------------------------------------------------
% solve_trace(+Goal, -Proof): like solve/1 but builds the proof tree.
%   fact(F)                       -- F was a fact
%   rule(Head, BodyProofs)        -- Head proved via a rule
% ---------------------------------------------------------------------

solve_trace(true, true) :-
    !.
solve_trace((A, B), (PA, PB)) :-
    !,
    solve_trace(A, PA),
    solve_trace(B, PB).
solve_trace(Goal, fact(Goal)) :-
    clause_kb(Goal, true).
solve_trace(Goal, rule(Goal, BodyProof)) :-
    clause_kb(Goal, Body),
    Body \== true,
    solve_trace(Body, BodyProof).

/* Why meta-interpreters matter for AI: this 10-line interpreter is the
   seed of the "explanation facility" in expert systems (Module 12: HOW
   did the system reach its conclusion? -- return the proof tree) and of
   research systems that modify the search strategy itself. In logic
   programming, the interpreter is just another logic program. */
