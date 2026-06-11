/*  Course:  CSC350: Logic Programming for Artificial Intelligence
    Module:  7 - Advanced Data Structures, CLP, and Language Integration
    Competencies: 4 (develop Prolog solutions), 5 (evaluate integration
                  architectures)
    Purpose: A small flight-route knowledge base queried FROM PYTHON by
             call_prolog.py. The Prolog side does what logic does best
             (recursive route finding); the Python side does I/O and
             formatting. The source is portable ISO Prolog, but the demo
             pipeline invokes it via SWI-Prolog's command line.
    Runs in: SWI-Prolog (as part of the Python demo); the code itself
             also loads in SICStus.

    Standalone queries (swipl kb_for_python.pl):
      ?- route(phoenix, boston, R).
      ?- findall(R, route(phoenix, boston, R), Rs).
*/

% flight(From, To): direct flights (one direction, like real schedules).
flight(phoenix, denver).
flight(phoenix, chicago).
flight(denver,  chicago).
flight(denver,  newyork).
flight(chicago, boston).
flight(chicago, newyork).
flight(newyork, boston).

% route(From, To, Route): Route is a list of cities from From to To
% following direct flights, visiting no city twice.
route(From, To, Route) :-
    route_acc(From, To, [From], Rev),
    reverse_p(Rev, Route).

route_acc(To, To, Acc, Acc).
route_acc(From, To, Acc, Route) :-
    flight(From, Next),
    \+ member_p(Next, Acc),          % no revisits => termination
    route_acc(Next, To, [Next|Acc], Route).

% Local list helpers keep the file dependency-free in both systems.
member_p(X, [X|_]).
member_p(X, [_|T]) :- member_p(X, T).

reverse_p(L, R) :- rev_acc(L, [], R).
rev_acc([], Acc, Acc).
rev_acc([H|T], Acc, R) :- rev_acc(T, [H|Acc], R).

% print_routes(From, To): one line per route -- machine-readable output
% for the Python wrapper to parse (it reads stdout).
print_routes(From, To) :-
    route(From, To, R),
    write(R), nl,
    fail.                            % drive backtracking through ALL routes
print_routes(_, _).                  % then succeed
