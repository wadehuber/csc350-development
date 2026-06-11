/*  Course:  CSC350: Logic Programming for Artificial Intelligence
    Module:  10 - Search Techniques and Graph Algorithms
    Competencies: 2 (logical reasoning in algorithms), 4 (Prolog
                  solutions), 6 (logic programming for AI problems)
    Purpose: Heuristic search -- greedy best-first and A* -- on the
             classic Romania-map fragment (Russell & Norvig). The
             frontier becomes a PRIORITY queue ordered by h(n) (greedy)
             or g(n)+h(n) (A*).
    Runs in: SWI-Prolog AND SICStus Prolog (portable, ISO-style).

    Suggested queries:
      ?- best_first(arad, bucharest, Path).
      ?- astar(arad, bucharest, Path, Cost).      % optimal: Cost = 418
*/

:- use_module(library(lists)).

/* ---- The map: road(City1, City2, Km), usable in both directions --- */

road(arad,      zerind,         75).
road(arad,      sibiu,         140).
road(arad,      timisoara,     118).
road(zerind,    oradea,         71).
road(oradea,    sibiu,         151).
road(timisoara, lugoj,         111).
road(lugoj,     mehadia,        70).
road(mehadia,   drobeta,        75).
road(drobeta,   craiova,       120).
road(craiova,   pitesti,       138).
road(craiova,   rimnicu,       146).
road(sibiu,     fagaras,        99).
road(sibiu,     rimnicu,        80).
road(rimnicu,   pitesti,        97).
road(fagaras,   bucharest,     211).
road(pitesti,   bucharest,     101).

% step(A, B, Cost): roads are two-way.
step(A, B, C) :- road(A, B, C).
step(A, B, C) :- road(B, A, C).

/* ---- h(City): straight-line distance to Bucharest (admissible) ---- */

h(arad,      366).  h(bucharest,   0).  h(craiova,  160).
h(drobeta,   242).  h(fagaras,   176).  h(lugoj,    244).
h(mehadia,   241).  h(oradea,    380).  h(pitesti,  100).
h(rimnicu,   193).  h(sibiu,     253).  h(timisoara, 329).
h(zerind,    374).

/* ------------------- GREEDY BEST-FIRST ----------------------------- */
/*  Frontier entries: entry(F, G, RevPath) where RevPath = [Node|...].
    Greedy uses F = h(Node) only -- fast, not optimal.                  */

best_first(Start, Goal, Path) :-
    h(Start, H),
    search([entry(H, 0, [Start])], Goal, greedy, RevPath, _),
    reverse(RevPath, Path).

/* ------------------- A* -------------------------------------------- */
/*  A* uses F = G + h(Node): cost so far plus optimistic cost to go.
    With an admissible h (never overestimates), the first goal pulled
    off the frontier is OPTIMAL.                                        */

astar(Start, Goal, Path, Cost) :-
    h(Start, H),
    search([entry(H, 0, [Start])], Goal, astar, RevPath, Cost),
    reverse(RevPath, Path).

/* ---- The engine, shared by both strategies ------------------------ */

% search(+Frontier, +Goal, +Mode, -RevPath, -Cost)
search([entry(_, G, [Goal|Rest]) | _], Goal, _, [Goal|Rest], G).
search([entry(_, G, [Node|Rest]) | Frontier], Goal, Mode, Path, Cost) :-
    Node \== Goal,
    findall(entry(F2, G2, [Next, Node | Rest]),
            ( step(Node, Next, StepCost),
              \+ member(Next, [Node|Rest]),      % no loops within a path
              G2 is G + StepCost,
              score(Mode, Next, G2, F2) ),
            Children),
    append(Frontier, Children, All),
    sort_frontier(All, Sorted),                  % priority queue, the simple way
    search(Sorted, Goal, Mode, Path, Cost).

% score(+Mode, +Node, +G, -F): the strategy lives in this one predicate.
score(greedy, Node, _G, F) :- h(Node, F).
score(astar,  Node,  G, F) :- h(Node, H), F is G + H.

% sort_frontier/2: keep entries ordered by F. msort/2 sorts WITHOUT
% removing duplicates (ISO; available in SWI and SICStus) -- standard
% term order compares entry(F,...) by F first, which is what we want.
sort_frontier(Frontier, Sorted) :- msort(Frontier, Sorted).

/*  Experiment: greedy goes Arad-Sibiu-Fagaras-Bucharest (450 km,
    found fast); A* finds Arad-Sibiu-Rimnicu-Pitesti-Bucharest (418 km,
    optimal). Re-sorting the whole frontier each step is O(n log n) --
    fine for teaching; real systems use heap-based priority queues.    */
