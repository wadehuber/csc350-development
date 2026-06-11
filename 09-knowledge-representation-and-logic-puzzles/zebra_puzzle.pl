/*  Course:  CSC350: Logic Programming for Artificial Intelligence
    Module:  9 - Knowledge Representation and Solving Logic Puzzles
    Competencies: 3 (construct KR schemas), 4 (Prolog solutions),
                  6 (logic programming for AI problems)
    Purpose: The classic Zebra Puzzle (Life International, 1962):
             five houses, five nationalities, five drinks, five pets,
             five cigarette brands, fifteen clues -- who owns the zebra?
             Pure Prolog: a schema, the clues, and built-in search.
    Runs in: SWI-Prolog AND SICStus Prolog (portable, ISO-style).

    Suggested queries:
      ?- zebra(Owner, Houses).
      ?- time(zebra(Owner, _)).        % SWI: count the inferences
*/

:- use_module(library(lists)).

/*  Schema: a list of five terms
        house(Color, Nation, Pet, Drink, Smoke)
    listed LEFT TO RIGHT, so "right of" and "next to" are positional
    relations on the list -- the KR decision that makes the clues easy. */

zebra(ZebraOwner, Houses) :-
    Houses = [_, _, _, _, _],                                    % five houses
    % 1. The Englishman lives in the red house.
    member(house(red, english, _, _, _), Houses),
    % 2. The Spaniard owns the dog.
    member(house(_, spanish, dog, _, _), Houses),
    % 3. Coffee is drunk in the green house.
    member(house(green, _, _, coffee, _), Houses),
    % 4. The Ukrainian drinks tea.
    member(house(_, ukrainian, _, tea, _), Houses),
    % 5. The green house is immediately to the right of the ivory house.
    right_of(house(green, _, _, _, _), house(ivory, _, _, _, _), Houses),
    % 6. The Old Gold smoker owns snails.
    member(house(_, _, snails, _, old_gold), Houses),
    % 7. Kools are smoked in the yellow house.
    member(house(yellow, _, _, _, kools), Houses),
    % 8. Milk is drunk in the middle house.
    Houses = [_, _, house(_, _, _, milk, _), _, _],
    % 9. The Norwegian lives in the first house.
    Houses = [house(_, norwegian, _, _, _) | _],
    % 10. The Chesterfields smoker lives next to the fox owner.
    next_to(house(_, _, _, _, chesterfields), house(_, _, fox, _, _), Houses),
    % 11. Kools are smoked next to the house with the horse.
    next_to(house(_, _, _, _, kools), house(_, _, horse, _, _), Houses),
    % 12. The Lucky Strike smoker drinks orange juice.
    member(house(_, _, _, orange_juice, lucky_strike), Houses),
    % 13. The Japanese smokes Parliaments.
    member(house(_, japanese, _, _, parliaments), Houses),
    % 14. The Norwegian lives next to the blue house.
    next_to(house(_, norwegian, _, _, _), house(blue, _, _, _, _), Houses),
    % 15. (Implicit) someone drinks water; someone owns the zebra.
    member(house(_, _, _, water, _), Houses),
    member(house(_, ZebraOwner, zebra, _, _), Houses).

% right_of(A, B, List): A is immediately to the right of B.
right_of(A, B, List) :- adjacent(B, A, List).

% next_to(A, B, List): A and B are adjacent in either order.
next_to(A, B, List) :- adjacent(A, B, List).
next_to(A, B, List) :- adjacent(B, A, List).

adjacent(A, B, [A, B | _]).
adjacent(A, B, [_ | Rest]) :- adjacent(A, B, Rest).

/*  Expected: a unique solution with ZebraOwner = japanese (and the
    Norwegian drinking water).

    Discussion: this program contains no search algorithm, yet solves a
    puzzle with 5!^5 ≈ 24 billion naive assignments in well under a
    second. Unification propagates partial information through the
    shared Houses structure, and clue ORDER prunes early -- try moving
    clue 9 to the end and timing it again. For an industrial-strength
    treatment of the same puzzle class, see Module 7's CLP(FD).        */
