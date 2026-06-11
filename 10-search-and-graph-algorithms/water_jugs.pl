/*  Course:  CSC350: Logic Programming for Artificial Intelligence
    Module:  10 - Search Techniques and Graph Algorithms
    Competencies: 2 (logical reasoning), 4 (Prolog solutions),
                  6 (logic programming for AI problems)
    Purpose: State-space search. The water jugs puzzle: with a 4-gallon
             jug, a 3-gallon jug, and a tap, measure exactly 2 gallons.
             No graph is given -- the MOVES RELATION generates it on
             demand. BFS guarantees the shortest plan.
    Runs in: SWI-Prolog AND SICStus Prolog (portable, ISO-style).

    Suggested queries:
      ?- solve_jugs(Plan), show_plan(Plan).
      ?- move(jugs(0,0), S, M).        % press ; -- the branching factor
*/

:- use_module(library(lists)).

/*  STATE: jugs(Big, Small) -- gallons in the 4-gal and 3-gal jugs.
    START: jugs(0, 0).   GOAL: 2 gallons in the big jug.

    This is exactly graph_search.pl's setup with edge/2 replaced by a
    COMPUTED relation move/3. State spaces are graphs you never store. */

goal(jugs(2, _)).

% move(+State, -NextState, -MoveName): all legal moves.
move(jugs(B, S), jugs(4, S), fill_big)    :- B < 4.
move(jugs(B, S), jugs(B, 3), fill_small)  :- S < 3.
move(jugs(B, S), jugs(0, S), empty_big)   :- B > 0.
move(jugs(B, S), jugs(B, 0), empty_small) :- S > 0.

% Pour big -> small until small is full or big is empty.
move(jugs(B, S), jugs(B2, S2), pour_big_into_small) :-
    B > 0, S < 3,
    Amount is min(B, 3 - S),
    B2 is B - Amount,
    S2 is S + Amount.

% Pour small -> big until big is full or small is empty.
move(jugs(B, S), jugs(B2, S2), pour_small_into_big) :-
    S > 0, B < 4,
    Amount is min(S, 4 - B),
    S2 is S - Amount,
    B2 is B + Amount.

/* ------------------- BFS over the state space ---------------------- */
/*  Queue entries: path(State, RevMoves). Seen-list prevents revisiting
    states -- essential: this state space is FULL of cycles
    (fill then empty, pour back and forth, ...).                        */

solve_jugs(Plan) :-
    bfs_jugs([path(jugs(0, 0), [])], [jugs(0, 0)], RevPlan),
    reverse(RevPlan, Plan).

bfs_jugs([path(State, Moves) | _], _, Moves) :-
    goal(State).
bfs_jugs([path(State, Moves) | Queue], Seen, Plan) :-
    \+ goal(State),
    findall(path(Next, [M-Next | Moves]),
            ( move(State, Next, M), \+ member(Next, Seen) ),
            Children),
    states_of(Children, NewStates),
    append(Seen, NewStates, Seen2),
    append(Queue, Children, Queue2),
    bfs_jugs(Queue2, Seen2, Plan).

states_of([], []).
states_of([path(S, _) | Ps], [S|Ss]) :- states_of(Ps, Ss).

% show_plan(+Plan): print each move and the state it produces.
show_plan(Plan) :-
    write('start: jugs(0, 0)'), nl,
    show_steps(Plan, 1).

show_steps([], _).
show_steps([Move-State | Rest], N) :-
    write(N), write('. '), write(Move),
    write('  -> '), write(State), nl,
    N1 is N + 1,
    show_steps(Rest, N1).

/*  Expected: a 6-step plan, e.g.
      fill_small, pour_small_into_big, fill_small,
      pour_small_into_big (big now 4, small 2),
      empty_big, pour_small_into_big      -> jugs(2, 0)

    The leap to internalize: NOTHING here is jug-specific in the search
    code. Swap move/3 and goal/1 and the same BFS solves 8-puzzles,
    river crossings, or Module 11's planning problems -- state-space
    search is one idea wearing many costumes.                          */
