# Module 1: Propositional and Predicate Logic

This module opens the course with the formal foundations everything else builds on:
the syntax and semantics of propositional logic (propositions, connectives, truth
tables) and predicate logic (constants, variables, predicates, and the quantifiers
∀ and ∃). The goal is to get comfortable reading and writing logical formulas and to
see, from day one, how those formulas map onto executable code — in Python, where we
*compute about* logic, and in Prolog, where logic *is* the program.

The Prolog examples here are deliberately gentle (this is many students' first look at
Prolog); the same ideas return with full force in Modules 4–5.

## Competencies Addressed

- **1.** Appraise the basic concepts and principles of logic as applied in a computer science context.
- **2.** Apply logical reasoning in algorithm development and problem-solving.
- **3.** Construct knowledge-representation schema for problems in artificial intelligence (first taste: representing a small domain as predicates).

## Files

| File | Language | What it shows |
|---|---|---|
| `truth_tables.py` | Python 3 | A small truth-table generator for propositional formulas built from `NOT`, `AND`, `OR`, `IMPLIES`, `IFF`. Prints the full table and reports whether a formula is a tautology, contradiction, or contingency. |
| `propositional_eval.pl` | Prolog (portable: SWI + SICStus) | Represents propositional formulas as Prolog terms (`and(p,q)`, `implies(p,q)`, …) and evaluates them under an assignment. Shows that formulas are just data — a key symbolic-AI idea. |
| `predicates_and_quantifiers.pl` | Prolog (portable: SWI + SICStus) | A tiny university domain (constants, predicates, facts). Shows how queries with variables behave like existential quantification and how rules capture universally quantified statements. |

## Running the Examples

**Python:**

```
python truth_tables.py
```

**Prolog (SWI):**

```
swipl propositional_eval.pl
```

then try the queries suggested in each file's header comment, e.g.:

```prolog
?- eval(implies(p, or(p, q)), [p=true, q=false], V).
V = true.

?- tautology(implies(and(p,q), p)).
true.
```

**Prolog (SICStus):** start `sicstus`, then `?- consult('propositional_eval.pl').`
Both `.pl` files in this module use only ISO predicates plus `library(lists)` and run
unchanged in both systems.

## Expected Output / Experimentation Notes

- `truth_tables.py` prints three demonstration tables (implication, De Morgan check,
  and a contingency) when run directly. Edit the `if __name__ == "__main__":` block to
  test your own formulas.
- In `predicates_and_quantifiers.pl`, compare the query `?- enrolled(ava, X).`
  ("does there exist an X…?") with the rule `overloaded/1` ("for all students…") —
  the README of Module 4 revisits why Prolog handles ∃ directly but expresses ∀
  through rules and negation.

## Student Extension Ideas

1. Add a `XOR` connective to `truth_tables.py` and to `propositional_eval.pl`, and
   verify with a truth table that `xor(p,q)` is equivalent to `and(or(p,q), not(and(p,q)))`.
2. In `propositional_eval.pl`, write a predicate `vars_of(Formula, Vars)` that
   collects the proposition letters appearing in a formula.
3. Extend the university domain in `predicates_and_quantifiers.pl` with a
   `prerequisite/2` predicate and write a query that finds courses a student is
   eligible to take.
4. Use `truth_tables.py` to test whether `implies(p,q)` and `implies(not(q), not(p))`
   (the contrapositive) always agree — a preview of Module 2.
