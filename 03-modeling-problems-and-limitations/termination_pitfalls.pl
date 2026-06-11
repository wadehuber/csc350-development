/*  Course:  CSC350: Logic Programming for Artificial Intelligence
    Module:  3 - Modeling Computational Problems and Logical Limitations
    Competencies: 1 (principles of logic), 2 (logical reasoning),
                  5 (evaluate limitations of logical systems)
    Purpose: Show, hands-on, that a logically correct program can still
             fail to terminate under Prolog's depth-first proof search.
             Each pitfall is paired with a terminating fix.
    Runs in: SWI-Prolog AND SICStus Prolog (portable, ISO-style).

    *** WARNING: the queries marked LOOPS below intentionally do not
    *** terminate. Interrupt with Ctrl+C then 'a' (abort).

    Experiments (in order):
      1.  ?- ancestor_ok(tom, X).           % fine: all descendants
      2.  ?- bad_ancestor(tom, X).          % first answers, then LOOPS on ;
      3.  ?- bad_ancestor(X, tom).          % LOOPS immediately
      4.  ?- connected(a, d).               % succeeds...
          ?- connected(a, z).               % ...but LOOPS (z unreachable)
*/

/* ---------------------------------------------------------------------
   A small family tree used throughout.
   --------------------------------------------------------------------- */
parent(tom, bob).
parent(tom, liz).
parent(bob, ann).
parent(bob, pat).
parent(pat, jim).

/* ---------------------------------------------------------------------
   PITFALL 1: LEFT RECURSION.

   Both definitions below are logically equivalent readings of
   "X is an ancestor of Z". As LOGIC they have identical meaning.
   As PROGRAMS under depth-first search they behave very differently.
   --------------------------------------------------------------------- */

% GOOD: the recursive call comes after a parent/2 goal that consumes
% one "generation", so every recursion makes progress toward facts.
ancestor_ok(X, Z) :-
    parent(X, Z).
ancestor_ok(X, Z) :-
    parent(X, Y),
    ancestor_ok(Y, Z).

% BAD: the recursive call is FIRST (left recursion). To prove
% bad_ancestor(X,Z), Prolog first tries to prove bad_ancestor(X,Y) --
% the same shape of goal, no smaller. Depth-first search descends
% forever once the parent/2 clause stops yielding new answers.
bad_ancestor(X, Z) :-
    parent(X, Z).
bad_ancestor(X, Z) :-
    bad_ancestor(X, Y),     % <- recursion before any progress is made
    parent(Y, Z).

/* The deep point: Prolog's strategy (SLD resolution, depth-first,
   left-to-right) is sound but INCOMPLETE -- there are true goals it
   cannot prove because it falls into an infinite branch first.
   A breadth-first strategy would find the proofs but is far more
   expensive. This trade-off is a concrete, everyday instance of the
   "limitations of logical systems" topic. */

/* ---------------------------------------------------------------------
   PITFALL 2: SYMMETRIC RULES.

   "Connectedness in an undirected graph" -- stating symmetry as a rule
   creates a cycle in the search space: connected(X,Y) calls
   connected(Y,X) calls connected(X,Y) ...
   --------------------------------------------------------------------- */

edge(a, b).
edge(b, c).
edge(c, d).

% Looks innocent; loops when the goal is NOT provable, because failure
% requires exhausting an infinite search space.
connected(X, Y) :- edge(X, Y).
connected(X, Y) :- connected(Y, X).            % symmetry as recursion: trouble
connected(X, Z) :- edge(X, Y), connected(Y, Z).

% FIX: make symmetry a property of the EDGE relation (data), not of the
% recursive predicate (search). link/2 is symmetric by construction and
% not recursive, so the recursion below always consumes an edge.
link(X, Y) :- edge(X, Y).
link(X, Y) :- edge(Y, X).

connected_ok(X, Y) :- link(X, Y).
connected_ok(X, Z) :- link(X, Y), connected_ok(Y, Z).

/* connected_ok/2 still loops on cyclic graphs (try adding edge(d, a).)
   -- the complete fix, carrying a visited-node list, is developed in
   Module 10 (search techniques). Knowing exactly WHERE the naive
   version breaks is the point of this module. */
