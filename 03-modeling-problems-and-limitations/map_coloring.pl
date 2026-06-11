/*  Course:  CSC350: Logic Programming for Artificial Intelligence
    Module:  3 - Modeling Computational Problems and Logical Limitations
    Competencies: 1 (principles of logic in CS), 2 (logical reasoning in
                  problem-solving), 5 (evaluate logic programming)
    Purpose: Model a constraint problem -- coloring a map so that no two
             neighboring regions share a color -- as a declarative logic
             program. The program IS the problem statement; Prolog's
             backtracking search finds the solutions.
    Runs in: SWI-Prolog AND SICStus Prolog (portable, ISO-style).

    Suggested queries:
      ?- color_map(Az, Ca, Nv, Ut, Nm).     % press ; for more solutions
      ?- color_map(red, Ca, Nv, Ut, Nm).    % fix Arizona's color first
      ?- count_colorings(N).
*/

/* ---------------------------------------------------------------------
   THE MODEL.
   Individuals: five southwestern US states and three colors.
   Predicate:   different/2 -- the single constraint between neighbors.

   Notice what is ABSENT: there is no algorithm here. No loops, no
   assignment ordering, no conflict-repair strategy. We state what a
   solution looks like; the inference engine supplies the search.
   --------------------------------------------------------------------- */

% color(C): the available palette.
color(red).
color(green).
color(blue).

% different(X, Y): X and Y are distinct colors.
% Defined positively (by generating from the palette) so it can also
% GENERATE pairs, not just test them.
different(X, Y) :-
    color(X),
    color(Y),
    X \== Y.

% color_map(Az, Ca, Nv, Ut, Nm):
% one variable per state; one different/2 goal per pair of neighbors.
%
%   Adjacencies modeled:  AZ-CA, AZ-NV, AZ-UT, AZ-NM, CA-NV, NV-UT
%
color_map(Az, Ca, Nv, Ut, Nm) :-
    different(Az, Ca),
    different(Az, Nv),
    different(Az, Ut),
    different(Az, Nm),
    different(Ca, Nv),
    different(Nv, Ut).

% count_colorings(N): how many valid colorings exist with this palette?
count_colorings(N) :-
    findall(s, color_map(_, _, _, _, _), Solutions),
    length(Solutions, N).

/* Modeling lesson: to change the problem, change the FACTS.
   - Fewer colors?   delete a color/1 fact.
   - Another state?  add a variable and its different/2 constraints.
   The "algorithm" never needs editing. Module 7 revisits this same
   problem with constraint logic programming (CLP), which searches far
   more cleverly than generate-and-test. */
