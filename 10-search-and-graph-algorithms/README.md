# Module 10: Search Techniques and Graph Algorithms

Search is the workhorse of classical AI, and Prolog is unusually well suited to it:
backtracking gives you depth-first search for free, and the other strategies are
short programs away. This module implements **depth-first search** (with the visited
list that finally fixes Module 3's cycle problem), **breadth-first search** (and why
it finds shortest paths), and **best-first / A\* search** with a heuristic. It then
applies state-space search to a problem that isn't a literal graph — the classic
**water jugs puzzle** — to make the point that *any* problem with states and moves is
a graph search in disguise.

## Competencies Addressed

- **2.** Apply logical reasoning in algorithm development and problem-solving.
- **4.** Develop solutions using a Prolog-based logic programming language.
- **6.** Develop logic programming-based solutions for computational problems and applications in artificial intelligence.

## Files

| File | Language | What it shows |
|---|---|---|
| `graph_search.pl` | Prolog (portable: SWI + SICStus) | DFS and BFS over the same cyclic, weighted graph: visited lists, path reconstruction, why BFS yields fewest-edges paths and DFS doesn't. |
| `best_first.pl` | Prolog (portable: SWI + SICStus) | Heuristic search: best-first and A* over a small map with straight-line-distance heuristic; compares the path each strategy finds. |
| `water_jugs.pl` | Prolog (portable: SWI + SICStus) | State-space search: the 4-gallon/3-gallon water jugs puzzle. States are terms, moves are a relation, and the BFS from `graph_search.pl` reappears almost verbatim. |

## Running the Examples

```
swipl graph_search.pl
```

```prolog
?- dfs(a, f, Path).            % press ; for alternative DFS paths
?- bfs(a, f, Path).            % fewest edges, found first
```

```
swipl best_first.pl
```

```prolog
?- best_first(arad, bucharest, Path).
?- astar(arad, bucharest, Path, Cost).
```

```
swipl water_jugs.pl
```

```prolog
?- solve_jugs(Plan), show_plan(Plan).
```

All files are portable between SWI-Prolog and SICStus Prolog. (Where SWI's autoloaded
list predicates are needed, `library(lists)` is loaded explicitly for SICStus.)

## Expected Output / Experimentation Notes

- On the sample graph, `bfs(a, f, P)` returns a shortest path (3 edges, `[a,b,d,f]`)
  first, while DFS's first answer is the longer `[a,b,d,e,f]` — depth-first dives
  down `d -> e` because that clause comes first, exactly the trade-off the module is
  about. Pressing `;` shows DFS *can* find the short path, just not first.
- The A* example uses the Romania-map fragment familiar from Russell & Norvig; the
  optimal Arad→Bucharest route costs 418. If your `astar/4` answer differs, compare
  the heuristic table.
- `water_jugs.pl` should find a 6-step plan reaching exactly 2 gallons in the
  4-gallon jug. Press `;` — BFS guarantees no shorter plan exists.

## Student Extension Ideas

1. Add edge `f -> a` to `graph_search.pl` (a cycle through the goal) and confirm both
   searches still terminate — then delete a visited check and watch what breaks.
2. Implement **iterative deepening** (`iddfs/3`) reusing the depth-limited DFS
   skeleton in `graph_search.pl`; compare its answers with `bfs/3`.
3. In `best_first.pl`, set every heuristic value to 0 and verify A* degenerates into
   uniform-cost search (same path, more nodes expanded).
4. Change `water_jugs.pl` to jugs of 5 and 3 gallons with a target of 4, and check
   the plan length.
