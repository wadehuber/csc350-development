"""
Course:  CSC350: Logic Programming for Artificial Intelligence
Module:  1 - Propositional and Predicate Logic
Competencies: 1 (appraise concepts of logic in a CS context),
              2 (apply logical reasoning in algorithm development)
Purpose: Generate truth tables for propositional formulas and classify each
         formula as a tautology, contradiction, or contingency.
Runs in: Python 3 (standard library only) -- run:  python truth_tables.py

Why Python here? In this module we are reasoning ABOUT propositional logic
(enumerating every truth assignment), which is ordinary computation. Later
modules use Prolog, where the logic itself becomes the program.
"""

from itertools import product

# ---------------------------------------------------------------------------
# Formula representation
# ---------------------------------------------------------------------------
# A formula is either:
#   - a string, naming a proposition letter, e.g. "p"
#   - a tuple whose first element is a connective name:
#       ("not", f)        ("and", f, g)      ("or", f, g)
#       ("implies", f, g) ("iff", f, g)
#
# Example:  ("implies", ("and", "p", "q"), "p")   means   (p AND q) -> p


def evaluate(formula, assignment):
    """Evaluate a formula under an assignment dict like {"p": True, "q": False}."""
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
        # p -> q is false only when p is true and q is false
        return (not evaluate(formula[1], assignment)) or evaluate(formula[2], assignment)
    if op == "iff":
        return evaluate(formula[1], assignment) == evaluate(formula[2], assignment)
    raise ValueError(f"unknown connective: {op}")


def variables(formula):
    """Return the proposition letters of a formula, in sorted order."""
    if isinstance(formula, str):
        return {formula}
    vs = set()
    for sub in formula[1:]:
        vs |= variables(sub)
    return vs


def show(formula):
    """Render a formula with conventional symbols, for table headers."""
    if isinstance(formula, str):
        return formula
    op = formula[0]
    if op == "not":
        return f"~{show(formula[1])}"
    symbol = {"and": "&", "or": "v", "implies": "->", "iff": "<->"}[op]
    return f"({show(formula[1])} {symbol} {show(formula[2])})"


def truth_table(formula):
    """Print the full truth table and classify the formula."""
    vs = sorted(variables(formula))
    header = vs + [show(formula)]
    print(" | ".join(header))
    print("-" * (len(" | ".join(header))))

    results = []
    # Enumerate every assignment: this is the semantics of propositional logic.
    for values in product([True, False], repeat=len(vs)):
        assignment = dict(zip(vs, values))
        value = evaluate(formula, assignment)
        results.append(value)
        row = ["T" if assignment[v] else "F" for v in vs] + ["T" if value else "F"]
        print(" | ".join(cell.center(len(h)) for cell, h in zip(row, header)))

    if all(results):
        verdict = "TAUTOLOGY (true under every assignment)"
    elif not any(results):
        verdict = "CONTRADICTION (false under every assignment)"
    else:
        verdict = "CONTINGENCY (depends on the assignment)"
    print(f"=> {verdict}\n")


if __name__ == "__main__":
    # 1. Material implication: (p & q) -> p   -- a tautology
    truth_table(("implies", ("and", "p", "q"), "p"))

    # 2. De Morgan's law as a biconditional: ~(p & q) <-> (~p v ~q)
    truth_table(("iff",
                 ("not", ("and", "p", "q")),
                 ("or", ("not", "p"), ("not", "q"))))

    # 3. A contingency: p -> q
    truth_table(("implies", "p", "q"))
