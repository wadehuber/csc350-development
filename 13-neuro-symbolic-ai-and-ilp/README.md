# Module 13: Neuro-Symbolic AI and Inductive Logic Programming

Symbolic AI (everything so far) reasons but doesn't learn; neural AI learns but can't
explain. This module surveys the field's response: **inductive logic programming**
(ILP — learning logical rules from examples plus background knowledge) and
**neuro-symbolic AI** (hybrid systems that bolt a learned perception component onto a
symbolic reasoning component; today's research frontier and the design behind systems
like AlphaGeometry).

Two hands-on demos keep it concrete: a toy ILP learner in Prolog that induces a
`daughter/2` rule from four examples, and a pure-Python neuro-symbolic pipeline where
a tiny perceptron *learns* to classify and symbolic rules then *reason* over its
outputs — with a final case showing why the symbolic layer catches mistakes the
network alone would make.

## Competencies Addressed

- **5.** Evaluate the use of logic programming for its applications in artificial intelligence and other domains (where symbolic AI fits in the deep-learning era).
- **6.** Develop logic programming-based solutions for computational problems and applications in artificial intelligence.

## Files

| File | Language | What it shows |
|---|---|---|
| `rule_learning.pl` | Prolog (portable: SWI + SICStus) | A miniature ILP system: given positive/negative examples of `daughter/2` and background predicates (`parent/2`, `female/1`, `male/1`), it searches a space of candidate rule bodies and returns the hypothesis covering all positives and no negatives — generalization as search. |
| `neuro_symbolic_demo.py` | Python 3 (standard library only) | A perceptron trained from scratch (no libraries) to recognize "ripe fruit" from features, then a symbolic rule layer that combines the perceptron's verdict with hard domain constraints; includes a case where the constraint layer vetoes the network. |

## Running the Examples

```
swipl rule_learning.pl
```

```prolog
?- learn(daughter, Rule).          % the induced rule, human-readable
?- show_search.                    % every candidate tried, and why it failed
```

```
python neuro_symbolic_demo.py
```

`rule_learning.pl` is portable between SWI-Prolog and SICStus Prolog.

## Expected Output / Experimentation Notes

- `learn(daughter, Rule)` should induce `daughter(A,B) :- female(A), parent(B,A)` —
  and `show_search/0` shows the over-general candidates (e.g. just `parent(B,A)`)
  being rejected by negative examples. *Negative examples are what force
  specialization*; delete them and watch the learner happily over-generalize.
- `neuro_symbolic_demo.py` prints the perceptron's training epochs, its test
  accuracy, and then the hybrid decisions. The last test case is engineered so the
  perceptron says "ripe" but the symbolic layer (which knows recalls/allergies)
  overrides it — neural proposal, symbolic disposal.
- Real systems scale these toys: Progol/Aleph/Popper for ILP; DeepProbLog,
  Scallop, and AlphaGeometry for neuro-symbolic — pointers for the course's
  emerging-trends discussion.

## Student Extension Ideas

1. Add examples for a `son/2` target to `rule_learning.pl` and confirm the learner
   induces the right body by changing only the example facts.
2. Add `grandparent/2` to the background predicates and give the learner examples of
   `granddaughter/2` — what happens to the size of the candidate space?
3. In `neuro_symbolic_demo.py`, shrink the training set to 4 examples and watch
   accuracy fall; which layer of the hybrid degrades, and which is unaffected?
4. Write a half-page evaluation (competency 5): for a medical-triage app, which
   subtasks belong to the learned component and which to the rule component? Justify
   with one failure mode of each.
