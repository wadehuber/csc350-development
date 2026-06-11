/*  Course:  CSC350: Logic Programming for Artificial Intelligence
    Module:  9 - Knowledge Representation and Solving Logic Puzzles
    Competencies: 3 (construct KR schemas), 4 (Prolog solutions),
                  6 (logic programming for AI problems)
    Purpose: A 3-house warm-up puzzle introducing the representation
             pattern for grid logic puzzles: one list of structured
             terms + member/2 goals as clues. Read this file BEFORE
             zebra_puzzle.pl -- it is the same idea at 1/5 scale.
    Runs in: SWI-Prolog AND SICStus Prolog (portable, ISO-style).

    Suggested query:
      ?- solve(Houses), report(Houses).
*/

:- use_module(library(lists)).

/*  THE PUZZLE. Three neighbors, three houses in a row (1, 2, 3).
    Each has a distinct color, owner, and pet.

      1. The red house is in the middle.
      2. Ana lives in the first house.
      3. The dog's owner lives in the blue house.
      4. Ben owns the cat.
      5. Ana does not own the dog and does not live next to it.
      Colors: red, blue, green.  Owners: ana, ben, eva.  Pets: dog, cat, fish.

    THE REPRESENTATION (this is the KR step):
      Houses = [house(C1, O1, P1), house(C2, O2, P2), house(C3, O3, P3)]
    Position is encoded by LIST POSITION -- "first house" is the head,
    "next to" is adjacency in the list. Every clue then becomes one
    member/2 or adjacency goal over Houses.                            */

solve(Houses) :-
    Houses = [house(_, ana, _), _, _],                 % clue 2
    Houses = [_, house(red, _, _), _],                 % clue 1
    member(house(blue, _, dog), Houses),               % clue 3
    member(house(_, ben, cat), Houses),                % clue 4
    % Close the puzzle: every attribute value is used exactly once.
    member(house(green, _, _), Houses),
    member(house(_, eva, _), Houses),
    member(house(_, _, fish), Houses),
    % NEGATIVE clues go LAST, once every slot is bound (Module 6's rule:
    % \+ needs ground goals). Run them earlier and \+ member(house(_,
    % ana, dog), ...) would UNIFY dog into a still-empty pet slot and
    % wrongly reject every candidate.
    \+ member(house(_, ana, dog), Houses),             % clue 5a
    \+ next_to(house(_, ana, _), house(_, _, dog), Houses).      % clue 5b

% next_to(A, B, List): A and B occupy adjacent positions (either order).
next_to(A, B, List) :- adjacent(A, B, List).
next_to(A, B, List) :- adjacent(B, A, List).

adjacent(A, B, [A, B | _]).
adjacent(A, B, [_ | Rest]) :- adjacent(A, B, Rest).

% report(+Houses): pretty-print the solution.
report([]).
report([house(Color, Owner, Pet) | Rest]) :-
    write(Owner), write(' lives in the '), write(Color),
    write(' house with the '), write(Pet), nl,
    report(Rest).

/*  Things to notice:

    - The unused slots start as VARIABLES; clues fill them in by
      unification. member/2 does double duty: testing placement when
      slots are bound, generating placements when they aren't.
    - POSITIVE clues can run in any order; NEGATIVE clues (\+) must
      wait until the slots they inspect are bound -- the same lesson
      as bachelor/1 vs bachelor_fixed/1 in Module 6.
    - Solving is just the conjunction of clues. Scale this pattern up
      by two attributes and ten clues and you have zebra_puzzle.pl.   */
