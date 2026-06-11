# Module 2: Logical Reasoning and Proof Techniques

This module covers logical equivalence, logical implication, common fallacies, and the
four core proof techniques — direct proof, contrapositive, contradiction, and
induction — applied to computer-science problems. The samples make these ideas
*executable*: an equivalence checker that mechanically verifies the laws you prove on
paper, a Prolog rule base that performs (and refuses to perform) classic inference
patterns, and a Python harness that tests inductive claims empirically before you
prove them formally.

A recurring theme: a truth table or a test run is *evidence*, but only a proof is
*certainty*. The `induction_demo.py` example makes this distinction explicit by
including a famous claim that holds for many small cases and then fails.

## Competencies Addressed

- **1.** Appraise the basic concepts and principles of logic as applied in a computer science context.
- **2.** Apply logical reasoning in algorithm development and problem-solving.

## Files

| File | Language | What it shows |
|---|---|---|
| `inference_rules.pl` | Prolog (portable: SWI + SICStus) | Modus ponens and modus tollens as Prolog rules over a small knowledge base; shows why the fallacies "affirming the consequent" and "denying the antecedent" do **not** follow. |
| `equivalence_checker.py` | Python 3 | Checks logical equivalence of two propositional formulas by comparing truth tables. Verifies De Morgan's laws, the contrapositive law (the basis of proof by contrapositive), and exposes a non-equivalence. |
| `induction_demo.py` | Python 3 | Empirically checks base case and inductive step for `1+2+...+n = n(n+1)/2`, then shows a cautionary example (a conjecture that survives small tests but is false), motivating real proofs. |

## Running the Examples

```
swipl inference_rules.pl
python equivalence_checker.py
python induction_demo.py
```

Suggested Prolog queries (also listed in the file header):

```prolog
?- derive(wet(grass), Why).        % modus ponens chain, with a "why" trace
?- modus_tollens(game_on, Conclusion).
?- affirming_consequent_example.   % prints why this inference is invalid
```

Both Python scripts print labeled demonstrations when run directly.
`inference_rules.pl` uses only ISO predicates plus `library(lists)` and runs
unchanged in SWI-Prolog and SICStus Prolog.

## Expected Output / Experimentation Notes

- `equivalence_checker.py` should report `EQUIVALENT` for De Morgan and the
  contrapositive pair, and `NOT EQUIVALENT` for `p -> q` vs. `q -> p` (the converse —
  this is exactly the error behind "affirming the consequent").
- `induction_demo.py` prints the inductive check for the sum formula, then shows that
  the conjecture "n² + n + 41 is prime" holds for n = 0..39 and fails at n = 40.
  Discuss in class: what would a *proof* give us that 40 passing tests did not?

## Student Extension Ideas

1. Add the *hypothetical syllogism* pattern (`p→q, q→r ⟹ p→r`) to
   `inference_rules.pl` and test it on the weather knowledge base.
2. Use `equivalence_checker.py` to check whether `implies(p, implies(q, r))` is
   equivalent to `implies(and(p, q), r)` (exportation). First predict the answer.
3. In `induction_demo.py`, add a checker for the formula `1² + 2² + ... + n² = n(n+1)(2n+1)/6`.
4. Write a paragraph (for discussion) on which proof technique you would use to prove
   that `member/2` in Prolog terminates on a proper (finite) list, and why induction
   on list length is the natural choice.
