# Module 4: Foundations of Logic Programming

This module steps back and asks what logic programming *is*: its history (Robinson's
resolution principle, 1965; Colmerauer & Roussel's first Prolog, 1972; Kowalski's
"Algorithm = Logic + Control", 1979), its real-world applications (natural-language
systems, expert systems, IBM Watson's Prolog components, verification, databases/Datalog),
the paradigm itself (programs as logical theories; computation as deduction), and the
computation model of logic programs — SLD resolution over Horn clauses, with
unification supplying parameter passing and depth-first search supplying control.

The samples make the computation model visible: `family.pl` is the classic first logic
program, sized for tracing by hand, and `computation_model.pl` instruments goal
reduction so you can watch the resolution steps and see how clause order and goal
order change *behavior* without changing *meaning* — Kowalski's equation in action.

## Competencies Addressed

- **1.** Appraise the basic concepts and principles of logic as applied in a computer science context.
- **2.** Apply logical reasoning in algorithm development and problem-solving.
- **5.** Evaluate the use of logic programming for its applications in artificial intelligence and other domains.

## Files

| File | Language | What it shows |
|---|---|---|
| `family.pl` | Prolog (portable: SWI + SICStus) | The canonical family-tree program: facts, rules, recursive rules. Small enough to trace each query by hand against the SLD computation model. |
| `computation_model.pl` | Prolog (portable: SWI + SICStus) | Horn clauses as data plus a tiny *meta-interpreter* (`solve/1`, `solve_trace/2`) that performs goal reduction explicitly — you can watch SLD resolution happen, and see the proof tree it builds. |

## Running the Examples

```
swipl family.pl
```

```prolog
?- grandparent(tom, X).
?- ancestor(tom, jim).
?- trace, ancestor(tom, jim).     % watch the built-in tracer do SLD resolution
?- notrace, nodebug.
```

```
swipl computation_model.pl
```

```prolog
?- solve(grandparent(tom, X)).
?- solve_trace(grandparent(tom, X), Proof).   % returns the proof tree
```

Both files are portable between SWI-Prolog and SICStus Prolog. The built-in
`trace/0` debugger exists in both systems, though the output format differs slightly
(SWI shows `Call/Exit/Redo/Fail` ports; SICStus similar with its own formatting).

## Expected Output / Experimentation Notes

- `solve_trace/2` returns a nested term representing the proof tree — compare it with
  the trace you got from `trace/0`; they describe the same derivation.
- Swap the order of the two `ancestor/2` clauses in `family.pl`, reload, and rerun
  `?- ancestor(tom, X).` The same answers appear in a different order: **logic
  unchanged, control changed** — Kowalski's "Algorithm = Logic + Control".

## A Two-Minute History (for context)

- **1965** — J. A. Robinson publishes the resolution principle, a single inference rule
  suitable for machines.
- **1972** — Alain Colmerauer and Philippe Roussel build the first Prolog in Marseille,
  for natural-language processing.
- **1974/1979** — Robert Kowalski gives the procedural interpretation of Horn clauses:
  a logic program can be *read* declaratively and *run* procedurally.
- **1980s** — Japan's Fifth Generation Computer Systems project adopts logic
  programming; Prolog spreads through AI research (expert systems, NLP, planning).
- **Today** — Prolog descendants and relatives: SWI-Prolog and SICStus in industry and
  teaching; Datalog in databases and program analysis; ASP (answer set programming)
  in combinatorial AI; CLP in scheduling and verification.

## Student Extension Ideas

1. Add `sibling/2` and `cousin/2` rules to `family.pl`; trace `cousin/2` and count the
   resolution steps.
2. Extend the meta-interpreter in `computation_model.pl` with a step counter:
   `solve_count(Goal, Steps)` — a first taste of measuring inference cost.
3. Add a fact that creates a second grandparent path and confirm that `solve_trace/2`
   produces a different proof tree on backtracking (`;`).
4. Pick one historical application (e.g., Watson, the Fifth Generation project) and
   write a half-page note: what made logic programming a good or bad fit?
