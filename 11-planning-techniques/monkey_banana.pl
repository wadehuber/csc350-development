/*  Course:  CSC350: Logic Programming for Artificial Intelligence
    Module:  11 - Planning Techniques
    Competencies: 4 (develop Prolog solutions), 6 (logic programming
                  solutions for AI applications)
    Purpose: The classic monkey-and-banana problem (after Bratko, ch.2):
             a monkey, a box, and a banana hanging from the ceiling.
             A tiny state-and-moves formulation yields goal-directed
             behavior from pure search.
    Runs in: SWI-Prolog AND SICStus Prolog (portable, ISO-style).

    Suggested queries:
      ?- can_get_banana(Plan).
      ?- move(state(atdoor, onfloor, atwindow, hasnot), M, S2).  % press ;
*/

/*  STATE: state(MonkeyAt, MonkeyLevel, BoxAt, HasBanana)
      MonkeyAt:    atdoor | atwindow | middle
      MonkeyLevel: onfloor | onbox
      BoxAt:       atdoor | atwindow | middle
      HasBanana:   has | hasnot
    The banana hangs over `middle`. Initially the monkey is at the
    door, the box at the window.                                       */

% move(+State, -Move, -NewState): the four available actions.

% Grasp: only standing on the box, under the banana.
move(state(middle, onbox, middle, hasnot),
     grasp,
     state(middle, onbox, middle, has)).

% Climb the box (monkey and box must be at the same place).
move(state(P, onfloor, P, H),
     climb,
     state(P, onbox, P, H)).

% Push the box (moves monkey and box together).
move(state(P1, onfloor, P1, H),
     push(P1, P2),
     state(P2, onfloor, P2, H)) :-
    place(P2),
    P2 \== P1.

% Walk anywhere on the floor.
move(state(P1, onfloor, B, H),
     walk(P1, P2),
     state(P2, onfloor, B, H)) :-
    place(P2),
    P2 \== P1.

place(atdoor).
place(atwindow).
place(middle).

/* ------------------- THE PLANNER ----------------------------------- */
/*  Depth-bounded forward search: getit/3 tries to reach `has` within
    N moves. The bound is the simplest possible termination guarantee
    (walking back and forth forever is otherwise a legal "plan").
    can_get_banana/1 deepens the bound 0,1,2,... so the FIRST plan
    found is also a SHORTEST one.                                       */

% getit(+State, +Bound, -Plan)
getit(state(_, _, _, has), _, []).
getit(State, Bound, [Move | Rest]) :-
    Bound > 0,
    B1 is Bound - 1,
    move(State, Move, NewState),
    getit(NewState, B1, Rest).

can_get_banana(Plan) :-
    nat(Bound),
    getit(state(atdoor, onfloor, atwindow, hasnot), Bound, Plan),
    !.                                  % first (= shortest) plan only

% nat(N): 0, 1, 2, ... on backtracking (drives the deepening).
nat(0).
nat(N) :- nat(M), N is M + 1.

/*  Expected plan (4 steps):
      walk(atdoor, atwindow), push(atwindow, middle), climb, grasp

    Worth pausing on: nothing in this file says "go to the box FIRST".
    The ordering emerges from preconditions plus search -- the
    monkey "figures out" that climbing before pushing leads nowhere
    because no sequence of moves from that state reaches `has` in
    budget. Purposeful-looking behavior from mechanical search is the
    oldest magic trick in AI.                                          */
