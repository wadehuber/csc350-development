/*  Course:  CSC350: Logic Programming for Artificial Intelligence
    Module:  11 - Planning Techniques
    Competencies: 4 (develop Prolog solutions), 6 (logic programming
                  solutions for AI applications)
    Purpose: A STRIPS-style planner for the blocks world. Actions are
             described declaratively by preconditions and add/delete
             effects; a domain-independent iterative-deepening search
             chains them into (shortest) plans.
    Runs in: SWI-Prolog AND SICStus Prolog (portable, ISO-style).

    Suggested queries:
      ?- demo_plan(Plan).
      ?- initial(S), plan(S, [on(c, a)], Plan).
      ?- initial(S), plan(S, [on(a,b), on(b,c)], Plan).
*/

:- use_module(library(lists)).

% can/2 and effects/3 are deliberately interleaved action-by-action
% below; this ISO directive tells the system that is intentional.
:- discontiguous(can/2).
:- discontiguous(effects/3).

/* ------------------- THE WORLD ------------------------------------- */
/*  Three blocks a, b, c. A STATE is a sorted list of facts:
      on(X, Y)      block X sits on block Y
      ontable(X)    block X sits on the table
      clear(X)      nothing sits on X

    Initial state:        c
                          a   b      (c on a; a, b on the table)
*/

initial(State) :-
    msort([ontable(a), ontable(b), on(c, a), clear(b), clear(c)], State).

block(a).
block(b).
block(c).

/* ------------------- THE ACTIONS (STRIPS operators) ----------------- */
/*  Each action has:
      can(Action, Preconditions)        facts that must hold
      effects(Action, AddList, DelList) facts it creates / destroys
    This declarative format is the heart of STRIPS (Fikes & Nilsson,
    1971) and survives in today's PDDL planning language.               */

% move(X, From, To): move block X from atop From to atop To.
can(move(X, From, To), [clear(X), clear(To), on(X, From)]) :-
    block(X), block(From), block(To),
    X \== From, X \== To, From \== To.

effects(move(X, From, To),
        [on(X, To), clear(From)],          % add
        [on(X, From), clear(To)]).         % delete

% move_from_table(X, To): lift X off the table onto To.
can(move_from_table(X, To), [clear(X), clear(To), ontable(X)]) :-
    block(X), block(To),
    X \== To.

effects(move_from_table(X, To),
        [on(X, To)],
        [ontable(X), clear(To)]).

% move_to_table(X, From): put X down on the table.
can(move_to_table(X, From), [clear(X), on(X, From)]) :-
    block(X), block(From),
    X \== From.

effects(move_to_table(X, From),
        [ontable(X), clear(From)],
        [on(X, From)]).

/* ------------------- THE PLANNER (domain-independent) --------------- */
/*  Nothing below mentions blocks. Give it other can/2 + effects/3
    definitions and it plans in that domain instead.

    Iterative deepening: try plans of length 0, then 1, 2, ... This
    finds a SHORTEST plan and -- unlike plain depth-first over plans --
    cannot dive down an infinite useless branch (Module 3's lesson,
    applied).                                                            */

% plan(+State, +Goals, -Plan)
plan(State, Goals, Plan) :-
    length(Plan, _),                   % generates lengths 0,1,2,... on
    plan_dfs(State, Goals, Plan).      %   backtracking = the deepening

plan_dfs(State, Goals, []) :-
    satisfied(State, Goals).
plan_dfs(State, Goals, [Action | Rest]) :-
    can(Action, Pre),
    satisfied(State, Pre),
    apply_action(State, Action, NewState),
    plan_dfs(NewState, Goals, Rest).

% satisfied(+State, +Goals): every goal fact holds in State.
satisfied(_, []).
satisfied(State, [G|Gs]) :-
    member(G, State),
    satisfied(State, Gs).

% apply_action(+State, +Action, -NewState): delete, then add, keeping
% the state sorted so equal states are equal lists.
apply_action(State, Action, NewState) :-
    effects(Action, Add, Del),
    subtract_p(State, Del, Mid),
    append(Add, Mid, Unsorted),
    msort(Unsorted, NewState).

subtract_p([], _, []).
subtract_p([X|Xs], Del, Rest) :-
    member(X, Del), !,
    subtract_p(Xs, Del, Rest).
subtract_p([X|Xs], Del, [X|Rest]) :-
    subtract_p(Xs, Del, Rest).

% demo_plan(-Plan): build the tower a-on-b-on-c and print the steps.
demo_plan(Plan) :-
    initial(S),
    plan(S, [on(a, b), on(b, c)], Plan),
    write('Plan found:'), nl,
    print_steps(Plan, 1).

print_steps([], _).
print_steps([A|As], N) :-
    write('  '), write(N), write('. '), write(A), nl,
    N1 is N + 1,
    print_steps(As, N1).

/*  THE SUSSMAN ANOMALY (try it):
        ?- initial(S), plan(S, [on(a,b), on(b,c)], Plan).
    Achieving on(a,b) first would bury b; achieving on(b,c) first
    blocks getting a. Naive achieve-subgoals-one-at-a-time planners
    fail here; our planner handles it because it searches over whole
    plans -- at the price of exponential search. The tension between
    subgoal decomposition and subgoal interaction drove twenty years
    of planning research (partial-order planning, GraphPlan, ...).     */
