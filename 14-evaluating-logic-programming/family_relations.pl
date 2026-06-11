/*  Course:  CSC350: Logic Programming for Artificial Intelligence
    Module:  14 - Evaluation of Logic Programming in AI and Other Domains
    Competencies: 5 (evaluate logic programming vs other paradigms)
    Purpose: The reference implementation for the three-paradigm
             comparison. Same data and queries as family_relations.py
             and family_relations.sql -- read all three side by side.
    Runs in: SWI-Prolog AND SICStus Prolog (portable, ISO-style).

    The five comparison queries:
      Q1  ?- grandparent(tom, X).      % forward
      Q2  ?- grandparent(X, jim).      % backward -- SAME rule
      Q3  ?- sibling(ann, X).
      Q4  ?- ancestor(tom, X).         % recursive
      Q5  ?- ancestor(X, jim).         % recursive, backward -- SAME rule
*/

/* ---- Data: identical to the Python list and the SQL table ---------- */

parent(pam, bob).
parent(tom, bob).
parent(tom, liz).
parent(bob, ann).
parent(bob, pat).
parent(pat, jim).

/* ---- The relations: the entire "implementation" -------------------- */

grandparent(X, Z) :-
    parent(X, Y),
    parent(Y, Z).

sibling(X, Y) :-
    parent(P, X),
    parent(P, Y),
    X \== Y.

ancestor(X, Z) :-
    parent(X, Z).
ancestor(X, Z) :-
    parent(X, Y),
    ancestor(Y, Z).

/*  Scorecard notes for the comparison discussion:

    - LINES of reasoning code: 8 clauses. Count the equivalents in the
      Python and SQL files.
    - DIRECTIONS: Q1 and Q2 use the same grandparent/2 rule; Python
      needs grandchildren_of() AND grandparents_of(). Relations beat
      functions when queries come from every direction.
    - RECURSION: ancestor/2 is the textbook definition, verbatim.
      SQL needs WITH RECURSIVE; Python needs explicit stack/visited
      management for the general case.
    - The catch: this elegance depends on the strategy behaving --
      reorder ancestor/2's clauses and goals badly (Module 3) and the
      backward query Q5 can loop. Power and pitfalls share a root.     */
