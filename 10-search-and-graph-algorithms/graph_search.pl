/*  Course:  CSC350: Logic Programming for Artificial Intelligence
    Module:  10 - Search Techniques and Graph Algorithms
    Competencies: 2 (logical reasoning in algorithms), 4 (Prolog
                  solutions), 6 (logic programming for AI problems)
    Purpose: Depth-first and breadth-first search over the same cyclic
             graph, with visited-list cycle protection and path
             reconstruction. DFS rides Prolog's backtracking; BFS
             manages an explicit frontier queue.
    Runs in: SWI-Prolog AND SICStus Prolog (portable, ISO-style).

    Suggested queries:
      ?- dfs(a, f, Path).        % press ; for alternative paths
      ?- bfs(a, f, Path).        % fewest-edges path comes first
      ?- dfs(f, a, Path).        % no path: both fail cleanly
*/

:- use_module(library(lists)).

/*  The graph (directed, cyclic -- note c->a):

         a --> b --> d --> f
         a --> c --> e --> f
         c --> a   (cycle!)
         b --> e,  d --> e
*/

edge(a, b).
edge(a, c).
edge(b, d).
edge(b, e).
edge(c, a).
edge(c, e).
edge(d, e).     % listed before d->f: lures DFS into a longer path
edge(d, f).
edge(e, f).

/* ------------------- DEPTH-FIRST SEARCH ---------------------------- */
/*  Prolog's own execution IS depth-first, so DFS needs almost no code:
    just recursion plus a visited list to survive the c->a cycle
    (the lesson Module 3 set up). The visited list doubles as the
    path-so-far, kept in reverse.                                       */

% dfs(+Start, +Goal, -Path)
dfs(Start, Goal, Path) :-
    dfs_walk(Start, Goal, [Start], Rev),
    reverse(Rev, Path).

dfs_walk(Goal, Goal, Visited, Visited).
dfs_walk(Node, Goal, Visited, Path) :-
    edge(Node, Next),
    \+ member(Next, Visited),          % cycle protection
    dfs_walk(Next, Goal, [Next|Visited], Path).

/* ------------------- BREADTH-FIRST SEARCH -------------------------- */
/*  BFS can't ride backtracking -- it needs to expand nodes in
    DISCOVERY order, so we manage an explicit queue of partial paths
    (each stored reversed, newest node first). The first solution out
    of the queue is guaranteed to have the fewest edges.                */

% bfs(+Start, +Goal, -Path)
bfs(Start, Goal, Path) :-
    bfs_queue([[Start]], Goal, [Start], Rev),
    reverse(Rev, Path).

% bfs_queue(+Queue, +Goal, +Seen, -RevPath)
% Queue: list of reversed partial paths. Seen: every node ever enqueued
% (checking at ENQUEUE time keeps the queue duplicate-free).
bfs_queue([[Goal|Rest] | _], Goal, _, [Goal|Rest]).
bfs_queue([[Node|Rest] | Queue], Goal, Seen, Path) :-
    Node \== Goal,
    findall([Next, Node | Rest],
            ( edge(Node, Next), \+ member(Next, Seen) ),
            Extensions),
    new_nodes(Extensions, News),
    append(Seen, News, Seen2),
    append(Queue, Extensions, Queue2),     % append at the BACK = FIFO = BFS
    bfs_queue(Queue2, Goal, Seen2, Path).

% new_nodes(+Paths, -Heads): the newly discovered node of each path.
new_nodes([], []).
new_nodes([[N|_] | Ps], [N|Ns]) :- new_nodes(Ps, Ns).

/* ------------------- DEPTH-LIMITED SEARCH -------------------------- */
/*  The missing piece for ITERATIVE DEEPENING (extension idea #2):
    DFS that gives up below depth 0. iddfs/3 = try limits 0, 1, 2, ...  */

% dls(+Start, +Goal, +Limit, -Path)
dls(Start, Goal, Limit, Path) :-
    dls_walk(Start, Goal, Limit, [Start], Rev),
    reverse(Rev, Path).

dls_walk(Goal, Goal, _, Visited, Visited).
dls_walk(Node, Goal, Limit, Visited, Path) :-
    Limit > 0,
    L1 is Limit - 1,
    edge(Node, Next),
    \+ member(Next, Visited),
    dls_walk(Next, Goal, L1, [Next|Visited], Path).

/*  Swapping ONE line changes the algorithm: append Extensions at the
    FRONT of the queue in bfs_queue/4 and you get DFS again. Frontier
    discipline -- stack vs queue vs priority queue (see best_first.pl)
    -- is the entire difference between the classic search strategies. */
