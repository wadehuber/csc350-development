# Module 3: Modeling Computational Problems and Logical Limitations

This module has two halves. First, the constructive half: how to take a computational
problem and *model* it in logic — choose the individuals, choose the predicates, state
the constraints, and let inference find the solutions. Map coloring is the running
example because the model is tiny but the technique (generate-and-test over a declarative
constraint statement) generalizes to scheduling, configuration, and planning.

Second, the sobering half: the limits of logical systems. Some of these limits are
deep mathematics (Gödel's incompleteness theorems, the undecidability of first-order
logic and of the halting problem) and are discussed in the README notes below. One
limit, though, you can experience directly at the Prolog prompt: a logically correct
program whose *proof search does not terminate*. `termination_pitfalls.pl` lets you
trigger and then fix this — a first-hand lesson that "logically true" and "computable
by this strategy" are different things.

## Competencies Addressed

- **1.** Appraise the basic concepts and principles of logic as applied in a computer science context.
- **2.** Apply logical reasoning in algorithm development and problem-solving.
- **5.** Evaluate the use of logic programming for its applications in artificial intelligence and other domains (here: evaluating what logic *can't* do).

## Files

| File | Language | What it shows |
|---|---|---|
| `map_coloring.pl` | Prolog (portable: SWI + SICStus) | Models the "color a map so neighbors differ" problem declaratively. The whole program is the problem statement; Prolog's search does the rest. |
| `termination_pitfalls.pl` | Prolog (portable: SWI + SICStus) | Three small programs that are logically reasonable but loop forever under Prolog's depth-first strategy (left recursion, symmetric rules), each paired with a terminating fix. **Read the comments before querying — some queries intentionally do not terminate.** |

## Running the Examples

```
swipl map_coloring.pl
```

```prolog
?- color_map(Az, Ca, Nv, Ut, Nm).      % press ; to see alternative colorings
?- count_colorings(N).
```

```
swipl termination_pitfalls.pl
```

Follow the numbered experiments in the file's comments. When a query hangs, interrupt
it with `Ctrl+C` then `a` (abort) in SWI-Prolog; in SICStus use `Ctrl+C` then `a` as
well.

## Limitations Discussed in This Module (lecture notes pointers)

- **Expressiveness:** propositional logic can't say "for all"; first-order logic can't
  finitely axiomatize arithmetic (Gödel). Choosing a logic is a modeling trade-off.
- **Decidability:** validity in first-order logic is undecidable (Church–Turing); the
  halting problem means no analyzer can decide termination for all programs — including
  the Prolog queries in `termination_pitfalls.pl`.
- **Practical incompleteness:** Prolog's depth-first search is an *incomplete* proof
  strategy: a provable goal can still loop. This is a deliberate engineering trade
  (speed and predictability for completeness) — a theme we evaluate again in Module 14.

## Expected Output / Experimentation Notes

- `color_map/5` has many solutions with 3 colors; `count_colorings/1` reports how many.
  Try removing a color from `color/1` and see when the problem becomes unsatisfiable.
- In `termination_pitfalls.pl`, the pairs (`bad_*` vs. fixed versions) differ only in
  clause order or goal order — yet one loops and one terminates. Prolog's computation
  rule, covered formally in Module 4, explains exactly why.

## Student Extension Ideas

1. Extend `map_coloring.pl` to a map of six or seven regions of your choice and
   determine experimentally whether three colors still suffice.
2. Modify the model to *minimize* colors: add a 2-color palette version and observe
   the query fail, demonstrating unsatisfiability as a useful answer.
3. In `termination_pitfalls.pl`, write a terminating version of `connected/2` for the
   symmetric-edge graph by keeping a list of visited nodes (preview of Module 10).
4. Short write-up: pick a real scheduling conflict (e.g., your own course schedule)
   and list the constants, predicates, and constraints you would use to model it.
