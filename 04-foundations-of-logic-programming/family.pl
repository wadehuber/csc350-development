/*  Course:  CSC350: Logic Programming for Artificial Intelligence
    Module:  4 - Foundations of Logic Programming
    Competencies: 1 (principles of logic in CS),
                  2 (logical reasoning in problem-solving)
    Purpose: The canonical first logic program -- a family tree. Facts,
             rules, and a recursive rule, sized so every query can be
             traced by hand against the SLD computation model.
    Runs in: SWI-Prolog AND SICStus Prolog (portable, ISO-style).

    Suggested queries:
      ?- parent(tom, X).
      ?- grandparent(tom, X).
      ?- ancestor(tom, jim).
      ?- ancestor(X, jim).               % who are jim's ancestors?
      ?- trace, ancestor(tom, jim).      % watch resolution step by step
*/

/* FACTS: unconditional Horn clauses. Read parent(tom, bob) as
   "tom is a parent of bob". */

parent(tom, bob).
parent(tom, liz).
parent(bob, ann).
parent(bob, pat).
parent(pat, jim).

female(liz).
female(ann).
female(pat).
male(tom).
male(bob).
male(jim).

/* RULES: conditional Horn clauses.  Head :- Body  means
   "Head is true if every goal in Body is true".

   Procedural reading (the computation model): to solve grandparent(X,Z),
   solve parent(X,Y), then -- with Y now bound -- solve parent(Y,Z). */

grandparent(X, Z) :-
    parent(X, Y),
    parent(Y, Z).

mother(X, Y) :-
    parent(X, Y),
    female(X).

father(X, Y) :-
    parent(X, Y),
    male(X).

/* A RECURSIVE rule. Declaratively: an ancestor is a parent, or a parent
   of an ancestor. Procedurally: each recursive call consumes one
   parent/2 fact, so the recursion bottoms out at the leaves of the tree
   (compare Module 3's termination pitfalls). */

ancestor(X, Z) :-
    parent(X, Z).
ancestor(X, Z) :-
    parent(X, Y),
    ancestor(Y, Z).

/* Hand-trace exercise: resolve ?- ancestor(tom, jim).
     ancestor(tom, jim)
       clause 1: parent(tom, jim)?  fails (no such fact)
       clause 2: parent(tom, Y), ancestor(Y, jim)
         Y = bob:  ancestor(bob, jim)
           clause 1: parent(bob, jim)? fails
           clause 2: parent(bob, Y2), ancestor(Y2, jim)
             Y2 = ann: ancestor(ann, jim) -> fails entirely, BACKTRACK
             Y2 = pat: ancestor(pat, jim)
               clause 1: parent(pat, jim) -> SUCCESS
   This is SLD resolution with depth-first search and chronological
   backtracking -- the entire Prolog computation model in one query. */
