# Module 11: Planning Techniques

Planning is search with structure: instead of hand-writing a moves relation per
puzzle, we describe actions generically by their **preconditions** and **effects**
(the STRIPS representation, 1971), and a domain-independent planner chains them into a
plan. This module implements a small STRIPS-style planner for the **blocks world** —
the fruit-fly of AI planning — and the classic **monkey and banana** problem from
Bratko's textbook, where a tiny means-ends program produces surprisingly purposeful
behavior.

The through-line from Module 10: a *state* is now a set of logical facts, an *action*
is a transformation on that set, and a *plan* is a path in the induced state space.
Knowledge representation (Module 9) and search (Module 10) meet here.

## Competencies Addressed

- **4.** Develop solutions using a Prolog-based logic programming language.
- **6.** Develop logic programming-based solutions for computational problems and applications in artificial intelligence.

## Files

| File | Language | What it shows |
|---|---|---|
| `blocks_world.pl` | Prolog (portable: SWI + SICStus) | A STRIPS-style planner: states as sorted lists of facts (`on(a,b)`, `clear(a)`); actions defined by `can/2` (preconditions) and `effects/3` (add/delete lists); iterative-deepening search over plans for optimality and termination. |
| `monkey_banana.pl` | Prolog (portable: SWI + SICStus) | Bratko's monkey-and-banana: a 4-slot state term and a `move/3` relation; the planner is two clauses of depth-bounded forward search. Minimal machinery, real planning behavior. |

## Running the Examples

```
swipl blocks_world.pl
```

```prolog
?- demo_plan(Plan).                        % stack a on b on c
?- initial(S), plan(S, [on(a,b), on(b,c)], Plan).
?- initial(S), plan(S, [on(c,a)], Plan).   % a different goal, same planner
```

```
swipl monkey_banana.pl
```

```prolog
?- can_get_banana(Plan).
```

Both files are portable between SWI-Prolog and SICStus Prolog.

## Expected Output / Experimentation Notes

- `demo_plan/1` *is* the famous **Sussman anomaly**: initial state `c` on `a` (with
  `a`, `b` on the table), goal `[on(a,b), on(b,c)]`. The optimal plan has exactly
  3 actions (`move_to_table(c,a)`, `move_from_table(b,c)`, `move_from_table(a,b)`),
  and iterative deepening guarantees the planner finds a 3-action plan. The closing
  comment in `blocks_world.pl` explains why this little problem broke a generation
  of subgoal-at-a-time planners.
- `monkey_banana.pl` should print a 4-step plan: walk to the box, push it under the
  banana, climb, grasp.

## Student Extension Ideas

1. Add a fourth block `d` to the initial state in `blocks_world.pl` and re-run the
   demo goal; observe how plan length and search time grow.
2. Add a new action `move_to_table(Block)` cost-free variant or give actions costs
   and report total plan cost alongside the plan.
3. In `monkey_banana.pl`, add a second box that is too light to stand on (climbing it
   achieves nothing) and confirm the planner ignores it.
4. Write the water-jugs problem from Module 10 in the STRIPS style of
   `blocks_world.pl` (states as fact lists, actions with add/delete lists) and compare
   the two formulations.
