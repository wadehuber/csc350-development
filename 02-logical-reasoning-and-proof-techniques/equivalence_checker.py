"""
Course:  CSC350: Logic Programming for Artificial Intelligence
Module:  2 - Logical Reasoning and Proof Techniques
Competencies: 1 (appraise principles of logic),
              2 (apply logical reasoning in problem-solving)
Purpose: Decide whether two propositional formulas are logically equivalent
         by comparing them under every truth assignment. Used to verify
         the equivalence laws (De Morgan, contrapositive, double negation)
         that justify proof techniques.
Runs in: Python 3 (standard library only) -- run: python equivalence_checker.py

Formula representation matches Module 1's truth_tables.py:
  "p"                      a proposition letter
  ("not", f)               negation
  ("and", f, g)  ("or", f, g)  ("implies", f, g)  ("iff", f, g)
"""

from itertools import product


def evaluate(formula, assignment):
    if isinstance(formula, str):
        return assignment[formula]
    op = formula[0]
    if op == "not":
        return not evaluate(formula[1], assignment)
    if op == "and":
        return evaluate(formula[1], assignment) and evaluate(formula[2], assignment)
    if op == "or":
        return evaluate(formula[1], assignment) or evaluate(formula[2], assignment)
    if op == "implies":
        return (not evaluate(formula[1], assignment)) or evaluate(formula[2], assignment)
    if op == "iff":
        return evaluate(formula[1], assignment) == evaluate(formula[2], assignment)
    raise ValueError(f"unknown connective: {op}")


def variables(formula):
    if isinstance(formula, str):
        return {formula}
    vs = set()
    for sub in formula[1:]:
        vs |= variables(sub)
    return vs


def show(formula):
    if isinstance(formula, str):
        return formula
    op = formula[0]
    if op == "not":
        return f"~{show(formula[1])}"
    symbol = {"and": "&", "or": "v", "implies": "->", "iff": "<->"}[op]
    return f"({show(formula[1])} {symbol} {show(formula[2])})"


def equivalent(f, g):
    """True iff f and g agree under every assignment of their combined letters.

    Two formulas are logically equivalent exactly when f <-> g is a
    tautology; checking agreement row-by-row is the same test.
    Returns (verdict, counterexample_or_None).
    """
    vs = sorted(variables(f) | variables(g))
    for values in product([True, False], repeat=len(vs)):
        assignment = dict(zip(vs, values))
        if evaluate(f, assignment) != evaluate(g, assignment):
            return False, assignment
    return True, None


def report(f, g):
    verdict, counterexample = equivalent(f, g)
    print(f"  {show(f)}")
    print(f"  {show(g)}")
    if verdict:
        print("  => EQUIVALENT (agree on every assignment)\n")
    else:
        nice = {k: ("T" if v else "F") for k, v in counterexample.items()}
        print(f"  => NOT EQUIVALENT; counterexample: {nice}\n")


if __name__ == "__main__":
    p, q = "p", "q"

    print("De Morgan's first law:")
    report(("not", ("and", p, q)),
           ("or", ("not", p), ("not", q)))

    print("Contrapositive law (the basis of proof by contrapositive):")
    report(("implies", p, q),
           ("implies", ("not", q), ("not", p)))

    print("Double negation:")
    report(("not", ("not", p)), p)

    print("An implication is NOT equivalent to its converse:")
    report(("implies", p, q),
           ("implies", q, p))
