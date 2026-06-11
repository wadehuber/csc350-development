/*  Course:  CSC350: Logic Programming for Artificial Intelligence
    Module:  15 - Final Exam Review, Project Presentations, and Exam
    Competencies: 1-6 (the capstone demonstrates competency 6 end to end)
    Purpose: A project SKELETON: the recommended structure for a capstone
             Prolog program, with a working miniature example (campus
             navigation) in every section. Replace each section's content
             with your project; keep the structure and the entry points.
    Runs in: SWI-Prolog AND SICStus Prolog (portable, ISO-style).

    Entry points:
      ?- demo.          % the 90-second presentation demo
      ?- run_tests.     % all tests, with a pass/fail summary
*/

:- use_module(library(lists)).

/* =====================================================================
   SECTION 1: KNOWLEDGE BASE (facts only)
   Keep raw facts separate from reasoning -- graders and teammates
   should find every assumption about the world in this section.
   ===================================================================== */

% building(Id, Name).
building(lib,  'Library').
building(sci,  'Science Hall').
building(eng,  'Engineering').
building(stu,  'Student Union').

% walkway(From, To, Minutes). One direction; symmetry is a rule, not data.
walkway(lib, sci, 4).
walkway(sci, eng, 3).
walkway(lib, stu, 6).
walkway(stu, eng, 5).

% accessible(From, To): walkway is step-free (subset of walkways).
accessible(lib, sci).
accessible(lib, stu).
accessible(stu, eng).

/* =====================================================================
   SECTION 2: REASONING RULES (derived relations)
   Pure rules over Section 1. No I/O here -- predicates in this section
   must be testable by query alone.
   ===================================================================== */

% connected(A, B, Minutes): walkways are two-way.
connected(A, B, T) :- walkway(A, B, T).
connected(A, B, T) :- walkway(B, A, T).

% step_free(A, B): two-way accessible link.
step_free(A, B) :- accessible(A, B).
step_free(A, B) :- accessible(B, A).

/* =====================================================================
   SECTION 3: SEARCH / PROBLEM SOLVING
   The algorithmic heart. Document WHICH technique you chose (Module 10
   or 11) and why; keep it domain-independent where you can.
   ===================================================================== */

% route(Start, Goal, Route, Minutes): DFS with visited list (Module 10).
route(Start, Goal, Route, Minutes) :-
    walk(Start, Goal, [Start], Rev, 0, Minutes),
    reverse(Rev, Route).

walk(Goal, Goal, Visited, Visited, T, T).
walk(At, Goal, Visited, Route, T0, T) :-
    connected(At, Next, Step),
    \+ member(Next, Visited),
    T1 is T0 + Step,
    walk(Next, Goal, [Next|Visited], Route, T1, T).

% best_route(Start, Goal, Route, Minutes): cheapest of all routes.
% (findall + minimum: simple and fine at campus scale; swap in A*
% from Module 10 if your project's graph is large.)
best_route(Start, Goal, Route, Minutes) :-
    findall(M-R, route(Start, Goal, R, M), Pairs),
    Pairs \== [],
    min_pair(Pairs, Minutes-Route).

min_pair([P], P).
min_pair([M1-R1, M2-_ | Rest], Best) :-
    M1 =< M2, !,
    min_pair([M1-R1 | Rest], Best).
min_pair([_ | Rest], Best) :-
    min_pair(Rest, Best).

/* =====================================================================
   SECTION 4: DEMO (the only section that prints)
   One predicate that tells your project's story in under two minutes.
   ===================================================================== */

demo :-
    write('--- Campus Route Advisor (capstone skeleton demo) ---'), nl,
    best_route(lib, eng, Route, Minutes),
    write('Fastest Library -> Engineering: '), write(Route),
    write(' ('), write(Minutes), write(' min)'), nl,
    ( route_step_free(lib, eng, AccRoute) ->
        write('Step-free option: '), write(AccRoute), nl
    ;   write('No step-free route available.'), nl
    ).

% route_step_free(S, G, R): a route using only step-free links.
route_step_free(Start, Goal, Route) :-
    sf_walk(Start, Goal, [Start], Rev),
    reverse(Rev, Route).

sf_walk(Goal, Goal, V, V).
sf_walk(At, Goal, Visited, Route) :-
    step_free(At, Next),
    \+ member(Next, Visited),
    sf_walk(Next, Goal, [Next|Visited], Route).

/* =====================================================================
   SECTION 5: TESTS
   Each test is goal + expected outcome. run_tests/0 reports a summary.
   Write tests BEFORE the features they test where you can.
   ===================================================================== */

test(buildings_exist,
     ( building(lib, _), building(eng, _) )).
test(connectivity_is_symmetric,
     ( connected(lib, sci, T), connected(sci, lib, T) )).
test(route_exists,
     route(lib, eng, _, _)).
test(best_route_is_seven_minutes,
     ( best_route(lib, eng, _, M), M =:= 7 )).
test(step_free_route_exists,
     route_step_free(lib, eng, _)).
test(no_route_to_unknown_building,
     \+ route(lib, gym, _, _)).

run_tests :-
    findall(Name-Result, run_one(Name, Result), Results),
    report_results(Results, 0, 0).

run_one(Name, Result) :-
    test(Name, Goal),
    ( call(Goal) -> Result = pass ; Result = fail ).

report_results([], P, F) :-
    nl, write('passed: '), write(P),
    write('  failed: '), write(F), nl,
    ( F =:= 0 -> write('ALL TESTS PASS') ; write('FIX FAILURES BEFORE PRESENTING') ),
    nl.
report_results([Name-pass | Rest], P, F) :-
    write('  [pass] '), write(Name), nl,
    P1 is P + 1,
    report_results(Rest, P1, F).
report_results([Name-fail | Rest], P, F) :-
    write('  [FAIL] '), write(Name), nl,
    F1 is F + 1,
    report_results(Rest, P, F1).

/*  Checklist before you present:
      [ ] Sections 1-2 contain no I/O and no cuts you can't justify
      [ ] Every Section 3 predicate terminates (Module 3!) -- test the
          failing direction, not just the succeeding one
      [ ] run_tests/0 is green in a FRESH Prolog session
      [ ] demo/0 runs in under two minutes and ends with output a
          non-programmer would understand                              */
