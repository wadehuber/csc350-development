"""
Course:  CSC350: Logic Programming for Artificial Intelligence
Module:  2 - Logical Reasoning and Proof Techniques
Competencies: 2 (apply logical reasoning in algorithm development and
              problem-solving)
Purpose: Make mathematical induction concrete. We empirically check the
         base case and inductive step of a summation formula, then show a
         conjecture that passes many small tests yet is FALSE -- evidence
         that testing supports a claim but only a proof establishes it.
Runs in: Python 3 (standard library only) -- run: python induction_demo.py
"""


# ---------------------------------------------------------------------------
# Claim:  P(n):  1 + 2 + ... + n  ==  n*(n+1)/2     for all n >= 1
#
# An induction proof has two obligations:
#   Base case:      P(1) holds.
#   Inductive step: for every k, if P(k) holds then P(k+1) holds.
# Below we CHECK both obligations numerically for a range of k. The real
# proof of the step is one line of algebra: (k(k+1)/2) + (k+1) = (k+1)(k+2)/2.
# ---------------------------------------------------------------------------

def lhs(n):
    """Sum 1 + 2 + ... + n computed the long way."""
    return sum(range(1, n + 1))


def rhs(n):
    """The closed form n(n+1)/2."""
    return n * (n + 1) // 2


def check_sum_formula(limit=1000):
    print(f"Claim: 1 + 2 + ... + n == n(n+1)/2")
    base_ok = lhs(1) == rhs(1)
    print(f"  Base case P(1): {lhs(1)} == {rhs(1)} -> {base_ok}")

    # Check the SHAPE of the inductive step: assuming the closed form at k,
    # adding (k+1) must give the closed form at k+1.
    step_ok = all(rhs(k) + (k + 1) == rhs(k + 1) for k in range(1, limit))
    print(f"  Inductive step P(k) -> P(k+1) checked for k = 1..{limit - 1}: {step_ok}")
    print("  (The checks pass -- and here the one-line algebra proof makes it certain.)\n")


# ---------------------------------------------------------------------------
# A cautionary tale: Euler's polynomial n^2 + n + 41.
# Conjecture: "n^2 + n + 41 is prime for every n >= 0."
# It survives an impressive number of tests... then fails.
# ---------------------------------------------------------------------------

def is_prime(m):
    if m < 2:
        return False
    d = 2
    while d * d <= m:
        if m % d == 0:
            return False
        d += 1
    return True


def check_euler_polynomial():
    print("Conjecture: n^2 + n + 41 is prime for all n >= 0")
    n = 0
    while is_prime(n * n + n + 41):
        n += 1
    print(f"  Holds for n = 0..{n - 1}  ({n} consecutive successes!)")
    value = n * n + n + 41
    print(f"  FAILS at n = {n}:  {n}^2 + {n} + 41 = {value} = {n + 1} * {value // (n + 1)}")
    print("  Lesson: passing tests is evidence; only a proof is certainty.")
    print("  (At n = 40: 40^2 + 40 + 41 = 41^2 -- the failure was built in all along.)")


if __name__ == "__main__":
    check_sum_formula()
    check_euler_polynomial()
